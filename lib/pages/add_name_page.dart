import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/firebase_service.dart';

class AddNamePage extends StatelessWidget {
  const AddNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller para guardar la informacion ingresada en el TextField
    TextEditingController nameController = TextEditingController(text: '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller:
                  nameController, // La infor que se escriba se guada aqui
              decoration: const InputDecoration(
                hintText: 'Ingrese el nuevo nombre',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Guardar informacion del textfield en firestore
                await addPeople(nameController.text)
                    // Registra y ejecuta un Callback cuando el future se resuelve
                    .then((_) => {
                          // Dentro del callback cerramos la pantalla cuando el registro se guarde
                          Navigator.pop(context)
                        });
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
