package com.dicoding.exam.optionalexam4

// TODO
fun getMiddleCharacters(string: String): String {
    val len = string.length
    if (len == 0) return ""
    return if (len % 2 == 0) {
        val start = len / 2 - 1
        string.substring(start, start + 2)
    } else {
        val mid = len / 2
        string.substring(mid, mid + 1)
    }
}