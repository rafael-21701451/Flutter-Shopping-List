import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iquechumbei/bloc/ShoppingList.dart';
import 'package:sensors/sensors.dart';
import 'CreateProductScreen.dart';
import 'EditProductScreen.dart';

class ShoppingListScreen extends StatefulWidget {
  ShoppingListScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  ShoppingList _shoppingList = new ShoppingList();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _popUpAberto;
  bool _menuList;

  _mensagemSnackBar(String texto) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(texto),
        duration: const Duration(milliseconds: 1500)));
  }

  _showAlertDialog(BuildContext context) {
    this._popUpAberto = true;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Apagar Lista"),
            content: Text(
                "Tem a certeza que quer apagar todos os produtos da lista?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  setState(() {
                    this._popUpAberto = false;
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    _shoppingList.limparLista();
                    this._popUpAberto = false;
                    _mensagemSnackBar("Lista de produtos eliminada.");
                    Navigator.pop(context);
                  });
                },
              )
            ],
          );
        });
  }

  _goToEditScreen(
      BuildContext context, ShoppingList shoppingList, int index) async {
    this._menuList = false;
    var texto = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditProductScreen(shoppingList: shoppingList, index: index)),
    );
    this._menuList = true;
    if (texto != null) {
      _mensagemSnackBar("$texto");
    }
  }

  _goToCreateScreen(BuildContext context, ShoppingList list) async {
    this._menuList = false;
    var texto = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CreateProductScreen(shoppingList: list)),
    );
    this._menuList = true;
    if (texto != null) {
      _mensagemSnackBar("$texto");
    } else {
      _shoppingList.produtoAEditar(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title + " - Lista de Compras"),
      ),
      body: Column(children: <Widget>[
        Expanded(
            child: ListView.builder(
                itemCount: _shoppingList.getProducts().length,
                itemBuilder: (context, index) {
                  final produto = _shoppingList.getProducts()[index].getNome();
                  return Slidable(
                    key: UniqueKey(),
                    actionExtentRatio: 0.25,
                    actionPane: SlidableStrechActionPane(),
                    dismissal: SlidableDismissal(
                      dismissThresholds: {
                        SlideActionType.primary: 0.0,
                        SlideActionType.secondary: 1.0,
                      },
                      child: SlidableDrawerDismissal(),
                      onDismissed: (actionType) {
                        if (actionType == SlideActionType.primary) {
                          setState(() {
                            _shoppingList.removerProduto(index);
                            _mensagemSnackBar(
                                "O produto $produto foi removido da lista.");
                          });
                        }
                      },
                    ),
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Eliminar',
                        closeOnTap: true,
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          setState(() {
                            _shoppingList.removerProduto(index);
                            _mensagemSnackBar(
                                "O produto $produto foi removido da lista.");
                          });
                        },
                      ),
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption:
                            _shoppingList.getProducts()[index].foiAdquirido() ==
                                    false
                                ? 'Adquirir'
                                : 'Desmarcar',
                        closeOnTap: true,
                        color:
                            _shoppingList.getProducts()[index].foiAdquirido() ==
                                    false
                                ? Colors.green
                                : Colors.amber,
                        icon:
                            _shoppingList.getProducts()[index].foiAdquirido() ==
                                    false
                                ? Icons.check
                                : Icons.close,
                        onTap: () {
                          setState(() {
                            if (_shoppingList
                                .getProducts()[index]
                                .foiAdquirido()) {
                              _shoppingList
                                  .getProducts()[index]
                                  .setAquisicao(false);
                              _mensagemSnackBar(
                                  "O produto $produto deixou de estar adquirido.");
                            } else {
                              _shoppingList
                                  .getProducts()[index]
                                  .setAquisicao(true);
                              _mensagemSnackBar(
                                  "O produto $produto foi adquirido.");
                            }
                          });
                        },
                      ),
                    ],
                    child: Card(
                        child: InkWell(
                      onTap: () {
                        _shoppingList
                            .produtoAEditar(_shoppingList.getProducts()[index]);
                        _goToEditScreen(context, _shoppingList, index);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: SizedBox(
                                width: 75.0,
                                child: _shoppingList.assetOuFile(
                                        _shoppingList.getProducts()[index])
                                    ? Image.asset(_shoppingList
                                        .getProducts()[index]
                                        .getFoto())
                                    : Image.file(_shoppingList
                                        .getProducts()[index]
                                        .getFotoTlm())),
                            title: Column(
                              children: <Widget>[
                                Text(
                                  _shoppingList.getProducts()[index].getNome(),
                                  style: TextStyle(
                                      color: _shoppingList
                                                  .getProducts()[index]
                                                  .foiAdquirido() ==
                                              true
                                          ? Colors.green
                                          : Colors.black54),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: <Widget>[
                                Text(
                                    'Quantidade: ' +
                                        _shoppingList
                                            .getProducts()[index]
                                            .getQuantidade()
                                            .toString(),
                                    style: TextStyle(
                                        color: _shoppingList
                                                    .getProducts()[index]
                                                    .foiAdquirido() ==
                                                true
                                            ? Colors.green
                                            : Colors.black54)),
                                Text(
                                    'Preço Total: ' +
                                        _shoppingList
                                            .getProducts()[index]
                                            .getPrecoTotal()
                                            .toStringAsFixed(2) +
                                        '€',
                                    style: TextStyle(
                                        color: _shoppingList
                                                    .getProducts()[index]
                                                    .foiAdquirido() ==
                                                true
                                            ? Colors.green
                                            : Colors.black54)),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Wrap(
                              spacing: 12, // space between two icons
                              children: <Widget>[
                                SizedBox(
                                  width: 30.0,
                                  child: IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: () {
                                        setState(() {
                                          _shoppingList.removerQuantidade(
                                              _shoppingList
                                                  .getProducts()[index]);
                                        });
                                      }),
                                ),
                                SizedBox(
                                  width: 30.0,
                                  child: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () {
                                        setState(() {
                                          _shoppingList.adicionarQuantidade(
                                              _shoppingList
                                                  .getProducts()[index]);
                                        });
                                      }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                  );
                })),
        Text(
          _shoppingList.getNumProdutos(),
          style: TextStyle(fontSize: 15),
        ),
        Text(_shoppingList.getPrecoTotal(), style: TextStyle(fontSize: 15)),
      ]),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _goToCreateScreen(context, _shoppingList);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._popUpAberto = false;
    this._menuList = true;
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if ((event.x > 20 ||
              event.x < -20 ||
              event.y > 20 ||
              event.y < -20 ||
              event.z > 20 ||
              event.z < -20) &&
          _menuList) {
        if (!this._popUpAberto) {
          setState(() {
            _showAlertDialog(context);
          });
        }
      }
    });
    accelerometerEvents.listen((AccelerometerEvent event) {
      if ((event.x > 20 ||
              event.x < -20 ||
              event.y > 20 ||
              event.y < -20 ||
              event.z > 20 ||
              event.z < -20) &&
          _menuList) {
        if (!this._popUpAberto) {
          setState(() {
            _showAlertDialog(context);
          });
        }
      }
    });
  }
}
