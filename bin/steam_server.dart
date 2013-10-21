import 'dart:io';
import 'dart:convert';

Map<String, String> games = new Map<String, String>();

main() {
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((request) {
      HttpResponse response = request.response;
      response.headers.add("Access-Control-Allow-Origin", "http://127.0.0.1:3030");

      Map<String, String> params = request.uri.queryParameters;
      if (params.containsKey('path')) {
        var path = Uri.decodeComponent(params['path']);
        scanDirectory(path);
      } else if (params.containsKey('term')) {
        String term = params['term'];
        var result = new Map<String, String>();
        if (term.length > 1) {
          games.keys.where((id) => games[id].toLowerCase().contains(term.toLowerCase())).forEach((id) => result[id] = games[id]);
        }
        response.write(JSON.encode(result));
      }

      response.close();
    });

    print('the SteamServer is up and running, please proceed using the SteamTiles');
  });
}

void scanDirectory(String path) {
  path = '$path/SteamApps';
  FileSystemEntity.isDirectory(path).then((_) {
    var dir = new Directory(path);
    dir.exists().then((exists) {
      if (exists) {
        addGamesInDir(dir);
      }
    });
  }, onError: (_) {});
}

void addGamesInDir(dir) {
  dir.list(recursive: false, followLinks: false).listen((entity) {
    if (entity is File && entity.path.endsWith('.acf')) {
      var file = entity as File;
      file.readAsString().then((content) {
        content = toJson(content);
        Map<String, dynamic> appState = JSON.decode(content)['appstate'];
        String name = appState['userconfig']['name'];
        String id = appState['appid'];
        if (name == null) {
          name = appState['installdir'];
        }
        if (name == null) {
          name = '$id (no name found)';
        }
        if (id != null) {
          games[appState['appid']] = name;
        }
      });
    }
  }, onError: (_) {});
}

String toJson(String content) {
  var result = content.replaceAllMapped(new RegExp(r'"(\t\t)(".*")(\s*)(["\}])'), (m) {
    if (m[4] == '"') {
      return '":${m[2]},${m[3]}${m[4]}';
    }
    return '":${m[2]}${m[3]}${m[4]}';
  });
  result = result.replaceAllMapped(new RegExp(r'^("[a-zA-Z]+")(\n)'), (m) => '${m[1]}:${m[2]}');
  result = result.replaceAllMapped(new RegExp(r'(\t+"[a-zA-Z]+")(\n)'), (m) => '${m[1]}:${m[2]}');
  result = result.replaceAllMapped(new RegExp(r'}(\s+)"'), (m) => '},${m[1]}"');
  result = result.replaceAllMapped(new RegExp(r'("\w+")'), (m) => m[1].toLowerCase());
  result = result.replaceAll('\\', '/');
  return '{$result}';
}