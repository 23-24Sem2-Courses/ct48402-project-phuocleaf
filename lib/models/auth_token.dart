class AuthToken {
  final String _token;
  final String _userId;
  final DateTime _expiryDate;
  final String _email;
  //final String _role;

  AuthToken({
    token,
    userId,
    expiryDate,
    email,
    //role,
  })  : _token = token,
        _userId = userId,
        _expiryDate = expiryDate,
        _email = email;
        //_role = role;

  bool get isValid {
    return token != null;
  }

  String get email {
    return _email;
  }

  String? get token {
    if (_expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  // String get role{
  //   return _role;
  // }

  DateTime get expiryDate {
    return _expiryDate;
  }

  Map<String, dynamic> toJson() {
    return {
      'authToken': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
      //'role': _role,
    };
  }

  static AuthToken fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['authToken'],
      userId: json['userId'],
      expiryDate: DateTime.parse(json['expiryDate']),
      //role: json['role'],
    );
  }
}
