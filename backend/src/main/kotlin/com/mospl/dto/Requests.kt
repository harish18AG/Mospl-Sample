package com.mospl.dto

data class RegisterRequest(val phone: String, val otp: String, val password: String)
data class LoginRequest(val phone: String, val password: String)
data class TokenResponse(val token: String)
data class ProductRequest(val name: String, val category: String, val description: String, val price: Double, val stock: Int)
data class CartRequest(val productId: Long, val quantity: Int)
data class OrderRequest(val userId: Long)
data class ProfileRequest(val name: String)
data class AddressRequest(val line1: String, val city: String, val state: String, val zip: String)
