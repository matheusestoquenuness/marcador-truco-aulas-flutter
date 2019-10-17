// [x] Não deixar que seja possível ficar com pontos negativos ao clicar em (-1) e também não pode ultrapassar 12 pontos.
// [x] Permitir de alguma forma que a partida seja reiniciada, sem zerar o número de vitórias
// [x] Transformar o AlertDialog em modal para que somente desapareça da tela ao clicar em CANCEL ou OK. Uma dia, precisa utilizar o atributo barrierDismissible
// [x] Trocar os nomes dos usuários ao clicar em cima do nome (Text). Pode-se utilizar um GestureDetector e exibir um AlertDialog com um TextField. Exemplo de AlertDialog com TextField.
// [x] Exibir uma notificação da mão de ferro: é a Mão de Onze especial, quando as duas duplas conseguem chegar a 11 pontos na partida. Todos os jogadores recebem as cartas “cobertas”, isto é, viradas para baixo, e deverão jogar assim. Quem vencer a mão, vence a partida
// [x] Instale o plugin Screen e adicione um código para deixar a tela sempre ativa enquanto joga.


import 'package:flutter/material.dart';
import 'package:marcador_truco/models/player.dart';
import 'package:screen/screen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  var _playerOne = Player(name: "Nós", score: 0, victories: 0, id: 1);
  var _playerTwo = Player(name: "Eles", score: 0, victories: 0, id: 2);

   bool _validate = false;
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetPlayers();
    _resetPartidas();
    
    Screen.keepOn(true);
  }



  void _resetPlayer({Player player, bool resetVictories = false}) {
    setState(() {
      player.score = 0;
      if (resetVictories) player.victories = 0;
    });
  }
  void _resetPlayers({bool resetVictories = false}) {
    _resetPlayer(player: _playerOne, resetVictories: resetVictories);
    _resetPlayer(player: _playerTwo, resetVictories: resetVictories);
  }

  void _resetPartidas({bool resetVictories = true}) {
    _resetPlayer(player: _playerOne, resetVictories: resetVictories);
    _resetPlayer(player: _playerTwo, resetVictories: resetVictories);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Marca Tento",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400), 
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _resetplayer(
                  title: 'RESETAR',
                  message:
                      'Você deseja zerar os pontos ou resetar as vitórias?',
                  confirm: () {
                    _resetPlayers();
                  },
                   resetar: () {
                    _resetPlayers();
                    _resetPartidas();
                  }
                  );                 
            },
            icon: Icon(Icons.refresh, color: Colors.white,),
          ), 
        ],
      ),
      body: Container(padding: EdgeInsets.all(20.0), child: _showPlayers()),
    );
  }
  Widget _showPlayerBoard(Player player) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _showPlayerName(player.name, player.id),
         _showPlayerScore(player.score), 
          _showPlayerVictories(player.victories),
          _showScoreButtons(player),
        ],
      ),
    );
  }
  Widget _showPlayers() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _showPlayerBoard(_playerOne),
        _showPlayerBoard(_playerTwo),
      ],
    );
  }
Widget _showPlayerName(String name, int id) {
    return InkWell(
      child: Text(
        name.toUpperCase(),
        style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      onTap: () {
        _changeName(
            title: 'Insira um Nome',
            confirm: () {
              setState(() {
                if (id == 1) {
                  _playerOne.name = _nameController.text;
                } else if (id == 2) {
                  _playerTwo.name = _nameController.text;
                }
                _nameController.text = '';
              });
            });
      },
    );
  }
  Widget _showPlayerVictories(int victories) {
    return Text(
      "vitórias ( $victories )",
      style: TextStyle(fontWeight: FontWeight.w300),
    );
  }
  Widget _showPlayerScore(int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52.0),
      child: Text(
        "$score",
        style: TextStyle(fontSize: 120.0),
      ),
    );
  }
  Widget _buildRoundedButton(
      {String text, double size = 52.0, Color color, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          color: color,
          height: size,
          width: size,
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
  Widget _showScoreButtons(Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRoundedButton(
          text: '-1',
          color: Colors.black.withOpacity(0.1),
          onTap: () {
            setState(() {
              player.score--;
              if(player.score < 0){
                player.score = 0;
              }
            });
          },
        ),      
        _buildRoundedButton(
          text: '+1',
          color: Colors.greenAccent,
          onTap: () {
            setState(() {
              player.score++;  
                if(player.score > 12){
                player.score = 12;
              }
            });
            if (player.score == 12) {
 _showDialog(
      title: 'Fim do jogo',
        message:'${player.name} ganhou!\nPlacar final: ${_playerOne.score} X ${_playerTwo.score}',
             confirm: () {
                setState(() {
                      player.victories++;
                  
                    });
                    _resetPlayers(resetVictories: false); },
                  cancel:() {
                    setState(() {
                      player.score--;
                    });
                  });
            }
            if(_playerOne.score == 11 && _playerTwo.score == 11){
            _maodeferro(
                  title: 'MÃO DE FERRO',
                  message:  'Todos os jogadores recebem as cartas cobertas", isto é, viradas para baixo, e deverão jogar assim.\nQuem vencer a mão, vence a partida!',
                  confirm:(){},);
                   }
                  },    
                ),
              ],
           );
        }
  

  void _showDialog(
      {String title, String message, Function confirm, Function cancel}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {               
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }
  //new bottom
   void _resetplayer(
      {String title, String message, Function confirm, Function cancel, Function resetar}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("ZERAR"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
           FlatButton(
              child: Text("RESETAR"),
              onPressed: () {
                Navigator.of(context).pop();
                if (resetar!= null) resetar();
              },
            ),
          ],
        );
      },
    ); 
  }
void _maodeferro(
      {String title,
      String message,
      Function confirm,
      Function cancel,
      Function resetar}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }
 void _changeName(
      {String title,
      Function confirm,
      Function cancel,
      Function error}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: _nameController,   
            decoration: InputDecoration(
              hintText: "Insira o nome do time",
              errorText: _validate ? 'Insira o nome' : null,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                 Navigator.of(context).pop();
                 if (confirm != null && _nameController.text != '') confirm();
                setState(() {
                  _nameController.text;
                });      
              },
            ),
          ],
        );
      },
    );
  }
}
