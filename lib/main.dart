import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modify.dart';
import 'mortgage.dart';
import 'sharedpreferences.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized(); 
	await SharedPreferencesHelper.init(); 
  runApp(
    ChangeNotifierProvider(
      create: (context) => MortgageProvider(),
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Calculator',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
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
  bool termsConditionsAccepted = false;

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Accept Terms and Conditions"),
          content: Text("Are you sure you would like to accept the Terms and Conditions?"),
          actions: [
            TextButton(
              child: Text("Decline"),
              onPressed: () {
                setState(() { 
                  termsConditionsAccepted = false;
                  Navigator.of(context).pop();
                });
              }
            ),
            TextButton(
              child: Text("OK"),
              onPressed: () {
                setState(() { 
                  termsConditionsAccepted = true;
                  Navigator.of(context).pop();
                });
              }
            )
          ]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final MortgageProvider mortgage = Provider.of<MortgageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("MortgageV0"),
      ),
      body: Center(
        child: Container(
          padding: .all(20),
          child: Column(
            mainAxisAlignment: .start,
            children: [
              DetailRow(label: "Amount:", value: mortgage.getFormattedAmount()),
              DetailRow(label: "Years", value: mortgage.getYears()),
              DetailRow(label: "Rate:", value: mortgage.getFormattedRate()),
              Divider( color: Colors.red, thickness: 4, height: 20 ),
              DetailRow(label: "Monthly Payment:", value: mortgage.formattedMonthlyPayment()),
              DetailRow(label: "Total Payment:", value: mortgage.formattedTotalPayment()),
              Row(
                mainAxisAlignment: .spaceEvenly,
                children: [
                  Checkbox(
                    value: termsConditionsAccepted,
                    onChanged: (bool? value) { 
                      showAlertDialog(context);
                    }
                  ),
                  Text("Accept Terms and Conditions?")
                ]
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ModifyScreen())
                ),
                child: Text("MODIFY DATA")
              )
            ],
          ),
        )
      )
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const DetailRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 20),
            textAlign: .start,
          )
        ),
        Expanded(
          child: Text(
            value?.toString() ?? "Invalid input",
            style: TextStyle(fontSize: 20),
            textAlign: .start,
          )
        )
      ] 
    );
  }
}