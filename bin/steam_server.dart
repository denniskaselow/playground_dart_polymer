import 'dart:io';
import 'dart:convert';

Map<String, String> games = new Map<String, String>();

main() {
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((request) {
      HttpResponse response = request.response;
      response.headers.add("Access-Control-Allow-Origin", "*, ");

      Map<String, String> params = request.uri.queryParameters;
      if (params.containsKey('path')) {
        scanDirectory(params['path']);
      } else if (params.containsKey('term')) {
        String term = params['term'];
        var result = new Map<String, String>();
        games.keys.where((id) => games[id].toLowerCase().contains(term.toLowerCase())).forEach((id) => result[id] = games[id]);
        response.write(JSON.encode(result));
      }

      response.close();
    });

    print('the SteamServer is up and running, please proceed using the SteamTiles');
  });
}

void scanDirectory(String path) {
  path = Uri.decodeComponent(path);
  path = '$path/SteamApps';
  FileSystemEntity.isDirectory(path).then((_) {
    var dir = new Directory(path);
    dir.list(recursive: false, followLinks: false).listen((entity) {
      if (entity is File && entity.path.endsWith('.acf')) {
        var file = entity as File;
        file.readAsString().then((content) {
          content = content.replaceAllMapped(new RegExp(r'"(\t\t)(".*")(\s*)(["\}])'), (m) {
            if (m[4] == '"') {
              return '":${m[2]},${m[3]}${m[4]}';
            }
            return '":${m[2]}${m[3]}${m[4]}';
          });
          content = content.replaceAllMapped(new RegExp(r'^("[a-zA-Z]+")(\n)'), (m) => '${m[1]}:${m[2]}');
          content = content.replaceAllMapped(new RegExp(r'(\t+"[a-zA-Z]+")(\n)'), (m) => '${m[1]}:${m[2]}');
          content = content.replaceAllMapped(new RegExp(r'}(\s+)"'), (m) => '},${m[1]}"');
          content = content.replaceAll('\\', '/');
          content = '{$content}';
          Map<String, dynamic> app = JSON.decode(content);
          Map<String, dynamic> appState = app['AppState'];
          String name = appState['UserConfig']['name'];
          if (name == null) {
            name = appState['InstallDir'];
          }
          games[appState['appid']] = name;
        });
      }
    }, onError: (e) => print(e));
  });
}