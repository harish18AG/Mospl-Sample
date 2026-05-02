package com.mospl.chatbot

import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/chatbot")
class ChatbotController(private val service: ChatbotService) {
    @PostMapping("/respond")
    fun respond(@RequestBody request: ChatbotRequest) = service.respond(request)
}
