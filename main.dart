import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'notification.dart';
import 'location.dart';
import 'rssfeed.dart';
import 'email.dart';

void main() {
  runApp(CareerMentorApp());
}

class CareerMentorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Career Mentor',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/notification': (context) => NotificationPage(),
        '/location': (context) => LocationPage(),
        '/rssfeed': (context) => RSSFeedPage(),
        '/email': (context) => EmailPage(),
      },
    );
  }
}

class Student {
  String name, email, selectedCourse, tenthGrade, twelfthGrade, collegeCGPA, areasOfInterest;
  Student({
    required this.name,
    required this.email,
    required this.selectedCourse,
    required this.tenthGrade,
    required this.twelfthGrade,
    required this.collegeCGPA,
    required this.areasOfInterest,
  });
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _tenthGradeController = TextEditingController();
  final _twelfthGradeController = TextEditingController();
  final _collegeCGPAController = TextEditingController();
  final _areasOfInterestController = TextEditingController();

  final List<String> _courses = ['AI & ML', 'Web Development', 'Cyber Security', 'Data Science'];
  String _selectedCourse = 'AI & ML';
  List<Student> _students = [];

  void _addStudent() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _students.add(Student(
          name: _nameController.text,
          email: _emailController.text,
          selectedCourse: _selectedCourse,
          tenthGrade: _tenthGradeController.text,
          twelfthGrade: _twelfthGradeController.text,
          collegeCGPA: _collegeCGPAController.text,
          areasOfInterest: _areasOfInterestController.text,
        ));

        _nameController.clear();
        _emailController.clear();
        _tenthGradeController.clear();
        _twelfthGradeController.clear();
        _collegeCGPAController.clear();
        _areasOfInterestController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student added successfully!')),
      );
    }
  }

  Map<String, double> _getCourseDistribution() {
    Map<String, double> dataMap = {
      for (var course in _courses) course: 0,
    };
    for (var student in _students) {
      dataMap[student.selectedCourse] = (dataMap[student.selectedCourse] ?? 0) + 1;
    }
    dataMap.removeWhere((key, value) => value == 0);
    return dataMap;
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.teal.shade100),
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Course')),
          DataColumn(label: Text('10th Grade')),
          DataColumn(label: Text('12th Grade')),
          DataColumn(label: Text('CGPA')),
          DataColumn(label: Text('Interests')),
        ],
        rows: _students.map((student) {
          return DataRow(cells: [
            DataCell(Text(student.name)),
            DataCell(Text(student.email)),
            DataCell(Text(student.selectedCourse)),
            DataCell(Text(student.tenthGrade)),
            DataCell(Text(student.twelfthGrade)),
            DataCell(Text(student.collegeCGPA)),
            DataCell(Text(student.areasOfInterest)),
          ]);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartData = _getCourseDistribution();

    return Scaffold(
      appBar: AppBar(
        title: Text('Career Mentor - Student Form'),
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () => Navigator.pushNamed(context, '/notification')),
          IconButton(icon: Icon(Icons.location_on), onPressed: () => Navigator.pushNamed(context, '/location')),
          IconButton(icon: Icon(Icons.rss_feed), onPressed: () => Navigator.pushNamed(context, '/rssfeed')),
          IconButton(icon: Icon(Icons.email), onPressed: () => Navigator.pushNamed(context, '/email')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🎯 Student Form
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text("Enter Student Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      _buildTextField(_nameController, 'Name', Icons.person),
                      _buildTextField(_emailController, 'Email', Icons.email, isEmail: true),
                      _buildDropdown(),
                      _buildTextField(_tenthGradeController, '10th Grade', Icons.school),
                      _buildTextField(_twelfthGradeController, '12th Grade', Icons.school_outlined),
                      _buildTextField(_collegeCGPAController, 'College CGPA', Icons.grade),
                      _buildTextField(_areasOfInterestController, 'Areas of Interest', Icons.interests),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text("Add Student"),
                        onPressed: _addStudent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),

            // 📊 Student Table
            if (_students.isNotEmpty) ...[
              Divider(),
              Text("Student Entries", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              _buildTable(),
              SizedBox(height: 24),
            ],

            // 📈 Pie Chart
            if (chartData.isNotEmpty) ...[
              Divider(),
              Text("Course Distribution", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12),
              PieChart(
                dataMap: chartData,
                chartType: ChartType.ring,
                chartRadius: MediaQuery.of(context).size.width / 2.5,
                chartValuesOptions: ChartValuesOptions(showChartValuesInPercentage: true),
                legendOptions: LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  legendTextStyle: TextStyle(fontSize: 14),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedCourse,
        decoration: InputDecoration(
          labelText: "Select Course",
          prefixIcon: Icon(Icons.menu_book),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: _courses.map((course) {
          return DropdownMenuItem(value: course, child: Text(course));
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCourse = value!;
          });
        },
      ),
    );
  }
}
