package com.watchcart.controller;

import com.watchcart.dto.ApiResponse;
import com.watchcart.dto.NoteRequest;
import com.watchcart.model.Note;
import com.watchcart.service.NoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/notes")
public class NoteController {

    @Autowired
    private NoteService noteService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<Note>>> getAll() {
        return ResponseEntity.ok(ApiResponse.ok(noteService.getAll()));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Note>> getById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(noteService.getById(id)));
    }

    @PostMapping
    public Note create(@Valid @RequestBody NoteRequest request) {
        return noteService.create(request);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Note>> update(
            @PathVariable Long id,
            @Valid @RequestBody NoteRequest request) {
        return ResponseEntity.ok(ApiResponse.ok("Note updated", noteService.update(id, request)));
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        noteService.delete(id);
    }
}
