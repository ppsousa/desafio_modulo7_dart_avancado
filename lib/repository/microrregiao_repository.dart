import 'package:desafio_modulo7/models/microrregiao_model.dart';
import 'package:mysql1/mysql1.dart';

import '../database_manager.dart';

class MicrorregiaoRepository {
  Future<void> cadastrarMicrorregiao(MicrorregiaoModel microrregiao) async {
    var conn = await getConnection();
    try {
      var buscarMicrorregiao = await conn
          .query('select id from microrregiao where id = ?', [microrregiao.id]);

      if (buscarMicrorregiao.isEmpty) {
        var resultMesorregiao = await conn.query(
            'insert into microrregiao(id, nome, mesorregiaoId)values(?,?,?)',
            [microrregiao.id, microrregiao.nome, microrregiao.mesorregiao.id]);

        print(resultMesorregiao.affectedRows > 0
            ? 'Microrregiao ${microrregiao.nome} cadastrada com sucesso !!!'
            : 'Não foi possível inserir a Microrregiao ${microrregiao.nome}!!!');
      } else {
        print('Microrregiao ${microrregiao.nome} já existe.');
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
