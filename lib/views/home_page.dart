import 'package:flutter/material.dart';
import 'package:github_search_flutter_client_rxdart_example/models/github_search_button.dart';

import '../app/github_search_delegate.dart';
import '../models/github_user.dart';
import '../services/github_search_api_wrapper.dart';
import '../services/github_search_service.dart';

class HomePage extends StatelessWidget {
  void _showSearch(BuildContext context) async {
    final searchService =
        GitHubSearchService(apiWrapper: GitHubSearchAPIWrapper());
    final user = await showSearch<GitHubUser>(
      context: context,
      delegate: GitHubSearchDelegate(searchService),
    );
    searchService.dispose();
    print(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Search'),
      ),
      // body: Center(
      //   child: RaisedButton(
      //     color: Theme.of(context).primaryColor,
      //     child: Text(
      //       'Search Users',
      //       style: Theme.of(context)
      //           .textTheme
      //           .headline6
      //           .copyWith(color: Colors.white),
      //     ),
      //     onPressed: () => _showSearch(context),
      //   ),
      // ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          GithubSearchButton(
            text: 'Search Users',
            color: Color.fromRGBO(62, 0, 255, 1),
            onTap: () => _showSearch(context),
          ),
          GithubSearchButton(
            text: 'Search Repos',
            color: Color.fromRGBO(174, 0, 251, 1),
            onTap: () => _showSearch(context),
          ),
        ],
      ),
    );
  }
}
