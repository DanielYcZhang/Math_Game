import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum GameState { initial, pause, playing, finish }

// TODO:
// 1. Each level mas 10 score, display level
// 1. Disable play once clicked.
// 2. Have a stop/quit game button.
// 3. Main page page for selecting game
// 4.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String answerString = "";
  GameState gameState = GameState.initial;

  int firstNumber = 0;
  int secondNumber = 0;
  bool result = false;
  bool isCheckingAnswer = false;
  int score = 0;

  Timer? countdownTimer;
  Duration countdownDuration = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setCountDown();
    });
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = countdownDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        checkAnswer();
        countdownTimer!.cancel();
      } else {
        countdownDuration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer() {
    setState(() {
      countdownTimer!.cancel();
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      countdownDuration = const Duration(seconds: 5);
    });
  }

  void checkAnswer() {
    int expectedResult = firstNumber * secondNumber;
    stopTimer();

    setState(() {
      isCheckingAnswer = true;
      if (answerString == "") {
        result = false;
      } else {
        int answerNumber = int.parse(answerString);
        result = expectedResult == answerNumber;
      }

      // if else shorcut
      score += result ? 1 : -1;
    });

    Timer(const Duration(seconds: 1), () {
      setState(() {
        resetTimer();
        nextQuestion();
      });
    });
  }

  void onNumberPressed(String number) {
    setState(() {
      answerString += number;
    });
  }

  void stop() {
    stopTimer();
    setState(() {
      gameState = GameState.finish;
    });
  }

  void play() {
    setState(() {
      gameState = GameState.playing;
      score = 0;
    });

    nextQuestion();
  }

  void nextQuestion() {
    // if (countdownDuration.inSeconds < 5) {
    //   resetTimer();
    // }

    startTimer();
    setState(() {
      isCheckingAnswer = false;
      firstNumber = Random().nextInt(9);
      secondNumber = Random().nextInt(9);
      answerString = "";
    });
  }

  List<Widget> getResultImages() {
    var numberArray = answerString.split(""); // "12" => ["1", "2"]
    // var stringValues = "a|b|c"; stringValues.split("|") => ["a", "b","c",] ,

    var l = numberArray
        .map(
          (numStr) => Image.asset(
            "assets/images/$numStr.png",
            height: 50,
            width: 50,
          ),
        )
        .toList();
    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/Background.png"),
              fit: BoxFit.fill),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Points: ",
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            score.toString(),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: gameState == GameState.playing
                            ? null
                            : () => play(),
                        child: const Text("Play"),
                      ),
                      Row(
                        children: [
                          const Text(
                            "Timer: ",
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            countdownDuration.inSeconds
                                .remainder(60)
                                .toString(),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/$firstNumber.png",
                          height: 100,
                          width: 100,
                        ),
                        Image.asset(
                          "assets/images/multiply.png",
                          height: 50,
                          width: 50,
                        ),
                        Image.asset(
                          "assets/images/$secondNumber.png",
                          height: 100,
                          width: 100,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/equal.png",
                            height: 50,
                            width: 50,
                          ),
                        ),
                        Row(children: getResultImages()),
                        // Text(
                        //   answerString,
                        //   style: const TextStyle(
                        //       fontSize: 40,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.black),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: isCheckingAnswer
                              ? (result
                                  ? const Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ))
                              : Container(),
                        )
                      ],
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () => onNumberPressed("1"),
                                child: const Text("1"),
                              ),
                              ElevatedButton(
                                onPressed: () => onNumberPressed("2"),
                                child: const Text("2"),
                              ),
                              ElevatedButton(
                                onPressed: () => onNumberPressed("3"),
                                child: const Text("3"),
                              ),
                              ElevatedButton(
                                onPressed: () => onNumberPressed("4"),
                                child: const Text("4"),
                              ),
                              ElevatedButton(
                                onPressed: () => onNumberPressed("5"),
                                child: const Text("5"),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () => onNumberPressed("6"),
                                child: const Text("6"),
                              ),
                              ElevatedButton(
                                onPressed: () => onNumberPressed("7"),
                                child: const Text("7"),
                              ),
                              ElevatedButton(
                                onPressed: () => onNumberPressed("8"),
                                child: const Text("8"),
                              ),
                              ElevatedButton(
                                onPressed: () => onNumberPressed("9"),
                                child: const Text("9"),
                              ),
                              ElevatedButton(
                                onPressed: () => onNumberPressed("0"),
                                child: const Text("0"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      onPressed: gameState == GameState.playing
                          ? () => checkAnswer()
                          : null,
                      child: const Text("Submit"),
                    ),
                    ElevatedButton(
                      onPressed:
                          gameState == GameState.playing ? () => stop() : null,
                      child: const Text("Stop"),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
