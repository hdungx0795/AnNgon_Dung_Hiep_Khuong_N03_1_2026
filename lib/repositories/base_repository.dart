import '../models/base_model.dart';

abstract class Repository<T extends BaseModel<ID>, ID> {
  List<T> getAll();
  T? getById(ID id);
  void add(T item);
  void update(ID id, T item);
  void delete(ID id);
}
