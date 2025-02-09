import 'package:flutter/material.dart';

class Menucarousel extends StatefulWidget {
  const Menucarousel({super.key});

  @override
  _MenucarouselState createState() => _MenucarouselState();
}

class _MenucarouselState extends State<Menucarousel> {
  late PageController _pageController;

  // Menu data with title, subtitle, and image
  final List<Map<String, String>> menus = [
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

  late final List<Map<String, String>> _loopedMenus = [
    menus.last, // Add last item at the beginning
    ...menus,
    menus.first, // Add first item at the end
  ];

  @override
  void initState() {
    super.initState();

    // Initialize the PageController with viewportFraction to show adjacent cards
    _pageController = PageController(
      initialPage: 1,
      viewportFraction: 0.85, // Show parts of the next and previous cards
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox(
          height: screenHeight * 0.45, // Maintain existing height
          width: screenWidth, // Maintain existing width
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              // Handle looping when reaching padded items
              if (index == 0) {
                _pageController.jumpToPage(_loopedMenus.length - 2);
              } else if (index == _loopedMenus.length - 1) {
                _pageController.jumpToPage(1);
              }
            },
            itemCount: _loopedMenus.length,
            itemBuilder: (context, index) {
              // Use the looped menu data
              final menu = _loopedMenus[index];
              return Card(
                elevation: 5, // Set the card's shadow elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // Rounded corners
                ),
                margin: EdgeInsets.symmetric(
                    horizontal:
                    screenWidth * 0.04), // Adjust space between cards
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image widget to display the image for each menu item (Top half of the card)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              16), // Rounded corners for the container
                          border: Border.all(
                            color: Colors.white, // Border color
                            width: 2, // Border width
                          ),
                        ),
                        height: screenHeight *
                            0.25, // Set image height to half of the card height
                        width: screenWidth * 0.8, // Maintain image width
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              16), // Ensure image respects the container's border radius
                          child: Image.asset(
                            menu["image"]!,
                            fit: BoxFit.cover, // Adjust how the image is fitted
                          ),
                        ),
                      ),

                      SizedBox(height: screenWidth * 0.004),
                      // Text section (Bottom half of the card)
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                                height: screenWidth *
                                    0.038), // Add some space between the text and button
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Action for the "Order Now" button
                                  print(
                                      "Order Now clicked for ${menu["title"]}");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(
                                      0xFFC02626), // Set the background color to #C02626
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        16), // Rounded corners
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 15), // Button padding
                                ),
                                child: Text(
                                  "Order Now",
                                  style: TextStyle(
                                    fontSize:
                                    screenWidth * 0.045, // Button text size
                                    fontWeight:
                                    FontWeight.bold, // Button text weight
                                    color: Colors.white, // Button text color
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}