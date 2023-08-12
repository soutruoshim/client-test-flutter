const String databaseName = "db_client";
const int databaseVersion = 1;
const String tableName = "tbl_clients";
const String columnId = "id";
const String columnName = "name";
const String columnGender = "gender";

class ClientModel {
  int? id;
  String? name;
  String? gender;

  ClientModel({this.id, this.name, this.gender});

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
        id : json['id'],
        name : json['name'],
        gender: json['gender']
    );
  }

  Map<String, dynamic> get toMap => {
    columnId : id,
    columnName: name,
    columnGender: gender
  };
}


