package com.dicoding.exam.optionalexam2

// TODO
fun minAndMax(number: Int): Int {
    val digits = number.toString().map { it.digitToInt() }
    val min = digits.minOrNull() ?: 0
    val max = digits.maxOrNull() ?: 0
    return min + max
}
