import 'package:iquechumbei/models/Product.dart';
import 'package:iquechumbei/data/DataSource.dart';

class ShoppingList {
  DataSource products = DataSource.getInstance();
  Product productToEdit = new Product();

  ShoppingList() {
    Product papel = Product(
        fotoProduto: 'lib/assets/papel.png',
        nomeProduto: "Papel Higiénico",
        descricao: "Limpa",
        quantidade: 10,
        precoUni: 0.59);
    papel.precoTotal = papel.quantidade * papel.precoUni;
    products.insert(papel);

    Product corona = Product(
        fotoProduto: 'lib/assets/corona.png',
        nomeProduto: "Cerveja Corona",
        descricao: "Cerveja Fresquinha",
        quantidade: 12,
        precoUni: 1.99);
    corona.precoTotal = corona.quantidade * corona.precoUni;
    products.insert(corona);

    Product chocolate = Product(
        fotoProduto: 'lib/assets/milka.png',
        nomeProduto: "Chocolate Milka",
        descricao: "Chocolate de Leite",
        quantidade: 3,
        precoUni: 3.99);
    chocolate.precoTotal = chocolate.quantidade * chocolate.precoUni;
    products.insert(chocolate);
  }

  getProducts() {
    return products.getAll();
  }

  String getNumProdutos() {
    int quantidade = 0;
    for (Product product in products.getAll()) {
      quantidade += product.getQuantidade();
    }
    return "Número de Produtos: " + quantidade.toString();
  }

  String getPrecoTotal() {
    double preco = 0;
    for (Product product in products.getAll()) {
      preco += product.getPrecoTotal();
    }
    return "Preço Total: " + preco.toStringAsFixed(2) + "€";
  }

  bool assetOuFile(Product product) {
    return product.isAsset();
  }

  void removerQuantidade(Product product) {
    product.removerQuantidade();
  }

  void adicionarQuantidade(Product product) {
    product.adicionaQuantidade();
  }

  void limparLista() {
    this.products.clear();
  }

  void removerProduto(int index) {
    this.products.getAll().removeAt(index);
  }

  void adicionarProduto(Product product) {
    this.products.insert(product);
  }

  void produtoAEditar(Product product) {
    this.productToEdit = product;
  }

  Product getProdutoAEditar() {
    return this.productToEdit;
  }

  void editarProduto(Product product, int index) {
    this.products.edit(product, index);
  }
}
