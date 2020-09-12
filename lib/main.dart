import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int score = 0;
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
                  checkAnswer(true);
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
                  checkAnswer(false);
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

  void checkAnswer(bool answer) {
    setState(() {
      if (quizBrain.getQuestionAnswer() == answer) {
        addScore(true);
      } else {
        addScore(false);
      }
      quizBrain.nextQuestion();
      if (quizBrain.getCurrentQuestion() != 0) {
        print(quizBrain.length());
        _text = quizBrain.getCurrentQuestion().toString() +
            "\n" +
            quizBrain.getQuestionText() +
            "\n" +
            quizBrain.getQuestionAnswer().toString();
      } else {
        alertScore();
        // TODO: - if OK pressed repeat the quiz else show your score and exit app

      }
    });
  }

  void addScore(bool response) {
    if (response) {
      scoreKeeper.add(Icon(
        Icons.check,
        color: Colors.green,
      ));
      score++;
      print('score =  $score');
    } else {
      scoreKeeper.add(Icon(
        Icons.close,
        color: Colors.red,
      ));
    }
  }

  void alertScore() {
    Alert(context: context, title: 'Replay ?', buttons: [
      DialogButton(
          child: Text('OK'),
          onPressed: () {
            _text = quizBrain.getCurrentQuestion().toString() +
                "\n" +
                quizBrain.getQuestionText() +
                "\n" +
                quizBrain.getQuestionAnswer().toString();
            setState(() {});
            scoreKeeper.clear();
            score = 0;
            Navigator.pop(context);
          }),
      DialogButton(
          child: Text('No'),
          onPressed: () {
            int total = quizBrain.length();
            Alert(
                context: context,
                title: 'Your score is $score / $total',
                type: AlertType.info,
                buttons: [
                  DialogButton(
                    child: Text(
                      "Exit",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  )
                ]).show();
          })
    ]).show();
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
