import 'package:flutter/material.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentIndex = 0;
  final TextEditingController answerController = TextEditingController();
  final List<String> answers = [];

  final List<String> questions = [
    'ايه هدفك الأساسي؟',
    'عندك كام سنة؟',
    'وزنك الحالي كام؟',
    'طولك كام؟',
    'بتتمرن كام مرة في الأسبوع؟',
  ];

  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void nextQuestion() {
    answers.add(answerController.text);
    answerController.clear();
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.pushNamed(context, '/subscription');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        title: Text(
          'سؤال ${currentIndex + 1} من ${questions.length}',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              color: Colors.greenAccent,
              backgroundColor: Colors.white12,
            ),
            const SizedBox(height: 40),
            Text(
              questions[currentIndex],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: answerController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'اكتب اجابتك هنا...',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentIndex == questions.length - 1
                    ? 'خلصت، شوف اشتراكاتي'
                    : 'التالي',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
