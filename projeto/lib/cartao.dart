class Cartao {
  int id;
  String nome;
  String endereco;
  String telefone;
  String site;
  String observacao;

  Cartao(
      {this.id,
      this.nome,
      this.endereco,
      this.telefone,
      this.site,
      this.observacao});

  bool enderecoValido(String endereco) {
    return null;
  }

  bool telefoneValido(String telefone){
    return null;

  }

factory Cartao.fromMap(Map<String, dynamic> json) => Cartao(
        id: json["id"],
        nome: json["nome"],
        endereco: json["endereco"],
        telefone: json["telefone"],
        site: json["site"],
        observacao: json["observacao"],
      );

 
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "nome": nome,
      "endereco": endereco,
      "telefone": telefone,
      "site": site,
      "observacao": observacao,
    };

    if (id != null) map["id"] = id;

    return map;
  }

}
