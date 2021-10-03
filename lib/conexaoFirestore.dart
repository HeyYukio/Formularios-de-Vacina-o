import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> registroVacinado(Map<String, dynamic> vacinado) async {
  try {
    await FirebaseFirestore.instance
        .collection('vacinados')
        .doc(_cpfOuCns(vacinado))
        .set({
      'nome': vacinado['Nome'],
      'email': vacinado['Email'],
      'CPF': vacinado['CPF'],
      'CNS': vacinado['CNS'],
      'Telefone': vacinado['Telefone'],
      'Sexo': vacinado['Sexo'],
      'Condicao': vacinado['Condicao'],
      'Endereco': vacinado['Endereço'],
      'Data de nascimento': vacinado['Nascimento'],
      '${_primeiraOuSegundaDose(vacinado)}': vacinado['Dose'],
      'Grupo': vacinado['Grupo'],
      'Raça': vacinado['Raça'],
      'Nome da mãe': vacinado['Nome da mãe'],
      'Aplicador': vacinado['Aplicador'],
    }, SetOptions(merge: true));
  } catch (e) {
    print("pegou " + e.toString());
  }
}

Future<void> registroAplicador(Map<String, dynamic> aplicador) async {
  try {
    await FirebaseFirestore.instance
        .collection('aplicadores')
        .doc(aplicador['Email'])
        .set({
      'nome': aplicador['Nome'],
      'email': aplicador['Email'],
      'CPF': aplicador['CPF'],
      'Coren': aplicador['Coren'],
    }, SetOptions(merge: true));
  } catch (e) {
    print("pegou " + e.toString());
  }
}

Future<dynamic> pegarDadosVacinado(String? cpfCns, bool botao) async {
  try {
    return FirebaseFirestore.instance.collection('vacinados').doc(cpfCns).get();
  } catch (e) {
    print("pegou " + e.toString());
  }
}

Future<dynamic> pegarDadosVacinas() async {
  try {
    return FirebaseFirestore.instance.collection('dados_vacinacao').get();
  } catch (e) {
    print("pegou " + e.toString());
  }
}

Future<dynamic> pegarTokens() async {
  try {
    return FirebaseFirestore.instance.collection('tokens').get();
  } catch (e) {
    print("pegou " + e.toString());
  }
}

String _cpfOuCns(Map<String, dynamic> vacinado) {
  if (vacinado['CPF'] == null) return vacinado['CNS'];
  return vacinado['CPF'];
}

String _primeiraOuSegundaDose(Map<String, dynamic> vacinado) {
  if (vacinado['numeroDose'] == '1') return '1a dose';
  return '2a dose';
}

Future<dynamic> pegarDadosAplicador(String? email) async {
  try {
    return FirebaseFirestore.instance
        .collection('aplicadores')
        .doc(email)
        .get();
  } catch (e) {
    print("pegou " + e.toString());
  }
}
