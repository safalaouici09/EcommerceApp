import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:proximity/proximity.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return OnBoardingItem(
                      image: onboardingData[index].imagePath,
                      title: onboardingData[index].title,
                      description: onboardingData[index].description);
                }),
          ),
          SizedBox(
            height: 60,
            width: 60,
            child: ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              },
              style: ElevatedButton.styleFrom(shape: const CircleBorder()),
              child: Center(child: const Icon(ProximityIcons.arrow_more)),
            ),
          )
        ],
      )),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

List<OnboardingContent> onboardingData = [
  OnboardingContent(
    title: "Create and Manage Stores",
    description:
        "Easily create and manage your own stores within the app. Showcase your products and attract customers.",
    imagePath: "assets/store_creation.png",
  ),
  /*OnboardingContent(
    title: "Effortless Product Management",
    description:
        "Add, edit, and organize your products with ease. Provide detailed descriptions and pricing information.",
    imagePath: "assets/images/product.png",
  ),*/
  OnboardingContent(
    title: "Promote Your Products",
    description:
        "Create promotions and discounts to attract more customers. Set promotional prices and limited-time offers.",
    imagePath: "assets/promote.png",
  ),
  OnboardingContent(
    title: "Streamlined Order Management",
    description:
        "Efficiently manage incoming orders, track shipments, and communicate with customers. Provide excellent service.",
    imagePath: "assets/orders.png",
  ),
  OnboardingContent(
    title: "Policy Management",
    description:
        "Set your store policies, such as shipping, returns, and terms of service. Customize policies to fit your needs.",
    imagePath: "assets/policy.png",
  ),
];

class OnBoardingItem extends StatelessWidget {
  OnBoardingItem(
      {Key? key,
      required this.image,
      required this.title,
      required this.description})
      : super(key: key);
  String image;
  String title;
  String description;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Spacer(),
      Image.asset(
        image,
        height: 250,
      ),
      const Spacer(),
      Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
              fontSize: normal_200,
              fontWeight: FontWeight.w600,
            ),
      ),
      const SizedBox(
        height: normal_100,
      ),
      Text(
        description,
        textAlign: TextAlign.center,
      ),
      const Spacer()
    ]);
  }
}
