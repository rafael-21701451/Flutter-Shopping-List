import 'dart:io';

class Product {
  String fotoProduto;
  File fotoProdutoTlm;
  String nomeProduto, descricao;
  double precoUni, precoTotal;
  int quantidade;
  bool adquirido;

  Product(
      {this.fotoProduto,
      this.nomeProduto,
      this.descricao,
      this.precoUni,
      this.quantidade,
      this.adquirido = false});

  void adicionaQuantidade() {
    this.quantidade++;
    this.precoTotal = this.quantidade * this.precoUni;
  }

  void removerQuantidade() {
    if (this.quantidade != 1) {
      this.quantidade--;
      this.precoTotal = this.quantidade * this.precoUni;
    }
  }

  void fotoDefault() {
    this.fotoProduto = 'lib/assets/default.png';
  }

  bool foiAdquirido() {
    return this.adquirido;
  }

  void setAquisicao(bool aquisicao) {
    this.adquirido = aquisicao;
  }

  void setNome(String nome) {
    this.nomeProduto = nome;
  }

  void setDescricao(String descricao) {
    this.descricao = descricao;
  }

  void setQuantidade(int quantidade) {
    this.quantidade = quantidade;
  }

  void setPrecoUni(double precoUni) {
    this.precoUni = precoUni;
  }

  void setPrecoTotal(double precoTotal) {
    this.precoTotal = precoTotal;
  }

  void setFoto(File foto) {
    this.fotoProduto = null;
    this.fotoProdutoTlm = foto;
  }

  int getQuantidade() {
    return this.quantidade;
  }

  double getPrecoTotal() {
    return this.precoTotal;
  }

  double getPrecoUni() {
    return this.precoUni;
  }

  String getNome() {
    return this.nomeProduto;
  }

  File getFotoTlm() {
    return this.fotoProdutoTlm;
  }

  String getFoto() {
    return this.fotoProduto;
  }

  String getDescricao() {
    return this.descricao;
  }

  bool isAsset() {
    if (this.fotoProduto == null) {
      return false;
    } else {
      return true;
    }
  }
}
