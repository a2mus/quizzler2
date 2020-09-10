import 'package:flutter/material.dart';
import 'package:quizzler/quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();
void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String _text = 'Click to see the questions ...';

  List<Icon> scoreKeeper = [];

  // TODO: replace with the shortened version
  bool isDisabled(int index) {
    if (index == -1) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    quizBrain.nextQuestion();
                    _text = quizBrain.getCurrentQuestion().toString() +
                        "\n" +
                        quizBrain.getQuestionText() +
                        "\n" +
                        quizBrain.getQuestionAnswer().toString();
                  });
                },
                child: Text(
                  _text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: AbsorbPointer(
              absorbing: isDisabled(quizBrain.getCurrentQuestion()),
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text(
                  'True',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  //The user press true.
                  if (quizBrain.getQuestionAnswer() == true) {
                    addScore(true);
                  } else {
                    addScore(false);
                  }
                  quizBrain.nextQuestion();

                  _text = quizBrain.getCurrentQuestion().toString() +
                      "\n" +
                      quizBrain.getQuestionText() +
                      "\n" +
                      quizBrain.getQuestionAnswer().toString();
                  // setState() can be added in the beginning or in the end of the instructions or contain the instructions
                  setState(() {});
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: AbsorbPointer(
              absorbing: isDisabled(quizBrain.getCurrentQuestion()),
              child: FlatButton(
                color: Colors.red,
                child: Text(
                  'False',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  //The user press false.

                  setState(() {
                    if (quizBrain.getQuestionAnswer() == false) {
                      addScore(true);
                    } else {
                      addScore(false);
                    }
                    quizBrain.nextQuestion();
                    _text = quizBrain.getCurrentQuestion().toString() +
                        "\n" +
                        quizBrain.getQuestionText() +
                        "\n" +
                        quizBrain.getQuestionAnswer().toString();
                  });
                  alertScore();
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: SizedBox(height: 25, child: Row(children: scoreKeeper)),
        )
        //TODO: Add a Row here as your score keeper
      ],
    );
  }

  void addScore(bool response) {
    if (response) {
      scoreKeeper.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
    } else {
      scoreKeeper.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
  }

  void alertScore() {
    Alert(
      context: context,
      title: 'my alert',
    ).show();
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
