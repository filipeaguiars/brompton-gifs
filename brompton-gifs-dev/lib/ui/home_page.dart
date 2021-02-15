import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'gif_page.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _pesquisa;
  int _offset = 0; //Controla as paginas

  Future<Map> _buscarGifs() async {
    http.Response resposta;

    if (_pesquisa == null)
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=udkhfz8QEhs1Q5hlfrpZd2z56fJmwHax&limit=20&rating=g");
    else
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=udkhfz8QEhs1Q5hlfrpZd2z56fJmwHax&q=$_pesquisa&limit=19&offset=$_offset&rating=g&lang=en");

    return json.decode(resposta.body);
  }

  @override
  void initState() {
    super.initState();

    _buscarGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Brompton Gifs",
        style: GoogleFonts.adventPro(fontSize: 40),), // Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,

      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise aqui",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  )),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
              onSubmitted: (texto) {
                setState(() {
                  _pesquisa = texto;
                  _offset = 0;
                });
              },
            ),
          ),
          Expanded(
              child: FutureBuilder(
            future: _buscarGifs(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
                    ),
                  );
                default:
                  if (snapshot.hasError)
                    return Container();
                  else
                    return _criarTabelaDeGifs(context, snapshot);
              }
            },
          )),
        ],
      ),
    );
  }

  int _contarGifs(List dados) {
    if (_pesquisa == null || _pesquisa.isEmpty) {
      return dados.length;
    } else {
      return dados.length + 1;
    }
  }

  Widget _criarTabelaDeGifs(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
      itemCount: _contarGifs(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_pesquisa == null || index < snapshot.data["data"].length)
          return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => PaginaDoGif(snapshot.data["data"][index])),
              );
            },
            onLongPress: (){
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 70,
                  ),
                  Text(
                    "Carregar mais...",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
              onTap: (){
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
      },
    );
  }
}
