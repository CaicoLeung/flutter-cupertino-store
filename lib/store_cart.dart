import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:cupertino_app/model/app_state_model.dart' show AppStateModel;
import 'package:cupertino_app/model/product.dart' show Product;
import 'styles.dart' show Styles;

const double _kDateTImePickerHeight = 216;

class CupertinoStoreCartPage extends StatefulWidget {
  @override
  _CupertinoStoreCartPage createState() => _CupertinoStoreCartPage();
}

class _CupertinoStoreCartPage extends State<CupertinoStoreCartPage> {
  String name;
  String email;
  String location;
  String pin;
  DateTime dateTime = DateTime.now();
  final _currencyFormat = NumberFormat.currency(symbol: '\$');

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: CustomScrollView(
            slivers: <Widget>[
              CupertinoSliverNavigationBar(
                largeTitle: Text('购物车'),
              ),
              SliverSafeArea(
                top: false,
                minimum: const EdgeInsets.only(top: 4),
                sliver: SliverList(
                  delegate: _buildSliverChildBuilderDelegate(model),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildNameField() {
    return CupertinoTextField(
      prefix: const Icon(
        CupertinoIcons.person_solid,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0, color: CupertinoColors.inactiveGray))),
      placeholder: '收货人',
      onChanged: (newName) {
        setState(() {
          name = newName;
        });
      },
    );
  }

  Widget _buildEmailField() {
    return const CupertinoTextField(
      prefix: Icon(
        CupertinoIcons.mail_solid,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0, color: CupertinoColors.inactiveGray))),
      placeholder: '邮箱',
    );
  }

  Widget _buildLocationField() {
    return const CupertinoTextField(
      prefix: Icon(
        CupertinoIcons.location_solid,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0, color: CupertinoColors.inactiveGray))),
      placeholder: '位置',
    );
  }

  SliverChildBuilderDelegate _buildSliverChildBuilderDelegate(AppStateModel model) {
    return SliverChildBuilderDelegate(
      (context, index) {
        final productIndex = index - 4;
        print(productIndex);
        switch (index) {
          case 0:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildNameField(),
            );
          case 1:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildEmailField(),
            );
          case 2:
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildLocationField(),
            );
          case 3:
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: _buildDateTimePicker(context),
                )
              ],
            );
          default:
            print('default: ');
            if (model.productsInCart.length > productIndex) {
              return ShoppingCartItem(
                index: index,
                product: model.getProductById(model.productsInCart.keys.toList()[productIndex]),
                quantity: model.productsInCart.values.toList()[productIndex],
                lastItem: productIndex == model.productsInCart.length - 1,
                formatter: _currencyFormat,
              );
            } else if (model.productsInCart.keys.length == productIndex && model.productsInCart.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '运费: '
                          '${_currencyFormat.format(model.shippingCost)}',
                          style: Styles.productRowItemPrice,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '税费: ${_currencyFormat.format(model.tax)}',
                          style: Styles.productRowItemPrice,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '总价: ${_currencyFormat.format(model.totalCost)}',
                          style: Styles.productRowTotal,
                        )
                      ],
                    )
                  ],
                ),
              );
            }
        }
        return null;
      },
    );
  }

  Widget _buildDateTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(context: context, builder: (BuildContext context) => _alertDialog(context));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const <Widget>[
              Icon(
                CupertinoIcons.clock,
                color: CupertinoColors.lightBackgroundGray,
                size: 28,
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                '收货时间',
                style: Styles.deliveryTimeLabel,
              )
            ],
          ),
          Text(
            DateFormat.yMd().add_jm().format(dateTime),
            style: Styles.deliveryTime,
          )
        ],
      ),
    );
  }

  Widget _alertDialog(BuildContext context) {
    return Container(
      height: _kDateTImePickerHeight,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        initialDateTime: dateTime,
        onDateTimeChanged: (newDateTime) {
          setState(() {
            dateTime = newDateTime;
          });
        },
      ),
    );
  }
}

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({this.product, this.index, this.lastItem, this.quantity, this.formatter});

  final Product product;
  final int index;
  final bool lastItem;
  final int quantity;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                child: Row(
                  children: <Widget>[
                    Image.asset(product.assetName, package: product.assetPackage, width: 76, height: 76,),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  product.name,
                                  style: Styles.productRowItemName,
                                ),
                                Text(
                                  '${formatter.format(quantity * product.price)}',
                                  style: Styles.productRowItemName,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '${quantity > 1 ? '$quantity x' : ''}'
                                  '${formatter.format(product.price)}',
                              style: Styles.productRowItemPrice,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
          ),
        ],
      )
    );
    return row;
  }
}
