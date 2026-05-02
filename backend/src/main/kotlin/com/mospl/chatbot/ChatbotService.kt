package com.mospl.chatbot

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpEntity
import org.springframework.http.HttpHeaders
import org.springframework.http.MediaType
import org.springframework.stereotype.Service
import org.springframework.web.client.RestTemplate

@Service
class ChatbotService(
    @Value("\${openai.api-key:}") private val apiKey: String,
    @Value("\${openai.model:gpt-4.1-mini}") private val model: String,
) {
    private val rest = RestTemplate()
    private val mapper = ObjectMapper()

    fun respond(req: ChatbotRequest): ChatbotResponse {
        val systemPrompt = """
            You are MOSPL's e-commerce assistant for leather products.
            Tasks: answer product queries, recommend products, help track orders, and guide app navigation.
            Use user history context: ${'$'}{req.history.takeLast(8)}.
            Keep responses concise and practical.
        """.trimIndent()

        if (apiKey.isBlank()) {
            return ChatbotResponse("Demo mode: I can suggest wallets under ₹1000, help with order tracking, and recommend best leather bags.")
        }

        val body = mapOf(
            "model" to model,
            "input" to listOf(
                mapOf("role" to "system", "content" to systemPrompt),
                mapOf("role" to "user", "content" to req.message),
            )
        )
        val headers = HttpHeaders().apply {
            contentType = MediaType.APPLICATION_JSON
            setBearerAuth(apiKey)
        }
        val response = rest.postForObject("https://api.openai.com/v1/responses", HttpEntity(body, headers), Map::class.java)
        val output = mapper.writeValueAsString(response)
        return ChatbotResponse(output.take(500))
    }
}
