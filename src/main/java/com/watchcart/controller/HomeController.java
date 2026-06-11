package com.watchcart.controller;

import com.watchcart.model.Product;
import com.watchcart.repository.CategoryRepository;
import com.watchcart.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private ProductService productService;

    @Autowired
    private CategoryRepository categoryRepository;

    @GetMapping("/")
    public String home(Model model) {
        List<Product> newArrivals = productService.getNewArrivals();
        model.addAttribute("newArrivals", newArrivals);
        model.addAttribute("categories", categoryRepository.findAll());
        return "index";
    }
}
