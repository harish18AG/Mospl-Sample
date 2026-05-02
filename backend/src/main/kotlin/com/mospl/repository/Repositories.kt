package com.mospl.repository

import com.mospl.model.*
import org.springframework.data.jpa.repository.JpaRepository

interface UserRepository: JpaRepository<AppUser, Long> { fun findByPhone(phone: String): AppUser? }
interface AddressRepository: JpaRepository<Address, Long> { fun findByUserId(userId: Long): List<Address> }
interface ProductRepository: JpaRepository<Product, Long> { fun findByCategory(category: String): List<Product> }
interface CartRepository: JpaRepository<CartItem, Long> { fun findByUserId(userId: Long): List<CartItem>; fun findByUserIdAndProductId(userId: Long, productId: Long): CartItem? }
interface OrderRepository: JpaRepository<OrderEntity, Long> { fun findByUserId(userId: Long): List<OrderEntity> }
