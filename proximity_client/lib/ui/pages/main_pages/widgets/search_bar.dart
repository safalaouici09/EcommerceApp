import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proximity/proximity.dart';
import 'package:proximity_client/domain/product_repository/product_repository.dart';
import 'package:proximity_client/domain/store_repository/store_repository.dart';
import 'package:proximity_client/ui/pages/pages.dart';
import 'package:proximity_client/ui/pages/product_pages/widgets/product_card.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  Future<void> _showSearch() async {
    await previewSearch(
      context: context,
      delegate: Search(),
      query: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showSearch,
      child: Container(
        padding: const EdgeInsets.all(small_100).copyWith(left: normal_100),
        margin: const EdgeInsets.symmetric(
            horizontal: normal_100, vertical: small_100),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(smallRadius),
            gradient: LinearGradient(
              colors: (Theme.of(context).brightness == Brightness.light)
                  ? lightSearchBarGradient
                  : darkSearchBarGradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
        child: Row(
          children: [
            Expanded(
                child: Text('Search...',
                    style: Theme.of(context).textTheme.headline5!.copyWith(
                        color: Theme.of(context).textTheme.bodyText2!.color))),
            const SizedBox(width: normal_100),
            const Icon(ProximityIcons.search)
          ],
        ),
      ),
    );
  }
}

/// A custom search delegate for proper handling and custom UI
class Search extends CustomSearchDelegate<Product> {
  @override
  Widget buildResults(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    productService.searchProducts(query);
    List<Widget> _widgetList = [];
    if (query.isNotEmpty) {
      for (int i = 0; i < productService.searchResults.length; i++) {
        _widgetList.add(ProductCard(product: productService.searchResults[i]));
      }
    }
    if (_widgetList.isEmpty) {
      return const NoResults(
          icon: ProximityIcons.no_results_illustration,
          message: 'No results were found.');
    } else {
      return MasonryGrid(
        column: 2,
        padding: const EdgeInsets.symmetric(
            horizontal: small_100, vertical: normal_100),
        children: _widgetList,
      );
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Widget> _widgetList = [];
    int i = 0;
    if (query != '') {
      final productService = Provider.of<ProductService>(context);
      productService.searchProducts(query);
      for (Product element in productService.searchResults) {
        if (element.name!.toLowerCase().contains(query.toLowerCase())) {
          _widgetList.add(GestureDetector(
              onTap: () {
                query = element.name!;
                showResults(context);
              },
              child: Container(
                  padding: const EdgeInsets.all(normal_100),
                  child: Text(element.name!,
                      style: Theme.of(context).textTheme.bodyText1))));
          _widgetList.add(Divider(
              height: tiny_50,
              thickness: tiny_50,
              color: Theme.of(context).dividerColor));
          i++;
          if (i >= 7) break;
        }
      }
    }

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _widgetList);
  }
}

enum _SearchBody {
  suggestions,
  results,
}

abstract class CustomSearchDelegate<T> {
  CustomSearchDelegate({
    this.searchFieldLabel,
    this.keyboardType,
    this.textInputAction = TextInputAction.search,
  });

  Widget buildSuggestions(BuildContext context);

  Widget buildResults(BuildContext context);

  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.white,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  String get query => _queryTextController.text;

  set query(String value) {
    _queryTextController.text = value;
  }

  void showResults(BuildContext context) {
    _focusNode!.unfocus();
    _currentBody = _SearchBody.results;
  }

  void showSuggestions(BuildContext context) {
    _focusNode!.requestFocus();
    _currentBody = _SearchBody.suggestions;
  }

  void close(BuildContext context, T result) {
    _currentBody = null;
    _focusNode!.unfocus();
    Navigator.of(context)
      ..popUntil((Route<dynamic> route) => route == _route)
      ..pop(result);
  }

  final String? searchFieldLabel;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;

  Animation<double> get transitionAnimation => _proxyAnimation;

  // The focus node to use for manipulating focus on the search page. This is
  // managed, owned, and set by the _SearchPageRoute using this delegate.
  FocusNode? _focusNode;

  final TextEditingController _queryTextController = TextEditingController();

  final ProxyAnimation _proxyAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);

  final ValueNotifier<_SearchBody?> _currentBodyNotifier =
      ValueNotifier<_SearchBody?>(null);

  _SearchBody? get _currentBody => _currentBodyNotifier.value;

  set _currentBody(_SearchBody? value) {
    _currentBodyNotifier.value = value;
  }

  _SearchPageRoute<T>? _route;
}

class _SearchPageRoute<T> extends PageRoute<T> {
  _SearchPageRoute({required this.delegate}) {
    assert(
      delegate._route == null,
    );
    delegate._route = this;
  }

  final CustomSearchDelegate<T> delegate;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => false;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Animation<double> createAnimation() {
    final Animation<double> animation = super.createAnimation();
    delegate._proxyAnimation.parent = animation;
    return animation;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _SearchPage<T>(
      delegate: delegate,
      animation: animation,
    );
  }

