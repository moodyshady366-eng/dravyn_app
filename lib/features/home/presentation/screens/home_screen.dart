import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DayData {
  int water=0, cal=0, prot=0, study=0, salawat=0, prayers=0, quran=0, mood=3, challenge=0, fajr=0, qiyam=0, istighfar=0, tasbeeh=0, moneySaved=0, pagesRead=0, screenHours=0, focus=0, coffee=0, medicine=0, energy=3, headache=0;
  double weight=0, sleep=0;
  bool azkar=false, thanked=false, calledFamily=false;
  List<String> meals=[], workouts=[], tasks=[], done=[], ideas=[], duas=[], fasting=[], surahs=[], hadiths=[], helpOthers=[], mistakes=[], courses=[], skills=[], videos=[], podcasts=[], grades=[], subjects=[], wordsEn=[], cleaning=[], noSocial=[], niceWords=[], learnedFrom=[], booksRead=[];
  int get score => water*5 + study~/10 + done.length*15 + prayers*10 + workouts.length*20 + salawat~/10 + quran*5 + challenge*5;
  int get totalTasks => tasks.length + done.length;
  String c(String s) => s.replaceAll('|',' ').replaceAll(';',' ').trim();
  String encode(){
    var n=[water,cal,prot,study,salawat,prayers,quran,mood,challenge,fajr,qiyam,istighfar,tasbeeh,moneySaved,pagesRead,screenHours,focus,coffee,medicine,energy,headache].map((e)=>e.toString()).toList();
    n.add(weight.toString()); n.add(sleep.toString()); n.add(azkar?'1':'0'); n.add(thanked?'1':'0'); n.add(calledFamily?'1':'0');
    var lists=[meals,workouts,tasks,done,ideas,duas,fasting,surahs,hadiths,helpOthers,mistakes,courses,skills,videos,podcasts,grades,subjects,wordsEn,cleaning,noSocial,niceWords,learnedFrom,booksRead];
    return n.join(',')+'||'+lists.map((l)=>l.map(c).join(';')).join('||');
  }
  static DayData decode(String s){
    var d=DayData();
    try{
      var p=s.split('||');
      var n=p[0].split(',').map((e)=>double.tryParse(e)??0).toList();
      if(n.length>=26){
        d.water=n[0].toInt(); d.cal=n[1].toInt(); d.prot=n[2].toInt(); d.study=n[3].toInt(); d.salawat=n[4].toInt(); d.prayers=n[5].toInt(); d.quran=n[6].toInt(); d.mood=n[7].toInt(); d.challenge=n[8].toInt(); d.fajr=n[9].toInt(); d.qiyam=n[10].toInt(); d.istighfar=n[11].toInt(); d.tasbeeh=n[12].toInt(); d.moneySaved=n[13].toInt(); d.pagesRead=n[14].toInt(); d.screenHours=n[15].toInt(); d.focus=n[16].toInt(); d.coffee=n[17].toInt(); d.medicine=n[18].toInt(); d.energy=n[19].toInt(); d.headache=n[20].toInt(); d.weight=n[21]; d.sleep=n[22]; d.azkar=n[23]==1; d.thanked=n[24]==1; d.calledFamily=n[25]==1;
      }
      List<String> g(int i)=> (p.length>i && p[i].isNotEmpty) ? p[i].split(';') : [];
      d.meals=g(1); d.workouts=g(2); d.tasks=g(3); d.done=g(4); d.ideas=g(5); d.duas=g(6); d.fasting=g(7); d.surahs=g(8); d.hadiths=g(9); d.helpOthers=g(10); d.mistakes=g(11); d.courses=g(12); d.skills=g(13); d.videos=g(14); d.podcasts=g(15); d.grades=g(16); d.subjects=g(17); d.wordsEn=g(18); d.cleaning=g(19); d.noSocial=g(20); d.niceWords=g(21); d.learnedFrom=g(22); d.booksRead=g(23);
    }catch(_){}
    return d;
  }
}

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override State<HomeScreen> createState()=>_HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  DayData today=DayData();
  Map<String,DayData> history={};
  bool isMuslim=true;
  String userName='بطل';
  String userGoal='ابقى احسن';
  String assistantName='Dravyn';
  final ctrl=TextEditingController();
  final taskCtrl=TextEditingController();
  String get k=>DateTime.now().toIso8601String().substring(0,10);
  String lastAction='مستني فعل...';

  @override void initState(){ super.initState(); _load(); }

  Future<void> _save() async{
    final p=await SharedPreferences.getInstance();
    history[k]=today;
    if(history.length>1095){ var ks=history.keys.toList()..sort(); history.remove(ks.first); }
    for(var e in history.entries){ await p.setString('day_${e.key}', e.value.encode()); }
    await p.setBool('muslim', isMuslim);
    await p.setString('userName', userName);
    await p.setString('userGoal', userGoal);
    await p.setString('assistantName', assistantName);
  }
  Future<void> _load() async{
    final p=await SharedPreferences.getInstance();
    isMuslim=p.getBool('muslim')??true;
    userName=p.getString('userName')??'بطل';
    userGoal=p.getString('userGoal')??'ابقى احسن';
    assistantName=p.getString('assistantName')??'Dravyn';
    for(var key in p.getKeys()){
      if(key.startsWith('day_')) history[key.replaceFirst('day_','')]=DayData.decode(p.getString(key)??'');
    }
    today=history[k]??DayData();
    if(mounted) setState((){});
  }

  void _do(void Function() fn, String label){
    setState((){ fn(); lastAction=label; });
    _save();
  }
  int _num(String t,[int d=10]){
    var m=RegExp(r'\d+').firstMatch(t);
    return m!=null ? (int.tryParse(m.group(0)!)??d) : d;
  }
  bool _has(String t, List<String> w){
    for(var x in w){ if(t.contains(x)) return true; }
    return false;
  }
  String _extract(String raw, String marker){
    var i=raw.indexOf(marker);
    if(i==-1) return '';
    var v=raw.substring(i+marker.length).trim();
    if(v.startsWith('ل') || v.startsWith('لـ')) v=v.substring(1).trim();
    if(v.startsWith(':') || v.startsWith('=')) v=v.substring(1).trim();
    return v;
  }

  void _handle(String input){
    final t=input.toLowerCase().trim();
    final raw=input.trim();
    if(t.isEmpty) return;

    // ==== اعدادات - المساعد بيغيرها بنفسه ====
    if(t.contains('غير اسمي')){
      var v=_extract(raw,'غير اسمي');
      if(v.isNotEmpty) return _do((){ userName=v; }, 'اسمك: $v');
    }
    if(t.contains('ناديني')){
      var v=_extract(raw,'ناديني');
      if(v.isNotEmpty) return _do((){ userName=v; }, 'اسمك: $v');
    }
    if(t.contains('غير اسمك')){
      var v=_extract(raw,'غير اسمك');
      if(v.isNotEmpty) return _do((){ assistantName=v; }, 'اسمي: $v');
    }
    if(t.contains('غير هدفي') || t.contains('هدفي')){
      var v=_extract(raw,'هدفي');
      if(v.isNotEmpty) return _do((){ userGoal=v; }, 'هدفك: $v');
    }
    if(t.contains('مش مسلم')){
      return _do((){ isMuslim=false; }, 'مسلم: لا');
    }
    if(t.contains('انا مسلم')){
      return _do((){ isMuslim=true; }, 'مسلم: ايوه');
    }
    if(t.contains('اعداداتي')){
      return _do((){}, '$userName | $userGoal | ${isMuslim?'مسلم':'مش مسلم'} | $assistantName');
    }
    if(t.contains('امسح كل حاجة')){
      return _do((){ today=DayData(); history.clear(); }, 'اتمسح كله');
    }

    // ==== افعال - كل سطر فعل واحد ====
    if(_has(t,['مية','ماء','شربت','كوب'])) return _do((){ today.water++; }, 'مية: ${today.water+1}/8');
    if(_has(t,['النبي'])) return _do((){ today.salawat+=_num(t,10); }, 'صلاة على النبي: ${today.salawat+_num(t,10)}');
    if(t.contains('فجر')) return _do((){ today.fajr++; today.prayers++; }, 'فجر: ${today.fajr+1} | صلاة: ${today.prayers+1}');
    if(_has(t,['صليت','صلاة','ظهر','عصر','مغرب','عشاء'])) return _do((){ today.prayers++; }, 'صلاة: ${today.prayers+1}');
    if(_has(t,['قرآن','قران'])) return _do((){ today.quran+=_num(t,1); }, 'قرآن: ${today.quran+_num(t,1)}');
    if(t.contains('سورة')) return _do((){ today.surahs.add(raw); }, 'سورة: ${today.surahs.length}');
    if(t.contains('استغفر')) return _do((){ today.istighfar+=_num(t,100); }, 'استغفار: ${today.istighfar+_num(t,100)}');
    if(t.contains('سبحان')) return _do((){ today.tasbeeh+=_num(t,33); }, 'تسبيح: ${today.tasbeeh+_num(t,33)}');
    if(t.contains('اذكار')) return _do((){ today.azkar=true; }, 'اذكار: تم');
    if(t.contains('قيام')) return _do((){ today.qiyam++; }, 'قيام: ${today.qiyam+1}');
    if(t.contains('دعاء')) return _do((){ today.duas.add(raw); }, 'دعاء: ${today.duas.length}');
    if(_has(t,['صمت','صيام'])) return _do((){ today.fasting.add('صايم'); }, 'صيام: تم');
    if(t.contains('حديث')) return _do((){ today.hadiths.add(raw); }, 'حديث: ${today.hadiths.length}');
    if(_has(t,['اكلت','فطرت','اتغديت','اتعشيت'])) return _do((){ today.meals.add(raw); today.cal+=_num(t,400); today.prot+=20; }, 'سعرات: ${today.cal+_num(t,400)} | بروتين: ${today.prot+20}');
    if(_has(t,['اتمرنت','تمرين','جيم','جري'])) return _do((){ today.workouts.add(raw); }, 'تمرين: ${today.workouts.length+1}');
    if(_has(t,['ذاكرت','مذاكرة','مراجعة'])) return _do((){ today.study+=_num(t,30); }, 'مذاكرة: ${today.study+_num(t,30)}د');
    if(t.contains('مهمة') || t.contains('هعمل')) return _do((){ today.tasks.add(raw); }, 'مهمة: ${today.tasks.length+1}');
    if(t.contains('خلصت')) return _do((){ if(today.tasks.isNotEmpty){ today.done.add(today.tasks.removeAt(0)); } }, 'خلصت: ${today.done.length+1}');
    if(t.contains('فكرة')) return _do((){ today.ideas.add(raw); }, 'فكرة: ${today.ideas.length}');
    if(t.contains('كلمة انجليزي')) return _do((){ today.wordsEn.add(raw); }, 'كلمة: ${today.wordsEn.length}');
    if(t.contains('تركيز')) return _do((){ today.focus+=25; }, 'تركيز: ${today.focus+25}د');
    if(t.contains('حوشت')) return _do((){ today.moneySaved+=_num(t,0); }, 'حوشت: ${today.moneySaved+_num(t,0)}');
    if(t.contains('ساعدت')) return _do((){ today.helpOthers.add(raw); }, 'ساعدت: ${today.helpOthers.length}');
    if(t.contains('غلطت')) return _do((){ today.mistakes.add(raw); }, 'غلطة: ${today.mistakes.length}');
    if(t.contains('فيديو')) return _do((){ today.videos.add(raw); }, 'فيديو: ${today.videos.length}');
    if(t.contains('بودكاست')) return _do((){ today.podcasts.add(raw); }, 'بودكاست: ${today.podcasts.length}');
    if(t.contains('كورس')) return _do((){ today.courses.add(raw); }, 'كورس: ${today.courses.length}');
    if(t.contains('مهارة')) return _do((){ today.skills.add(raw); }, 'مهارة: ${today.skills.length}');
    if(t.contains('درجة') || t.contains('جبت')) return _do((){ today.grades.add(raw); }, 'درجة: ${today.grades.length}');
    if(t.contains('مادة')) return _do((){ today.subjects.add(raw); }, 'مادة: ${today.subjects.length}');
    if(t.contains('قهوة')) return _do((){ today.coffee++; }, 'قهوة: ${today.coffee+1}');
    if(t.contains('دوا')) return _do((){ today.medicine++; }, 'دوا: ${today.medicine+1}');
    if(t.contains('طاقة')) return _do((){ today.energy=_num(t,3); }, 'طاقة: ${_num(t,3)}');
    if(t.contains('صداع')) return _do((){ today.headache++; }, 'صداع: ${today.headache+1}');
    if(t.contains('شاشة')) return _do((){ today.screenHours+=_num(t,2); }, 'شاشة: ${today.screenHours+_num(t,2)}س');
    if(t.contains('نضفت') || t.contains('رتبت')) return _do((){ today.cleaning.add(raw); }, 'تنظيف: تم');
    if(t.contains('كلمة حلوة')) return _do((){ today.niceWords.add(raw); }, 'كلمة حلوة: ${today.niceWords.length}');
    if(t.contains('اتعلمت من')) return _do((){ today.learnedFrom.add(raw); }, 'اتعلمت: ${today.learnedFrom.length}');
    if(t.contains('من غير سوشيال')) return _do((){ today.noSocial.add('يوم'); }, 'من غير سوشيال: تم');
    if(t.contains('كلمت')) return _do((){ today.calledFamily=true; }, 'كلمت اهلك: تم');
    if(t.contains('الحمدلله')) return _do((){ today.thanked=true; }, 'الحمدلله: تم');
    if(t.contains('نام')) return _do((){ today.sleep=7; }, 'نوم: 7س');
    if(t.contains('وزن')) return _do((){ today.weight=_num(t,70).toDouble(); }, 'وزن: ${_num(t,70)}');
    if(t.contains('قريت')) return _do((){ today.pagesRead+=_num(t,10); today.booksRead.add(raw); }, 'قراءة: ${today.pagesRead+_num(t,10)}ص');
    if(t.contains('تحدي')) return _do((){ today.challenge++; }, 'تحدي: ${today.challenge+1}/30');
    if(t.contains('ملخص')) return _do((){}, '${today.done.length}/${today.totalTasks} | ${today.study}د | ${today.water} مية | ${today.prayers} صلاة | ${today.salawat} صلاة على النبي');
    if(t.contains('امبارح')){
      var y=DateTime.now().subtract(const Duration(days:1)).toIso8601String().substring(0,10);
      var d=history[y];
      return _do((){}, d==null ? 'امبارح: مفيش' : 'امبارح: ${d.study}د | ${d.done.length} | ${d.score}');
    }
    if(t.contains('كتاب اليوم')){
      const b=['العادات الذرية','فن اللامبالاة','الأب الغني','قوة الآن','كيف تكسب الأصدقاء'];
      return _do((){}, 'كتاب اليوم: ${b[DateTime.now().day % b.length]}');
    }
    setState((){ lastAction='مش فاهم: اكلت، شربت، ذاكرت 45'; });
  }

  Widget btn(String l, void Function() f)=>Padding(padding: const EdgeInsets.only(right:6), child: ElevatedButton(onPressed: ()=>_do(f,l), child: Text(l)));

  @override Widget build(BuildContext context){
    final d=today;
    return Scaffold(
      appBar: AppBar(title: Text('$assistantName | $userName | $userGoal | ${d.score}')),
      body: Column(children:[
        Container(padding: const EdgeInsets.all(10), color: Colors.teal.shade50, width: double.infinity, child: Text(lastAction, style: const TextStyle(fontSize:16, fontWeight: FontWeight.bold))),
        Padding(padding: const EdgeInsets.all(8), child: Text('مية ${d.water}/8 | سعرات ${d.cal} | بروتين ${d.prot} | مذاكرة ${d.study}د | مهام ${d.done.length}/${d.totalTasks} | تمرين ${d.workouts.length} ${isMuslim ? '| صلاة ${d.prayers} | صلاة على النبي ${d.salawat} | قرآن ${d.quran}' : ''} | تركيز ${d.focus}د')),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children:[
          btn('+ مية', (){ d.water++; }),
          btn('+ اكل', (){ d.meals.add('وجبة'); d.cal+=400; d.prot+=20; }),
          btn('+ تمرين', (){ d.workouts.add('تمرين'); }),
          btn('+ مذاكرة 30', (){ d.study+=30; }),
          if(isMuslim) btn('+ صلاة', (){ d.prayers++; }),
          if(isMuslim) btn('+ 100 صلاة على النبي', (){ d.salawat+=100; }),
          if(isMuslim) btn('+ قرآن', (){ d.quran++; }),
          btn('تحدي', (){ d.challenge++; }),
        ])),
        Padding(padding: const EdgeInsets.symmetric(horizontal:8), child: Row(children:[
          Expanded(child: TextField(controller: taskCtrl, decoration: const InputDecoration(hintText: 'مهمة جديدة...'))),
          IconButton(icon: const Icon(Icons.add), onPressed: (){ if(taskCtrl.text.isNotEmpty) _do((){ d.tasks.add(taskCtrl.text); }, 'مهمة: ${d.tasks.length+1}'); taskCtrl.clear(); }),
        ])),
        if(d.tasks.isNotEmpty) ...d.tasks.map((t)=>ListTile(title: Text(t), trailing: Row(mainAxisSize: MainAxisSize.min, children:[
          IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: ()=>_do((){ d.tasks.remove(t); d.done.add(t); }, 'خلصت: $t')),
          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: ()=>_do((){ d.tasks.remove(t); }, 'اتمسحت')),
        ]))),
        Expanded(child: ListView(children:[
          if(d.done.isNotEmpty) ListTile(title: Text('انجزت: ${d.done.join(' | ')}')),
          if(d.ideas.isNotEmpty) ListTile(title: Text('افكار: ${d.ideas.join(' | ')}')),
          if(d.wordsEn.isNotEmpty) ListTile(title: Text('كلمات: ${d.wordsEn.join(' | ')}')),
          if(d.grades.isNotEmpty) ListTile(title: Text('درجات: ${d.grades.join(' | ')}')),
          if(d.duas.isNotEmpty) ListTile(title: Text('ادعية: ${d.duas.join(' | ')}')),
        ])),
        Padding(padding: const EdgeInsets.all(8), child: Row(children:[
          Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'فعل: اكلت، شربت، ذاكرت 45، غير اسمي لمحمد...'))),
          IconButton(onPressed: (){ _handle(ctrl.text); ctrl.clear(); }, icon: const Icon(Icons.send)),
        ])),
      ]),
    );
  }
}
