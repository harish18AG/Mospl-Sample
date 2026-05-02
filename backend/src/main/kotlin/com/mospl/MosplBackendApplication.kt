package com.mospl

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class MosplBackendApplication

fun main(args: Array<String>) {
    runApplication<MosplBackendApplication>(*args)
}
