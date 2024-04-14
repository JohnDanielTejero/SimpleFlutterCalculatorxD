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
  double? firstnum;
  double? lastnum;
  String? operation;
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
        if (val == "C") {
          currentVal = "0";

          return;
        }

        if (val == "DEL") {
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

          double? result;
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
            case '%':
              result = firstnum! % lastnum!;
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
          currentVal = currentVal.endsWith(".0")
              ? currentVal.substring(0, currentVal.length - 2)
              : currentVal;

          return;
        }

        if (firstnum == null && operation == null) {
          String finalVal = currentVal.endsWith(".")
              ? currentVal.substring(0, currentVal.length - 1)
              : currentVal;

          firstnum = double.parse(finalVal);
          operation = val;
          currentVal = "0";
        } else {
          Fluttertoast.showToast(
              msg: "operator already selected!",
              toastLength: Toast.LENGTH_SHORT);
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
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: TextField(
                    controller: controller,
                    enabled: false,
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: false,
                        isCollapsed: true,
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                            top: 60, bottom: 60, left: 20, right: 20)),
                  ),
                ),
                RowButtons(
                    onPressed: buttonClick, labels: const ["7", "8", "9", "/"]),
                RowButtons(
                    onPressed: buttonClick, labels: const ["4", "5", "6", "x"]),
                RowButtons(
                    onPressed: buttonClick, labels: const ["1", "2", "3", "-"]),
                RowButtons(
                    onPressed: buttonClick,
                    labels: const ["+/-", "0", ".", "+"]),
                RowButtons(
                    onPressed: buttonClick,
                    labels: const ["C", "%", "DEL", "="]),
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
    if (label == '+' || label == '-' || label == 'x' || label == '/') {
      return const Color.fromARGB(255, 31, 31, 31); // Color for operations
    } else if (label == '+/-' ||
        label == "." ||
        label == "C" ||
        label == "%" ||
        label == "DEL") {
      return const Color.fromARGB(255, 46, 45, 45);
    } else if (label == '=') {
      return const Color.fromARGB(255, 0, 0, 0);
    } else {
      return const Color.fromARGB(255, 128, 128, 128); // Color for numbers
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressed(label),
      backgroundColor: _getButtonColor(label),
      shape: const CircleBorder(),
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

class RowButtons extends StatelessWidget {
  //const RowButtons({super.key});
  final Function onPressed;
  final List<String> labels;
  //RowButtons({super.key, required this.onPressed, required this.labels});
  const RowButtons({super.key, required this.onPressed, required this.labels});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: labels.map((String label) {
        return CalculatorButton(label: label, onPressed: onPressed);
      }).toList(),
    );
  }
}
