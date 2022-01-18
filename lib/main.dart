import 'dart:async';

import 'package:flutter/material.dart';
import 'LadderWidget.dart';
import 'dart:math' as Math;

void main() {
  runApp(const FractionGameApp());
}

class FractionGameApp extends StatelessWidget {
  const FractionGameApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Limitless Fractions',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
        canvasColor: Color(0xff1c1c4d),
        brightness: Brightness.dark,
      ),
      home: const FractionGamePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class FractionGamePage extends StatefulWidget {
  const FractionGamePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<FractionGamePage> createState() => _FractionGamePageState();
}

class _FractionGamePageState extends State<FractionGamePage> {
  FractionQuestion question = FractionSumQuestion(operation: FractionOperation.DIVIDE, aDenominator: 2, aNumerator: 1, bDenominator: 4, bNumerator: 1);
 // FractionQuestion question = FractionConvertQuestion(aDenominator: 2, aNumerator: 1, wholeNumber: 4);
  int numberOfLives = 10;
  String answerNumerator = '';
  String answerDenominator = '';
  bool workingOnNumerator = true;
  int score = 0;
  bool useKeys = true, answerError = false;
  int combo = 1;
  int questionCount = 0;

  void _resetGame() {
    numberOfLives = 10;
    combo = 1;
    score = 0;
    questionCount = 0;
    _resetNewQuestion();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    final rand = Math.Random();
    final i = rand.nextInt(3);
    if( i == 2 ) {
      question = FractionConvertQuestion.generateRandom();
    }else{
      question = FractionSumQuestion.generateRandom();
    }
    questionCount ++;
  }

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 5.0,
                  )
                ),
                child: Center(
                  child: Text('Fraction Game', style: theme.textTheme.headline2,),
                ),
              ),
              Expanded(
                  child: Row(
                    children: [
                      Expanded( // Left Column
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('Lives', style: theme.textTheme.headline4,),
                                  Text(numberOfLives.toString(), style: theme.textTheme.headline4,)
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(question is FractionConvertQuestion ? 'Simplify:' : 'Solve:', style: theme.textTheme.headline4,),
                                  FractionQuestionWidget(
                                    question: question,
                                  ),
                                ],
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        maxHeight: 100.0,
                                        minHeight: 80.0,
                                        minWidth: 200.0,
                                        maxWidth: 300.0
                                      ),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(18.0),
                                                    side: BorderSide(color: Colors.red)
                                                )
                                            )
                                        ),
                                        onPressed: useKeys ? _checkAnswer : null,
                                        child: Text('Enter', style: theme.textTheme.headline4,),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(  //Center Column
                        child: Container(
                          child: LadderWidget(
                            combo: combo,
                            rungBuilder: (context, value) {
                              return LadderRung( value );
                            },
                            pos: score,
                          ),
                        ),
                        flex: 1,
                      ),
                      SizedBox(
                        width: 30.0,
                        child: Container(

                        ),
                      ),
                      Expanded( //Right Column
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                                    child: Text('Q${questionCount}', style: theme.textTheme.headline6,),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                           FractionWidget(
                                             numerator: answerNumerator == '' ? null : int.parse(answerNumerator),
                                             denominator: answerDenominator == '' ? null : int.parse(answerDenominator),
                                             color: answerError ? Colors.red : null
                                           )
                                        ],
                                        mainAxisAlignment: MainAxisAlignment.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              KeypadWidget(
                                onPressed: useKeys ? _keyPressed : null,
                              )
                            ],
                          ),
                        ),
                        flex: 2,
                      ),

                    ],
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0,
                    )
                ),
                child: Center(
                  child: Text('Combo $combo', style: theme.textTheme.headline4,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _keyPressed(String v) {
    setState(() {
      if(v == '<') {
        if (workingOnNumerator) {
          if(answerNumerator.isNotEmpty) {
            answerNumerator =
                answerNumerator.substring(0, answerNumerator.length-1);
          }
        }else{
          if(answerDenominator.isNotEmpty) {
            answerDenominator =
                answerDenominator.substring(0, answerDenominator.length-1);
          }
        }
      }else if( v == '/') {
        workingOnNumerator = !workingOnNumerator;
      }else{
        if (workingOnNumerator) {
          answerNumerator = answerNumerator + v;
        }else{
          answerDenominator = answerDenominator + v;
        }
      }
    });
  }

  void _resetNewQuestion() {
    answerError = false;
    _generateNewQuestion();
    answerDenominator = '';
    answerNumerator = '';
    useKeys = true;
    workingOnNumerator = true;
  }

  void _checkAnswer() {
    if (answerNumerator.isNotEmpty && answerDenominator.isNotEmpty) {
      setState(() {
        useKeys = false;
      });
      if (question.answer.numerator == int.parse(answerNumerator) &&
          question.answer.denominator == int.parse(answerDenominator)) {
        setState(() {
          score += combo;
          combo ++;
          if(combo > 3) {
            combo = 3;
          }
          _resetNewQuestion();
        });
      } else {
        setState(() {
          numberOfLives -= 1;
          combo = 1;
          answerError = true;
          answerNumerator = question.answer.numerator.toString();
          answerDenominator = question.answer.denominator.toString();
        });
        if(numberOfLives>0) {
          Timer(Duration(seconds: 1), () {
            setState(() {
              _resetNewQuestion();
            });
          });
        }else {
          Timer(Duration(seconds: 3), () async
          {
            await showDialog(
                context: context,
                builder: (context) {
                  return GameOverDialog(LadderWidget.posMap(score));
                });
            setState(() {
              _resetGame();
            });
          });
        }
      }
    }
  }
}

class Fraction {
  final int numerator;
  final int denominator;

  Fraction(this.numerator, this.denominator);
}

class FractionQuestion {
  late Fraction answer;

  int _greatestCommonFactor(int a, int b) {
    while( b != 0 ) {
      final tmp = b;
      b = a % b;
      a = tmp;
    }
    return a;
  }
}

enum FractionOperation {
  ADD,
  SUBTRACT,
  MULTIPLY,
  DIVIDE
}

class FractionSumQuestion extends FractionQuestion {
  final FractionOperation operation;
  final int aDenominator;
  final int aNumerator;
  final int bDenominator;
  final int bNumerator;

  static FractionSumQuestion generateRandom() {
    final rand = Math.Random();
    int randOperation = rand.nextInt(4);
    final op =  randOperation == 0 ? FractionOperation.ADD :
                randOperation == 1 ? FractionOperation.SUBTRACT :
                randOperation == 2 ? FractionOperation.MULTIPLY :
                FractionOperation.DIVIDE;
    final aDen = rand.nextInt(11)+2;
    final aNum = rand.nextInt(12)+1;
    int bNum, bDen;

    if( op == FractionOperation.SUBTRACT ) {
         while(true) {
           bDen = rand.nextInt(11)+2;
           bNum = rand.nextInt(12)+1;

           if( (bNum/bDen) < (aNum/aDen) ) {
             break;
           }
         }
    }else{
      bDen = rand.nextInt(11)+2;
      bNum = rand.nextInt(12)+1;
    }

    return FractionSumQuestion(operation: op, aDenominator: aDen, aNumerator: aNum, bDenominator: bDen, bNumerator: bNum);
  }

  FractionSumQuestion({required this.operation, required this.aDenominator, required this.aNumerator,
    required this.bDenominator, required this.bNumerator}) {
    answer = _calculateAnswer();
  }

  Fraction _calculateAnswer() {
    if(operation == FractionOperation.ADD || operation == FractionOperation.SUBTRACT) {
      final commonDenomiator = aDenominator * bDenominator;
      final anum = aNumerator * bDenominator;
      final bnum = bNumerator * aDenominator;
      int num;
      if(operation == FractionOperation.ADD) {
        num = anum + bnum;
      }else{
        num = anum - bnum;
      }
      final commonFactor = _greatestCommonFactor(num, commonDenomiator);
      return Fraction((num / commonFactor).round(), (commonDenomiator / commonFactor).round());
    }else if(operation == FractionOperation.MULTIPLY) {
      final num = aNumerator * bNumerator;
      final dom = aDenominator * bDenominator;
      final commonFactor = _greatestCommonFactor(num, dom);
      return Fraction((num/commonFactor).round(), (dom/commonFactor).round());
    }else if(operation == FractionOperation.DIVIDE) {
      final num = aNumerator * bDenominator;
      final dom = aDenominator * bNumerator;
      final commonFactor = _greatestCommonFactor(num, dom);
      return Fraction((num/commonFactor).round(), (dom/commonFactor).round());
    }else{
      return Fraction(0, 1);
    }
  }
}

class FractionConvertQuestion extends FractionQuestion {
  final int aDenominator;
  final int aNumerator;
  final int wholeNumber;

   static FractionConvertQuestion generateRandom() {
     final rand = Math.Random();
     final den = rand.nextInt(11)+2;
     return FractionConvertQuestion(aDenominator: den, aNumerator: rand.nextInt(den-1)+1, wholeNumber: rand.nextInt(12)+1);
   }

   FractionConvertQuestion({ required this.aDenominator, required this.aNumerator,
    required this.wholeNumber}) {
    answer = _calculateAnswer();
  }

  Fraction _calculateAnswer() {
    final num = (wholeNumber * aDenominator) + aNumerator;
    final commonFactor = _greatestCommonFactor(num, aDenominator);
    return Fraction((num/commonFactor).round(), (aDenominator/commonFactor).round());
  }

}


class FractionQuestionWidget extends StatelessWidget {
  final FractionQuestion question;

  const FractionQuestionWidget({
    Key? key,
    required this.question
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(question is FractionSumQuestion) {
      return _buildFractionSumQuestion(context, question as FractionSumQuestion);
    }else if(question is FractionConvertQuestion) {
      return _buildFractionConvertQuestion(context, question as FractionConvertQuestion);
    }else {
      return Container();
    }
  }

  Widget _buildFractionSumQuestion(BuildContext context, FractionSumQuestion q) {
    final theme = Theme.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(15.0),
                child: FractionWidget(
                  numerator: q.aNumerator,
                  denominator: q.aDenominator,
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child:  q.operation == FractionOperation.DIVIDE ?
                      Text('\u00f7', style: theme.textTheme.headline3,)
                    : Icon(
                    q.operation == FractionOperation.ADD ?  Icons.add :
                    q.operation == FractionOperation.SUBTRACT ?  Icons.remove :
                    q.operation == FractionOperation.MULTIPLY ?  Icons.close :
                    Icons.check_box_outline_blank,
                  color: theme.textTheme.headline3?.color ?? Colors.white,
                  size: theme.textTheme.headline3?.fontSize ?? 20.0,
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: FractionWidget(
                  numerator: q.bNumerator,
                  denominator: q.bDenominator,
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }

  Widget _buildFractionConvertQuestion(BuildContext context, FractionConvertQuestion q) {
    final theme = Theme.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( q.wholeNumber.toString(), style: theme.textTheme.headline3,)
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15.0),
                  child: FractionWidget(
                    numerator: q.aNumerator,
                    denominator: q.aDenominator,
                  ),
                ),
              ]
          ),
        ],
      ),
    );
  }
}

