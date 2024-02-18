import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cryptogen/controllers/services/api/apis.dart';
import 'package:http/http.dart' as http;

class API{
  static Future getCryptoMarketData()async{
    final api = Uri.parse(getMarkedData);
    try{
      var response = await http.get(api, headers: {'Content-Type':'application/json'}).timeout(Duration(seconds: 60), onTimeout: (){
        throw TimeoutException("Connection timed out");
      });
      log(response.statusCode.toString());
      if(response.statusCode == 200){
        var decodedResponse = jsonDecode(response.body);
        log(decodedResponse.toString());
        List<dynamic> products = decodedResponse as List<dynamic>;
        return products;
      }
    }catch(e){
      log(e.toString());
    }
  }

  static Future<List<dynamic>> fetchGraphData(String  id, int days)async{
    try{
      Uri requestPath = Uri.parse("https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=$days");
      var response = await http.get(requestPath);
      var decodedResponse = jsonDecode(response.body);
      log(decodedResponse.toString());
      List<dynamic> prices = decodedResponse["prices"];
      return prices;
    }catch(e){
      return [];
    }
  }
}