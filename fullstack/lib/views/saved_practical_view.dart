import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/saved_practical_viewmodel.dart';

class SavedPracticalView extends StatelessWidget {
  const SavedPracticalView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SavedPracticalViewModel()..loadSavedQuestions(),
      child: const _SavedPracticalBody(),
    );
  }
}

class _SavedPracticalBody extends StatelessWidget {
  const _SavedPracticalBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SavedPracticalViewModel>(context);

    if (vm.questions.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('저장된 문제가 없습니다.')),
      );
    }

    final q = vm.currentQuestion;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '저장된 문제',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.black),
            onPressed: () async {
              final deleted = await vm.deleteCurrentQuestion();
              if (context.mounted && deleted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('문제가 삭제되었습니다.')));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                '${q['id']}. ${q['question'] ?? ''}',
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
                  q['code'] ?? '',
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => vm.goToPrevious(),
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
                onPressed: () => vm.goToNext(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
