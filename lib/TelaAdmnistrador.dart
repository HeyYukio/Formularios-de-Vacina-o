import 'package:flutter/material.dart';

class TelaAdministrador extends StatefulWidget {
  const TelaAdministrador({Key? key}) : super(key: key);

  @override
  _TelaAdministradorState createState() => _TelaAdministradorState();
}

class _TelaAdministradorState extends State<TelaAdministrador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green.shade400),
              ),
              onPressed: () {},
              child: const Text('  Cadastrar aplicador  '),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green.shade400),
              ),
              onPressed: () {},
              child: const Text('Gerenciar aplicadores'),
            ),
          ],
        ),
      ),
    );
  }
}
