import 'package:expenses/controllers/db_helper.dart';
import 'package:expenses/pages/home.dart';
import 'package:expenses/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';


import '../theme/static.dart'as Static;

class AddExpenseDialog extends StatefulWidget {
  bool Income; //String type= 'Income'
  AddExpenseDialog({required this.Income});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState(isIncome: Income);
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final amountTextController= TextEditingController();
  final itemTextController = TextEditingController();
  int? amount;
  String note ='Spent on note';
  DateTime selectedDate = DateTime.now();
  bool isIncome;
  final formKey = GlobalKey<FormState>(); //might cause error
  List <String> months =[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  Future<void> _selectDate(BuildContext context) async{
    final DateTime? picked =await showDatePicker(context: context,
     initialDate: selectedDate, firstDate: DateTime(2020,12), lastDate: DateTime(2100,01));
    if(picked !=null && picked != selectedDate ){
      setState(() {
        selectedDate = picked;
      });
    }

  }
  _AddExpenseDialogState({required this.isIncome});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('N E W  T R A N S A C T I O N '),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Expense'),
                  Switch(
                    value: isIncome,
                    onChanged: (newValue) {
                      setState(() {
                        isIncome=newValue;
                      });
                    },
                  ),
                  const Text('Income'),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Amount',
                        ),
                        validator: (text){
                          if (text==null || text.isEmpty){
                            return 'Please Enter an Amount';
                          }
                          return null;
                        },
                        onChanged: (val){
                          try {
                            amount=int.parse(val);                         
                          } catch (e) {
                            print('Invalid Amount Error');
                          }
                        },
                        controller: amountTextController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly, //to allow digits only in the textfield
                        ],
                        keyboardType: TextInputType.number, //to change the keyboard into numeric keyboard
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children:[
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Spent on'
                      ),
                      onChanged: (val){
                        note=val;
                      },
                      controller: itemTextController,                      
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: (){
                  _selectDate(context);
                  },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                    // decoration: BoxDecoration(
                    //   color: Static.PrimaryColor,
                    //   borderRadius: BorderRadius.circular(16.0),
                    // ),
                    //padding: const EdgeInsets.all(12.0),
                    child: const Icon(
                      Icons.date_range,
                      size: 24.0,
                      color: Static.PrimaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                      "${selectedDate.day} ${months[selectedDate.month-1]}",
                      style: const TextStyle(
                        //color: Colors.blueGrey,
                        fontSize: 20,
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
        actions: [
          MaterialButton(
            color: Colors.red,
            child: const Text(
              'Cancel',
              style:TextStyle(
                color: Colors.white,
              ) ,
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            color: Theme.of(context).primaryColor,
            child: const Text(
              'ADD',
              style:TextStyle(
                color: Colors.white,
              ) ,
            ),
            onPressed: ()async{      
              if(amount !=null && note.isNotEmpty){
                DbHelper dbHelper=DbHelper();
                await dbHelper.addData(amount!, selectedDate, note, isIncome);
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home(),
                )).whenComplete((){
                  setState(() {                    
                  });
                });
                print('Values ADDED!!');
              }
              else{
                print('not all values provided');
              }
              // print(amount);
              // print(note);
              // print(isIncome);
              // print(selectedDate);       //add transaction function here
              // Navigator.of(context).pop();
            },
          ),
          
        ],
    );
  }
}
