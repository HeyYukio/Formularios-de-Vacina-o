import 'package:aplicativo/TelaCPFCNS.dart';
import 'TelaLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'TelaScan.dart';
import 'dart:async';

class TelaVacinador extends StatefulWidget {
  TelaVacinador(this.dadosVacinacao, {Key? key}) : super(key: key);
  dynamic dadosVacinacao;

  @override
  _TelaVacinadorState createState() => _TelaVacinadorState();
}

class _TelaVacinadorState extends State<TelaVacinador> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Sair do app'),
            content:
                new Text('Você tem certeza que deseja sair do aplicativo?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('Não'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Sim'),
              ),
            ],
          ),
        )) ??
        false;
  }

  FutureBuilder _ativarCamera() {
    return FutureBuilder(
        future: Scanner_main(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else
            return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    Size tamanhoDispositivo = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
              title: Text(
                "Tela do Vacinador",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.green,
              actions: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(right: tamanhoDispositivo.width * 0.05),
                    child: TextButton(
                      style: TextButton.styleFrom(
                          primary: Colors.white,
                          textStyle: TextStyle(
                              fontSize: tamanhoDispositivo.width * .04)),
                      onPressed: () async {
                        await auth.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TelaLogin({})),
                            (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'DESLOGAR',
                        style: TextStyle(
                            fontSize: tamanhoDispositivo.height * .02),
                      ),
                    ))
              ]),
          body: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: Text(
                      "Digitar Formulario de vacinação",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      print(aplicador);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TelaCPFCNS(
                                    widget.dadosVacinacao,
                                  )));
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      "Escanear Formulario de vacinação",
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      print('apertou');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Scanner(widget.dadosVacinacao)));
                    },
                  ),
                  _ativarCamera()
                ],
              ),
            ),
          ),
        ));
  }
}
