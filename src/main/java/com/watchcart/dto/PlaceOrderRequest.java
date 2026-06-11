package com.watchcart.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;

@Getter
@Setter
public class PlaceOrderRequest {

    @NotBlank
    private String shippingAddress;

    @NotBlank
    private String paymentMethod;
}
