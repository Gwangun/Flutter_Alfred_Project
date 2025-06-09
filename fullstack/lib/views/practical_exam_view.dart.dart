import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/practical_exam_viewmodel.dart';
import 'practical_practice_view.dart';
import 'saved_practical_view.dart';

class PracticalExamView extends StatelessWidget {
  const PracticalExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PracticalExamViewModel(),
      child: const _PracticalExamBody(),
    );
  }
}

class _PracticalExamBody extends StatelessWidget {
  const _PracticalExamBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PracticalExamViewModel>(context);

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
                Text(
                  vm.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    vm.subtitle,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 16,
            top: 178,
            child: Text(
              'Course',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            left: 15,
            top: 211,
            child: Column(
              children: [
                ModeTile(
                  title: '연습 모드',
                  icon: Icons.edit_note,
                  onTap:
                      () => vm.goToPage(context, const PracticalPracticeView()),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 74,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomNavItem(
                    label: 'Home',
                    icon: Icons.home,
                    onTap: () => vm.goToNamed(context, '/home'),
                  ),
                  BottomNavItem(
                    label: '저장된 문제',
                    icon: Icons.bookmark_border,
                    onTap:
                        () => vm.goToPage(context, const SavedPracticalView()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModeTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ModeTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                color: const Color(0xFFEDE7F6),
                borderRadius: BorderRadius.circular(13.27),
              ),
              child: Icon(icon, size: 36, color: const Color(0xFF491B6D)),
            ),
            const SizedBox(width: 36),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const BottomNavItem({
    super.key,
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected ? const Color(0xFF491B6D) : const Color(0xFF4B4B4B),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color:
                  selected ? const Color(0xFF491B6D) : const Color(0xFF4B4B4B),
            ),
          ),
        ],
      ),
    );
  }
}
