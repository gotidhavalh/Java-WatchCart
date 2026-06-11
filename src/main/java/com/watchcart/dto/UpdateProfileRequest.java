package com.watchcart.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Size;

@Getter
@Setter
public class UpdateProfileRequest {

    @NotBlank
    @Size(min = 2, max = 60)
    private String fullName;

    private String phoneNumber;

    private String address;
}
