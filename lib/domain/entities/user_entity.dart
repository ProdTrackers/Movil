class UserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is UserEntity &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}