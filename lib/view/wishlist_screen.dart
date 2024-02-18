import 'package:cryptogen/controllers/provider/crypto_provider.dart';
import 'package:cryptogen/model/crypto_data_model.dart';
import 'package:cryptogen/view/specific_crypto_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CryptoDataProvider>(
        builder: (context, marketProvider, child) {
      List<CryptoDataModel> wishlist = marketProvider.cryptoData
          .where((element) => element.addedToWishlist == true)
          .toList();
      if (wishlist.isNotEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            await marketProvider.fetchData();
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
            ),
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: wishlist.length,
            itemBuilder: (context, index) {
              CryptoDataModel currentCrypto = wishlist[index];
              return CryptoTile(currentCryptoData: currentCrypto);
            },
          ),
        );
      } else {
        return const Center(
          child: Text(
            'No CryptoCurrency added to Wishlist',
style: TextStyle(
  color:Colors.grey,
fontSize: 20
),
          ),
        );
      }
    });
  }
}

class CryptoTile extends StatelessWidget {
  const CryptoTile({
    super.key,
    required this.currentCryptoData,
  });

  final CryptoDataModel currentCryptoData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpecificCryptoDataScreen(
              cryptoId: currentCryptoData.id!,
            ),
          ),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 5.w,
          backgroundColor: Colors.white12,
          child: Image.network(currentCryptoData.image!),
        ),
        title: Text(
          currentCryptoData.name!,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          currentCryptoData.currentPrice!.toStringAsFixed(2),
          style: TextStyle(
            color: currentCryptoData.priceChange24! > 0
                ? Colors.green
                : Colors.red,
          ),
        ),
      ),
    );
  }
}
