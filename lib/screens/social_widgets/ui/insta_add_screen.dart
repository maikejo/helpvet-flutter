import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_finey/screens/social_widgets/ui/insta_upload_photo_screen.dart';
import 'package:image_picker/image_picker.dart';

class InstaAddScreen extends StatefulWidget {
  @override
  _InstaAddScreenState createState() => _InstaAddScreenState();
}

class _InstaAddScreenState extends State<InstaAddScreen> {
  File imageFile;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Galeria'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery,maxHeight: 480, maxWidth: 640)
        : await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 480, maxWidth: 640);

    return selectedImage;
  }

  _showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Escolha na Galeria'),
                onPressed: () {
                  _pickImage('Galeria').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: ((context) => InstaUploadPhotoScreen(imageFile: imageFile,))
                    ));
                  });
                },
              ),
              SimpleDialogOption(
                child: Text('Tirar Foto'),
                onPressed: () {
                  _pickImage('Camera').then((selectedImage) {
                    setState(() {
                      imageFile = selectedImage;
                    });
                    Navigator.push(context, MaterialPageRoute(
                      builder: ((context) => InstaUploadPhotoScreen(imageFile: imageFile,))
                    ));
                  }); 
                },
              ),
              SimpleDialogOption(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF162A49),
        centerTitle: true,
        elevation: 2.0,
        title: Text('Adicionar Postagem'),
      ),
      body: Center(
          child: RaisedButton.icon(
        splashColor: Colors.yellow,
        shape: StadiumBorder(),
        color: Colors.black,
        label: Text(
          'Enviar Imagem',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.cloud_upload,
          color: Colors.white,
        ),
        onPressed: _showImageDialog,
      )),
    );
  }
}
