import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/github_search_result.dart';
import '../models/github_user.dart';
import '../services/github_search_service.dart';

class GitHubSearchDelegate extends SearchDelegate<GitHubUser> {
  GitHubSearchDelegate(this.searchService);
  final GitHubSearchService searchService;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (query.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black12,
              offset: Offset(0, 0),
              spreadRadius: 1,
            ),
          ],
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              theme.primaryColor.withOpacity(0.5),
              theme.primaryColor,
            ],
          ),
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: double.infinity,
              child: Text(
                '1.Search for any github profile',
                style: TextStyle(
                  shadows: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black26,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    ),
                  ],
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                '2.Typing in the searchbar',
                style: TextStyle(
                  shadows: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black26,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    ),
                  ],
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                '3.Results will appear automatically',
                style: TextStyle(
                  shadows: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black26,
                      offset: Offset(0, 0),
                      spreadRadius: 1,
                    ),
                  ],
                  color: Colors.white,
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      );
    }
    // search-as-you-type if enabled
    searchService.searchUser(query);
    return buildMatchingSuggestions(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    // always search if submitted
    searchService.searchUser(query);
    return buildMatchingSuggestions(context);
  }

  Widget buildMatchingSuggestions(BuildContext context) {
    final Map<GitHubAPIError, String> errorMessages = {
      GitHubAPIError.parseError: 'Error reading data from the API',
      GitHubAPIError.rateLimitExceeded: 'Rate limit exceeded',
      GitHubAPIError.unknownError: 'Unknown error',
    };
    // then return results
    return StreamBuilder<GitHubSearchResult>(
      stream: searchService.results,
      builder: (context, AsyncSnapshot<GitHubSearchResult> snapshot) {
        if (snapshot.hasData) {
          final GitHubSearchResult result = snapshot.data;
          return result.when(
            (users) => GridView.builder(
              itemCount: users.length,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 5,
                mainAxisSpacing: 0,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                return GitHubUserSearchResultTile(
                  user: users[index],
                  onSelected: (value) => close(context, value),
                );
              },
            ),
            error: (error) => SearchPlaceholder(title: errorMessages[error]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : <Widget>[
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          ];
  }
}

class GitHubUserSearchResultTile extends StatelessWidget {
  const GitHubUserSearchResultTile(
      {@required this.user, @required this.onSelected});

  final GitHubUser user;
  final ValueChanged<GitHubUser> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () => onSelected(user),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ClipPath(
              clipper: ShapeBorderClipper(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              child: Container(
                child: Image.network(
                  user.avatarUrl,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              user.login,
              style: theme.textTheme.headline6,
              textAlign: TextAlign.start,
            )
          ],
        ),
      ),
    );
  }
}

class SearchPlaceholder extends StatelessWidget {
  const SearchPlaceholder({@required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Lottie.network(
            title == 'Error reading data from the API'
                ? 'https://assets3.lottiefiles.com/packages/lf20_GlZGOi.json'
                : title == 'Rate limit exceeded'
                    ? 'https://assets9.lottiefiles.com/packages/lf20_IGkesg.json'
                    : 'https://assets9.lottiefiles.com/dotlotties/dlf10_yCmSxN.lottie',
            fit: BoxFit.contain,
            width: double.infinity,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          title == 'Error reading data from the API'
              ? 'No results found.\nTry again!'
              : title == 'Rate limit exceeded'
                  ? 'Too many requests.\nPlease wait...'
                  : title,
          style: theme.textTheme.headline5,
          textAlign: TextAlign.center,
        ),
      ],
    );
    // Center(
    //   child: Text(
    //     title,
    //     style: theme.textTheme.headline5,
    //     textAlign: TextAlign.center,
    //   ),
    // );
  }
}
