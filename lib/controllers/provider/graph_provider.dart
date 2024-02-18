import 'package:cryptogen/controllers/services/get_marked_data.dart';
import 'package:cryptogen/model/crypto_graph_data_model.dart';
import 'package:flutter/cupertino.dart';


class GraphProvider with ChangeNotifier{
  List<CryptoGraphData> graphPoints = [];

  Future<void> fetchGraphData (String id, int days)async{
    graphPoints = [];
    notifyListeners();
    List<dynamic> priceData = await API.fetchGraphData(id, days);
    List<CryptoGraphData> temp = [];
    for(var pricePoint in priceData){
      CryptoGraphData graphPoint = CryptoGraphData.fromList(pricePoint);
      temp.add(graphPoint);
    }

    graphPoints  = temp;
    notifyListeners();
  }
}