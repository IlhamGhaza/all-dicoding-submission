import 'exam4.dart';

Future<void> main() async {
  final dicodingStudent = DicodingStudent('Muhammad Ilham Ghazali', 21);

  print('Full Name = ${dicodingStudent.fullName}');
  print('Age       = ${dicodingStudent.age}');

  print('Age + 1   = ${dicodingStudent.incrementAge()}');

  final studentInfo = await dicodingStudent.getStudentInfo();
  print(studentInfo);

  print(await createStudent().fullName);
  print(await createStudent().age);
}