  @override
  void didComplete(T? result) {
    super.didComplete(result);
    assert(delegate._route == this);
    delegate._route = null;
    delegate._currentBody = null;
  }
}

class _SearchPage<T> extends StatefulWidget {
  const _SearchPage({
    this.delegate,
    this.animation,
  });

  final CustomSearchDelegate<T>? delegate;
  final Animation<double>? animation;

  @override
  State<StatefulWidget> createState() => _SearchPageState<T>();
}

class _SearchPageState<T> extends State<_SearchPage<T>> {
  // This node is owned, but not hosted by, the search page. Hosting is done by
  // the text field.
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.delegate!._queryTextController.addListener(_onQueryChanged);
    widget.animation!.addStatusListener(_onAnimationStatusChanged);
    widget.delegate!._currentBodyNotifier.addListener(_onSearchBodyChanged);
    focusNode.addListener(_onFocusChanged);
    widget.delegate!._focusNode = focusNode;
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate!._queryTextController.removeListener(_onQueryChanged);
    widget.animation!.removeStatusListener(_onAnimationStatusChanged);
    widget.delegate!._currentBodyNotifier.removeListener(_onSearchBodyChanged);
    widget.delegate!._focusNode = null;
    focusNode.dispose();
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    widget.animation!.removeStatusListener(_onAnimationStatusChanged);
    if (widget.delegate!._currentBody == _SearchBody.suggestions) {
      focusNode.requestFocus();
    }
  }

  @override
  void didUpdateWidget(_SearchPage<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.delegate != oldWidget.delegate) {
      oldWidget.delegate!._queryTextController.removeListener(_onQueryChanged);
      widget.delegate!._queryTextController.addListener(_onQueryChanged);
      oldWidget.delegate!._currentBodyNotifier
          .removeListener(_onSearchBodyChanged);
      widget.delegate!._currentBodyNotifier.addListener(_onSearchBodyChanged);
      oldWidget.delegate!._focusNode = null;
      widget.delegate!._focusNode = focusNode;
    }
  }

  void _onFocusChanged() {
    if (focusNode.hasFocus &&
        widget.delegate!._currentBody != _SearchBody.suggestions) {
      widget.delegate!.showSuggestions(context);
    }
  }

  void _onQueryChanged() {
    setState(() {
      // rebuild ourselves because query changed.
    });
  }

  void _onSearchBodyChanged() {
    setState(() {
      // rebuild ourselves because search body changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    final ThemeData theme = widget.delegate!.appBarTheme(context);
    final String searchFieldLabel = widget.delegate!.searchFieldLabel ??
        MaterialLocalizations.of(context).searchFieldLabel;
    Widget body;
    switch (widget.delegate!._currentBody!) {
      case _SearchBody.suggestions:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.suggestions),
          child: widget.delegate!.buildSuggestions(context),
        );
        break;
      case _SearchBody.results:
        body = KeyedSubtree(
          key: const ValueKey<_SearchBody>(_SearchBody.results),
          child: widget.delegate!.buildResults(context),
        );
        break;
    }
    String routeName;
    switch (theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        routeName = '';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        routeName = searchFieldLabel;
    }

    return Semantics(
        explicitChildNodes: true,
        scopesRoute: true,
        namesRoute: true,
        label: routeName,
        child: Scaffold(
          body: SafeArea(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: small_100)
                      .copyWith(left: normal_100),
                  margin: const EdgeInsets.all(normal_100),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(smallRadius),
                      gradient: LinearGradient(
                        colors:
                            (Theme.of(context).brightness == Brightness.light)
                                ? lightSearchBarGradient
                                : darkSearchBarGradient,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )),
                  child: Center(
                      child: TextFormField(
                          focusNode: focusNode,
                          controller: widget.delegate!._queryTextController,
                          textAlignVertical: TextAlignVertical.center,
                          onFieldSubmitted: (String _) {
                            widget.delegate!.showResults(context);
                          },
                          keyboardType: TextInputType.name,
                          style: Theme.of(context).textTheme.headline5,
                          cursorColor: Theme.of(context).primaryColor,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              isDense: true,
                              suffixIcon: IconButton(
                                  icon: (widget.delegate!.query == '')
                                      ? Icon(ProximityIcons.search,
                                          color:
                                              Theme.of(context).iconTheme.color)
                                      : Icon(ProximityIcons.remove,
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                  onPressed: () {
                                    widget.delegate!.query = '';
                                  }),
                              border: InputBorder.none,
                              hintText: 'Search Product.',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .headline5!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color))))),
              Divider(
                  height: tiny_50,
                  thickness: tiny_50,
                  color: Theme.of(context).dividerColor),
              Expanded(
                  child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: AnimatedSwitcher(
                          duration: normalAnimationDuration, child: body)))
            ]),
          ),
        ));
  }
}

Future<T?> previewSearch<T>({
  required BuildContext context,
  required CustomSearchDelegate<T> delegate,
  String query = '',
}) {
  delegate.query = query;
  delegate._currentBody = _SearchBody.suggestions;
  return Navigator.of(context).push(_SearchPageRoute<T>(delegate: delegate));
}
