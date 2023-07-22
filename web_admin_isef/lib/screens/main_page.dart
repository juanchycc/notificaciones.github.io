import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_isef/services/socket_service.dart';
import 'package:web_admin_isef/widget/custom_input.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.title,
    required this.size,
    required this.titleController,
    required this.descriptionController,
    required this.anuncio,
  });

  final String title;
  final Size size;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final Map<String, dynamic> anuncio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Completar los datos del anuncio:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              CustomInput(
                controller: titleController,
                hintText: "Titulo",
              ),
              CustomInput(
                controller: descriptionController,
                hintText: "Contenido",
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.2, right: size.width * 0.2),
                child: ElevatedButton(
                  onPressed: () {
                    anuncio['title'] = titleController.text;
                    anuncio['descr'] = descriptionController.text;
                    final socketService =
                        Provider.of<SocketService>(context, listen: false);
                    print(anuncio);
                    socketService.emit('nuevo-anuncio', anuncio);
                    titleController.clear();
                    descriptionController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400]),
                  child: const Text(
                    "Enviar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
