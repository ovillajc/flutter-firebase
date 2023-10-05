import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firebase_service.dart';

class EditNamePage extends StatelessWidget {
  const EditNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller para guardar la informacion ingresada en el TextField
    TextEditingController nameController = TextEditingController(text: '');

    // Recibir argumentos enviados desde la home page
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    // Asignar argumento al controlador
    nameController.text = arguments['name'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller:
                  nameController, // La infor que se escriba se guada aqui
              decoration: const InputDecoration(
                hintText: 'Ingrese la modificación',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Actualizar Información
                await updatePeople(arguments['uid'], nameController.text)
                    .then((value) => {Navigator.pop(context)});
              },
              child: const Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
