package com.watchcart.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Min;
import javax.validation.constraints.NotNull;

@Getter
@Setter
public class AddToCartRequest {

    @NotNull
    private Long productId;

    @Min(1)
    private int quantity = 1;
}
