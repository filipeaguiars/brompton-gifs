import 'package:flutter/material.dart';
import 'package:share/share.dart';

class PaginaDoGif extends StatelessWidget {

  final _dadosDoGif;
  //construtor
  PaginaDoGif(this._dadosDoGif);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dadosDoGif["title"]),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: (){
                Share.share(_dadosDoGif["images"]["fixed_height"]["url"]);
              })
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_dadosDoGif["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
