package com.watchcart.controller;

import com.watchcart.dto.ApiResponse;
import com.watchcart.dto.RegisterRequest;
import com.watchcart.dto.UpdateProfileRequest;
import com.watchcart.model.User;
import com.watchcart.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<User>> register(@Valid @RequestBody RegisterRequest req) {
        User user = new User();
        user.setFullName(req.getFullName());
        user.setEmail(req.getEmail());
        user.setPassword(req.getPassword());
        user.setPhoneNumber(req.getPhoneNumber());
        User saved = userService.registerUser(user);
        saved.setPassword(null);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.ok("Registration successful", saved));
    }

    @GetMapping("/me")
    public ResponseEntity<ApiResponse<User>> getProfile(
            @AuthenticationPrincipal UserDetails userDetails) {
        User user = userService.findByEmail(userDetails.getUsername());
        user.setPassword(null);
        return ResponseEntity.ok(ApiResponse.ok(user));
    }

    @PutMapping("/me")
    public ResponseEntity<ApiResponse<User>> updateProfile(
            @AuthenticationPrincipal UserDetails userDetails,
            @Valid @RequestBody UpdateProfileRequest req) {
        User user = userService.findByEmail(userDetails.getUsername());
        user.setFullName(req.getFullName());
        user.setPhoneNumber(req.getPhoneNumber());
        user.setAddress(req.getAddress());
        User updated = userService.updateUser(user);
        updated.setPassword(null);
        return ResponseEntity.ok(ApiResponse.ok("Profile updated", updated));
    }
}
