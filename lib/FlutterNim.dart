import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo Nim',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController totalPalitosController = TextEditingController();
  TextEditingController limitePalitosController = TextEditingController();
  TextEditingController moveController =
      TextEditingController(); // Novo controller para a jogada do usuário
  String outputText = "";
  int numberOfPieces = 0;
  int limit = 0;
  bool computerPlay = false;
  List<String> moveHistory = [];

  @override
  void initState() {
    super.initState();
  }

  void startGame() {
    numberOfPieces = int.tryParse(totalPalitosController.text) ?? 0;
    limit = int.tryParse(limitePalitosController.text) ?? 0;

    if (numberOfPieces < 2) {
      setState(() {
        outputText = 'Quantidade inválida! Informe um valor >= a 2.\n';
      });
      return;
    }

    if (limit <= 0 || limit >= numberOfPieces) {
      setState(() {
        outputText =
            'Limite inválido! Informe um valor >0 e <total de palitos.\n';
      });
      return;
    }

    setState(() {
      outputText = "";
      computerPlay = (numberOfPieces % (limit + 1)) == 0;
    });

    if (!computerPlay) {
      userPlay();
    } else {
      computerMove();
    }
  }

  void userPlay() {
    setState(() {
      outputText = "Sua vez. Quantos palitos vai remover? (1 a $limit)";
    });
  }

  void updateGame(int move) {
    setState(() {
      numberOfPieces -= move;
      moveHistory.add(
          "Você removeu $move palito(s). Restaram $numberOfPieces palitos.");
      if (numberOfPieces == 1) {
        endGame();
      } else {
        computerPlay = !computerPlay;
        if (computerPlay) {
          computerMove();
        } else {
          userPlay();
        }
      }
    });
  }

  void computerMove() {
    int computerMove = computerChoosesMove(numberOfPieces, limit);
    setState(() {
      numberOfPieces -= computerMove;
      moveHistory.add(
          "O computador removeu $computerMove palito(s). Restaram $numberOfPieces palitos.");

      // Voltar para dentro do else
      computerPlay = !computerPlay;

      if (numberOfPieces == 1) {
        endGame();
      } else {
        userPlay();
      }
    });
  }

  int computerChoosesMove(int numberOfPieces, int limit) {
    int remainder = numberOfPieces % (limit + 1);
    // int move = (remainder == 0) ? 1 : remainder;
    if (remainder == 0) {
      return limit;
    } else {
      return (remainder - 1) == 0 ? limit : (remainder - 1);
    }
    // return move;
  }

  void endGame() {
    // moveHistory.add("\n\nSobraram $numberOfPieces peças e a o computador joga? $computerPlay\n\n");
    String result = computerPlay ? "Você ganhou!" : "O computador ganhou!";
    setState(() {
      moveHistory.add(result);
      moveHistory.add("Fim de jogo.\nObrigada por jogar!");
    });
  }

  void restartGame() {
    setState(() {
      numberOfPieces = 0;
      limit = 0;
      outputText = "";
      moveHistory.clear();
    });
  }

  void processUserMove() {
    int move = int.tryParse(moveController.text) ?? 0;
    if (move < 1 || move > limit) {
      setState(() {
        moveHistory.add("\nJogada inválida. Tente novamente.\n");
      });
    } else {
      updateGame(move);
      setState(() {
        moveController.text = ""; // Limpa o campo de entrada
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Jogo Nim'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Anna Carolina Lima de Souza',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              Text('RA: 1431432312015',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              TextField(
                controller: totalPalitosController,
                decoration: InputDecoration(
                    labelText: 'Quantidade de palitos? (Maior que 2)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: limitePalitosController,
                decoration: InputDecoration(
                    labelText:
                        'Limite de palitos por jogada? (Maior que zero e menor que o total de palitos)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: startGame,
                    child: Text('Iniciar Jogo'),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: restartGame,
                    child: Text('Reiniciar Jogo'),
                  ),
                ),
              ]),
              SizedBox(height: 20),
              Text(
                outputText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Histórico de Jogadas:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      itemCount: moveHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            moveHistory[index],
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: moveController,
                decoration:
                    InputDecoration(labelText: 'Sua jogada (1 a $limit)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: processUserMove,
                  child: Text('Enviar Jogada'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
