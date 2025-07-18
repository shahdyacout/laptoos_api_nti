class ResponseModel {
  final String status;
  final String message;

  ResponseModel({
    required this.status,
    required this.message,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      status: json['status'].toString(), // عشان لو status جت bool
      message: json['message'] ?? '',
    );
  }

}
