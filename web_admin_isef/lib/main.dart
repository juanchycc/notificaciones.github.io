import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_isef/firebase_options.dart';
import 'package:web_admin_isef/helpers/File_helper.dart';
import 'package:web_admin_isef/screens/main_page.dart';
import 'package:web_admin_isef/screens/ver_anuncios_screen.dart';
import 'package:web_admin_isef/services/socket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => FileHelper()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
          ),
          routes: {
            'main': (context) => const MyHomePage(title: 'Crear Anuncio'),
            'anuncios': (context) => const VerAnunciosScreen()
          },
          initialRoute: 'main'),
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
      'images': [],
      'files': []
    };

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return MainPage(
        title: title,
        size: size,
        titleController: titleController,
        descriptionController: descriptionController,
        anuncio: anuncio);
    //child: VerAnunciosScreen());
  }
}
