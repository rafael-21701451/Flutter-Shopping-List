import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iquechumbei/bloc/ShoppingList.dart';

class EditProductScreen extends StatefulWidget {
  EditProductScreen({Key key, this.shoppingList, this.index}) : super(key: key);
  final ShoppingList shoppingList;
  final int index;

  @override
  State<StatefulWidget> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<EditProductScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _image;

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = image;
        widget.shoppingList.getProdutoAEditar().setFoto(_image);
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
        title: Text("Editar Produto"),
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
                widget.shoppingList.getProdutoAEditar().getFotoTlm() == null
                    ? Image.asset(
                        widget.shoppingList.getProdutoAEditar().getFoto())
                    : Image.file(
                        widget.shoppingList.getProdutoAEditar().getFotoTlm(),
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
                initialValue: widget.shoppingList.getProdutoAEditar().getNome(),
                validator: (val) => val.isEmpty ? 'Nome obrigatório' : null,
                onSaved: (val) =>
                    widget.shoppingList.getProdutoAEditar().setNome(val)),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Descrição Produto (opcional)',
                hintText: 'Ex: Bebida Essencial',
              ),
              initialValue:
                  widget.shoppingList.getProdutoAEditar().getDescricao(),
              onSaved: (val) =>
                  widget.shoppingList.getProdutoAEditar().setDescricao(val),
            ),
            TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.euro_symbol),
                  labelText: 'Preço Unitário (€)',
                  hintText: 'Ex: 1,99',
                ),
                initialValue: widget.shoppingList
                    .getProdutoAEditar()
                    .getPrecoUni()
                    .toStringAsFixed(2),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter(
                      RegExp("[0-9]+[.]?([0-9][0-9])?"))
                ],
                validator: (val) => val.isEmpty ? 'Preço obrigatório' : null,
                onSaved: (val) => widget.shoppingList
                    .getProdutoAEditar()
                    .setPrecoUni(double.parse(val))),
            TextFormField(
                decoration: InputDecoration(
                  icon: Icon(Icons.add_shopping_cart),
                  labelText: 'Quantidade',
                  hintText: 'Ex: 5',
                ),
                initialValue: widget.shoppingList
                    .getProdutoAEditar()
                    .getQuantidade()
                    .toString(),
                keyboardType: TextInputType.number,
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                validator: (val) =>
                    val.isEmpty ? 'Quantidade obrigatória' : null,
                onSaved: (val) => widget.shoppingList
                    .getProdutoAEditar()
                    .setQuantidade(int.parse(val))),
            Container(
              padding: EdgeInsets.all(15.0),
              child: FlatButton(
                color: Colors.amber,
                onPressed: () {
                  bool result = _submeter();
                  if (result == true) {
                    if (_image != null) {
                      widget.shoppingList.getProdutoAEditar().setFoto(_image);
                    }
                    widget.shoppingList.getProdutoAEditar().setPrecoTotal(widget
                            .shoppingList
                            .getProdutoAEditar()
                            .getQuantidade() *
                        widget.shoppingList.getProdutoAEditar().getPrecoUni());
                    String nome =
                        widget.shoppingList.getProdutoAEditar().getNome();
                    widget.shoppingList.editarProduto(
                        widget.shoppingList.getProdutoAEditar(), widget.index);
                    Navigator.pop(context, "O produto $nome foi editado.");
                  }
                },
                child: Text("Adicionar Produto"),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
