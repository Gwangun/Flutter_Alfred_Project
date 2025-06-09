import 'package:flutter/material.dart';
import '../widgets/text_styles.dart';
import '../views/written_exam_view.dart';
import '../views/practical_exam_view.dart.dart';
import '../viewmodels/home_viewmodel.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = HomeViewModel();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('정보처리기사', style: AppTextStyles.greeting),
                const SizedBox(height: 8),
                Opacity(
                  opacity: 0.5,
                  child: const Text(
                    'What do you want to learn?',
                    style: AppTextStyles.subtitle,
                  ),
                ),
                const SizedBox(height: 75),
                const Text('Course', style: AppTextStyles.courseTitle),
                const SizedBox(height: 1),
                _courseTile(
                  context,
                  '필기시험',
                  'assets/images/written.png',
                  const WrittenExamPage(),
                ),
                const SizedBox(height: 16),
                _courseTile(
                  context,
                  '실기시험',
                  'assets/images/practical.png',
                  const PracticalExamView(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 74,
        color: Colors.white,
        child: Row(
          children: [
            _navItem(context, label: 'Home', icon: Icons.home, selected: true),
            _navItem(
              context,
              label: '저장된 문제',
              icon: Icons.bookmark_border,
              onTap: () => vm.showSavedQuestionDialog(context),
            ),
            _navItem(
              context,
              label: '오답 노트',
              icon: Icons.note_alt_outlined,
              onTap: () => vm.goToWrongNote(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _courseTile(
    BuildContext context,
    String title,
    String assetPath,
    Widget destinationPage,
  ) {
    return InkWell(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destinationPage),
          ),
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFF1F1F1), width: 1),
          borderRadius: BorderRadius.circular(17.69),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 68.57,
              height: 68.57,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.27),
                image: DecorationImage(
                  image: AssetImage(assetPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 36),
            Expanded(child: Text(title, style: AppTextStyles.courseItem)),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    bool selected = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color:
                  selected ? const Color(0xFF491B6D) : const Color(0xFF4B4B4B),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style:
                  selected
                      ? AppTextStyles.navSelected
                      : AppTextStyles.navUnselected,
            ),
          ],
        ),
      ),
    );
  }
}
