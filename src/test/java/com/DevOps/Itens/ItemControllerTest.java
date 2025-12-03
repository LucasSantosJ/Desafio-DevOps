package com.DevOps.Itens;


import com.DevOps.controller.ItemController;
import com.DevOps.model.Item;
import com.DevOps.service.ItemService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.hamcrest.Matchers.is;

@WebMvcTest(ItemController.class)
public class ItemControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private ItemService service;

    @Test
    public void deveListarItens() throws Exception {
        Item item = new Item("Teste", "Descricao Teste");
        item.setId("1");

        Mockito.when(service.findAll()).thenReturn(Arrays.asList(item));

        mockMvc.perform(get("/api/items")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$[0].nome", is("Teste")));
    }

    @Test
    public void deveCriarItem() throws Exception {
        Item item = new Item("Novo", "Nova Descricao");
        Mockito.when(service.save(Mockito.any(Item.class))).thenReturn(item);

        mockMvc.perform(post("/api/items")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"nome\": \"Novo\", \"descricao\": \"Nova Descricao\"}"))
                .andExpect(status().isCreated());
    }
}