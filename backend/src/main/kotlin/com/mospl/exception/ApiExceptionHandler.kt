package com.mospl.exception

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice

data class ErrorResponse(val message: String)
class NotFoundException(message: String): RuntimeException(message)

@RestControllerAdvice
class ApiExceptionHandler {
    @ExceptionHandler(NotFoundException::class)
    fun notFound(ex: NotFoundException) = ResponseEntity.status(HttpStatus.NOT_FOUND).body(ErrorResponse(ex.message ?: "Not found"))

    @ExceptionHandler(IllegalArgumentException::class)
    fun badRequest(ex: IllegalArgumentException) = ResponseEntity.badRequest().body(ErrorResponse(ex.message ?: "Bad request"))

    @ExceptionHandler(Exception::class)
    fun generic(ex: Exception) = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ErrorResponse(ex.message ?: "Error"))
}
