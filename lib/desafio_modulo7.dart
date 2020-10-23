import 'repository/uf_repository.dart';

void Run() async {
  var estados = await UfRepository().buscarEstados();
  for (var reg in estados) {
    await UfRepository().cadastrarEstado(reg);
  }
}
