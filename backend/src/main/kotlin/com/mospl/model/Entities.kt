package com.mospl.model

import jakarta.persistence.*
import java.time.Instant

@Entity data class AppUser(@Id @GeneratedValue(strategy = GenerationType.IDENTITY) val id: Long = 0,
    @Column(unique = true) val phone: String,
    var password: String,
    var name: String = "",
    var role: String = "USER")

@Entity data class Address(@Id @GeneratedValue(strategy = GenerationType.IDENTITY) val id: Long = 0,
    val userId: Long, var line1: String, var city: String, var state: String, var zip: String)

@Entity data class Product(@Id @GeneratedValue(strategy = GenerationType.IDENTITY) val id: Long = 0,
    var name: String, var category: String, var description: String, var price: Double, var stock: Int, var imageUrl: String? = null)

@Entity data class CartItem(@Id @GeneratedValue(strategy = GenerationType.IDENTITY) val id: Long = 0,
    val userId: Long, val productId: Long, var quantity: Int)

@Entity data class OrderEntity(@Id @GeneratedValue(strategy = GenerationType.IDENTITY) val id: Long = 0,
    val userId: Long, var status: String = "PLACED", val totalAmount: Double, val createdAt: Instant = Instant.now())
