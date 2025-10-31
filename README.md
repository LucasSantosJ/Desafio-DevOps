Desafio Docker: API Spring Boot + MongoDB
Este projeto implementa uma API RESTful com Spring Boot (Java 21) que realiza operações CRUD em um banco de dados MongoDB. Todo o ambiente é orquestrado usando Docker e Docker Compose.

Tecnologias Utilizadas
Java 21 e Spring Boot (para a API)

MongoDB (Banco de dados NoSQL)

Docker e Docker Compose (Containerização e orquestração)

Funcionalidades
Ambiente multi-container (aplicação + banco de dados).

API com CRUD completo para uma entidade Item.

Persistência de dados do MongoDB usando volumes Docker.

Rede Docker customizada para comunicação isolada.

Configuração segura de variáveis de ambiente usando um arquivo .env.

Criação de usuário não-root no MongoDB com permissões limitadas (init-mongo.js).

Dockerfile multi-estágio com imagem Alpine (Java 21) para uma build otimizada.

Pré-requisitos
Docker (com Docker Compose V2)

Como Executar
Clone o repositório:

Bash

git clone <url-do-repositorio>
cd <nome-do-repositorio>
Crie o arquivo .env: Na raiz do projeto, crie um arquivo chamado .env com o seguinte conteúdo:

Ini, TOML

# Credenciais do Root do MongoDB (usado apenas na inicialização)
MONGO_ROOT_USER=root
MONGO_ROOT_PASS=root_secret_password_123

# Credenciais do Usuário da Aplicação
MONGO_USER=appuser
MONGO_PASS=app_secret_password_456
MONGO_DB_NAME=meudb
Suba os containers: Use o Docker Compose para construir as imagens e iniciar os containers. (Nota: Usamos docker compose com espaço, que é a sintaxe moderna, e sudo caso seu usuário não esteja no grupo docker).

Bash

sudo docker compose up --build -d
Testando a API
A aplicação estará disponível em http://localhost:8080. O endpoint principal é /api/items.

Você pode usar curl ou uma ferramenta como Insomnia/Postman.

1. Criar um Item (POST)
   Endpoint: POST /api/items

Importante: Este endpoint espera um Content-Type: application/json, que foi a causa do erro 400 (Bad Request).

Bash

curl -X POST http://localhost:8080/api/items \
-H "Content-Type: application/json" \
-d '{
"nome": "Meu Primeiro Item",
"descricao": "Este é um item de teste."
}'
Nota: Copie o id retornado para usar nos próximos comandos.

2. Listar todos os Itens (GET)
   Endpoint: GET /api/items

Bash

curl http://localhost:8080/api/items
3. Buscar um Item por ID (GET)
   Endpoint: GET /api/items/{id}

Bash

curl http://localhost:8080/api/items/{ID_DO_ITEM}
4. Atualizar um Item (PUT)
   Endpoint: PUT /api/items/{id}

Bash

curl -X PUT http://localhost:8080/api/items/{ID_DO_ITEM} \
-H "Content-Type: application/json" \
-d '{
"nome": "Item Atualizado",
"descricao": "Nova descrição."
}'
5. Deletar um Item (DELETE)
   Endpoint: DELETE /api/items/{id}

Bash

curl -X DELETE http://localhost:8080/api/items/{ID_DO_ITEM}
Parando o Ambiente
Para parar e remover os containers, redes e volumes, execute:

Bash

sudo docker compose down