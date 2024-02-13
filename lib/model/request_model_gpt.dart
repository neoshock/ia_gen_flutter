class RequestModelGPT {
  String model;
  List<RequestMessageGPT> messages;

  RequestModelGPT(this.model, this.messages);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['messages'] = this.messages.map((e) => e.toJson()).toList();
    return data;
  }
}

class RequestMessageGPT {
  String role;
  String message;

  RequestMessageGPT(this.role, this.message);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['content'] = this.message;
    return data;
  }

  @override
  String toString() {
    return 'RequestMessageGPT{role: $role, message: $message}';
  }
}
