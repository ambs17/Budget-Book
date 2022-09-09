import 'package:expenses/controllers/db_helper.dart';
import 'package:expenses/pages/addExpenseDialogPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../theme/static.dart'as Static;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  DbHelper dbHelper =DbHelper();
  int totalBalance=0;
  int totalIncome=0;
  int totalExpense=0;

  getTotalBalance(Map entireData){
    totalBalance=0;
    totalIncome=0;
    totalExpense=0;
    entireData.forEach((key, value) {
      print(value);
      if(value['type']==true){
        totalBalance += (value['amount'] as int);
        totalIncome+=(value['amount'] as int);
      }
      else{
        totalBalance -= (value['amount'] as int);
        totalExpense+=(value['amount'] as int);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map>(
        future: dbHelper.fetch(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return const Center(child: Text('Unexpected Error'),);
          } 
          if(snapshot.hasData){
            if(snapshot.data!.isEmpty){
              return const Center(
                child: Text("No Values Found!"),
              );
            }
            //
            getTotalBalance(snapshot.data!);
            return ListView(
              children: [
                Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width *0.9,
                  margin: const EdgeInsets.all(12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15.0)
                      ),
                      boxShadow: [
                        BoxShadow(
                        color: Colors.grey.shade500,
                        offset: const Offset(4.0,4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4.0,-4.0),
                        blurRadius: 15.0,
                        spreadRadius: 1.0,
                      ),
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 8.0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'B A L A N C E',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey.shade600,
                              //color: Static.PrimaryColor,
                            ),
                          ),
                          Text(
                            '₹ $totalBalance',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w500,
                              //color: Colors.grey.shade800,
                              color: Static.PrimaryColor,
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cardIncome(totalIncome.toString()),
                                cardExpense(totalExpense.toString()),
                              ],
                            ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'R E C E N T',
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Static.PrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ), 
                ),

                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Map dataatIndex= snapshot.data![index];
                    if(dataatIndex['type']==true){
                      return incomeTile(dataatIndex["amount"], dataatIndex["note"]);
                    }
                    return expenseTile(dataatIndex["amount"], dataatIndex["note"]);
                  } 
                ),
              ],
            );
          }
          else{
            return const Center(child: Text('Some Error Occured'),);
          }                   
        }
      )
    );
  }

  Widget cardIncome(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              20.0
            ),
          ),
          padding: const EdgeInsets.all(
            6.0,
          ),
            margin: const EdgeInsets.only(
              right: 8.0,
            ),
          child: const Icon(
            Icons.arrow_downward,
            size: 28.0,
            color: Colors.green,
            ),
        ),
        Column(
          children: [
            const Text(
              'Income',
              style: TextStyle(
                fontSize: 16.0,
                color: Static.PrimaryColor,
              ),
            ),
            Text(
              "₹$value",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Static.PrimaryColor,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget cardExpense(String value){
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(
              20.0
            ),
          ),
          padding: const EdgeInsets.all(
            6.0,
          ),
            margin: const EdgeInsets.only(
              right: 8.0,
            ),
          child: const Icon(
            Icons.arrow_upward,
            size: 28.0,
            color: Colors.red,
            ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expense',
              style: TextStyle(
                fontSize: 16.0,
                color: Static.PrimaryColor,
              ),
            ),
            Text(
              "₹$value",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Static.PrimaryColor,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget expenseTile(int value, String note){
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 216, 218, 226),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.arrow_circle_up_outlined,
                size: 40.0,
                color: Colors.red,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                note,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          Text(
          ("-$value"),
            style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }

  Widget incomeTile(int value, String note){
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 216, 218, 226),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.arrow_circle_down_outlined,
                size: 40.0,
                color: Colors.green,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                note,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          Text(
          ("+$value"),
            style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w400
            ),
          ),
        ],
      ),
    );
  }



}