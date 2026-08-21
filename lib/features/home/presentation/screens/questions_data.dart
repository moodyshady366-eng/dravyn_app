// dravyn_app/lib/features/home/presentation/screens/onboarding/questions_data.dart

class OnboardingQuestion {
  final int id;
  final String section;
  final String question;
  final String type; // 'text', 'number', 'single_choice', 'multi_choice', 'slider'
  final List<String>? options;
  final String? unit;
  final Map<String, dynamic>? validation;

  const OnboardingQuestion({
    required this.id,
    required this.section,
    required this.question,
    required this.type,
    this.options,
    this.unit,
    this.validation,
  });
}

const List<OnboardingQuestion> onboardingQuestions = [
  // القسم 1: جسمك الحالي - 12 سؤال
  OnboardingQuestion(id: 1, section: 'جسمك الحالي', question: 'اسمك الأول؟', type: 'text'),
  OnboardingQuestion(id: 2, section: 'جسمك الحالي', question: 'سنك؟', type: 'number', unit: 'سنة', validation: {'min': 13, 'max': 70}),
  OnboardingQuestion(id: 3, section: 'جسمك الحالي', question: 'طولك؟', type: 'number', unit: 'سم', validation: {'min': 130, 'max': 220}),
  OnboardingQuestion(id: 4, section: 'جسمك الحالي', question: 'وزنك الحالي؟', type: 'number', unit: 'كجم', validation: {'min': 30, 'max': 200}),
  OnboardingQuestion(id: 5, section: 'جسمك الحالي', question: 'نوع جسمك؟', type: 'single_choice', options: ['نحيف جداً', 'نحيف', 'متوسط', 'ممتلىء', 'سمين']),
  OnboardingQuestion(id: 6, section: 'جسمك الحالي', question: 'شكل جسمك أقرب لإيه؟', type: 'single_choice', options: ['على شكل V', 'مستطيل', 'على شكل O', 'كمثرى']),
  OnboardingQuestion(id: 7, section: 'جسمك الحالي', question: 'محيط وسطك؟', type: 'number', unit: 'سم', validation: {'min': 50, 'max': 150}),
  OnboardingQuestion(id: 8, section: 'جسمك الحالي', question: 'محيط الصدر؟', type: 'number', unit: 'سم', validation: {'min': 60, 'max': 160}),
  OnboardingQuestion(id: 9, section: 'جسمك الحالي', question: 'محيط الذراع؟', type: 'number', unit: 'سم', validation: {'min': 15, 'max': 60}),
  OnboardingQuestion(id: 10, section: 'جسمك الحالي', question: 'محيط الفخذ؟', type: 'number', unit: 'سم', validation: {'min': 30, 'max': 90}),
  OnboardingQuestion(id: 11, section: 'جسمك الحالي', question: 'مستواك في التمرين؟', type: 'single_choice', options: ['أول مرة', 'مبتدىء أقل من 6 شهور', 'متوسط 6 شهور لسنتين', 'متقدم +سنتين', 'وحش كاليثتنكس']),
  OnboardingQuestion(id: 12, section: 'جسمك الحالي', question: 'بتقدر تعمل كام ضغط صحيح؟', type: 'single_choice', options: ['ولا عدة', '1-5', '6-15', '16-30', '30+']),

  // القسم 2: هدفك وشكل حلمك - 10 أسئلة
  OnboardingQuestion(id: 13, section: 'هدفك', question: 'هدفك الأساسي؟', type: 'single_choice', options: ['أخس وأنشف', 'أزيد عضل صافي', 'أزيد وزن وقوة', 'لياقة ومرونة بس', 'أتعلم حركات كاليثتنكس']),
  OnboardingQuestion(id: 14, section: 'هدفك', question: 'عايز توصل لوزن كام؟', type: 'number', unit: 'كجم', validation: {'min': 30, 'max': 200}),
  OnboardingQuestion(id: 15, section: 'هدفك', question: 'أهم عضلة عايز تركز عليها؟', type: 'multi_choice', options: ['صدر', 'ضهر', 'كتف', 'دراع', 'بطن', 'رجل', 'الجسم كله']),
  OnboardingQuestion(id: 16, section: 'هدفك', question: 'نفسك تتعلم حركة ايه؟', type: 'multi_choice', options: ['عقلة', 'متوازي', 'Handstand', 'Muscle Up', 'Front Lever', 'Planche', 'مش مهتم بالحركات']),
  OnboardingQuestion(id: 17, section: 'هدفك', question: 'عايز توصل لهدفك في قد ايه؟', type: 'single_choice', options: ['شهر', '3 شهور', '6 شهور', 'سنة', 'براحتي']),
  OnboardingQuestion(id: 18, section: 'هدفك', question: 'ايه أهم سبب مخليك عايز تتغير؟', type: 'single_choice', options: ['شكلي في المراية', 'صحتي', 'ثقتي في نفسي', 'اللبس', 'عشان حد معين', 'تحدي شخصي']),
  OnboardingQuestion(id: 19, section: 'هدفك', question: 'مستعد تلتزم بنسبة كام؟', type: 'slider', validation: {'min': 50, 'max': 100}),
  OnboardingQuestion(id: 20, section: 'هدفك', question: 'توصف فورمتك الحلم بكلمة؟', type: 'single_choice', options: ['مشرح', 'ضخم', 'رياضي', 'متناسق', 'وحش']),
  OnboardingQuestion(id: 21, section: 'هدفك', question: 'أول حاجة هتعملها لما توصل لهدفك؟', type: 'text'),
  OnboardingQuestion(id: 22, section: 'هدفك', question: 'مستوى الصعوبة اللي تفضله؟', type: 'single_choice', options: ['سهل وعلى الهادي', 'متوسط يحرق', 'صعب فشخ', 'انتحاري طلع الوحش']),

  // القسم 3: حياتك وظروفك - 14 سؤال
  OnboardingQuestion(id: 23, section: 'ظروفك', question: 'هتتمرن فين؟', type: 'single_choice', options: ['في البيت', 'في الجيم', 'في الشارع/حديقة', 'خليط']),
  OnboardingQuestion(id: 24, section: 'ظروفك', question: 'ايه الأدوات المتاحة؟', type: 'multi_choice', options: ['ولا حاجة وزن جسم بس', 'عقلة', 'متوازي', 'حبل مقاومة', 'دامبلز', 'بار', 'جيم كامل']),
  OnboardingQuestion(id: 25, section: 'ظروفك', question: 'كام يوم تقدر تتمرن في الأسبوع؟', type: 'single_choice', options: ['2', '3', '4', '5', '6', 'كل يوم']),
  OnboardingQuestion(id: 26, section: 'ظروفك', question: 'مدة التمرين المتاحة؟', type: 'single_choice', options: ['10-20 دقيقة', '20-30 دقيقة', '30-45 دقيقة', '45-60 دقيقة', 'ساعة+', 'معايا وقت مفتوح']),
  OnboardingQuestion(id: 27, section: 'ظروفك', question: 'امتى بتحب تتمرن؟', type: 'single_choice', options: ['الفجر', 'الصبح', 'الضهر', 'العصر', 'بليل', 'نص الليل', 'أي وقت']),
  OnboardingQuestion(id: 28, section: 'ظروفك', question: 'طبيعة شغلك/دراستك؟', type: 'single_choice', options: ['مكتبي قاعد طول اليوم', 'واقف على رجلي', 'فيه حركة كتير', 'شغل بدني تقيل', 'لسه بدرس', 'لا أعمل']),
  OnboardingQuestion(id: 29, section: 'ظروفك', question: 'بتنام كام ساعة؟', type: 'single_choice', options: ['أقل من 5', '5-6', '6-7', '7-8', '8+']),
  OnboardingQuestion(id: 30, section: 'ظروفك', question: 'جودة نومك؟', type: 'single_choice', options: ['زفت بصحى تعبان', 'بقلق كتير', 'متوسط', 'كويسة', 'بنوم زي القتيل']),
  OnboardingQuestion(id: 31, section: 'ظروفك', question: 'مستوى التوتر في حياتك؟', type: 'slider', validation: {'min': 0, 'max': 10}),
  OnboardingQuestion(id: 32, section: 'ظروفك', question: 'بتشرب مياه قد ايه؟', type: 'single_choice', options: ['مبنسهاش', 'لتر', '2 لتر', '3 لتر', '4 لتر+']),
  OnboardingQuestion(id: 33, section: 'ظروفك', question: 'بتشرب قهوة/شاي؟', type: 'single_choice', options: ['لا', 'فنجان في اليوم', '2-3', 'عايش عليهم']),
  OnboardingQuestion(id: 34, section: 'ظروفك', question: 'بتدخن؟', type: 'single_choice', options: ['لا الحمدلله', 'شيشة بس', 'فيب', 'سجاير خفيف', 'سجاير كتير']),
  OnboardingQuestion(id: 35, section: 'ظروفك', question: 'ميزانيتك للأكل في الأسبوع؟', type: 'single_choice', options: ['200ج', '350ج', '500ج', '800ج', '1000ج+', 'مفتوحة']),
  OnboardingQuestion(id: 36, section: 'ظروفك', question: 'مين بيطبخلك؟', type: 'single_choice', options: ['أنا', 'أمي/مراتي', 'باكل من بره', 'خليط']),

  // القسم 4: أكلك ومزاجك - 12 سؤال
  OnboardingQuestion(id: 37, section: 'أكلك', question: 'كام وجبة في اليوم؟', type: 'single_choice', options: ['وجبة واحدة', '2', '3', '4', '5', '6+', 'باكل طول اليوم']),
  OnboardingQuestion(id: 38, section: 'أكلك', question: 'نظام أكلك الحالي؟', type: 'single_choice', options: ['بعك الدنيا', 'بحاول بس بلغبط', 'متوسط', 'ملتزم 80%', 'ماشي بالمسطرة']),
  OnboardingQuestion(id: 39, section: 'أكلك', question: 'فطارك المفضل؟', type: 'multi_choice', options: ['فول وطعمية', 'بيض', 'جبنة', 'شوفان', 'بان كيك', 'مبفطرش']),
  OnboardingQuestion(id: 40, section: 'أكلك', question: 'بتحب اللحوم؟', type: 'multi_choice', options: ['فراخ', 'لحمة', 'سمك', 'تونة', 'كبدة', 'نباتي']),
  OnboardingQuestion(id: 41, section: 'أكلك', question: 'الكارب المفضل؟', type: 'multi_choice', options: ['رز', 'مكرونة', 'عيش', 'بطاطس', 'بطاطا', 'شوفان']),
  OnboardingQuestion(id: 42, section: 'أكلك', question: 'بتحب الفاكهة؟', type: 'multi_choice', options: ['موز', 'تفاح', 'برتقال', 'بطيخ', 'مانجا', 'بلح', 'مبحبهاش']),
  OnboardingQuestion(id: 43, section: 'أكلك', question: 'اكتر حاجة متقدرش تستغنى عنها؟', type: 'single_choice', options: ['السكر', 'البيبسي', 'الشيبسي', 'الشوكولاتة', 'العيش', 'ولا حاجة سهل']),
  OnboardingQuestion(id: 44, section: 'أكلك', question: 'الأكل اللي بتكرهه؟', type: 'multi_choice', options: ['الكوسة', 'البامية', 'الكبدة', 'السمك', 'التونة', 'الشوفان', 'باكل أي حاجة']),
  OnboardingQuestion(id: 45, section: 'أكلك', question: 'عندك حساسية من أكل؟', type: 'multi_choice', options: ['لا', 'لاكتوز', 'جلوتين', 'مكسرات', 'بيض', 'سمك']),
  OnboardingQuestion(id: 46, section: 'أكلك', question: 'نفسك في حلويات قد ايه؟', type: 'single_choice', options: ['مدمن', 'بحبها اوي', 'متوسط', 'قليل', 'مليش فيها']),
  OnboardingQuestion(id: 47, section: 'أكلك', question: 'بتاكل بره كام مرة؟', type: 'single_choice', options: ['كل يوم', '4-5 مرات', '2-3 مرات', 'مرة', 'نادراً']),
  OnboardingQuestion(id: 48, section: 'أكلك', question: 'بتاخد مكملات؟', type: 'multi_choice', options: ['لا', 'واي بروتين', 'كرياتين', 'مالتي فيتامين', 'أوميجا 3', 'مش عارف ايه دي']),

  // القسم 5: نفسيتك ودينك - 10 أسئلة
  OnboardingQuestion(id: 49, section: 'نفسيتك', question: 'ايه اللي بيخليك تكسل؟', type: 'multi_choice', options: ['الملل', 'التعب', 'مفيش وقت', 'مفيش نتيجة سريعة', 'مفيش حد يشجعني', 'الجوع']),
  OnboardingQuestion(id: 50, section: 'نفسيتك', question: 'بتحب تتمرن لوحدك ولا مع حد؟', type: 'single_choice', options: ['لوحدي', 'مع صاحب', 'في جروب', 'مع مدرب', 'مش فارقة']),
  OnboardingQuestion(id: 51, section: 'نفسيتك', question: 'بتسمع ايه وانت بتتمرن؟', type: 'single_choice', options: ['مهرجانات', 'راب', 'روك', 'قرآن', 'بودكاست', 'ولا حاجة']),
  OnboardingQuestion(id: 52, section: 'نفسيتك', question: 'لما تغلط في الدايت بتعمل ايه؟', type: 'single_choice', options: ['بجلد ذاتي وأوقف', 'بكمل عك', 'بتضايق شوية واكمل', 'ولا كأني عملت حاجة', 'بعوض في التمرين']),
  OnboardingQuestion(id: 53, section: 'نفسيتك', question: 'ايه اكتر حاجة تحفزك؟', type: 'single_choice', options: ['صور قبل وبعد', 'كلام تشجيع', 'أرقام ونتائج', 'فلوس/رهان', 'المنافسة', 'اني ابقى قدوة']),
  OnboardingQuestion(id: 54, section: 'نفسيتك', question: 'بتحب التطبيق يكلمك ازاي؟', type: 'single_choice', options: ['صاحبك بيزعقلك', 'مدرب عسكري', 'أخ كبير حنين', 'رسمي', 'ساخر وبيتريق']),
  OnboardingQuestion(id: 55, section: 'نفسيتك', question: 'بتصلي؟', type: 'single_choice', options: ['الحمدلله منتظم', 'بقطع', 'الجمعة بس', 'نفسي انتظم', 'لا']),
  OnboardingQuestion(id: 56, section: 'نفسيتك', question: 'عايز التطبيق يفكرك بالصلاة؟', type: 'single_choice', options: ['اه ياريت', 'لا شكراً', 'بصوت الأذان']),
  OnboardingQuestion(id: 57, section: 'نفسيتك', question: 'بتقرأ قرآن؟', type: 'single_choice', options: ['ورد يومي', 'كل جمعة', 'في رمضان بس', 'نفسي بس بكسل', 'لا']),
  OnboardingQuestion(id: 58, section: 'نفسيتك', question: 'عايز نبدأ التحدي امتى؟', type: 'single_choice', options: ['حالاً', 'بكره الصبح', 'السبت', 'أول الشهر', 'لما أفضى']),
];
