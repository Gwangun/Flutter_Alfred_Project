import 'package:flutter/material.dart';
import '../viewmodels/written_exam_viewmodel.dart';
import '../widgets/text_styles.dart';

class WrittenExamPage extends StatelessWidget {
  const WrittenExamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = WrittenExamViewModel();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 16,
            top: 50.34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('필기 문제 풀기', style: AppTextStyles.greeting),
                const SizedBox(height: 8),
                Opacity(
                  opacity: 0.5,
                  child: const Text(
                    'What do you want to learn?',
                    style: AppTextStyles.subtitle,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            top: 178,
            child: const Text('Course', style: AppTextStyles.courseTitle),
          ),
          Positioned(
            top: 211,
            left: 0,
            right: 0,
            child: _modeTile(
              context,
              title: '연습 모드',
              icon: Icons.edit_note,
              onTap: () => vm.navigateToPractice(context),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 74,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: _bottomNavItem(
                      context,
                      label: 'Home',
                      icon: Icons.home,
                      onTap: () => vm.navigateToHome(context),
                    ),
                  ),
                  Expanded(
                    child: _bottomNavItem(
                      context,
                      label: '저장된 문제',
                      icon: Icons.bookmark_border,
                      onTap: () => vm.navigateToSaved(context),
                    ),
                  ),
                  Expanded(
                    child: _bottomNavItem(
                      context,
                      label: '오답 노트',
                      icon: Icons.note_alt_outlined,
                      onTap: () => vm.navigateToWrong(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: screenWidth - 32,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF1F1F1)),
            borderRadius: BorderRadius.circular(17.69),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 68.57,
                height: 68.57,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(13.27),
                ),
                child: Icon(icon, size: 36, color: const Color(0xFF491B6D)),
              ),
              const SizedBox(width: 36),
              Expanded(child: Text(title, style: AppTextStyles.courseItem)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF4B4B4B), size: 24),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.navUnselected),
        ],
      ),
    );
  }
}
