import 'package:chapanotify/config/graphql_config.dart';
import 'package:chapanotify/main.dart';
import 'package:chapanotify/screens/widgets/transaction_card.dart';
import 'package:chapanotify/services/graphql_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GraphqlService _graphqlService = GraphqlService();
  late Future<List<Map<String, dynamic>>> _transactions;
  int totalAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transactions = _graphqlService.getTransaction();
    totalTransactionAmount();
  }

  void totalTransactionAmount() async {
    final fetchTransactions = await _graphqlService.getTransaction();
    setState(() {
      totalAmount = fetchTransactions.fold(0, (sum, item) {
        return sum + (item['amount'] as int? ?? 0);
      });
    });
  }

  Future<List<BotData>> fetchTransactions() async {
    await Future.delayed(Duration(seconds: 2));

    List<Map<String, dynamic>> transactions =
        await _graphqlService.getTransaction();

    Map<String, dynamic> categorizedData = {};

    for (var transaction in transactions) {
      String botName = transaction['botName'];
      int amount = transaction['amount'];

      categorizedData.update(
        botName,
        (value) => value + amount,
        ifAbsent: () => amount,
      );
    }

    return categorizedData.entries.map((entry) {
      return BotData(name: entry.key, amount: entry.value);
    }).toList();
  }

  Future<void> _pullRefresh() async {
    await fetchTransactions();
    setState(() {
      _transactions = _graphqlService.getTransaction();
      totalTransactionAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // app bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              'assets/img/profile.png',
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome Back 👋'),
                              Text(
                                'Yoni Tad',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(Icons.notifications_active_outlined),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  // chart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total Earn\'s'),
                          Text(
                            'ETB ${totalAmount.toDouble()}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      DropdownButton(
                        items: [DropdownMenuItem(child: Text('All time'))],
                        onChanged: (value) => {},
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),

                  SizedBox(
                    height: 250.h,
                    child: transactionChart(fetchTransactions),
                  ),
                  SizedBox(height: 40.h),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transactions',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13.sp,
                        ),
                      ),

                      transactionList(_transactions),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget transactionList(_transactions) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: _transactions,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No transactions available.'));
      }

      List<Map<String, dynamic>> transactions = snapshot.data!;

      return ListView.builder(
        itemCount: transactions.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return TransactionCard(
            botName: transaction['botName'],
            amount: transaction['amount'],
            timeStamp: formatTimeStamp(transaction['timeStamp']),
          );
        },
      );
    },
  );
}

Widget transactionChart(fetchTransactions) {
  return FutureBuilder<List<BotData>>(
    future: fetchTransactions(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No transactions available.'));
      }

      List<BotData> botTransactions = snapshot.data!;

      return BarChart(
        BarChartData(
          barGroups:
              botTransactions
                  .asMap()
                  .entries
                  .map(
                    (entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.amount.toDouble(),
                          color: Colors.blueAccent,
                          width: 20,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  )
                  .toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(botTransactions[value.toInt()].name);
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      );
    },
  );
}

String formatTimeStamp(timeStamp) {
  DateTime dateTime = DateTime.parse(timeStamp);
  return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
}

class BotData {
  final String name;
  final int amount;

  BotData({required this.name, required this.amount});
}
