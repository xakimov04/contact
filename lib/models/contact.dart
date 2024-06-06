class Contact {
  int? id;
  String name;
  String phone;
  DateTime createdTime;

  Contact({
    this.id,
    required this.name,
    required this.phone,
    required this.createdTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'createdTime': createdTime.toIso8601String(),
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      createdTime: DateTime.parse(map['createdTime']),
    );
  }
}
