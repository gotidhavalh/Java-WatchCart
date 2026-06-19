package com.watchcart.dto;

import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotBlank;

@Getter
@Setter
public class NoteRequest {

    private String title;

    private String content;
}
