import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const NexaApp());
}




// --- مدل‌های داده‌ای یکپارچه (حفاظت از منطق دیتابیس شما) ---
class Comment {
  String id;
  String user;
  String text;

  Comment({required this.id, required this.user, required this.text});
}

class Submission {
  String id;
  String title;
  String description;
  String sender;
  String format;
  String field;
  String imgPath;
  String status;
  int score;
  int likes;
  int views;
  String knowledgeCode;
  String refereeFeedback;
  String assignedRefereePhone;
  List<Comment> comments;

  Submission({
    required this.id,
    required this.title,
    required this.description,
    required this.sender,
    required this.format,
    required this.field,
    required this.imgPath,
    this.status = "pending",
    this.score = 0,
    this.likes = 0,
    this.views = 0,
    this.knowledgeCode = "",
    this.refereeFeedback = "",
    this.assignedRefereePhone = "",
    required this.comments,
  });
}

class RefereeProfile {
  String firstName;
  String lastName;
  String phone;
  String nationalId;
  String field;

  RefereeProfile({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.nationalId,
    required this.field,
  });
}

class NexaApp extends StatelessWidget {
  const NexaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نکسا (NEXA)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF002d5b),
        fontFamily: 'Tahoma',
      ),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const NEXASystemNavigator(),
    );
  }
}

class NEXASystemNavigator extends StatefulWidget {
  const NEXASystemNavigator({super.key});

  @override
  State<NEXASystemNavigator> createState() => _NEXASystemNavigatorState();
}

class _NEXASystemNavigatorState extends State<NEXASystemNavigator> {
  String currentStep = "welcome";
  String userRole = "guest";
  String loginPhone = "";
  String loginId = "";
  int _navIdx = 0;

  static List<RefereeProfile> globalReferees = [
    RefereeProfile(
      firstName: "استاد",
      lastName: "نمونه",
      phone: "0912",
      nationalId: "123",
      field: "۲. حوزه فنی و مهندسی",
    ),
  ];

  static List<Submission> submissionDatabase = [
    Submission(
      id: "s1",
      title: "بهسازی زیرسازی آزادراه",
      description: "سناریوی اصلاح لایه بیس",
      sender: "واحد مهندسی",
      format: "PDF",
      field: "۱۳. حوزه آسفالت",
      imgPath: "assets/highway_site.jpg",
      status: "published",
      likes: 25,
      views: 500,
      comments: [],
    ),
  ];

  final List<String> fieldCommittees = [
    "۱. حوزه معماری و منظر",
    "۲. حوزه فنی و مهندسی",
    "۳. حوزه برنامه‌ریزی",
    "۴. حوزه کنترل پروژه",
    "۵. حوزه نقشه‌برداری",
    "۶. حوزه بتن",
    "۷. حوزه هوش مصنوعی",
    "۸. حوزه ICT",
    "۹. حوزه نگهداری ماشین‌آلات",
    "۱۰. حوزه کنترل کیفیت",
    "۱۱. حوزه HSSE",
    "۱۲. حوزه BIM",
    "۱۳. حوزه آسفالت",
    "۱۴. حوزه مالی",
  ];
  final List<String> universityMajors = [
    "عمران",
    "معماری",
    "مکانیک",
    "برق",
    "هوش مصنوعی",
    "صنایع",
    "مدیریت",
    "حقوق",
  ];

  final _pName = TextEditingController();
  final _pId = TextEditingController();
  final _pMob = TextEditingController();

  void _resetApp() => setState(() {
    currentStep = "welcome";
    userRole = "guest";
    _navIdx = 0;
  });

  @override
  Widget build(BuildContext context) {
    if (currentStep == "welcome") return _buildWelcome();
    if (currentStep == "login") return _buildLogin();
    if (currentStep == "verify") return _buildVerify();
    return _buildDashboard();
  }

