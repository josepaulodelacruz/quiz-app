
import 'package:equatable/equatable.dart';

class Violation extends Equatable {
  final int id;
  final String violation;
  final String description;

  static const empty = Violation(id: 0, violation: "", description: "");

  const Violation({
    this.id = 0,
    this.violation = "",
    this.description = "",
  });

  factory Violation.fromMap(Map<String, dynamic> map) {
    return Violation(
      id: map['id'],
      violation: map['violation'],
      description: map['description'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    violation,
    description,
  ];
}