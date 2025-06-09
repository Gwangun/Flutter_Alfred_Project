import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/practical_practice_viewmodel.dart';

class PracticalPracticeView extends StatelessWidget {
  const PracticalPracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PracticalPracticeViewModel()..loadQuestions(),
      child: const _PracticeBody(),
    );
  }
}

class _PracticeBody extends StatelessWidget {
  const _PracticeBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PracticalPracticeViewModel>(context);

    if (vm.questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = vm.currentQuestion;
    final int questionId = question['id'];
    final String questionText = question['question'];
    final String codeText = question['code'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '연습 모드',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () async {
              final msg = await vm.saveQuestion();
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(msg)));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$questionId. $questionText',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.black,
                child: Text(
                  codeText,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => vm.loadAnswer(),
                  child: const Text('정답 확인'),
                ),
              ),
              if (vm.showAnswer) ...[
                const SizedBox(height: 24),
                Text(
                  '정답: ${vm.answer}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('해설', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  vm.explanation ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: vm.hasPrevious ? vm.previousQuestion : null,
              ),
              Text(
                '${vm.currentIndex + 1} / ${vm.questions.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: vm.hasNext ? vm.nextQuestion : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
