import 'package:flutter/material.dart';
import 'dart:async';

import 'package:swappp/constants/global_variables.dart';

class OnboardingScreen extends StatefulWidget {
  final List<OnboardingPage> pages;
  final VoidCallback onSignUp;
  final VoidCallback onLogin;
  final VoidCallback onHowItWorks;

  const OnboardingScreen({
    Key? key,
    required this.pages,
    required this.onSignUp,
    required this.onLogin,
    required this.onHowItWorks,
  }) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class OnboardingPage {
  final AssetImage image;
  final String title;
  final String description;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;
  late AnimationController _progressController;
  static const int _storyDuration = 5; // Duration in seconds for each story

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _storyDuration),
    )..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _nextPage();
        }
      });
    _startStoryTimer();
  }

  void _startStoryTimer() {
    _progressController.forward(from: 0.0);
  }

  void _nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _progressController.forward(from: 0.0);
    } else {
      _currentPage = 0;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      _progressController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;
    final topPadding = mediaQuery.padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // PageView for images
          PageView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: widget.pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
                _progressController.forward(from: 0.0);
              });
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: widget.pages[index].image,
                    fit: BoxFit.cover,
                  ),
                  // Extended gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                          Colors.black,
                          Colors.black,
                        ],
                        stops: const [0.3, 0.5, 0.7, 0.85, 1.0],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          // Content layout
          Column(
            children: [
              // Top progress bar section
              SizedBox(height: topPadding + 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: List.generate(
                    widget.pages.length,
                    (index) => Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: index == _currentPage 
                              ? _progressController.value 
                              : index < _currentPage ? 1.0 : 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Expanded space for main content
              const Spacer(),
              // Bottom content section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and description
                    Text(
                      widget.pages[_currentPage].title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.pages[_currentPage].description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Buttons section
                    ElevatedButton(
                      onPressed: widget.onSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalVariables.secondaryColor,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Try WorthEveryPenny for Free',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: widget.onLogin,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: GlobalVariables.secondaryColor,
                        side: const BorderSide(color: GlobalVariables.secondaryColor, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'I already Have an Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // How it works button
                    Center(
                      child: TextButton(
                        onPressed: widget.onHowItWorks,
                        child: const Text(
                          'How Does It Work?',
                          style: TextStyle(
                            color: GlobalVariables.secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: bottomPadding + 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}