class response_message {
  String Type;
  String Message;

  response_message({this.Type,this.Message});
  factory response_message.fromMap(Map<String, dynamic> json) {
    return response_message(
      Type: json["Type"],
      Message: json["Message"],
    );
  }

  Map<String, dynamic> toMap() => {
    'Type': Type,
    'Message': Message
  };
}