import 'package:flutter/material.dart';

class Menucarousel extends StatefulWidget {
  const Menucarousel({super.key});

  @override
  _MenucarouselState createState() => _MenucarouselState();
}

class _MenucarouselState extends State<Menucarousel> {
  late PageController _pageController;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> menus = [
    {
      "title": "Chana Kulcha",
      "subtitle": "Special",
      "image": "assets/images/menu/kulcha.png"
    },
    {
      "title": "Pizza",
      "subtitle": "Hot & Spicy",
      "image": "assets/images/menu/pizza.png"
    },
    {
      "title": "Dosa",
      "subtitle": "Refreshing",
      "image": "assets/images/menu/dosa.png"
    },
    {
      "title": "Chana Kulcha",
      "subtitle": "Special",
      "image": "assets/images/menu/kulcha.png"
    },
    {
      "title": "Pizza",
      "subtitle": "Hot & Spicy",
      "image": "assets/images/menu/pizza.png"
    },
    {
      "title": "Dosa",
      "subtitle": "Refreshing",
      "image": "assets/images/menu/dosa.png"
    },
  ];

  List<Map<String, String>> filteredMenus = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    filteredMenus = menus; // Initially, show all items

    _searchController.addListener(() {
      filterSearchResults(_searchController.text);
    });
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMenus = menus;
      } else {
        filteredMenus = menus
            .where((menu) =>
                menu["title"]!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search menu items...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              height: screenHeight * 0.5,
              child: filteredMenus.isEmpty
                  ? Center(
                      child: Text(
                        "No items found",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : PageView.builder(
                      controller: _pageController,
                      itemCount: filteredMenus.length,
                      itemBuilder: (context, index) {
                        final menu = filteredMenus[index];
                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: screenHeight * 0.25,
                                width: screenWidth * 0.8,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    menu["image"]!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      menu["title"]!,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.09,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      menu["subtitle"]!,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.055,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(
                                              "Order Now clicked for ${menu["title"]}");
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFFC02626),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                        ),
                                        child: Text(
                                          "Order Now",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
