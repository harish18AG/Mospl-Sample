package com.mospl.security

import io.jsonwebtoken.Jwts
import io.jsonwebtoken.security.Keys
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.util.*

@Service
class JwtService(
    @Value("\${security.jwt.secret}") private val secret: String,
    @Value("\${security.jwt.expiry-ms}") private val expiryMs: Long,
) {
    fun generateToken(subject: String): String {
        val key = Keys.hmacShaKeyFor(secret.padEnd(32, 'x').toByteArray())
        return Jwts.builder().subject(subject).issuedAt(Date()).expiration(Date(System.currentTimeMillis() + expiryMs)).signWith(key).compact()
    }
}
