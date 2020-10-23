import 'dart:convert';
import 'mesorregiao_model.dart';

class MicrorregiaoModel {
  int id;
  String nome;
  MesorregiaoModel mesorregiao;

  MicrorregiaoModel({
    this.id,
    this.nome,
    this.mesorregiao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'mesorregiao': mesorregiao?.toMap(),
    };
  }

  factory MicrorregiaoModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MicrorregiaoModel(
      id: map['id'],
      nome: map['nome'],
      mesorregiao: MesorregiaoModel.fromMap(map['mesorregiao']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MicrorregiaoModel.fromJson(String source) =>
      MicrorregiaoModel.fromMap(json.decode(source));
}
