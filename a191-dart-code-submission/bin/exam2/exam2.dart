dynamic oddOrEven(int number) {
  if (number % 2 == 0) {
    return "genap";
  } else {
    return "ganjil";
  }
}

dynamic createListOneToX(int x) {
  final List<int> list = [];

  if (x >= 1) {
    for (int i = 1; i <= x; i++) {
      list.add(i);
    }
  }

  return list;
}

String getStars(int n) {
  var result = '';

  for (int i = n; i >= 1; i--) {
    result += '*' * i;
    if (i > 1) {
      result += '\n';
    }
  }

  return result;
}
