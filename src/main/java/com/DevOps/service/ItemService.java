package com.DevOps.service;

import com.DevOps.model.Item;
import com.DevOps.repository.ItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ItemService {

    @Autowired
    private ItemRepository repository;

    public List<Item> findAll() {
        return repository.findAll();
    }

    public Optional<Item> findById(String id) {
        return repository.findById(id);
    }

    public Item save(Item item) {
        return repository.save(item);
    }

    public Optional<Item> update(String id, Item itemDetails) {
        return repository.findById(id)
                .map(item -> {
                    item.setNome(itemDetails.getNome());
                    item.setDescricao(itemDetails.getDescricao());
                    return repository.save(item);
                });
    }

    public void deleteById(String id) {
        repository.deleteById(id);
    }
}