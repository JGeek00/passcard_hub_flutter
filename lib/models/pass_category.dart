class PassCategory {
  final String id;
  final String name;
  final String dateFormat;
  final String? path;
  final int? index;
  final List items;

  const PassCategory({
    required this.id,
    required this.name,
    required this.dateFormat,
    required this.path,
    required this.index,
    required this.items
  });
}