import 'dart:convert';

import 'package:desafio_modulo7/models/uf_model.dart';

class MesorregiaoModel {
  int id;
  String nome;
  UfModel uf;

  MesorregiaoModel({
    this.id,
    this.nome,
    this.uf,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'uf': uf?.toMap(),
    };
  }

  factory MesorregiaoModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MesorregiaoModel(
      id: map['id'],
      nome: map['nome'],
      uf: UfModel.fromMap(map['UF']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MesorregiaoModel.fromJson(String source) => MesorregiaoModel.fromMap(json.decode(source));
}
