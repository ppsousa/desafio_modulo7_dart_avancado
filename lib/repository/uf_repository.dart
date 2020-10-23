import 'package:desafio_modulo7/models/uf_model.dart';
import 'package:desafio_modulo7/models/regiao_model.dart';
import 'package:desafio_modulo7/repository/municipio_repository.dart';
import 'package:desafio_modulo7/repository/regiao_repository.dart';
import 'package:dio/dio.dart';
import 'package:mysql1/mysql1.dart';

import '../database_manager.dart';

class UfRepository {
  Future<List<UfModel>> buscarEstados() async {
    try {
      var url = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados';
      var dio = Dio();

      var response = await dio.get(url);
      var respData = response.data;
      if (response.statusCode == 200) {
        var estados = respData != null ? List.from(respData) : null;
        var retornoEstados = <UfModel>[];
        for (var reg in estados) {
          var estado = UfModel.fromMap(reg);
          retornoEstados.add(estado);
        }
        return retornoEstados;
      }
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> cadastrarEstado(UfModel uf) async {
    var conn = await getConnection();
    try {
      //regiao
      var regiao = RegiaoModel(
          id: uf.regiao.id, nome: uf.regiao.nome, sigla: uf.regiao.sigla);

      await RegiaoRepository().cadastrarRegiao(regiao);

      //estado
      var buscarUf =
          await conn.query('select id from estado where id = ?', [uf.id]);

      if (buscarUf.isEmpty) {
        var resultUf = await conn.query(
            'insert into estado(id, nome, sigla, regiaoId)values(?, ?, ?, ?)',
            [uf.id, uf.nome, uf.sigla, uf.regiao.id]);

        print(resultUf.affectedRows > 0
            ? 'UF cadastrado com sucesso!!!'
            : 'Não foi possível inserir o UF!!!');
      } else {
        print('UF ${uf.nome} já existe');
      }

      var municipios = await MunicipioRepository().buscarMunicipios(uf.id);
      for (var municipio in municipios) {
        await MunicipioRepository().cadastrarMunicipio(municipio);
      }
    } on MySqlException catch (m) {
      print(m);
    } on Exception catch (e) {
      print(e);
    } finally {
      await conn?.close();
    }
  }
}
