import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iquechumbei/bloc/ShoppingList.dart';
import '../models/Product.dart';

class CreateProductScreen extends StatefulWidget {
  CreateProductScreen({Key key, this.shoppingList}) : super(key: key);
  final ShoppingList shoppingList;

  @override
  State<StatefulWidget> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  Product _product = new Product();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _image;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = image;
      }
    });
  }

  _CreateProductScreenState();

  bool _submeter() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      return false;
    } else {
      form.save();
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Adicionar Produto"),
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
                child: Column(
              children: <Widget>[
                _image == null
                    ? IconButton(
                        icon: Icon(Icons.add_a_photo),
                        onPressed: () {
                          _getImage();
                        },
                      )
                    : Image.file(
                        _image,
                      ),
                FlatButton(
                  onPressed: () {
                    _getImage();
                  },
                  child: Text("Seleccione uma imagem (opcional)"),
                )
              ],
            )),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.create),
                labelText: 'Nome Produto',
                hintText: 'Ex: Água',
              ),
              validator: (val) => val.isEmpty ? 'Nome obrigatório' : null,
              onSaved: (val) => _product.setNome(val),
            ),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Descrição Produto (opcional)',
                hintText: 'Ex: Bebida Essencial',
              ),
              onSaved: (val) => _product.setDescricao(val),
            ),
            TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.euro_symbol),
                  labelText: 'Preço Unitário (€)',
                  hintText: 'Ex: 1,99',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter(
                      RegExp("[0-9]+[.]?([0-9][0-9])?"))
                ],
                validator: (val) => val.isEmpty ? 'Preço obrigatório' : null,
                onSaved: (val) => _product.setPrecoUni(double.parse(val))),
            TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.add_shopping_cart),
                  labelText: 'Quantidade',
                  hintText: 'Ex: 5',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                validator: (val) =>
                    val.isEmpty ? 'Quantidade obrigatória' : null,
                onSaved: (val) => _product.setQuantidade(int.parse(val))),
            Container(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                color: Colors.amber,
                onPressed: () {
                  bool result = _submeter();
                  if (result == true) {
                    if (_image != null) {
                      _product.setFoto(_image);
                    } else {
                      _product.fotoDefault();
                    }
                    _product.setPrecoTotal(
                        _product.getQuantidade() * _product.getPrecoUni());
                    widget.shoppingList.adicionarProduto(_product);
                    Navigator.pop(context,
                        "O produto ${_product.nomeProduto} foi adicionado.");
                  }
                },
                child: Text("Adicionar Produto"),
              ),
            )
          ],
        ),
      )),
    );
  }
}
