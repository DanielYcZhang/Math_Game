import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
    final reduceSecondsBy = 1;
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

  void play() {
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Math Game"),
        backgroundColor: Colors.amber,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              color: Colors.pink,
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
                        onPressed: () => play(),
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
          ),
          Flexible(
            child: Container(
              color: Colors.brown,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        firstNumber.toString(),
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "*",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        secondNumber.toString(),
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "=",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        answerString,
                        style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow),
                      ),
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
                    onPressed: () => checkAnswer(),
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
