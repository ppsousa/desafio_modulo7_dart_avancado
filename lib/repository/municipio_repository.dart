import 'package:desafio_modulo7/models/mesorregiao_model.dart';
import 'package:desafio_modulo7/models/microrregiao_model.dart';
import 'package:desafio_modulo7/models/municipio_model.dart';
import 'package:desafio_modulo7/repository/mesorregiao_repository.dart';
import 'package:desafio_modulo7/repository/microrregiao_repository.dart';
import 'package:dio/dio.dart';
import 'package:mysql1/mysql1.dart';

import '../database_manager.dart';

class MunicipioRepository {
  Future<List<MunicipioModel>> buscarMunicipios(int idEstado) async {
    try {
      var url = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados/' +
          idEstado.toString() +
          '/municipios';
      var dio = Dio();

      var response = await dio.get(url);
      var respData = response.data;
      if (response.statusCode == 200) {
        var municipios = respData != null ? List.from(respData) : null;
        var retornoMunicipios = <MunicipioModel>[];
        for (var reg in municipios) {
          var municipio = MunicipioModel.fromMap(reg);
          retornoMunicipios.add(municipio);
        }
        return retornoMunicipios;
      }
    } on Exception catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> cadastrarMunicipio(MunicipioModel municipio) async {
    var conn = await getConnection();
    try {
      //mesorregiao
      var mesorregiao = MesorregiaoModel();
      mesorregiao.id = municipio.microrregiao.mesorregiao.id;
      mesorregiao.nome = municipio.microrregiao.mesorregiao.nome;

      await MesorregiaoRepository().cadastrarMesorregiao(mesorregiao);

      //microrregiao
      var microrregiao = MicrorregiaoModel();
      microrregiao.id = municipio.microrregiao.id;
      microrregiao.nome = municipio.microrregiao.nome;
      microrregiao.mesorregiao = mesorregiao;

      await MicrorregiaoRepository().cadastrarMicrorregiao(microrregiao);

      //municipio
      var buscarMunicipio = await conn
          .query('select id from municipio where id = ?', [municipio.id]);

      if (buscarMunicipio.isEmpty) {
        var resultMunicipio = await conn.query(
            'insert into municipio(id, nome, microrregiaoId, estadoId)values(?, ?, ?, ?)',
            [
              municipio.id,
              municipio.nome,
              municipio.microrregiao.id,
              municipio.microrregiao.mesorregiao.uf.id
            ]);

        print(resultMunicipio.affectedRows > 0
            ? 'Município ${municipio.nome} cadastrado com sucesso para o estado ${municipio.microrregiao.mesorregiao.uf.nome}!!!'
            : 'Não foi possível inserir o Município para o estado ${municipio.microrregiao.mesorregiao.uf.nome}!!!');
      } else {
        print('Municipio ${municipio.nome} já existe');
      }
    } on MySqlException catch (m) {
      print(m);
      throw ('Ocorreu erro: $m');
    } on Exception catch (e) {
      print(e);
    } finally {
      await conn?.close();
    }
  }
}
