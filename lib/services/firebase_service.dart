import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Instaciar firebase para crear la base de datos
FirebaseFirestore db = FirebaseFirestore.instance;
// Instanciar firebase para utilizar el storage de archivos
final FirebaseStorage storage = FirebaseStorage.instance;

//! CRUD DATABASE
// Funcion que nos traera la info de firebase
Future<List> getPeople() async {
  List people = [];

  // Llamado a la base de datos (Referenciando la coleccion)
  CollectionReference collectionReferencePeople = db.collection('people');

  // Query para realizar la consulta de la info de la conlleccion
  QuerySnapshot queryPeople = await collectionReferencePeople.get();

  // Recorrer los documentos y añadirlo al List people = [];
  for (var document in queryPeople.docs) {
    // Añadimos la info que viene en el document a un mapa
    final Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final person = {
      'uid': document.id,
      'name': data['name'],
    };

    // añadir la data del document al list
    people.add(person);
  }

  // Agregar un pequeño delay para que se note el circular progress inicator
  await Future.delayed(const Duration(seconds: 2));

  return people;
}

// Guardar nuevo documento en la base de datos
Future<void> addPeople(String name) async {
  await db
      // Indicamos la coleccion donde se hara el nuevo registro
      .collection('people')
      // Asignamos el campo del documento
      .add({'name': name});
}

// Actualizar documento de la base datos
Future<void> updatePeople(String uid, String newName) async {
  await db
      // Indicamos la coleccion donde se hara la actualización del registro
      .collection('people')
      // Seleccionamos el documento a editar
      .doc(uid)
      // Mandamos el campo que deseamos actualziar
      .set({'name': newName});
}

// Eliminar documento de la coleccion de la base de datos
Future<void> deletePeople(String uid) async {
  await db.collection('people').doc(uid).delete();
}

//! UPLOAD IMAGES
// Subir el archivo
Future<bool> uploadImage(File image) async {
  // Obtener el path del archivo seleccionado
  final String nameFile = image.path.split('/').last;

  // Almacenar el archivo en el storage de firebase
  // ref: nos regresa una referencia unica para cada imagen
  // First child: nombre de la carpeta donde se almacenara
  // Seccond child: nombre del archivo
  final Reference fileReference = storage.ref().child('images').child(nameFile);

  // tarea del file para subir el archivo
  final UploadTask uploadTask = fileReference.putFile(image);

  // Monitoreo de la tarea
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  // Recuperar la url del archivo subido
  // final String url = await snapshot.ref.getDownloadURL();

  // Retornamos true or false basado en la resolucion de la tarea
  if (snapshot.state == TaskState.success) {
    return true;
  } else {
    return false;
  }
}
