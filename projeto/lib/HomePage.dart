import 'package:flushbar/flushbar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:tcc/CartaoHelper.dart';
import 'package:tcc/cartao.dart';
import 'package:tcc/cartaoDialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cartao> _cartaoList = [];
  CartaoHelper _helper = CartaoHelper();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _helper.getAll().then((list) {
      setState(() {
        _cartaoList = list;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Cartoes')),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: _addNewCartao),
      body: _buildCartaoList(),
    );
  }

  Widget _buildCartaoList() {
    if (_cartaoList.isEmpty) {
      return Center(
        child: _loading ? CircularProgressIndicator() : Text("Sem cartoes!"),
      );
    } else {
      return ListView.builder(
        itemBuilder: _buildCartaoItemSlidable,
        itemCount: _cartaoList.length,
      );
    }
  }

  Widget _buildCartaoItem(BuildContext context, int index) {
    final cartao = _cartaoList[index];
    return CheckboxListTile(
      title: Text(cartao.nome),
      subtitle: Text(cartao.telefone),
    
    );
  }

  Widget _buildCartaoItemSlidable(BuildContext context, int index) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: _buildCartaoItem(context, index),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            _addNewCartao(editedCartao: _cartaoList[index], index: index);
          },
        ),
        IconSlideAction(
          caption: 'Excluir',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _deleteCartao(deletedCartao: _cartaoList[index], index: index);
          },
        ),
      ],
    );
  }

  Future _addNewCartao({Cartao editedCartao, int index}) async {
    final cartao = await showDialog<Cartao>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CartaoDialog(cartao: editedCartao);
      },
    );

    if (cartao != null) {
      setState(() {
        if (index == null) {
          _cartaoList.add(cartao);
          _helper.save(cartao);
        } else {
          _cartaoList[index] = cartao;
          _helper.update(cartao);
        }
      });
    }
  }

  void _deleteCartao({Cartao deletedCartao, int index}) {
    setState(() {
      _cartaoList.removeAt(index);
    });

    _helper.delete(deletedCartao.id);

    Flushbar(
      title: "Exclusão de cartoes",
      message: "Tarefa \"${deletedCartao.nome}\" removida.",
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      duration: Duration(seconds: 3),
      mainButton: FlatButton(
        child: Text(
          "Desfazer",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          setState(() {
            _cartaoList.insert(index, deletedCartao);
            _helper.update(deletedCartao);
          });
        },
      ),
    )..show(context);
  }
}
