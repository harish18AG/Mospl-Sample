package com.mospl.controller

import com.mospl.dto.*
import com.mospl.service.*
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile

@RestController @RequestMapping("/api/auth")
class AuthController(private val authService: AuthService) {
    @PostMapping("/register") fun register(@RequestBody req: RegisterRequest) = authService.register(req)
    @PostMapping("/login") fun login(@RequestBody req: LoginRequest) = authService.login(req)
}

@RestController @RequestMapping("/api/products")
class ProductController(private val service: ProductService) {
    @PostMapping fun add(@RequestBody req: ProductRequest) = service.add(req)
    @PutMapping("/{id}") fun update(@PathVariable id: Long, @RequestBody req: ProductRequest) = service.update(id, req)
    @DeleteMapping("/{id}") fun delete(@PathVariable id: Long) = service.delete(id)
    @GetMapping fun all(@RequestParam(defaultValue = "0") page: Int, @RequestParam(defaultValue = "20") size: Int) = service.all(page, size)
    @GetMapping("/category/{category}") fun byCategory(@PathVariable category: String) = service.byCategory(category)
}

@RestController @RequestMapping("/api/cart")
class CartController(private val service: CartService) {
    @PostMapping("/{userId}") fun add(@PathVariable userId: Long, @RequestBody req: CartRequest) = service.add(userId, req)
    @DeleteMapping("/{id}") fun remove(@PathVariable id: Long) = service.remove(id)
    @PatchMapping("/{id}") fun update(@PathVariable id: Long, @RequestParam quantity: Int) = service.updateQty(id, quantity)
}

@RestController @RequestMapping("/api/orders")
class OrderController(private val service: OrderService) {
    @PostMapping fun place(@RequestBody req: OrderRequest) = service.place(req)
    @GetMapping("/user/{userId}") fun userOrders(@PathVariable userId: Long) = service.userOrders(userId)
    @GetMapping("/{id}/track") fun track(@PathVariable id: Long) = service.track(id)
}

@RestController @RequestMapping("/api/users")
class UserController(private val service: UserService) {
    @PutMapping("/{userId}/profile") fun profile(@PathVariable userId: Long, @RequestBody req: ProfileRequest) = service.updateProfile(userId, req)
    @PostMapping("/{userId}/addresses") fun addAddress(@PathVariable userId: Long, @RequestBody req: AddressRequest) = service.addAddress(userId, req)
    @GetMapping("/{userId}/addresses") fun listAddress(@PathVariable userId: Long) = service.userAddresses(userId)
}

@RestController @RequestMapping("/api/admin")
class AdminController {
    @GetMapping("/sales-analytics") fun analytics() = mapOf("dailySales" to 12450, "orders" to 87)
    @GetMapping("/order-control") fun orderControl() = mapOf("pending" to 12, "shipped" to 43)
}

@RestController @RequestMapping("/api/uploads")
class UploadController {
    @PostMapping("/image") fun upload(@RequestParam file: MultipartFile): ResponseEntity<Map<String, String>> {
        val url = "https://storage.googleapis.com/mospl/${file.originalFilename}"
        return ResponseEntity.ok(mapOf("url" to url))
    }
}
