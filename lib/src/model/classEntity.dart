class ClassEntity{
  late String name;
  late String id;

  ClassEntity({
    required this.name,
    required this.id
  });

  ClassEntity.fromMap(Map<String, dynamic>? map) {
    name = map?['name'] ?? '';
    id = map?['id'] ?? '';
  }
}