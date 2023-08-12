import 'package:client_test/db/client_helper.dart';
import 'package:client_test/db/client_model.dart';
import 'package:flutter/material.dart';

import 'inset_page.dart';
class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  ClientDbHelper _clientRepo = ClientDbHelper();
  bool _isLoading = true;
  late Future<List<ClientModel>> _clientModelList;

  void _initClientList() async {
    _clientRepo.openDB().then((value) {
      setState(() {
        _isLoading = false;
      });
      _clientModelList = _clientRepo.selectAll();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initClientList();
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
      title: Text("Client Test"),
      actions: [IconButton(onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(builder: (context) => InsertPage()));
      }, icon: Icon(Icons.add))],
    );
  }

  Widget get _buildBody {
    return Container(
      alignment: Alignment.center,
      color: Colors.white70,
      child: _isLoading ? CircularProgressIndicator() : _buildFuture(),
    );
  }
  Widget _buildFuture() {
    return FutureBuilder<List<ClientModel>>(
        future: _clientModelList,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildListView(snapshot.data ?? []);
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _buildListView(List<ClientModel> items) {
    return RefreshIndicator(
        child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildItem(items[index]);
            }),
        onRefresh: () async {
          setState(() {
            _clientModelList = _clientRepo.selectAll();
          });
        });
  }
  Widget _buildItem(ClientModel item){
    return Card(
      child: ListTile(
        title: Text("${item.name}"),
        subtitle: Text("${item.gender}"),
        trailing: IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () async{
            await _clientRepo.delete(item.id!);
            setState(() {
              _clientModelList = _clientRepo.selectAll();
            });
          },
        ),
      ),
    );
  }
}
