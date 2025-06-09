class SignupRequest {
  final String email;
  final String password;

  SignupRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
