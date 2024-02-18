import 'package:cryptogen/controllers/local_storage/local_storage.dart';
import 'package:cryptogen/controllers/provider/crypto_provider.dart';
import 'package:cryptogen/controllers/provider/graph_provider.dart';
import 'package:cryptogen/model/crypto_data_model.dart';
import 'package:cryptogen/model/crypto_graph_data_model.dart';
import 'package:cryptogen/view/crypto_listing_screen.dart';
import 'package:cryptogen/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SpecificCryptoDataScreen extends StatefulWidget {
  final String cryptoId;

  const SpecificCryptoDataScreen({super.key, required this.cryptoId});

  @override
  State<SpecificCryptoDataScreen> createState() =>
      _SpecificCryptoDataScreenState();
}

class _SpecificCryptoDataScreenState extends State<SpecificCryptoDataScreen> {
  List<String> timePeriod = ['1D', '5D', '1W', '1M', '1Y'];
  String selectedTimePeriod = '1D';
  TrackballBehavior trackballBehavior = TrackballBehavior(enable: true);
  CrosshairBehavior crosshairBehavior = CrosshairBehavior(enable: true);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CryptoDataProvider>().fetchCryptoById(widget.cryptoId);
      context.read<GraphProvider>().fetchGraphData(widget.cryptoId, 1);
    });
    super.initState();
  }

  getCryptoDataTitle(int index) {
    switch (index) {
      case 0:
        return '% change 24HR';
      case 1:
        return '\$ change 24HR';
      case 2:
        return 'Price';
      case 3:
        return 'Market Cap';
      case 4:
        return '24HR Low';
      case 5:
        return '24HR High';
      case 6:
        return 'ATL';
      case 7:
        return 'ATH';
    }
  }

  getCryptoDataValue(CryptoDataModel crypto, int index) {
    switch (index) {
      case 0:
        return crypto.priceChangePercentage24!.toStringAsFixed(2);
      case 1:
        return crypto.priceChange24!.toStringAsFixed(2);
      case 2:
        return crypto.currentPrice!.toStringAsFixed(2);
      case 3:
        return crypto.marketCap!.toString();
      case 4:
        return crypto.low24!.toStringAsFixed(2);
      case 5:
        return crypto.high24!.toStringAsFixed(2);
      case 6:
        return crypto.atl!.toStringAsFixed(2);
      case 7:
        return crypto.ath!.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoDataProvider>(builder: (context, cryptoDataProvider, child) {
      if (cryptoDataProvider.fetchingCurrentCrypto == true) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>HomeScreen())),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    cryptoDataProvider.updateWishlist(
                      cryptoDataProvider.currentCrypto.id!,
                      cryptoDataProvider.currentCrypto
                    );
                  },
                  icon: Icon(
                    cryptoDataProvider.wishlist.contains(cryptoDataProvider.currentCrypto.id!) == true? Icons.bookmark:
                    Icons.bookmark_border,
                    color: Colors.white,
                  ))
            ],
            title: Row(
              children: [
                CircleAvatar(
                  child: Image.network(cryptoDataProvider.currentCrypto.image!),
                ),
                SizedBox(
                  width: 2.w,
                ),
                Text(
                  cryptoDataProvider.currentCrypto.name!,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          body: ListView(
            children: [
              CryptoChart(context),
              SizedBox(
                height: 2.h,
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.h,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 2.h
                  ),
                  itemCount: 8,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                  return Column(
                    crossAxisAlignment: index%2==0? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      Text(
                        getCryptoDataTitle(index),
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        getCryptoDataValue(cryptoDataProvider.currentCrypto, index),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: double.parse(getCryptoDataValue(cryptoDataProvider.currentCrypto, index))<0?Colors.red:Colors.green,
                          overflow: TextOverflow.ellipsis
                        ),
                      )
                    ],
                  );
                  },
              )
            ],
          ),
        );
      }
    });
  }
  Column CryptoChart(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 25.h,
          child: Consumer<GraphProvider>(
            builder: (context, graphProvider, child) {
              return SfCartesianChart(
                trackballBehavior: trackballBehavior,
                crosshairBehavior: crosshairBehavior,
                primaryXAxis: DateTimeAxis(
                  isVisible: true,
                  borderColor: Colors.transparent,
                ),
                primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.compact(), isVisible: true),
                //plotAreaBorderWidth: 0,
                series: <AreaSeries>[
                  AreaSeries<CryptoGraphData, dynamic>(
                    enableTooltip: true,
                    color: Colors.transparent,
                    borderColor: Color(0xff1ab7c3),
                    borderWidth: 2,
                    dataSource: graphProvider.graphPoints,
                    xValueMapper: (CryptoGraphData graphPoint, index) =>
                        graphPoint.date,
                    yValueMapper: (CryptoGraphData graphPoint, index) =>
                        graphPoint.price,
                  )
                ],
              );
            },
          ),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: timePeriod
                .map((commWidget) => InkWell(
                      onTap: () {
                        String time = commWidget;
                        switch (time) {
                          case '1D':
                            context
                                .read<GraphProvider>()
                                .fetchGraphData(widget.cryptoId, 1);
                            setState(() {
                              selectedTimePeriod = '1D';
                            });
                            break;
                          case '5D':
                            context
                                .read<GraphProvider>()
                                .fetchGraphData(widget.cryptoId, 5);
                            setState(() {
                              selectedTimePeriod = '5D';
                            });
                            break;
                          case '1W':
                            context.read<GraphProvider>()
                                .fetchGraphData(widget.cryptoId, 7);
                            setState(() {
                              selectedTimePeriod = '1W';
                            });
                            break;
                          case '1M':
                            context.read<GraphProvider>()
                                .fetchGraphData(widget.cryptoId, 30);
                            setState(() {
                              selectedTimePeriod = '1M';
                            });
                            break;
                          case '1Y':
                            context.read<GraphProvider>()
                                .fetchGraphData(widget.cryptoId, 365);
                            setState(() {
                              selectedTimePeriod = '1Y';
                            });
                            break;
                          default:
                            context.read<GraphProvider>()
                                .fetchGraphData(widget.cryptoId, 1);
                            setState((){
                              selectedTimePeriod ='1D';
                            });
                            break;
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: selectedTimePeriod == commWidget?Colors.white12:Colors.transparent,
                          borderRadius: BorderRadius.circular(
                            10.sp,
                          ),
                          border: Border.all(
                            color: Colors.white30,
                          ),
                        ),
                        child: Text(
                          commWidget,
                          style: TextStyle(
                            color:Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ))
                .toList())
      ],
    );
  }
}
