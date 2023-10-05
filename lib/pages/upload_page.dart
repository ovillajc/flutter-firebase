import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firebase_service.dart';
import 'package:flutter_firebase/services/select_image.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? imageToUpload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Column(
        children: [
          // Mostar imagen o container en base a si esta  o no esta vacio imageToUpload
          imageToUpload != null
              ? Image.file(imageToUpload!)
              : Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 200,
                  color: Colors.red,
                ),
          ElevatedButton(
            onPressed: () async {
              // LLamamos al servicio para subir seleccionar imagen de la galeria
              final img = await getImage();

              // guardamos la imagen seleccionada en la variable de tipo file
              setState(() {
                imageToUpload = File(img!.path);
              });
            },
            child: const Text('Seleccionar Imagen'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (imageToUpload == null) {
                return;
              }

              final uploadedImage = await uploadImage(imageToUpload!);

              // Mostrar una alerta para indicar el resultado de la operacion
              if (uploadedImage) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Imagen Subida Correctamente'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error al Subir Imagen'),
                  ),
                );
              }
            },
            child: const Text('Subir a Firebase '),
          ),
        ],
      ),
    );
  }
}
