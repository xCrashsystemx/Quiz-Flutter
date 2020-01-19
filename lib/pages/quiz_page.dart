import 'package:flutter/material.dart';
import 'package:quiz/pages/score_page.dart';
import '../ultis/quiz.dart';
import '../ultis/question.dart';
import '../ui/answer_button.dart';
import '../ui/questions_text.dart';
import '../ui/correct_wrong_overlay.dart';
import './quiz_page.dart';

class QuizPage extends StatefulWidget{
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage>{

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Schafft Dave die Regelstudienzeit?", true),
    new Question("Pizza is love?", true),
    new Question("Flutter is awesome", true),
  ]);
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlay = false;

  @override
  void initState(){
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;


  }

  void handleAnswer(bool answer){
    isCorrect = (currentQuestion.answer == answer); 
    quiz.answer(isCorrect);
    this.setState(() {
      overlay = true;
    });
  }


  @override
  Widget build(BuildContext context){
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( // Main page...
        children: <Widget>[
        new AnswerButton(true,() => handleAnswer(true)),
        new QuestionText(questionText, questionNumber),
        new AnswerButton(false,() => handleAnswer(false)),
        ]
        ),
       overlay == true ? new CorrectWrongOverlay(
         isCorrect,
         (){
           if(quiz.length == questionNumber){
             Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext build) => new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
             return;
           }
           currentQuestion = quiz.nextQuestion;
           this.setState((){
              overlay = false;
              questionText = currentQuestion.question;
              questionNumber = quiz.questionNumber;
           });

         }
       ) : new Container()
      ]
    );

  }

}