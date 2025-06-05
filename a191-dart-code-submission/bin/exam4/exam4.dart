class DicodingStudent {
  String fullName;
  int age;

  DicodingStudent(this.fullName, this.age);

  int incrementAge() {
    return age + 1;
  }

  Future<String> getStudentInfo() {
    return Future.delayed(const Duration(seconds: 3), () {
      return "Nama Lengkap: $fullName, Umur: $age tahun";
    });
  }
}

dynamic createStudent() {
  var dicodingStudent = DicodingStudent("Budi", 20);
  return dicodingStudent;
}
