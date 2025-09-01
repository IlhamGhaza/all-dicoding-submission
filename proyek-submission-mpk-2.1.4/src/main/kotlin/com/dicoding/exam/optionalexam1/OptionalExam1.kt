package com.dicoding.exam.optionalexam1

// TODO
fun sumOfBigThree(vararg numbers: Int): Int {
    return numbers.asList().sortedDescending().take(3).sum()
}
