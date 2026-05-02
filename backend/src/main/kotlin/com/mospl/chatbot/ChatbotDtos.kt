package com.mospl.chatbot

data class ChatbotRequest(val userId: String, val message: String, val history: List<String> = emptyList())
data class ChatbotResponse(val reply: String)
