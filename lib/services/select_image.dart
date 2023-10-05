import 'package:image_picker/image_picker.dart';

Future<XFile?> getImage() async {
  // Instancia de image picker para acceder a sus metodos
  final ImagePicker picker = ImagePicker();

  // Tomar una imagen de la galeria
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  return image;
}
