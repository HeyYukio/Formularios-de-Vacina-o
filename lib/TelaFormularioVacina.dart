import 'package:aplicativo/TelaVacinador.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'conexaoFirestore.dart';
import 'TelaLogin.dart';

class TelaVacina extends StatefulWidget {
  TelaVacina(this.vacinado, this.dados_vacinacao, {Key? key}) : super(key: key);
  Map<String, dynamic> vacinado;
  dynamic dados_vacinacao;
  @override
  _TelaVacinaState createState() => _TelaVacinaState();
}

class _TelaVacinaState extends State<TelaVacina> {
  bool segundaDose = false;
  final _formKey = GlobalKey<FormState>();
  bool botao = false;
  String? dropdownValueVacina;
  String? dropdownValueOcupacao;
  String? dropdownValueLote;
  Map<String, dynamic> dose = {};
  Map<String, dynamic> outro = {};

  Widget _dataAprazamento(vacina, data, dose) {
    if (data == null) data = widget.vacinado['Aplicação'];
    if (data == null) data = DateTime.now();
    if (dose == '1') {
      if (vacina == 'CORONAVAC')
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              helperText: 'Data de aprazamento',
              hintText: DateFormat('dd/MM/yyyy')
                  .format(data.add(Duration(days: 28)))), // CORONAVAC: 28 dias
        );
      else if (vacina == 'ASTRAZENECA')
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              helperText: 'Data de aprazamento',
              hintText: DateFormat('dd/MM/yyyy').format(
                  data.add(Duration(days: 84)))), // ASTRAZENECA: 84 dias
        );
      else if (vacina == 'PFIZER')
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              //labelText: 'Data de aprazamento',
              helperText: 'Data de aprazamento',
              hintText: DateFormat('dd/MM/yyyy')
                  .format(data.add(Duration(days: 84)))), // PFIZER: 84 dias
        );
      else if (vacina == 'JANSSEN')
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
              //labelText: 'Data de aprazamento',
              helperText: 'Data de aprazamento',
              hintText: 'DOSE UNICA'), // PFIZER: 84 dias
        );
      return TextFormField(
        enabled: false,
        decoration: InputDecoration(
            //labelText: 'Data de aprazamento',
            helperText: 'Data de aprazamento',
            hintText:
                'Para a data de aprazamento, selecione uma vacina'), // PFIZER: 84 dias
      );
    }
    return Container();
  }

  List<String> _lotes(String? vacina) {
    List<String> lotes = [];
    widget.dados_vacinacao.forEach((valor) => {
          if (valor["Nome"] == vacina)
            {lotes = List<String>.from(valor["Lotes"] as List)}
        });
    lotes.add("Outro");
    return lotes;
  }

  List<String> _grupos() {
    List<String> grupos = [];
    widget.dados_vacinacao.forEach((valor) => {
          if (valor["Nome"] == "Grupos")
            {grupos = List<String>.from(valor["Grupos"] as List)}
        });
    grupos.add("Outro");
    return grupos;
  }

  Widget _campoLote(String? opcao) {
    if (opcao == "Outro" || widget.vacinado['Lote'] == "Outro")
      return TextFormField(
          initialValue: widget.vacinado['loteScan'],
          decoration: InputDecoration(
            hintText: "Lote",
          ),
          validator: (input) => input!.isEmpty ? 'Digite o lote.' : null,
          onChanged: (input) => outro['Lote'] = input);
    return Container();
  }

  Widget _campoVac(String? opcao) {
    if (opcao == "Outro" || widget.vacinado['Vacina'] == "Outra")
      return TextFormField(
          initialValue: widget.vacinado['Vacina'] == 'Outro'
              ? ''
              : widget.vacinado['Vacina'],
          decoration: InputDecoration(hintText: "Vacina"),
          validator: (input) =>
              input!.isEmpty ? 'Digite o nome da vacina.' : null,
          onChanged: (input) => outro['Vacina'] = input);
    return Container();
  }

  Widget _campoGrupo(String? opcao) {
    if (opcao == "Outro")
      return TextFormField(
          initialValue: widget.vacinado['grupoScan'],
          decoration: InputDecoration(
            hintText: "Grupo",
          ),
          validator: (input) => input!.isEmpty ? 'Digite o grupo.' : null,
          onChanged: (input) => outro['Grupo'] = input);
    return Container();
  }

  bool _botaoInicial() {
    if (widget.vacinado['numeroDose'] == '1')
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    Size tamanhoDispositivo = MediaQuery.of(context).size;
    final format = DateFormat("dd/MM/yyyy");
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Formulário - Vacina"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Container(
          height: tamanhoDispositivo.height * 0.85,
          width: tamanhoDispositivo.height * 0.8,
          padding: EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: [
                      Spacer(),
                      Text('Registrar 1ª dose'),
                      Switch(
                          value: _botaoInicial(),
                          onChanged: (_) => setState(() {
                                botao = !botao;
                                widget.vacinado['numeroDose'] =
                                    botao ? '2' : '1';
                              })),
                      Text('Registrar 2ª dose'),
                      Spacer(),
                    ],
                  ),
                  DropdownButtonFormField<String>(
                    validator: (value) =>
                        value == null ? 'Preencha a vacina.' : null,
                    value: widget.vacinado['Vacina'],
                    hint: Text('Selecione a vacina a ser aplicada'),
                    decoration: InputDecoration(
                        labelText:
                            widget.vacinado['Vacina'] == null ? "" : "Vacina"),
                    dropdownColor: Colors.lightGreen[100],
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.vacinado['Vacina'] = newValue!;
                        dose['Vacina'] = widget.vacinado['Vacina'];
                      });
                    },
                    items: <String>[
                      'ASTRAZENECA',
                      'CORONAVAC',
                      'JANSSEN',
                      'PFIZER',
                      'Outro'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  _campoVac(dose['Vacina']),
                  DropdownButtonFormField<String>(
                    validator: (value) =>
                        value == null ? 'Preencha o lote.' : null,
                    isExpanded: true,
                    value: widget.vacinado['Lote'],
                    hint: Text('Lote'),
                    decoration: InputDecoration(
                        labelText:
                            widget.vacinado['Lote'] == null ? "" : "Lote"),
                    dropdownColor: Colors.lightGreen[100],
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.vacinado['Lote'] = newValue!;
                        dose['Lote'] = widget.vacinado['Lote'];
                      });
                    },
                    items: _lotes(dose['Vacina'])
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  _campoLote(dose['Lote']),
                  DropdownButtonFormField<String>(
                    validator: (value) => value == null
                        ? 'Preencha o grupo de atendimento.'
                        : null,
                    isExpanded: true,
                    value: widget.vacinado['Grupo'],
                    hint: Text('Grupo de atendimento'),
                    decoration: InputDecoration(
                        labelText: widget.vacinado['Grupo'] == null
                            ? ""
                            : "Grupo de atendimento"),
                    dropdownColor: Colors.lightGreen[100],
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.vacinado['Grupo'] = newValue!;
                      });
                    },
                    items:
                        _grupos().map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  _campoGrupo(widget.vacinado['Grupo']),
                  DateTimeField(
                    initialValue: widget.vacinado['Aplicação'] == null
                        ? DateTime.now()
                        : widget.vacinado['Aplicação'],
                    decoration: InputDecoration(
                        hintText: "Data de aplicação",
                        labelText: "Data de aplicação"),
                    onChanged: (input) =>
                        setState(() => widget.vacinado['Data'] = input),
                    format: format,
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(2021),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2022));
                    },
                  ),
                  _dataAprazamento(
                      widget.vacinado['Vacina'],
                      widget.vacinado['Data'], //antes: dose['Vacina']
                      widget.vacinado['numeroDose']),
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            if (widget.vacinado['Scan'] == true) {
                              if (widget.vacinado['Data'] == null)
                                widget.vacinado['Data'] =
                                    widget.vacinado['Aplicação'];
                              if (outro['Lote'] == null)
                                outro['Lote'] = widget.vacinado['loteScan'];
                              if (outro['Vacina'] == null)
                                outro['Vacina'] = widget.vacinado['Vacina'];
                              if (outro['Grupo'] == null)
                                outro['Grupo'] = widget.vacinado['grupoScan'];
                              widget.vacinado['Aplicador'] = aplicador['nome'];
                            }
                            if (dose['Lote'] == 'Outro' ||
                                widget.vacinado['Lote'] == 'Outro')
                              dose['Lote'] = outro['Lote'];
                            if (widget.vacinado['Grupo'] == 'Outro')
                              widget.vacinado['Grupo'] = outro['Grupo'];
                            if (dose['Vacina'] == 'Outro' ||
                                widget.vacinado['tipoVac'] == 'Outro')
                              dose['Vacina'] = outro['Vacina'];
                            if (widget.vacinado['Data'] == null)
                              widget.vacinado['Data'] = DateTime.now();
                            dose['Data'] = widget.vacinado['Data'];
                            widget.vacinado['Dose'] = dose;
                            registroVacinado(widget.vacinado);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TelaVacinador(widget.dados_vacinacao)),
                              (Route<dynamic> route) => false,
                            );
                          }
                        });
                      },
                      child: Text('Enviar'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
