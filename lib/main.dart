import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  GameController gameController =
      new GameController(['👋', '🎙️', '🔝', '🔥', '🤖', '🎮']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
          children: gameController.cards.map((e) => CardView(e)).toList(),
        ),
      ),
    );
  }
}

class CardView extends StatefulWidget {
  CardView(this.card, {Key? key}) : super(key: key);
  CardData card;
  @override
  State<CardView> createState() => _CardViewState();
}

class _CardViewState extends State<CardView>
    with SingleTickerProviderStateMixin {
  bool isFacedUp = false;
  late AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    super.initState();
  }

  void showCard() {
    animationController.animateTo(1);
  }

  void hideCard() {
    animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController.view,
      builder: (context, _) {
        bool cardContentShown = animationController.value > 0.5;
        Matrix4 matrix = Matrix4.identity();
        matrix.setEntry(3, 2, 0.0015);
        matrix.rotateY(animationController.value * 3.14);
        return Transform(
            transform: matrix,
            alignment: Alignment.center,
            child: GestureDetector(
                onTap: () {
                  if (isFacedUp) {
                    hideCard();
                  } else {
                    showCard();
                  }
                  isFacedUp = !isFacedUp;
                },
                child: Container(
                  // color: Colors.red,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.red),
                    color: cardContentShown ? Colors.white : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    cardContentShown ? widget.card.content : '',
                    style: TextStyle(fontSize: 35),
                  ),
                )));
      },
    );
  }
}

class CardData {
  bool isMatched = false;
  String content;
  late GlobalKey<_CardViewState> cardKey;
  CardData(this.content) {
    cardKey = GlobalKey<_CardViewState>();
  }
}

class GameController {
  List<CardData> cards = [];
  GameController(List<String> emojies) {
    for (final emojie in emojies) {
      cards.add(CardData(emojie));
      cards.add(CardData(emojie));
    }
    cards.shuffle();
  }
}
