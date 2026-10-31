class user {
  int id;
  String nama;
  String email;
  String password;  

  user({
    required this.id,
    required this.nama,
    required this.email,
    required this.password,
  });

  factory user.fromJson(Map<String, dynamic> json) {
    return user(
      id: json['id'] as int,
      nama: json['nama'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }
}