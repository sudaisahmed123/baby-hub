import 'package:flutter/material.dart';
import 'package:fresh_store_ui/model/special_offer.dart';
import 'package:fresh_store_ui/screens/home/view_products.dart';
import 'package:fresh_store_ui/screens/mostpopular/most_popular_screen.dart';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:fresh_store_ui/model/category1.dart'; // Ensure this model has the right fields
import '../../components/special_offer_widget.dart';
import 'package:fresh_store_ui/model/popular.dart'; // Ensure this model has the right fields
import 'package:fresh_store_ui/model/category.dart';



typedef SpecialOffersOnTapSeeAll = void Function();

class SpecialOffers extends StatefulWidget {
  final SpecialOffersOnTapSeeAll? onTapSeeAll;
  const SpecialOffers({super.key, this.onTapSeeAll});

  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  late List<Category> categories = [];
  late final List<SpecialOffer> specials = homeSpecialOffers;

  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final DatabaseReference categoryRef = FirebaseDatabase.instance.ref('categories');
    final DatabaseEvent event = await categoryRef.once();

    if (event.snapshot.exists) {
      setState(() {
        categories = (event.snapshot.value as Map).entries.map((entry) {
          return Category.fromMap(Map<String, dynamic>.from(entry.value), entry.key);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        const SizedBox(height: 24),
        Stack(children: [
          Container(
            height: 181,
            decoration: const BoxDecoration(
              color: Color(0xFFE7E7E7),
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
            child: PageView.builder(
              itemBuilder: (context, index) {
                final data = specials[index];
                return SpecialOfferWidget(context, data: data, index: index);
              },
              itemCount: specials.length,
              allowImplicitScrolling: true,
              onPageChanged: (value) {
                setState(() => selectIndex = value);
              },
            ),
          ),
          _buildPageIndicator()
        ]),
        const SizedBox(height: 24),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: categories.length,
          scrollDirection: Axis.vertical,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 100,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            maxCrossAxisExtent: 77,
          ),
          itemBuilder: ((context, index) {
            final data = categories[index];
            return GestureDetector(
              onTap: () {
                // Navigate to ViewProductsScreen with category ID and name
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProducts(
                      categoryId: data.id, // Assuming your Category model has an 'id' field
                      categoryName: data.name,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                       gradient: LinearGradient(
                colors: [Colors.orange, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: data.icon != null
                        ? Image.memory(base64Decode(data.icon), width: 28, height: 28)
                        : const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FittedBox(
                    child: Text(
                      data.name,
                      style: const TextStyle(color: Color(0xff424242), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Special Offers',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF212121)),
        ),
        TextButton(
          onPressed: () => widget.onTapSeeAll?.call(),
          child: const Text(
            'See All',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF212121)),
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < specials.length; i++) {
      list.add(i == selectIndex ? _indicator(true) : _indicator(false));
    }
    return Container(
      height: 181,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list,
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return SizedBox(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        height: 4.0,
        width: isActive ? 16 : 4.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: isActive ? const Color(0XFF101010) : const Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}


