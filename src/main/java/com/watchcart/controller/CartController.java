package com.watchcart.controller;

import com.watchcart.model.Cart;
import com.watchcart.model.User;
import com.watchcart.service.CartService;
import com.watchcart.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String viewCart(@AuthenticationPrincipal UserDetails userDetails, Model model) {
        User user = userService.findByEmail(userDetails.getUsername());
        Cart cart = cartService.getCartByUserId(user.getId());
        model.addAttribute("cart", cart);
        return "cart";
    }

    @PostMapping("/add")
    public String addToCart(
            @AuthenticationPrincipal UserDetails userDetails,
            @RequestParam Long productId,
            @RequestParam(defaultValue = "1") int quantity,
            RedirectAttributes redirectAttributes) {
        User user = userService.findByEmail(userDetails.getUsername());
        cartService.addItemToCart(user.getId(), productId, quantity);
        redirectAttributes.addFlashAttribute("successMessage", "Item added to cart!");
        return "redirect:/products/" + productId;
    }

    @PostMapping("/update/{itemId}")
    public String updateCartItem(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long itemId,
            @RequestParam int quantity) {
        User user = userService.findByEmail(userDetails.getUsername());
        cartService.updateItemQuantity(user.getId(), itemId, quantity);
        return "redirect:/cart";
    }

    @PostMapping("/remove/{itemId}")
    public String removeFromCart(
            @AuthenticationPrincipal UserDetails userDetails,
            @PathVariable Long itemId) {
        User user = userService.findByEmail(userDetails.getUsername());
        cartService.removeItemFromCart(user.getId(), itemId);
        return "redirect:/cart";
    }
}
