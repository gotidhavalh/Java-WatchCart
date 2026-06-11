package com.watchcart.controller;

import com.watchcart.model.Product;
import com.watchcart.repository.CategoryRepository;
import com.watchcart.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/products")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryRepository categoryRepository;

    @GetMapping
    public String listProducts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "12") int size,
            @RequestParam(defaultValue = "name") String sort,
            @RequestParam(required = false) Long category,
            @RequestParam(required = false) String search,
            Model model) {

        Page<Product> products;

        if (search != null && !search.isBlank()) {
            products = productService.searchProducts(search, page, size);
            model.addAttribute("search", search);
        } else if (category != null) {
            products = productService.getAllActiveProducts(page, size, sort);
            model.addAttribute("selectedCategory", category);
        } else {
            products = productService.getAllActiveProducts(page, size, sort);
        }

        model.addAttribute("products", products);
        model.addAttribute("categories", categoryRepository.findAll());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", products.getTotalPages());
        model.addAttribute("sort", sort);
        return "products";
    }

    @GetMapping("/{id}")
    public String productDetail(@PathVariable Long id, Model model) {
        Product product = productService.getProductById(id);
        model.addAttribute("product", product);
        model.addAttribute("relatedProducts",
                productService.getProductsByCategory(product.getCategory().getId()));
        return "product-detail";
    }
}
