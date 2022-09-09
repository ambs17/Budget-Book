import 'package:expenses/controllers/db_helper.dart';
import 'package:expenses/pages/graphPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'homePage.dart';
import 'addExpenseDialogPage.dart';
import '../theme/static.dart'as Static;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool incomeType= true;
  int currentTab =0;
  final List<Widget> screens =[
    HomePage(),
    GraphPage()
  ];

  final PageStorageBucket bucket =PageStorageBucket();
  Widget currentScreen= HomePage();

  void _newTransaction(){
    showDialog(context: context, builder: (context){
      return AddExpenseDialog(Income: incomeType); //Dialog box widget to add new transactions
    });
  }

  //DbHelper dbHelper =DbHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //toolbarHeight: 0.0,
        title: Text('B U D G E T  B O O K'),
      ),
      body: PageStorage(
        child:currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newTransaction,
        backgroundColor: Static.PrimaryColor,
        child: const Icon(
          Icons.add,
          size: 32.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: (){
                      setState(() {
                        currentScreen= HomePage();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentTab==0? 
                          Color.fromRGBO(34, 44, 101, 1) 
                          :Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: currentTab==0? 
                            Color.fromRGBO(34, 44, 101, 1)
                            :Colors.grey)
                        ),
                      ],
                    ),
                  ),
                ],

              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    onPressed: (){
                      setState(() {
                        currentScreen= GraphPage();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bar_chart,
                          color: currentTab==1? 
                          const Color.fromRGBO(34, 44, 101, 1) 
                          :Colors.grey,
                        ),
                        Text(
                          'Graph',
                          style: TextStyle(
                            color: currentTab==1? 
                            const Color.fromRGBO(34, 44, 101, 1)
                            :Colors.grey)
                        ),
                      ],
                    ),
                  )
                ],

              ),
            ],
          ),
        ),

      ),
    );
  }
}