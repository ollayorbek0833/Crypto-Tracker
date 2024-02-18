import 'package:cryptogen/view/crypto_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:cryptogen/view/wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child:Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                tabs: [
              Tab(text: "Market",),
              Tab(text: "Wishlist",)
            ]),
            title: const Text(
                "Hello!",
              style: TextStyle(
                fontSize: 39,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),
          body: TabBarView(children: [
            CryptoListScreen(),
            WishlistScreen(),
          ]),
        )
    );
  }
}
