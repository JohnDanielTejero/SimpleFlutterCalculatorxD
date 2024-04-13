import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Flutter Caclulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CalcMain(),
    );
  }
}

class CalcState extends State<CalcMain> {
  double? firstnum = null;
  double? lastnum = null;
  String? operation = null;
  String currentVal = "0";

  void buttonClick(String val) {
    // Implement your button click logic here

    setState(() {
      if (currentVal == "Infinity") {
        currentVal = "0";
      }

      try {
        double.parse(val);
        if (currentVal == "0") {
          currentVal = "";
        }

        currentVal += val;
        return;
      } on Exception catch (_) {
        if (val == "backspace") {
          String newVal = currentVal.substring(0, currentVal.length - 1);
          currentVal = newVal.isEmpty || newVal == "-" ? "0" : newVal;
          return;
        }

        if (val == "+/-") {
          if (!currentVal.startsWith("-")) {
            // Check if the currentVal doesn't already start with a minus sign
            currentVal =
                "-$currentVal"; // Add a minus sign at the beginning of the string
          } else {
            // If it already starts with a minus sign, remove it
            currentVal = currentVal.substring(1);
          }
          return;
        }

        if (val == "." && !currentVal.contains(".")) {
          currentVal += val;
          return;
        }

        if (val == "=") {
          String finalVal = currentVal.endsWith(".")
              ? currentVal.substring(0, currentVal.length - 1)
              : currentVal;

          lastnum = double.parse(finalVal);

          if (firstnum == null || lastnum == null) {
            Fluttertoast.showToast(
                msg: "Please input an operator and two numbers first!",
                toastLength: Toast.LENGTH_SHORT);
            return;
          }

          double? result = null;
          switch (operation) {
            case '+':
              result = firstnum! + lastnum!;
              break;
            case '-':
              result = firstnum! - lastnum!;
              break;
            case 'x':
              result = firstnum! * lastnum!;
              break;
            case '/':
              result = firstnum! / lastnum!;
              break;
            default:
              Fluttertoast.showToast(
                  msg: "An error has occurred!",
                  toastLength: Toast.LENGTH_SHORT);
              firstnum = null;
              lastnum = null;
              operation = null;
              currentVal = "0";
              return;
          }
          firstnum = null;
          lastnum = null;
          operation = null;
          currentVal = result.toString();
          return;
        }

        if (firstnum == null && operation == null) {
          String finalVal = currentVal.endsWith(".")
              ? currentVal.substring(0, currentVal.length - 1)
              : currentVal;

          firstnum = double.parse(finalVal);
          operation = val;
          currentVal = "0";
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: currentVal);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          buttonClick("backspace");
                        },
                        child: const Icon(
                          Icons.backspace,
                        ),
                      ),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(right: 5, left: 5),
                              child: TextField(
                                controller: controller,
                                enabled: false,
                                textAlign: TextAlign.end,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ))),
                      CalculatorButton(
                        label: '=',
                        onPressed: buttonClick,
                      ),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CalculatorButton(
                      label: '7',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '8',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '9',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '/',
                      onPressed: buttonClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CalculatorButton(
                      label: '4',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '5',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '6',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: 'x',
                      onPressed: buttonClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CalculatorButton(
                      label: '1',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '2',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '3',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '-',
                      onPressed: buttonClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CalculatorButton(
                      label: '+/-',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '0',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '.',
                      onPressed: buttonClick,
                    ),
                    CalculatorButton(
                      label: '+',
                      onPressed: buttonClick,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  const CalculatorButton(
      {super.key, required this.label, required this.onPressed});

  Color _getButtonColor(String label) {
    if (label == '+' ||
        label == '-' ||
        label == 'x' ||
        label == '=' ||
        label == '/') {
      return const Color.fromARGB(255, 12, 12, 12); // Color for operations
    } else {
      return const Color.fromARGB(255, 81, 81, 82); // Color for numbers
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressed(label),
      backgroundColor: _getButtonColor(label),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class CalcMain extends StatefulWidget {
  const CalcMain({super.key});

  @override
  State<StatefulWidget> createState() => CalcState();
}

class HelloWorld extends StatelessWidget {
  const HelloWorld({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Fluttertoast.showToast(
            msg: "clicked!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: const Color.fromARGB(255, 255, 0, 0));
      },
      child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                  color: const Color.fromARGB(255, 255, 0, 0), width: 2)),
          child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello world",
                    style: TextStyle(
                        color: Color.fromARGB(255, 32, 132, 255),
                        decoration: TextDecoration.none),
                  )
                ],
              ))),
    );
  }
}
