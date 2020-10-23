import 'package:desafio_modulo7/models/regiao_model.dart';
import 'package:mysql1/mysql1.dart';

import '../database_manager.dart';

class RegiaoRepository {
  Future<void> cadastrarRegiao(RegiaoModel regiao) async {
    var conn = await getConnection();
    try {
      var buscarRegiao =
          await conn.query('select id from regiao where id = ?', [regiao.id]);

      if (buscarRegiao.isEmpty) {
        var resultRegiao = await conn.query(
            'insert into regiao(id, nome, sigla)values(?,?,?)',
            [regiao.id, regiao.nome, regiao.sigla]);

        print(resultRegiao.affectedRows > 0
            ? 'Região ${regiao.nome} cadastrada com sucesso !!!'
            : 'Não foi possível inserir a Região ${regiao.nome}!!!');
      } else {
        print('Região ${regiao.nome} já existe.');
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
