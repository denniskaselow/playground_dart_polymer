import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:github/browser.dart';

/// A Polymer `<main-app>` element.
@CustomTag('main-app')
class MainApp extends PolymerElement {
  @observable String username = '';
  @observable String reposelection = '';
  @observable int repoLoadProgress = 0;
  final List<Repository> repos = toObservable([]);

  GitHub gh = createGitHubClient();

  /// Constructor used to create instance of MainApp.
  MainApp.created() : super.created();

  void showRepos(var e, var detail, var target) {
    reposelection = '';
    gh.users.getUser(username).then((user) {
      if (null == user) {

      } else {
        var repoCount = user.publicReposCount;
        var reposLoaded = 0;
        repoLoadProgress = 0;
        var tmpRepos = [];
        repos.clear();

        var repoLoadPregressbar = shadowRoot.querySelector('#repoLoadProgress');
        var repocontainer = shadowRoot.querySelector('#repocontainer');
        repoLoadPregressbar.style.removeProperty('display');
        repocontainer.style.display = 'none';

        var dropdown = shadowRoot.querySelector('paper-dropdown-menu').shadowRoot.querySelector('#dropdown');
        // otherwise it'll have the height of the first time it was opened
        dropdown.style.removeProperty('height');

        gh.repositories.listUserRepositories(username).listen((repo) {
          tmpRepos.add(repo);
          reposLoaded++;
          repoLoadProgress = 100 * reposLoaded ~/ repoCount;
        }).onDone(() {
          repoLoadPregressbar.style.display = 'none';
          repos.addAll(tmpRepos);
          shadowRoot.querySelector('#repocontainer').style.removeProperty('display');
        });
      }
    });
  }

  void usernameChanged(String oldValue, String newValue) {
    shadowRoot.querySelector('#repocontainer').style.display = 'none';
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
