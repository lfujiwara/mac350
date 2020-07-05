CREATE SCHEMA exam_tracker
CREATE TABLE pessoa (
    id serial PRIMARY KEY,
    cpf char(11) NOT NULL,
    nome varchar(255) NOT NULL,
    area_de_pesquisa varchar(255),
    instituicao varchar(255),
    data_de_nascimento date,
    endereco varchar(255),
    login VARCHAR(255),
    senha varchar(255),
    id_tutor int REFERENCES pessoa (id),
    UNIQUE (cpf),
    UNIQUE (LOGIN)
)
CREATE TABLE perfil (
    id_perfil serial PRIMARY KEY,
    codigo varchar(255) NOT NULL,
    tipo varchar(255),
    UNIQUE (codigo)) --Relacionamento possui
CREATE TABLE possui (
    id serial PRIMARY KEY,
    id_usuario int NOT NULL REFERENCES pessoa (id),
    id_perfil int NOT NULL REFERENCES perfil (id_perfil),
    UNIQUE (id_usuario, id_perfil))
CREATE TABLE servico (
    id_servico serial PRIMARY KEY,
    nome varchar(255) NOT NULL,
    classe varchar(255) NOT NULL CHECK (classe IN ('visualização', 'inserção', 'alteração', 'remoção')),
    UNIQUE (nome, classe)) --Relacionamento pertence
CREATE TABLE pertence (
    id serial PRIMARY KEY,
    id_servico int NOT NULL REFERENCES servico (id_servico),
    id_perfil int NOT NULL REFERENCES perfil (id_perfil),
    UNIQUE (id_servico, id_perfil)) --Relacionamento tutelamento
CREATE TABLE tutelamento (
    id serial PRIMARY KEY,
    id_usuario_tutelado int NOT NULL REFERENCES pessoa (id),
    id_tutor int NOT NULL REFERENCES pessoa (id),
    id_servico int NOT NULL REFERENCES servico (id_servico),
    id_perfil int NOT NULL REFERENCES perfil (id_perfil),
    data_de_inicio date NOT NULL,
    data_de_termino date,
    UNIQUE (id_usuario_tutelado, id_tutor, id_servico, id_perfil))
CREATE TABLE exame (
    id_exame serial PRIMARY KEY,
    tipo varchar(255) NOT NULL,
    virus varchar(255) NOT NULL,
    UNIQUE (tipo, virus)) --Relacionamento gerencia
CREATE TABLE gerencia (
    id serial PRIMARY KEY,
    id_servico int NOT NULL REFERENCES servico (id_servico),
    id_exame int NOT NULL REFERENCES exame (id_exame),
    UNIQUE (id_servico, id_exame)) --Relacionamento realiza
CREATE TABLE realiza (
    id serial PRIMARY KEY,
    id_paciente int NOT NULL REFERENCES pessoa (id),
    id_exame int NOT NULL REFERENCES exame (id_exame),
    codigo_amostra varchar(255),
    data_de_realizacao timestamp,
    data_de_solicitacao timestamp,
    UNIQUE (id_paciente, id_exame, data_de_realizacao)) --Agregado amostra
CREATE TABLE amostra (
    id serial PRIMARY KEY,
    id_paciente int NOT NULL REFERENCES pessoa (id),
    id_exame int NOT NULL REFERENCES exame (id_exame),
    codigo_amostra varchar(255) NOT NULL,
    metodo_de_coleta varchar(255) NOT NULL,
    material varchar(255) NOT NULL,
    UNIQUE (id_paciente, id_exame, codigo_amostra))
CREATE TABLE registro_de_uso (
    id_registro_de_uso serial PRIMARY KEY,
    id_usuario int NOT NULL REFERENCES pessoa (id),
    id_perfil int NOT NULL REFERENCES perfil (id_perfil),
    id_servico int NOT NULL REFERENCES servico (id_servico),
    id_exame int NOT NULL references exame (id_exame),
    data_de_uso timestamp NOT NULL,
    UNIQUE (id_exame, id_servico, id_usuario, data_de_uso)
);
