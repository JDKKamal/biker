class LoginResponse {
  final int empId;
  final String empName;
  final String empMobile;
  final String message;

  LoginResponse({this.empId, this.empName, this.empMobile, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      empId: json['EMPID'],
      empName: json['EMPNAME'],
      empMobile: json['EMPMBNO'],
      message: json['Message'],
    );
  }
}
