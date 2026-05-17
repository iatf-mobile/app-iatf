import 'package:flutter/material.dart';
import 'package:iatf_mobile/ui/register/register_screen.dart';

import 'theme.dart';
import 'util.dart';
import 'ui/login/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define as fontes
    final textTheme = createTextTheme(context, 'Roboto', 'Montserrat');

    // Usa o textTheme pra montar o ThemeData completo
    final materialTheme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'IATF Mobile',
      debugShowCheckedModeBanner: false,

      // Tema claro
      theme: materialTheme.light(),

      // Tema escuro
      darkTheme: materialTheme.dark(),

      // Segue o sistema do celular
      themeMode: ThemeMode.system,

      home: const RegisterScreen(),
    );
  }
}