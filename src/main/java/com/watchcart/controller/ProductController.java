package com.watchcart.controller;

import com.watchcart.dto.ApiResponse;
import com.watchcart.model.Category;
import com.watchcart.model.Product;
import com.watchcart.repository.CategoryRepository;
import com.watchcart.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryRepository categoryRepository;

    @GetMapping
    public ResponseEntity<ApiResponse<Page<Product>>> listProducts(
            @RequestParam(defaultValue = "0")  int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(defaultValue = "name") String sort,
            @RequestParam(required = false) String search) {

        Page<Product> products = (search != null && !search.isBlank())
                ? productService.searchProducts(search, page, size)
                : productService.getAllActiveProducts(page, size, sort);

        return ResponseEntity.ok(ApiResponse.ok(products));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Product>> getProduct(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(productService.getProductById(id)));
    }

    @GetMapping("/new-arrivals")
    public ResponseEntity<ApiResponse<List<Product>>> newArrivals() {
        return ResponseEntity.ok(ApiResponse.ok(productService.getNewArrivals()));
    }

    @GetMapping("/category/{categoryId}")
    public ResponseEntity<ApiResponse<List<Product>>> byCategory(@PathVariable Long categoryId) {
        return ResponseEntity.ok(ApiResponse.ok(productService.getProductsByCategory(categoryId)));
    }

    @GetMapping("/categories")
    public ResponseEntity<ApiResponse<List<Category>>> allCategories() {
        return ResponseEntity.ok(ApiResponse.ok(categoryRepository.findAll()));
    }
}
