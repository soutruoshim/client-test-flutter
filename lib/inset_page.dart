import 'package:client_test/db/client_helper.dart';
import 'package:client_test/db/client_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  ClientDbHelper _clientRepo = ClientDbHelper();
  bool _isLoading = true;
  String gender="male";

  TextEditingController _nameCtrl = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _clientRepo.openDB().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  AppBar get _buildAppBar {
    return AppBar(
      title: Text("Add Client"),
      actions: [
        ElevatedButton.icon(
            onPressed: () {
              ClientModel clientModel = ClientModel(
                  id: DateTime.now().microsecond,
                  name: _nameCtrl.text.trim(),
                  gender: gender
              );
              _clientRepo.insert(clientModel).then((value) {
                print("${value.id} inserted");
                Fluttertoast.showToast(
                    msg: "${value.id} inserted",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              });
            }, icon: Icon(Icons.save), label: Text("Save")),
        ElevatedButton.icon(
            onPressed: () {
              _nameCtrl.clear();
              setState(() {
                gender = "male";
              });
            }, icon: Icon(Icons.clear), label: Text("Clear"))
      ],
    );
  }

  Widget get _buildBody {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
      child: _isLoading ? CircularProgressIndicator() : _buildPanel(),
    );
  }

  Widget _buildPanel() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
      TextField(
        controller: _nameCtrl,
        decoration: InputDecoration(hintText: "Full Name"),
      ),
      SizedBox(height: 16,),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choice gender?", style: TextStyle(
              fontSize: 18
          ),),
          RadioListTile(
            title: Text("Male"),
            value: "male",
            groupValue: gender,
            onChanged: (value){
              setState(() {
                gender = value.toString();
              });
            },
          ),

          RadioListTile(
            title: Text("Female"),
            value: "female",
            groupValue: gender,
            onChanged: (value){
              setState(() {
                gender = value.toString();
              });
            },
          ),
        ],
      )
    ]);
  }
}
