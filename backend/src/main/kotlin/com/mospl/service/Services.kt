package com.mospl.service

import com.mospl.dto.*
import com.mospl.exception.NotFoundException
import com.mospl.model.*
import com.mospl.repository.*
import com.mospl.security.JwtService
import org.springframework.data.domain.PageRequest
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.stereotype.Service

@Service
class AuthService(private val users: UserRepository, private val jwt: JwtService) {
    private val encoder = BCryptPasswordEncoder()
    fun register(req: RegisterRequest): TokenResponse {
        require(req.otp == "123456") { "Invalid OTP" }
        val user = users.save(AppUser(phone = req.phone, password = encoder.encode(req.password)))
        return TokenResponse(jwt.generateToken(user.phone))
    }
    fun login(req: LoginRequest): TokenResponse {
        val user = users.findByPhone(req.phone) ?: throw NotFoundException("User not found")
        require(encoder.matches(req.password, user.password)) { "Invalid credentials" }
        return TokenResponse(jwt.generateToken(user.phone))
    }
}

@Service
class ProductService(private val products: ProductRepository) {
    fun add(req: ProductRequest) = products.save(Product(name=req.name, category=req.category, description=req.description, price=req.price, stock=req.stock))
    fun update(id: Long, req: ProductRequest) = products.findById(id).orElseThrow { NotFoundException("Product") }.apply {
        name=req.name; category=req.category; description=req.description; price=req.price; stock=req.stock
    }.let(products::save)
    fun delete(id: Long) = products.deleteById(id)
    fun all(page: Int, size: Int) = products.findAll(PageRequest.of(page, size))
    fun byCategory(category: String) = products.findByCategory(category)
}

@Service
class CartService(private val carts: CartRepository) {
    fun add(userId: Long, req: CartRequest) = carts.save(carts.findByUserIdAndProductId(userId, req.productId)?.apply { quantity += req.quantity } ?: CartItem(userId=userId, productId=req.productId, quantity=req.quantity))
    fun remove(id: Long) = carts.deleteById(id)
    fun updateQty(id: Long, quantity: Int) = carts.findById(id).orElseThrow { NotFoundException("Cart item") }.apply { this.quantity = quantity }.let(carts::save)
}

@Service
class OrderService(private val orders: OrderRepository) {
    fun place(req: OrderRequest) = orders.save(OrderEntity(userId = req.userId, totalAmount = 99.0))
    fun userOrders(userId: Long) = orders.findByUserId(userId)
    fun track(id: Long) = orders.findById(id).orElseThrow { NotFoundException("Order") }
}

@Service
class UserService(private val users: UserRepository, private val addresses: AddressRepository) {
    fun updateProfile(userId: Long, req: ProfileRequest) = users.findById(userId).orElseThrow { NotFoundException("User") }.apply { name = req.name }.let(users::save)
    fun addAddress(userId: Long, req: AddressRequest) = addresses.save(Address(userId=userId, line1=req.line1, city=req.city, state=req.state, zip=req.zip))
    fun userAddresses(userId: Long) = addresses.findByUserId(userId)
}
