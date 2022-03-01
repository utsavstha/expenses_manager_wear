import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'budget_model.dart';
import 'http_requests.dart';
import 'shape_widget.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<Data> budgets = [];
  void getData() async {
    try {
      HttpRequest httpRequest = HttpRequest();
      var response = await httpRequest
          .getWithAuth("http://192.168.10.65:3000/api/v1/budget");
      var budgetModel = Budget.fromJson(response);
      setState(() {
        budgets = budgetModel.data;
      });
      // return Success(true);
    } catch (e) {
      print(e);
      // return Failure('Could not login');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    Timer.periodic(Duration(seconds: 120), (Timer t) => getData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WatchShape(
            builder: (BuildContext context, WearShape shape, Widget? child) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {
                  return CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: (double.parse(
                                budgets[index].totalAmount.numberDecimal) /
                            double.parse(budgets[index].amount.numberDecimal)) /
                        100,
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(budgets[index].title),
                    ),
                    center:
                        Text("Rs " + budgets[index].totalAmount.numberDecimal),
                    progressColor: Color(0xffff3378),
                    footer: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Rs " + budgets[index].amount.numberDecimal,
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                  );
                }),
          );
        }),
      ),
    );
  }
}
/**
 * Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: 0.5,
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Monthly Budget"),
                    ),
                    center: Text("Rs 10000"),
                    progressColor: Color(0xffff3378),
                    backgroundColor: Color(0xff41e94b),
                    footer: Text(
                      "Sales this week",
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 5.0,
                    percent: 0.5,
                    center: Text("100%"),
                    progressColor: Color(0xffff3378),
                  )
                ],
              ),
 */