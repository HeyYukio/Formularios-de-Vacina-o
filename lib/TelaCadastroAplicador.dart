import 'package:aplicativo/auth.dart';
import 'package:flutter/material.dart';
import 'conexaoFirestore.dart';
import 'TelaLogin.dart';
import 'package:flutter/services.dart';

class CadastroAplicador extends StatefulWidget {
  const CadastroAplicador(this.aplicador, this.tokens, {Key? key})
      : super(key: key);

  final dynamic tokens;
  final Map<String, dynamic> aplicador;
  @override
  _CadastroAplicadorState createState() => _CadastroAplicadorState();
}

class _CadastroAplicadorState extends State<CadastroAplicador> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _obscureText2 = true;
  String? nome;
  String email = '';
  String password = '';
  String token = '';
  String error = '';
  bool achou = false;

  String? _validarCPF(String? input) {
    if (input == null) return "Digite o CPF";
    if (input.length != 11)
      return "Digite o CPF completo.";
    else {
      int soma = 0;
      for (int i = 0; i < 9; i++) {
        soma += int.parse(input[i]) * (10 - i);
      }
      int digito1;
      int resto = (soma % 11);
      if (resto < 2) {
        digito1 = 0;
      } else
        digito1 = 11 - resto;
      if (digito1 != int.parse(input[9])) return "CPF inválido.";

      int digito2;
      soma = 0;
      for (int i = 0; i < 9; i++) {
        soma += int.parse(input[i]) * (11 - i);
      }
      soma += digito1 * 2;
      resto = (soma % 11);
      if (resto < 2) {
        digito2 = 0;
      } else
        digito2 = 11 - resto;
      print(digito2);
      if (digito2 != int.parse(input[10])) return "CPF inválido.";
      return null;
    }
  }

  String? _validarEmail(String? email) {
    if (email!.isEmpty) return "Digite um email";
    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)) return "O email digitado não é válido";
    return null;
  }

  String? _validarSenha(String? senha) {
    if (senha!.isEmpty) return "Digite uma senha";
    if (senha.length < 6) return "A senha é muito curta.";
    return null;
  }

  String? _validarToken(String? token) {
    for (var i in widget.tokens) {
      if (i['token'] == token) return null;
    }
    return 'Token inválido';
  }

  @override
  Widget build(BuildContext context) {
    Size tamanhoDispositivo = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Página de cadastro do aplicador')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: tamanhoDispositivo.width * .8,
            height: tamanhoDispositivo.height * .75,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(hintText: "Nome"),
                      validator: (input) =>
                          input!.isEmpty ? 'Digite o nome' : null,
                      onChanged: (input) => widget.aplicador['Nome'] = input),
                  Spacer(),
                  TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                      ],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(hintText: "CPF"),
                      keyboardType: TextInputType.number,
                      validator: (input) => _validarCPF(input),
                      onChanged: (input) => widget.aplicador['CPF'] = input),
                  Spacer(),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(hintText: "Coren"),
                      validator: (input) =>
                          input!.isEmpty ? 'Digite o Coren' : null,
                      onChanged: (input) => widget.aplicador['Coren'] = input),
                  Spacer(),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => _validarEmail(val),
                      decoration: InputDecoration(
                        hintText: "Digite seu email",

                        //
                      ),
                      onChanged: (val) {
                        setState(() => email = val);
                        widget.aplicador['Email'] = val;
                      }),
                  Spacer(),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (val) => _validarSenha(val),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() {
                                _obscureText = !_obscureText;
                                print('teste');
                              })),
                      hintText: "Digite sua senha.",

                      //
                    ),
                    obscureText: _obscureText,
                    onChanged: (val) => setState(() => password = val),
                  ),
                  Spacer(),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (val) => _validarToken(val),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(_obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() {
                                _obscureText2 = !_obscureText2;
                                print('teste');
                              })),
                      hintText: "Digite o token.",

                      //
                    ),
                    obscureText: _obscureText2,
                    onChanged: (val) => setState(() => token = val),
                  ),
                  Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        setState(() async {
                          if (_formKey.currentState!.validate()) {
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() => error = 'email inválido');
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TelaLogin(widget.aplicador)),
                                  (Route<dynamic> route) => false);
                              registroAplicador(widget.aplicador);
                            }
                          }
                        });
                      },
                      child: Text('Registrar')),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: (14.0)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
