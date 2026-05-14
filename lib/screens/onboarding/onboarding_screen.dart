import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_sizes.dart';
import '../../services/prefs_service.dart';
import '../../widgets/app_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isCompleting = false;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Chào mừng đến với PKA Food',
      description:
          'Khám phá các món ăn quen thuộc và đặt nhanh ngay trong khuôn viên.',
      image: 'assets/images/onboarding/slide1.png',
      icon: Icons.restaurant_menu,
    ),
    OnboardingData(
      title: 'Giao hàng siêu tốc',
      description:
          'Theo dõi trạng thái đơn rõ ràng từ lúc chuẩn bị tới khi giao.',
      image: 'assets/images/onboarding/slide2.png',
      icon: Icons.delivery_dining,
    ),
    OnboardingData(
      title: 'Thanh toán dễ dàng',
      description:
          'Chọn phương thức thanh toán demo phù hợp trước khi đặt món.',
      image: 'assets/images/onboarding/slide3.png',
      icon: Icons.payments_outlined,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const Key('onboarding-skip-button'),
                  onPressed: _isCompleting ? null : _completeOnboarding,
                  child: const Text('Bỏ qua'),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  key: const Key('onboarding-page-view'),
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    return _OnboardingPage(data: _pages[index]);
                  },
                ),
              ),
              Row(
                children: List.generate(
                  _pages.length,
                  (index) => _buildIndicator(index),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              PrimaryButton(
                key: const Key('onboarding-primary-button'),
                label: _currentPage == _pages.length - 1
                    ? 'Bắt đầu'
                    : 'Tiếp tục',
                icon: _currentPage == _pages.length - 1
                    ? Icons.check
                    : Icons.arrow_forward,
                isLoading: _isCompleting,
                onPressed: _currentPage == _pages.length - 1
                    ? _completeOnboarding
                    : _goToNextPage,
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                '${_currentPage + 1}/${_pages.length}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goToNextPage() async {
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    if (_isCompleting) return;

    setState(() => _isCompleting = true);
    await context.read<PrefsService>().setOnboardingDone();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildIndicator(int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = _currentPage == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(right: AppSizes.sm),
      height: AppSizes.sm,
      width: isActive ? 28 : AppSizes.sm,
      decoration: BoxDecoration(
        color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final OnboardingData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 520;
        final imageHeight = compact ? 150.0 : 240.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxHeight: compact ? 220 : 320),
                  padding: const EdgeInsets.all(AppSizes.lg),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                  child: AppImage.asset(
                    data.image,
                    height: imageHeight,
                    fit: BoxFit.contain,
                    fallbackKind: AppImageFallbackKind.illustration,
                  ),
                ),
                SizedBox(height: compact ? AppSizes.lg : AppSizes.xl),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(data.icon, color: colorScheme.primary),
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSizes.sm),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Text(
                    data.description,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OnboardingData {
  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
    required this.icon,
  });

  final String title;
  final String description;
  final String image;
  final IconData icon;
}
