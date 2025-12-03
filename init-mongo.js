// Conecta-se ao banco 'admin' para criar o usuário
db = db.getSiblingDB('admin');

db.createUser({
    user: process.env.MONGO_USER,
    pwd: process.env.MONGO_PASS,
    roles: [
        {
            role: 'readWrite',
            db: process.env.MONGO_DB_NAME, // Permissão de leitura/escrita apenas no DB da aplicação
        },
    ],
});

// Conecta-se ao banco de dados da aplicação
db = db.getSiblingDB(process.env.MONGO_DB_NAME);

// Cria uma coleção inicial 
db.createCollection('items');