class FractionWidget extends StatelessWidget {
  const FractionWidget({
    Key? key,
    this.numerator,
    this.denominator,
    this.color
  }) : super(key: key);

  final int? numerator;
  final int? denominator;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            numerator?.toString()  ?? '   ',
            style: theme.textTheme.headline3?.copyWith(color: color ?? theme.textTheme.headline3?.color ?? Colors.white),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: color ?? theme.textTheme.headline3?.color ?? Colors.white,
                width: 5.0
              )
            )
          ),
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              denominator?.toString() ?? '   ',
              style: theme.textTheme.headline3?.copyWith(color: color ?? theme.textTheme.headline3?.color ?? Colors.white),
            ),
          ),
        ),

      ],
    );
  }
}

class KeypadWidget extends StatelessWidget {
  final Function(String v)? onPressed;

  const KeypadWidget({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        for(int y=0; y<3; y++)
          TableRow(
            children: [
              for(int x=0; x<3; x++)
                KeypadKeyWidget( value: ((y*3)+x+1).toString(), onPressed: onPressed )
            ]
          ),
        TableRow(
          children: [
            KeypadKeyWidget( value: '/', onPressed: onPressed ),
            KeypadKeyWidget( value: '0', onPressed: onPressed ),
            KeypadKeyWidget( value: '<', onPressed: onPressed ),

          ]
        )
      ],
    );
  }
}

class KeypadKeyWidget extends StatelessWidget {
  final Function(String v)? onPressed;
  final String value;
  const KeypadKeyWidget({Key? key, required this.value, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed == null ? null : () {
        final Function(String v)? f = onPressed;
        if(f != null) {
          f(value);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: theme.textTheme.headline3?.color ?? Colors.white,
          )
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(5.0),
        child: Center(
          child: Text(
            value,
            style: theme.textTheme.headline4,
          ),
        ),
      ),
    );
  }
}

class GameOverDialog extends StatelessWidget {
  final int finalScore;

  GameOverDialog(this.finalScore);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SimpleDialog(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text('Game Over!', style: theme.primaryTextTheme.headline2,),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text('Your final score was $finalScore', style: theme.primaryTextTheme.headline5,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Start over', style: theme.textTheme.headline5,)
              ),
            )
          ],
        )
      ],
    );
  }
}
