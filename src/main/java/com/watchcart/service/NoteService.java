package com.watchcart.service;

import com.watchcart.dto.NoteRequest;
import com.watchcart.model.Note;
import com.watchcart.repository.NoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class NoteService {

    @Autowired
    private NoteRepository noteRepository;

    public List<Note> getAll() {
        return noteRepository.findAll();
    }

    public Note getById(Long id) {
        return noteRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Note not found: " + id));
    }

    public Note create(NoteRequest request) {
        Note note = new Note();
        note.setTitle(request.getTitle());
        note.setContent(request.getContent());
        return noteRepository.save(note);
    }

    public Note update(Long id, NoteRequest request) {
        Note note = getById(id);
        note.setTitle(request.getTitle());
        note.setContent(request.getContent());
        return noteRepository.save(note);
    }

    public void delete(Long id) {
        if (!noteRepository.existsById(id)) {
            throw new IllegalArgumentException("Note not found: " + id);
        }
        noteRepository.deleteById(id);
    }
}
