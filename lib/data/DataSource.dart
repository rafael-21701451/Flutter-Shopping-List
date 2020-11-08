class DataSource {
  final _datasource = [];
  static DataSource _instance;

  DataSource._internal();

  static DataSource getInstance() {
    if (_instance == null) {
      _instance = DataSource._internal();
    }
    return _instance;
  }

  void insert(operation) => _datasource.add(operation);

  void clear() => _datasource.clear();

  void remove(int index) => _datasource.removeAt(index);

  void edit(value, int index) => _datasource[index] = value;

  List getAll() => _datasource;
}
