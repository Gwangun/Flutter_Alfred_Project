import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/written_save_viewmodel.dart';

class WrittenSavePage extends StatelessWidget {
  const WrittenSavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WrittenSaveViewModel()..loadSavedQuestions(),
      child: Consumer<WrittenSaveViewModel>(
        builder: (context, vm, _) {
          final questions = vm.savedQuestions;
          final current =
              questions.isNotEmpty ? questions[vm.currentIndex] : null;
          if (current == null) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: Text('저장된 문제가 없습니다.')),
            );
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 1,
              centerTitle: true,
              title: const Text(
                '저장된 문제',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmark, color: Colors.black),
                  onPressed: () async {
                    final success = await vm.deleteCurrentQuestion();
                    if (context.mounted && success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('문제가 삭제되었습니다.')),
                      );
                    }
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${current['id']}.',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    current['question'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(4, (i) {
                    final text = current['choice${i + 1}'] ?? '';
                    final answer = current['answer'] - 1;
                    final selected = vm.selectedOption == i;
                    final isCorrect = i == answer;
                    final isWrong = selected && !isCorrect;

                    Color? bgColor;
                    Color border = Colors.grey;
                    Color textColor = Colors.black;

                    if (vm.selectedOption != null) {
                      if (isCorrect) {
                        bgColor = Colors.green.shade100;
                        border = Colors.green;
                        textColor = Colors.green.shade800;
                      } else if (isWrong) {
                        bgColor = Colors.red.shade100;
                        border = Colors.red;
                        textColor = Colors.red.shade800;
                      }
                    }

                    return GestureDetector(
                      onTap: () => vm.selectOption(i),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.transparent,
                              child: Text(
                                '${i + 1}',
                                style: TextStyle(color: textColor),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                text,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  if (vm.selectedOption != null &&
                      (current['explanation'] ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '해설',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            current['explanation'] ?? '',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: vm.previousQuestion,
                    ),
                    Text(
                      '${vm.currentIndex + 1} / ${questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: vm.nextQuestion,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
