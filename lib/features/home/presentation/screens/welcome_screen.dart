import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // الاسم
              const Text(
                'DRAVY',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 22,
                  letterSpacing: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // الترحيب - من غير وعود كدابة
              const Text(
                'اهلا، انا درافي.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'انا هنا عشان اساعدك تنظم يومك،\nلو انت قررت تلتزم.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'هل مستعد تبدأ؟',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // الزرار - بيودي للأسئلة مش للاشتراك
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // الصح: يروح لأول سؤال
                    Navigator.pushNamed(context, '/questions');
                    // ممنوع: Navigator.pushNamed(context, '/subscription');
                  },
                  child: const Text(
                    'ايوه، مستعد',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'هنبدأ بـ 58 سؤال، وبعدها نعمل خطتك على مقاسك',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
