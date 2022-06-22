
import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final int id;
  final String fullName;
  final String profilePicture;

  const Author({
    this.id = 0,
    this.fullName = "",
    this.profilePicture = "",
  });

  static const empty = Author();

  @override
  List<Object> get props => [
    id,
    fullName,
    profilePicture
  ];

  factory Author.fromMap(Map<String, dynamic> map) {
    return Author(
      id: map['id'],
      fullName: map['full_name'],
      profilePicture: map['profile_picture'],
    );
  }

}