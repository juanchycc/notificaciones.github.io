import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_isef/helpers/File_helper.dart';
import 'package:web_admin_isef/services/firebase_storage_service.dart';
import 'package:web_admin_isef/services/socket_service.dart';
import 'package:web_admin_isef/widget/custom_input.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.title,
    required this.size,
    required this.titleController,
    required this.descriptionController,
    required this.anuncio,
  });

  final Map<String, dynamic> anuncio;
  final TextEditingController descriptionController;
  final Size size;
  final String title;
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    final fileHelper = Provider.of<FileHelper>(context);
    FirebaseStorageService firebaseStorage = FirebaseStorageService();
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'anuncios');
                },
                icon: const Icon(
                  Icons.table_rows_outlined,
                  color: Colors.white,
                ))
          ],
        ),
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.6,
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Completar los datos del anuncio:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: CustomInput(
                  controller: titleController,
                  hintText: "Titulo",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: CustomInput(
                  controller: descriptionController,
                  hintText: "Contenido",
                  maxLines: 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ImagenContainer(
                      size: size,
                      imageHelper: fileHelper,
                      initialText: "Cargar Imagen",
                    ),
                    ImagenContainer(
                      size: size,
                      imageHelper: fileHelper,
                      initialText: "Cargar Adjunto",
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 20, left: size.width * 0.2, right: size.width * 0.2),
                child: ElevatedButton(
                  onPressed: () async {
                    anuncio['title'] = titleController.text;
                    anuncio['descr'] = descriptionController.text;

                    anuncio['images'] =
                        await cargarLista(firebaseStorage, fileHelper.images);

                    anuncio['files'] =
                        await cargarLista(firebaseStorage, fileHelper.files);

                    socketService.emit('nuevo-anuncio', anuncio);
                    titleController.clear();
                    descriptionController.clear();
                    fileHelper.clear();
                    //TODO: enviar solo si fue correcto el envio
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Enviado Correctamente"),
                      ),
                    );
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

Future<List<String>> cargarLista(
    FirebaseStorageService firebaseService, Map<String, List<int>> data) async {
  List<String> newData = [];
  for (String k in data.keys) {
    String? url = await firebaseService.uploadFile("Novedades", k, data[k]!);
    if (url != null) {
      newData.add(url);
    }
  }
  return newData;
}

class ImagenContainer extends StatefulWidget {
  ImagenContainer(
      {super.key,
      required this.size,
      required this.imageHelper,
      required this.initialText});

  FileHelper imageHelper;
  final String initialText;
  final Size size;

  @override
  State<ImagenContainer> createState() => _ImagenContainerState();
}

class _ImagenContainerState extends State<ImagenContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.3,
      width: widget.size.width * 0.25,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.imageHelper.imageFile != null &&
              widget.initialText.contains("Imagen"))
            ImagenesSlider(
              fileHelper: widget.imageHelper,
            ),
          if (!widget.initialText.contains("Imagen") &&
              widget.imageHelper.otherFile != null)
            SizedBox(
              height: widget.size.height * 0.24,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.imageHelper.files.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    tileColor: Colors.grey,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.imageHelper.files.keys.toList()[index]),
                        IconButton(
                            onPressed: () {
                              widget.imageHelper.removeFile(widget
                                  .imageHelper.files.keys
                                  .toList()[index]);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  );
                },
              ),
            ),
          const SizedBox(
            height: 3,
          ),
          if (widget.imageHelper.imageFile == null &&
              widget.initialText.contains("Imagen"))
            Text(widget.initialText),
          if (widget.imageHelper.otherFile == null &&
              !widget.initialText.contains("Imagen"))
            Text(widget.initialText),
          ElevatedButton(
              onPressed: () async {
                if (widget.initialText.contains("Imagen")) {
                  if (await widget.imageHelper.pickImage(context)) {
                    setState(() {});
                  }
                } else {
                  if (await widget.imageHelper.pickFile(context)) {
                    setState(() {});
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[400]),
              child: const Icon(
                Icons.upload,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}

class ImagenesSlider extends StatefulWidget {
  const ImagenesSlider({
    super.key,
    required this.fileHelper,
  });

  final FileHelper fileHelper;

  @override
  State<ImagenesSlider> createState() => _ImagenesSliderState();
}

class _ImagenesSliderState extends State<ImagenesSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final len = widget.fileHelper.images.keys.length;

    return CarouselSlider(
      options: CarouselOptions(
        height: size.height * 0.25,
        autoPlay: false,
        initialPage: len,
        onPageChanged: (index, _) {
          setState(() {
            _current = index;
          });
        },
      ),
      items: widget.fileHelper.images.keys.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Column(
              children: [
                SizedBox(
                    width: size.width * 0.15,
                    child: Image.memory(
                      Uint8List.fromList(widget.fileHelper.images[i]!),
                      fit: BoxFit.scaleDown,
                      height: size.height * 0.2,
                      width: size.width * 0.4,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Imagen ${_current == 0 ? len : _current} de $len"),
                    IconButton(
                        onPressed: () {
                          widget.fileHelper.removeImage(i);
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete))
                  ],
                )
              ],
            );
          },
        );
      }).toList(),
    );
  }
}
