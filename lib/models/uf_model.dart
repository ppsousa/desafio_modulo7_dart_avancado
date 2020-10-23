import 'dart:convert';

import 'package:desafio_modulo7/models/regiao_model.dart';

class UfModel {
  int id;
  String nome;
  String sigla;
  RegiaoModel regiao;

  UfModel({
    this.id,
    this.nome,
    this.sigla,
    this.regiao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sigla': sigla,
      'regiao': regiao?.toMap(),
    };
  }

  factory UfModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UfModel(
      id: map['id'],
      nome: map['nome'],
      sigla: map['sigla'],
      regiao: RegiaoModel.fromMap(map['regiao']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UfModel.fromJson(String source) =>
      UfModel.fromMap(json.decode(source));
}
