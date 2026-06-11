import '../models/base_model.dart';
import 'base_repository.dart';

class InMemoryRepository<T extends BaseModel<ID>, ID> implements Repository<T, ID> {
  final List<T> _items;

  InMemoryRepository([List<T>? initialItems]) : _items = List<T>.from(initialItems ?? []);

  @override
  List<T> getAll() => List<T>.unmodifiable(_items);

  @override
  T? getById(ID id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void add(T item) {
    _items.add(item);
  }

  @override
  void update(ID id, T item) {
    final index = _items.indexWhere((x) => x.id == id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  void delete(ID id) {
    _items.removeWhere((item) => item.id == id);
  }
}
