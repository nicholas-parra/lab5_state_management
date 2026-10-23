import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mortgage.dart';

class ModifyScreen extends StatefulWidget {
  const ModifyScreen({super.key});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  final _formKey = GlobalKey<FormState>(); 
  
  late MortgageProvider mortgage;
  late int? _selectedYear;
  late final TextEditingController _amountController = TextEditingController();
  late double _selectedRate;

  @override
  void initState() {
    mortgage = Provider.of<MortgageProvider>(super.context, listen:false);
    super.initState();
    _selectedYear = mortgage.getYears();
    _amountController.text = mortgage.getAmount().toString();
    _selectedRate = mortgage.getRate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mortgage Value Update',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("MortgageV0"),
        ),
        body: Form( 
          key: _formKey, 
          child: Container(
            padding: .all(20),
            child: Column( 
              mainAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Text("Years", style: TextStyle(fontSize: 20), textAlign: .start)
                    ),
                    Expanded(
                      flex: 4,
                      child: RadioGroup<int>(
                        groupValue: _selectedYear,
                        onChanged: (int? value) {
                          setState(() { _selectedYear = value; });
                        },
                        child: Row(
                          mainAxisAlignment: .spaceEvenly,
                          children: <Widget>[
                            Expanded(child: RadioListTile(
                              value: 10, 
                              contentPadding: .directional(start: 5),
                              horizontalTitleGap: 5,
                              title: Text('10')
                            )),
                            Expanded(child: RadioListTile(
                              value: 15, 
                              contentPadding: .directional(start: 5),
                              horizontalTitleGap: 5,
                              title: Text('15')
                            )),
                            Expanded(child: RadioListTile(
                              value: 30, 
                              contentPadding: .directional(start: 5),
                              horizontalTitleGap: 5,
                              title: Text('30')
                            )),
                          ],
                        ),
                      )
                    )
                  ]
                ),
                Row(
                  mainAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Text("Amount", style: TextStyle(fontSize: 20), textAlign: .start)
                    ),
                    Expanded(child: TextFormField( 
                      textAlign: .start,
                      controller: _amountController,
                      decoration: const InputDecoration( 
                        hintText: 'Enter your mortgage amount', 
                      ), 
                      validator: (value) { 
                        double? ret = double.tryParse(value!);
                        if (ret == null) { 
                          return 'Please enter a Decimal value.'; 
                        } 
                        return null; 
                      }, 
                    ))
                  ]
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: .start,
                  children: [
                    Expanded(
                      child: Text("Rate", style: TextStyle(fontSize: 20), textAlign: .start)
                    ),
                    Container(
                      height: 100,
                      width: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 53, // 1 + (max - min) / interval --> 1 + 13 / .25 = 53
                        itemBuilder: (BuildContext context, int index) {
                          double value = .02 + index * 0.0025;
                          bool isSelected = value == _selectedRate;
                          return ListTile(
                            title: Text((value * 100).toStringAsPrecision(3)),
                            trailing: isSelected
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : const Icon(Icons.circle_outlined),
                            onTap: () { 
                              setState(() {
                                _selectedRate = value;
                              });
                            }
                          );
                        },
                      )
                    )
                  ]
                ),
                const SizedBox(height: 20), 
                ElevatedButton( 
                  onPressed: () async { 
                    if (_formKey.currentState!.validate()) { 
                      mortgage.setYears(_selectedYear!);
                      mortgage.setAmount(double.parse(_amountController.text));
                      mortgage.setRate(_selectedRate);

                      var saveResults = await mortgage.saveToSharedPreferences();
                      var displayText = !saveResults.contains(false)
                        ? 'Updates submitted successfully!' 
                        : 'Updates not persisted to local storage!';
                      ScaffoldMessenger.of(context).showSnackBar( 
                        SnackBar(content: Text(displayText)), 
                      );

                      Navigator.of(context).pop(); 
                    } 
                  }, 
                  child: const Text('Submit'), 
                ), 
              ], 
            ), 
          )
        )
      )
    );
  }
}