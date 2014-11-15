import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:github/browser.dart';

/// A Polymer `<main-app>` element.
@CustomTag('main-app')
class MainApp extends PolymerElement {
  @observable String username = '';
  @observable String reposelection = '';
  @observable int repoLoadProgress = 0;
  @observable int forkLoadProgress = 0;
  final List<Repository> repos = toObservable([]);
  final List<Repository> forks = toObservable([]);
  final Map<String, int> forkCounts = new Map<String, int>();

  GitHub gh = createGitHubClient();

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created();

  void showRepos(var e, var detail, var target) {
    reposelection = '';
    gh.users.getUser(username).then((user) {
      if (null == user) {

      } else {
        var repoCount = user.publicReposCount;
        repoLoadProgress = 0;
        var tmpRepos = [];
        repos.clear();

        var dropdown = shadowRoot.querySelector('paper-dropdown-menu').shadowRoot.querySelector('#dropdown');
        // otherwise it'll have the height of the first time it was opened
        dropdown.style.removeProperty('height');

        var repoLoadPregressbar = shadowRoot.querySelector('#repoLoadProgress');
        var repoContainer = shadowRoot.querySelector('#repoContainer');
        repoLoadPregressbar.style.removeProperty('display');
        repoContainer.style.display = 'none';

        gh.repositories.listUserRepositories(username).listen((repo) {
          tmpRepos.add(repo);
          forkCounts[repo.name] = repo.forksCount;
          repoLoadProgress = 100 * tmpRepos.length ~/ repoCount;
        }).onDone(() {
          repoLoadPregressbar.style.display = 'none';
          repos.addAll(tmpRepos);
          repoContainer.style.removeProperty('display');
        });
      }
    });
  }

  void analyzeForks(var e, var detail, var target) {
    forks.clear();
    forkLoadProgress = 0;
    var tmpForks = [];
    var forksCount = forkCounts[reposelection];

    var forkLoadPregressbar = shadowRoot.querySelector('#forkLoadProgress');
    var forkContainer = shadowRoot.querySelector('#forkContainer');
    forkLoadPregressbar.style.removeProperty('display');
    forkContainer.style.display = 'none';

    gh.repositories.listForks(new RepositorySlug(username, reposelection)).listen((repo) {
      tmpForks.add(repo);
      forkLoadProgress = 100 * tmpForks.length ~/ forksCount;
    }).onDone(() {
      forkLoadPregressbar.style.display = 'none';
      forks.addAll(tmpForks);
      forkContainer.style.removeProperty('display');
    });
  }

  void usernameChanged(String oldValue, String newValue) {
    shadowRoot.querySelector('#repoContainer').style.display = 'none';
    shadowRoot.querySelector('#forkContainer').style.display = 'none';
    reposelection = '';
  }

  // Optional lifecycle methods - uncomment if needed.

//  /// Called when an instance of main-app is inserted into the DOM.
//  attached() {
//    super.attached();
//  }

//  /// Called when an instance of main-app is removed from the DOM.
//  detached() {
//    super.detached();
//  }

//  /// Called when an attribute (such as a class) of an instance of
//  /// main-app is added, changed, or removed.
//  attributeChanged(String name, String oldValue, String newValue) {
//    super.attributeChanges(name, oldValue, newValue);
//  }

//  /// Called when main-app has been fully prepared (Shadow DOM created,
//  /// property observers set up, event listeners attached).
//  ready() {
//    super.ready();
//  }
}
