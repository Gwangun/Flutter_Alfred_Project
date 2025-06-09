import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/wrong_note_viewmodel.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class WrongNotePage extends StatelessWidget {
  const WrongNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WrongNoteViewModel()..loadWrongQuestions(),
      child: const _WrongNoteBody(),
    );
  }
}

class _WrongNoteBody extends StatefulWidget {
  const _WrongNoteBody();

  @override
  State<_WrongNoteBody> createState() => _WrongNoteBodyState();
}

class _WrongNoteBodyState extends State<_WrongNoteBody> with RouteAware {
  late WrongNoteViewModel vm;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // 다른 화면에서 돌아왔을 때 실행
  }

  @override
  void didPop() {
    vm.deleteAllMarked();
  }

  @override
  Widget build(BuildContext context) {
    vm = Provider.of<WrongNoteViewModel>(context);

    if (vm.wrongQuestions.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('오답 문제가 없습니다.')),
      );
    }

    final current = vm.currentQuestion;
    final options = [
      current['choice1'],
      current['choice2'],
      current['choice3'],
      current['choice4'],
    ];
    final answerIndex = (current['answer'] ?? 1) - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () async {
            await vm.deleteAllMarked();
            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          '오답 노트',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                '${current['id']}.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                current['question'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ...List.generate(options.length, (i) {
                final isSelected = vm.selectedOption == i;
                final isCorrect = i == answerIndex;

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
              if (vm.selectedOption != null && current['explanation'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
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
                        current['explanation'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
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
                '${vm.currentIndex + 1} / ${vm.wrongQuestions.length}',
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
