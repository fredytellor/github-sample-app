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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          GithubSearchButton(
            text: 'Search Users',
            color: Color.fromRGBO(232, 236, 241, 1),
            onTap: () => _showSearch(context),
          ),
          GithubSearchButton(
            text: 'Search Repos',
            color: Color.fromRGBO(181, 207, 216, 1),
            onTap: () => _showSearch(context),
          ),
          GithubSearchButton(
            text: 'Search Topics',
            color: Color.fromRGBO(115, 147, 167, 1),
            onTap: () => _showSearch(context),
          ),
        ],
      ),
    );
  }
}
