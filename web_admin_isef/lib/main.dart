import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_isef/screens/main_page.dart';
import 'package:web_admin_isef/services/socket_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Crear Anuncio'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final Map<String, dynamic> anuncio = {
      'title': '',
      'descr': '',
      'media': []
    };

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SocketService())],
      child: MainPage(
          title: title,
          size: size,
          titleController: titleController,
          descriptionController: descriptionController,
          anuncio: anuncio),
    );
  }
}
