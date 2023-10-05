import 'package:flutter/material.dart';

import '../services/firebase_service.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase CRUD'),
      ),
      body: FutureBuilder(
        future: getPeople(),
        builder: ((context, snapshot) {
          // Verificar si ya hay data para dibujar el widger y evitar el error de null
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                // Regresamos un text con los nombres consultados a  firebase
                return Dismissible(
                  /* confirmDismiss: Nos sirve para poder preguntar si queremos eliminar el item 
                    Esto nos servira para poder mostrar un dialog donde preguntemos al usuario si
                    esta seguro de eliminar el item
                  */
                  confirmDismiss: (direction) async {
                    bool result = false;

                    result = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              "¿Deseas eliminar el dato: ${snapshot.data?[index]['name']}?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                return Navigator.pop(context, false);
                              },
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                return Navigator.pop(context, true);
                              },
                              child: const Text('Si, estoy seguro'),
                            ),
                          ],
                        );
                      },
                    );

                    return result;
                  },
                  // onDismissed. Se ejecuta luego de deslizar el Dismissable
                  onDismissed: (direction) async {
                    // Llamamos al metodo del servicio para eliminar un documento
                    await deletePeople(snapshot.data?[index]['uid']);
                    // Eliminamos el documento del arreglo local para evitar errores
                    snapshot.data?.removeAt(index);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  // Nos permite definir la direccion de deslizado
                  direction: DismissDirection.endToStart,
                  // Dismissable pide un key unico para cada item, asi detecta cual es el que deslizamos
                  key: Key(snapshot.data?[index]['uid']),
                  child: ListTile(
                    title: Text(snapshot.data?[index]['name']),
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        '/edit',
                        arguments: {
                          // Enviar argumentos al edit page
                          'uid': snapshot.data?[index]['uid'],
                          'name': snapshot.data?[index]['name'],
                        },
                      );
                      setState(() {});
                    },
                  ),
                );
              },
            );
          } else {
            // Enviar un progress indicator en caso de que todavía este cargando la data
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add');

          // Actualizamos el estado el widget
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
