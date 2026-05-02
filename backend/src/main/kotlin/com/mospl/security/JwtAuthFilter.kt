package com.mospl.security

import io.jsonwebtoken.Jwts
import io.jsonwebtoken.security.Keys
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter

@Component
class JwtAuthFilter(@Value("\${security.jwt.secret}") private val secret: String) : OncePerRequestFilter() {
    override fun doFilterInternal(request: HttpServletRequest, response: HttpServletResponse, chain: FilterChain) {
        val auth = request.getHeader("Authorization")
        if (auth != null && auth.startsWith("Bearer ")) {
            runCatching {
                val token = auth.removePrefix("Bearer ")
                val key = Keys.hmacShaKeyFor(secret.padEnd(32, 'x').toByteArray())
                val subject = Jwts.parser().verifyWith(key).build().parseSignedClaims(token).payload.subject
                val authentication = UsernamePasswordAuthenticationToken(subject, null, emptyList())
                authentication.details = WebAuthenticationDetailsSource().buildDetails(request)
                SecurityContextHolder.getContext().authentication = authentication
            }
        }
        chain.doFilter(request, response)
    }
}
