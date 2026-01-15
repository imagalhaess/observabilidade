-- PostgreSQL database initialization script

CREATE TABLE IF NOT EXISTS usuario (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    email VARCHAR(255) NOT NULL,
    senha VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS perfil (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS usuario_perfis (
    usuario_id INTEGER NOT NULL,
    perfis_id INTEGER NOT NULL,
    PRIMARY KEY (usuario_id, perfis_id)
);

CREATE TABLE IF NOT EXISTS curso (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL,
    categoria TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS resposta (
    id SERIAL PRIMARY KEY,
    autor_id INTEGER NOT NULL,
    topico_id INTEGER NOT NULL,
    mensagem TEXT NOT NULL,
    solucao TEXT NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS topico (
    id SERIAL PRIMARY KEY,
    titulo TEXT NOT NULL,
    mensagem TEXT NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status TEXT NOT NULL,
    autor_id INTEGER NOT NULL,
    curso_id INTEGER NOT NULL
);

-- Insert initial data
INSERT INTO usuario(nome, email, senha) VALUES('Aluno', 'aluno@email.com', '$2a$10$sFKmbxbG4ryhwPNx/l3pgOJSt.fW1z6YcUnuE2X8APA/Z3NI/oSpq');
INSERT INTO usuario(nome, email, senha) VALUES('Moderador', 'moderador@email.com', '$2a$10$sFKmbxbG4ryhwPNx/l3pgOJSt.fW1z6YcUnuE2X8APA/Z3NI/oSpq');
INSERT INTO perfil(id, nome) VALUES(1, 'ROLE_ALUNO');
INSERT INTO perfil(id, nome) VALUES(2, 'ROLE_MODERADOR');
INSERT INTO usuario_perfis(usuario_id, perfis_id) VALUES(1, 1);
INSERT INTO usuario_perfis(usuario_id, perfis_id) VALUES(2, 2);
INSERT INTO curso(nome, categoria) VALUES('Spring Boot', 'Programacao');
INSERT INTO curso(nome, categoria) VALUES('HTML 5', 'Front-end');
INSERT INTO topico(titulo, mensagem, data_criacao, status, autor_id, curso_id) VALUES('Duvida 1', 'Erro ao criar projeto', '2019-05-05 18:00:00', 'NAO_RESPONDIDO', 1, 1);
INSERT INTO topico(titulo, mensagem, data_criacao, status, autor_id, curso_id) VALUES('Duvida 2', 'Projeto nao compila', '2019-05-05 19:00:00', 'NAO_RESPONDIDO', 1, 1);
INSERT INTO topico(titulo, mensagem, data_criacao, status, autor_id, curso_id) VALUES('Duvida 3', 'Tag HTML', '2019-05-05 20:00:00', 'NAO_RESPONDIDO', 1, 2);
