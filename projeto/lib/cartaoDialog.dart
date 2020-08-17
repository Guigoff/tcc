import 'package:flutter/material.dart';
import 'package:tcc/cartao.dart';

class CartaoDialog extends StatefulWidget {
  final Cartao cartao;

  CartaoDialog({this.cartao});

  @override
  _CartaoDialogState createState() => _CartaoDialogState();
}

class _CartaoDialogState extends State<CartaoDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Cartao _currentCartao = Cartao();

  @override
  void initState() {
    super.initState();

    if (widget.cartao != null) {
      _currentCartao = Cartao.fromMap(widget.cartao.toMap());
    }

    _titleController.text = _currentCartao.nome;
    _descriptionController.text = _currentCartao.telefone;
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.cartao == null ? 'Nova tarefa' : 'Editar tarefas'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
              autofocus: true),
          TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição')),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Salvar'),
          onPressed: () {
            _currentCartao.nome = _titleController.value.text;
            _currentCartao.telefone = _descriptionController.text;

            Navigator.of(context).pop(_currentCartao);
          },
        ),
      ],
    );
  }
}