  Widget _appHeader(String sub) => Container(
    width: double.infinity,
    color: const Color(0xFF002d5b),
    padding: const EdgeInsets.only(top: 60, bottom: 25),
    child: Column(
      children: [
        Image.asset(
          "assets/logo.png",
          height: 70,
          errorBuilder: (c, e, s) =>
              const Icon(Icons.star, color: Colors.white, size: 50),
        ),
        const Text(
          'نکسا (NEXA)',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Text(
          'نظام یکپارچه محتوا عاشورا',
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 10),
        Text(sub, style: const TextStyle(color: Colors.white54, fontSize: 13)),
      ],
    ),
  );

  Widget _buildWelcome() => Scaffold(
    body: Column(
      children: [
        _appHeader("ورود به سامانه پایش تخصصی محتوا"),
        Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              const Text(
                "لطفاً نوع کاربری خود را تعیین کنید:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 25),
              _roleBtn("کاربر عادی (پرسنل اجرایی)", "user"),
              _roleBtn("داور تخصصی / نخبگان دانشی", "referee"),
              _roleBtn("مدیر سامانه", "manager"),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _roleBtn(String t, String r) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        side: const BorderSide(color: Color(0xFF002d5b), width: 2),
        minimumSize: const Size(double.infinity, 55),
      ),
      onPressed: () => setState(() {
        userRole = r;
        currentStep = "login";
      }),
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  Widget _buildLogin() => Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SizedBox(height: 80),
          _lbl("شماره همراه فعال سامانه :"),
          TextField(
            onChanged: (v) => loginPhone = v,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 15),
          _lbl("کد ملی کاربر (رمز ورود) :"),
          TextField(
            onChanged: (v) => loginId = v,
            obscureText: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 25),
          _primaryBtn(
            "درخواست کد تایید هویت",
            () => setState(() {
              currentStep = "verify";
            }),
          ),
        ],
      ),
    ),
  );

  Widget _buildVerify() => Scaffold(
    body: Center(
      child: _primaryBtn("تایید و ورود نهایی", _handleFinalLogin, width: 250),
    ),
  );

