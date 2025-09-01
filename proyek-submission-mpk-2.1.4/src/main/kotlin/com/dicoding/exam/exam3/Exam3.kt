package com.dicoding.exam.exam3

// TODO
fun <T> checkType(args: T): String {
    val type = when (args) {
        is Int -> "Integer"
        is String -> "String"
        is Boolean -> "Boolean"
        is Double -> "Double"
        is List<*> -> "List"
        is Map<*, *> -> "Map"
        else -> "Unknown"
    }
    return "Yes! it's $type"
}