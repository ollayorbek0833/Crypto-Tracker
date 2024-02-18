
import 'package:cryptogen/controllers/provider/crypto_provider.dart';
import 'package:cryptogen/model/crypto_data_model.dart';
import 'package:cryptogen/view/specific_crypto_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<CryptoDataProvider>(builder: (context, cryptoDataProvider, child){
                if(cryptoDataProvider.isLoading==true){
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }else{
                  return Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cryptoDataProvider.cryptoData.length,
                      itemBuilder: (context, index){
                        CryptoDataModel currentCryptoData = cryptoDataProvider.cryptoData[index];
                        return InkWell(
                          onTap: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SpecificCryptoDataScreen(cryptoId: currentCryptoData.id!.toString()),));
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Colors.white12,
                              radius: 5. w,
                              child: Image.network(currentCryptoData.image!),
                            ),
                            title: Text(
                              currentCryptoData.name!,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                            trailing: Text(
                              currentCryptoData.currentPrice!.toStringAsFixed(2),
                              style: TextStyle(
                                  color: currentCryptoData.priceChange24!<0?Colors.red:Colors.green
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
