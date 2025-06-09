import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/written_practice_viewmodel.dart';

class WrittenPracticePage extends StatelessWidget {
  const WrittenPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WrittenPracticeViewModel()..loadQuestions(),
      child: const _WrittenPracticeBody(),
    );
  }
}

class _WrittenPracticeBody extends StatelessWidget {
  const _WrittenPracticeBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<WrittenPracticeViewModel>(context);

    if (vm.questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final q = vm.currentQuestion;
    final options = q['options'] ?? [];
    final answerIndex = (q['answer'] ?? 1) - 1;

    return Scaffold(
      backgroundColor: Colors.white, // ✅ 전체 배경 흰색
      appBar: AppBar(
        backgroundColor: Colors.white, // ✅ AppBar 배경 흰색
        elevation: 1,
        centerTitle: true, // ✅ 제목 가운데 정렬
        title: const Text(
          '연습 모드',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold, // ✅ 굵은 글씨
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.black),
            onPressed: () async {
              final msg = await vm.saveCurrentQuestion();
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(msg)));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                '${q['id']}.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(q['question'] ?? '', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 32),
              ...List.generate(options.length, (i) {
                final isSelected = vm.selectedOption == i;
                final isCorrect = answerIndex == i;

                Color? bgColor;
                Color borderColor = Colors.grey.shade400;
                Color textColor = Colors.black;

                if (vm.selectedOption != null) {
                  if (isCorrect) {
                    bgColor = Colors.green.shade100;
                    borderColor = Colors.green.shade400;
                    textColor = Colors.green.shade800;
                  } else if (isSelected && !isCorrect) {
                    bgColor = Colors.red.shade100;
                    borderColor = Colors.red.shade400;
                    textColor = Colors.red.shade800;
                  }
                }

                return GestureDetector(
                  onTap: () => vm.selectOption(i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(color: borderColor, width: 2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.transparent,
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            options[i] ?? '',
                            style: TextStyle(fontSize: 16, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              if (vm.selectedOption != null && q['explanation'] != null) ...[
                const SizedBox(height: 32),
                const Text(
                  '해설',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(q['explanation'], style: const TextStyle(fontSize: 14)),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: vm.goToPrevious,
              ),
              Text(
                '${vm.currentIndex + 1} / ${vm.questions.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: vm.goToNext,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
