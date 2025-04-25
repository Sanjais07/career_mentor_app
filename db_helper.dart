// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class StudentModel {
  int? id;
  String name;
  String email;
  String selectedCourse;
  String tenthGrade;
  String twelfthGrade;
  String collegeCGPA;
  String areasOfInterest;

  StudentModel({
    this.id,
    required this.name,
    required this.email,
    required this.selectedCourse,
    required this.tenthGrade,
    required this.twelfthGrade,
    required this.collegeCGPA,
    required this.areasOfInterest,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'selectedCourse': selectedCourse,
      'tenthGrade': tenthGrade,
      'twelfthGrade': twelfthGrade,
      'collegeCGPA': collegeCGPA,
      'areasOfInterest': areasOfInterest,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      selectedCourse: map['selectedCourse'],
      tenthGrade: map['tenthGrade'],
      twelfthGrade: map['twelfthGrade'],
      collegeCGPA: map['collegeCGPA'],
      areasOfInterest: map['areasOfInterest'],
    );
  }
}

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('students.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        selectedCourse TEXT,
        tenthGrade TEXT,
        twelfthGrade TEXT,
        collegeCGPA TEXT,
        areasOfInterest TEXT
      )
    ''');
  }

  Future<int> insertStudent(StudentModel student) async {
    final db = await database;
    return await db.insert('students', student.toMap());
  }

  Future<List<StudentModel>> getAllStudents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('students');
    return List.generate(maps.length, (i) => StudentModel.fromMap(maps[i]));
  }

  Future<int> deleteAllStudents() async {
    final db = await database;
    return await db.delete('students');
  }
}
