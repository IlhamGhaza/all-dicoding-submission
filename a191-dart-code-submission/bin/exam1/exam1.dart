dynamic studentInfo() {
  var name = "Muhammad Ilham Ghazali";
  var favNumber = 7;
  var isDicodingStudent = true;

  return [name, favNumber, isDicodingStudent];
}

dynamic circleArea(num r) {
  if (r < 0) {
    return 0.0;
  } else {
    const double pi = 3.1415926535897932;

    num area = pi * r * r;
    return area;
  }
}

int? parseAndAddOne(String? input) {
  if (input == null) {
    return null;
  }
  try {
    int parsedInt = int.parse(input);
    return parsedInt + 1;
  } on FormatException {
    throw Exception('Input harus berupa angka');
  }
}
