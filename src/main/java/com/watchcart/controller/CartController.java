package com.watchcart.controller;

import com.watchcart.dto.AddToCartRequest;
import com.watchcart.dto.ApiResponse;
import com.watchcart.model.Cart;
import com.watchcart.model.User;
import com.watchcart.service.CartService;
import com.watchcart.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.Min;

@RestController
@RequestMapping("/api/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private UserService userService;

    @GetMapping
    public ResponseEntity<ApiResponse<Cart>> getCart(
            @AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.findByEmail(userDetails.getUsername());
        return ResponseEntity.ok(ApiResponse.ok(cartService.getCartByUserId(user.getId())));
    }

    @PostMapping("/add")
    public ResponseEntity<ApiResponse<Cart>> addItem(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody AddToCartRequest req) {
        User user = userService.findByEmail(userDetails.getUsername());
        Cart cart = cartService.addItemToCart(user.getId(), req.getProductId(), req.getQuantity());
        return ResponseEntity.ok(ApiResponse.ok("Item added to cart", cart));
    }

    @PutMapping("/items/{itemId}")
    public ResponseEntity<ApiResponse<Cart>> updateItem(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long itemId,
            @RequestParam @Min(1) int quantity) {
        User user = userService.findByEmail(userDetails.getUsername());
        Cart cart = cartService.updateItemQuantity(user.getId(), itemId, quantity);
        return ResponseEntity.ok(ApiResponse.ok("Cart updated", cart));
    }

    @DeleteMapping("/items/{itemId}")
    public ResponseEntity<ApiResponse<Cart>> removeItem(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long itemId) {
        User user = userService.findByEmail(userDetails.getUsername());
        Cart cart = cartService.removeItemFromCart(user.getId(), itemId);
        return ResponseEntity.ok(ApiResponse.ok("Item removed", cart));
    }

    @DeleteMapping
    public ResponseEntity<ApiResponse<Void>> clearCart(
            @AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.findByEmail(userDetails.getUsername());
        cartService.clearCart(user.getId());
        return ResponseEntity.ok(ApiResponse.ok("Cart cleared", null));
    }
}
