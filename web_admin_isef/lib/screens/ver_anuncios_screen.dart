import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_isef/services/socket_service.dart';

class VerAnunciosScreen extends StatelessWidget {
  const VerAnunciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    List<Map<String, dynamic>> anuncios = socketService.getAnuncios();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.red[400],
        title: const Text(
          "Anuncios",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(
              top: size.height * 0.1, bottom: size.height * 0.1),
          width: size.width * 0.6,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(5)),
          child: ListView.builder(
            itemCount: anuncios.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(anuncios[index]['title']),
                    IconButton(
                        onPressed: () {
                          socketService.eliminarAnuncio(
                              index, anuncios[index]['_id']);
                        },
                        icon: const Icon(Icons.delete))
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