  void _handleFinalLogin() {
    if (userRole == "referee") {
      bool ok = globalReferees.any(
        (r) => r.phone == loginPhone && r.nationalId == loginId,
      );
      if (!ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("هویت داوری شما ثبت نشده است")),
        );
        return;
      }
    }
    setState(() => currentStep = "main");
  }

  Widget _buildDashboard() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "نکسا | میز $userRole",
          style: const TextStyle(
            color: Color(0xFF002d5b),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _resetApp,
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIdx,
        selectedItemColor: const Color(0xFF002d5b),
        onTap: (i) => setState(() => _navIdx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "میز کار"),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: "تالار گفتگو",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            label: "پروفایل",
          ),
        ],
      ),
    );
  }

  Widget _buildPage() {
    if (_navIdx == 1) return _buildChatForum();
    if (_navIdx == 2) return _buildProfileEditor();
    if (userRole == "user") return _buildUserWorkbench(); // حاجی کلمه اصلاح شد
    if (userRole == "manager") return _buildManagerWorkbench();
    return _buildRefereeWorkbench();
  }

  // --- ۱. پنل کاربر ---
  Widget _buildUserWorkbench() => // نام اصلاح شده بدون فاصله
  DefaultTabController(
    length: 4,
    child: Column(
      children: [
        const TabBar(
          isScrollable: true,
          labelColor: Color(0xFF002d5b),
          indicatorColor: Color(0xFFfbbf24),
          tabs: [
            Tab(text: "ویترین دانش"),
            Tab(text: "ارسال محتوا"),
            Tab(text: "وضعیت پیگیری"),
            Tab(text: "پیشنهاد موضوعات"),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              _buildShowcase(),
              _buildSubmitForm(),
              _buildTracking(),
              _buildUniversityList(),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _buildShowcase() => ListView.builder(
    itemCount: submissionDatabase.length,
    itemBuilder: (c, i) => _buildContentCard(submissionDatabase[i]),
  );

  Widget _buildContentCard(Submission s) => Card(
    margin: const EdgeInsets.all(15),
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      border: BorderSide(color: Colors.grey[200]!),
    ),
    child: Column(
      children: [
        Image.asset(
          s.imgPath,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            height: 180,
            color: Colors.blue[50],
            child: const Icon(Icons.engineering),
          ),
        ),
        ListTile(
          title: Text(
            s.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("${s.field} | کد: ${s.knowledgeCode}"),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.red),
                onPressed: () => setState(() => s.likes++),
              ),
              Text(" لایک (${s.likes})"),
              const Spacer(),
              TextButton(
                onPressed: () => _openComments(s),
                child: const Text(
                  "نظرات",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  void _openComments(Submission s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (c) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(c).viewInsets.bottom,
          top: 15,
          left: 15,
          right: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "تبادل نظر نخبگان",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: s.comments.length,
                itemBuilder: (cc, ii) => ListTile(
                  title: Text(
                    s.comments[ii].user,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(s.comments[ii].text),
                ),
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "درج نظر فنی...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (v) {
                setState(() {
                  s.comments.add(
                    Comment(id: "x", user: "همکار پروژه", text: v),
                  );
                });
                Navigator.pop(c);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitForm() => SingleChildScrollView(
    padding: const EdgeInsets.all(25),
    child: Column(
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: "عنوان سناریو / محتوای فنی",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField(
          decoration: const InputDecoration(labelText: "حوزه پیشنهادی"),
          items: fieldCommittees
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 11)),
                ),
              )
              .toList(),
          onChanged: (v) {},
        ),
        const SizedBox(height: 15),
        _filePickerField(),
        const SizedBox(height: 30),
        _primaryBtn(
          "ثبت و ارسال به نکسا",
          () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("ارسال گردید"))),
        ),
      ],
    ),
  );

  Widget _filePickerField() => InkWell(
    onTap: () async {
      FilePickerResult? res = await FilePicker.platform.pickFiles();
      if (res != null)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("فایل انتخاب شد")));
    },
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: const Row(
        children: [
          Icon(Icons.attachment),
          SizedBox(width: 15),
          Text("پیوست فایل (ویدیو/PDF)"),
        ],
      ),
    ),
  );

  // --- ۲. پنل مدیر ---
  Widget _buildManagerWorkbench() => DefaultTabController(
    length: 2,
    child: Column(
      children: [
        const TabBar(
          labelColor: Color(0xFF002d5b),
          tabs: [
            Tab(text: "میز ارجاع مدیر"),
            Tab(text: "ثبت داور"),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              ListView.builder(
                itemCount: submissionDatabase.length,
                itemBuilder: (c, i) => ListTile(
                  title: Text(submissionDatabase[i].title),
                  subtitle: const Text("در انتظار ارجاع"),
                  trailing: ElevatedButton(
                    onPressed: _showReferralDialog,
                    child: const Text("بررسی"),
                  ),
                ),
              ),
              _addRefereeForm(),
            ],
          ),
        ),
      ],
    ),
  );

  void _showReferralDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("ارجاع به نخبگان:"),
        content: DropdownButton<RefereeProfile>(
          isExpanded: true,
          items: globalReferees
              .map(
                (r) => DropdownMenuItem(
                  value: r,
                  child: Text("${r.firstName} ${r.lastName}"),
                ),
              )
              .toList(),
          onChanged: (v) {
            Navigator.pop(c);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("ارجاع شد")),
            ); // کلمه ScaffoldMessenger اصلاح شد
          },
        ),
      ),
    );
  }

  // --- ۳. پنل داور ---
  Widget _buildRefereeWorkbench() => ListView.builder(
    itemCount: 1,
    itemBuilder: (c, i) => Card(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          const ListTile(
            title: Text("سناریو فنی تثبیت روسازی"),
            subtitle: Text("در انتظار امتیاز دهی نخبگان"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text("رد", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(onPressed: () {}, child: const Text("تایید علمی")),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );

  Widget _buildChatForum() => const Center(
    child: Text("تالار گفتگو سراسری نخبگان مؤسسه عاشورا فعال است."),
  );

  Widget _buildProfileEditor() => SingleChildScrollView(
    padding: const EdgeInsets.all(30),
    child: Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: Color(0xFF002d5b),
          child: Icon(Icons.person, color: Colors.white, size: 50),
        ),
        const SizedBox(height: 25),
        TextField(
          controller: _pName,
          decoration: const InputDecoration(labelText: "نام و نام خانوادگی"),
        ),
        TextField(
          controller: _pId,
          decoration: const InputDecoration(labelText: "کد ملی"),
        ),
        TextField(
          controller: _pMob,
          decoration: const InputDecoration(labelText: "شماره همراه"),
        ),
        const SizedBox(height: 30),
        _primaryBtn("ذخیره پروفایل", () {}),
      ],
    ),
  );

  Widget _lbl(String t) => Align(
    alignment: Alignment.centerRight,
    child: Text(
      t,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
    ),
  );

  Widget _primaryBtn(String t, VoidCallback p, {double? width}) => SizedBox(
    width: width ?? double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007bff),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: p,
      child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
    ),
  );

  Widget _addRefereeForm() => SingleChildScrollView(
    padding: const EdgeInsets.all(25),
    child: Column(
      children: [
        const Text("تعریف داور فنی جدید"),
        TextField(decoration: const InputDecoration(labelText: "نام نخبگان")),
        TextField(decoration: const InputDecoration(labelText: "شماره همراه")),
        TextField(decoration: const InputDecoration(labelText: "کد ملی (ID)")),
        _primaryBtn("ثبت نهایی", () {}),
      ],
    ),
  );

  Widget _buildTracking() => ListView.builder(
    itemCount: 1,
    itemBuilder: (c, i) => const ListTile(
      title: Text("وضعیت طرح ها"),
      subtitle: Text("در حال بررسی توسط مدیریت"),
      leading: Icon(Icons.timer),
    ),
  );

  Widget _buildUniversityList() => ListView.builder(
    itemCount: universityMajors.length,
    itemBuilder: (c, i) => Card(
      child: ListTile(title: Text("رشته مهندسی ${universityMajors[i]}")),
    ),
  );
}
