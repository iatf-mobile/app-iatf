import 'package:flutter/material.dart';
import 'theme.dart';
import 'util.dart';
import 'routing/app.router.dart';

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

    return MaterialApp.router(
      title: 'IATF Mobile',
      debugShowCheckedModeBanner: false,

      // Rotas
      routerConfig: appRouter,

      // Tema claro
      theme: materialTheme.light(),

      // Tema escuro
      darkTheme: materialTheme.dark(),

      // Segue o sistema do celular
      themeMode: ThemeMode.system

    );
  }
}
