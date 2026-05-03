// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/prefs_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Chào mừng đến với PKA Food',
      description: 'Khám phá hàng ngàn món ăn ngon từ các nhà hàng xung quanh bạn.',
      image: 'assets/images/onboarding/slide1.png',
    ),
    OnboardingData(
      title: 'Giao hàng siêu tốc',
      description: 'Chúng tôi đảm bảo đồ ăn luôn nóng hổi khi đến tay bạn.',
      image: 'assets/images/onboarding/slide2.png',
    ),
    OnboardingData(
      title: 'Thanh toán dễ dàng',
      description: 'Nhiều hình thức thanh toán tiện lợi và an toàn.',
      image: 'assets/images/onboarding/slide3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(_pages.length, (index) => _buildIndicator(index)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_currentPage == _pages.length - 1) {
                      await PrefsService().setOnboardingDone();
                      if (mounted) Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'BẮT ĐẦU' : 'TIẾP TỤC',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () async {
                await PrefsService().setOnboardingDone();
                if (mounted) Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Bỏ qua', style: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primary : Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data.image,
            height: 300,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.fastfood,
              size: 200,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 50),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({required this.title, required this.description, required this.image});
}
