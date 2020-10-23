import 'dart:convert';

import 'package:desafio_modulo7/models/microrregiao_model.dart';

class MunicipioModel {
  int id;	
  String nome;	
  MicrorregiaoModel microrregiao;
  
  MunicipioModel({
    this.id,
    this.nome,
    this.microrregiao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'microrregiao': microrregiao?.toMap(),
    };
  }

  factory MunicipioModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return MunicipioModel(
      id: map['id'],
      nome: map['nome'],
      microrregiao: MicrorregiaoModel.fromMap(map['microrregiao']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MunicipioModel.fromJson(String source) => MunicipioModel.fromMap(json.decode(source));
}
