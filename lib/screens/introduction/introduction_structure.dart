import 'package:cafesmart/screens/introduction/pages/expense_page.dart';
import 'package:cafesmart/screens/introduction/pages/food_page.dart';
import 'package:cafesmart/screens/introduction/pages/recommend_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionStructure extends StatefulWidget {
  const IntroductionStructure({super.key});

  @override
  State<IntroductionStructure> createState() => _IntroductionStructureState();
}

class _IntroductionStructureState extends State<IntroductionStructure> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_controller.page! < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipIntro() {
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              FoodPage(),
              RecommendPage(),
              ExpensePage(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _skipIntro,
                  child: const Text("Skip", style: TextStyle(fontSize: 14)),
                ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 6,
                    dotWidth: 6,
                    activeDotColor: Colors.blue,
                  ),
                ),
                onLastPage
                    ? TextButton(
                        onPressed: () => context.go('/signup'),
                        child: const Text("Done", style: TextStyle(fontSize: 14)),
                      )
                    : TextButton(
                        onPressed: _nextPage, // Move to the next page
                        child: const Text("Next", style: TextStyle(fontSize: 14),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
