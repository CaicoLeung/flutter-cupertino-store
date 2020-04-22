import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_app/components/product_row_item.dart' show ProductRowItem;
import 'package:cupertino_app/components/search_bar.dart' show SearchBar;
import 'package:cupertino_app/model/app_state_model.dart' show AppStateModel;
import 'styles.dart' show Styles;

class CupertinoStoreSearchPage extends StatefulWidget {
  @override
  _CupertinoStoreSearchPageState createState() => _CupertinoStoreSearchPageState();
}

class _CupertinoStoreSearchPageState extends State<CupertinoStoreSearchPage> {
  TextEditingController _controller;
  FocusNode _focusNode;
  String _terms = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController()..addListener(_onTextChanged);
    _focusNode = FocusNode();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    final results = model.search(_terms);
    return DecoratedBox(
        decoration: const BoxDecoration(color: Styles.scaffoldBackground),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              _buildSearchBox(),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) => ProductRowItem(
                      index: index,
                      product: results[index],
                      lastItem: index == results.length - 1,
                    ),
                    itemCount: results.length,
                  ),
                )
              )
            ],
          ),
        ));
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }

  void _onTextChanged() {
    setState(() {
      _terms = _controller.text;
    });
  }
}
