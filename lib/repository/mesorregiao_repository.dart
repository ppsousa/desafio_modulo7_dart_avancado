import 'package:desafio_modulo7/models/mesorregiao_model.dart';

import '../database_manager.dart';

class MesorregiaoRepository {
  Future<void> cadastrarMesorregiao(MesorregiaoModel mesorregiao) async {
    var conn = await getConnection();
    try {
      var buscarMesorregiao = await conn
          .query('select id from mesorregiao where id = ?', [mesorregiao.id]);

      if (buscarMesorregiao.isEmpty) {
        var resultMesorregiao = await conn.query(
            'insert into mesorregiao(id, nome)values(?,?)',
            [mesorregiao.id, mesorregiao.nome]);

        print(resultMesorregiao.affectedRows > 0
            ? 'Mesorregião ${mesorregiao.nome} cadastrada com sucesso !!!'
            : 'Não foi possível inserir a Mesorregião ${mesorregiao.nome}!!!');
      } else {
        print('Mesorregiao ${mesorregiao.nome} já existe.');
      }
    } on Exception catch (e) {
      print(e);
    } finally {
      await conn?.close();
    }
  }
}
