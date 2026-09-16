class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final bool isStarter;

  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    this.isStarter = false,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      types: List<String>.from(json['types']),
      isStarter: json['isStarter'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'types': types,
      'isStarter': isStarter,
    };
  }

  @override
  String toString() {
    return '$name (${types.join(' / ')})';
  }
}