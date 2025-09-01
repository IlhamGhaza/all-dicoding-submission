package com.dicoding.exam.optionalexam3

// TODO
fun manipulateString(str: String, int: Int): String {
    val digits = str.filter { it.isDigit() }
    return if (digits.isNotEmpty()) {
        val text = str.filter { !it.isDigit() }
        val number = digits.toInt()
        text + (number * int)
    } else {
        str + int.toString()
    }
}
