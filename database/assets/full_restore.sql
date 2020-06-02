CREATE SCHEMA exam_tracker CREATE TABLE usuario (
  id_usuario serial PRIMARY KEY,
  cpf char(11) NOT NULL,
  nome varchar(255) NOT NULL,
  area_de_pesquisa varchar(255),
  instituicao varchar(255),
  data_de_nascimento date,
  login VARCHAR(255) NOT NULL,
  senha varchar(255) NOT NULL,
  id_tutor int REFERENCES usuario (id_usuario),
  UNIQUE (cpf),
  UNIQUE (LOGIN))
CREATE TABLE perfil (
  id_perfil serial PRIMARY KEY,
  codigo varchar(255) NOT NULL,
  tipo varchar(255),
  UNIQUE (codigo)) --Relacionamento possui
CREATE TABLE possui (
  id_usuario int NOT NULL REFERENCES usuario (id_usuario),
  id_perfil int NOT NULL REFERENCES perfil (id_perfil),
  UNIQUE (id_usuario, id_perfil))
CREATE TABLE servico (
  id_servico serial PRIMARY KEY,
  nome varchar(255) NOT NULL,
  classe varchar(255) NOT NULL CHECK (classe IN ('visualização', 'inserção', 'alteração', 'remoção')),
  UNIQUE (nome, classe)) --Relacionamento pertence
CREATE TABLE pertence (
  id_servico int NOT NULL REFERENCES servico (id_servico),
  id_perfil int NOT NULL REFERENCES perfil (id_perfil),
  UNIQUE (id_servico, id_perfil)) --Relacionamento tutelamento
CREATE TABLE tutelamento (
  id_usuario_tutelado int NOT NULL REFERENCES usuario (id_usuario),
  id_tutor int NOT NULL REFERENCES usuario (id_usuario),
  id_servico int NOT NULL REFERENCES servico (id_servico),
  id_perfil int NOT NULL REFERENCES perfil (id_perfil),
  data_de_inicio date NOT NULL,
  data_de_termino date,
  UNIQUE (id_usuario_tutelado, id_tutor, id_servico, id_perfil))
CREATE TABLE paciente (
  id_paciente serial PRIMARY KEY,
  cpf varchar(11) NOT NULL,
  nome varchar(255) NOT NULL,
  endereco varchar(255) NOT NULL,
  nascimento date NOT NULL,
  UNIQUE (cpf))
CREATE TABLE exame (
  id_exame serial PRIMARY KEY,
  tipo varchar(255) NOT NULL,
  virus varchar(255) NOT NULL,
  UNIQUE (tipo, virus)) --Relacionamento gerencia
CREATE TABLE gerencia (
  id_servico int NOT NULL REFERENCES servico (id_servico),
  id_exame int NOT NULL REFERENCES exame (id_exame),
  UNIQUE (id_servico, id_exame)) --Relacionamento realiza
CREATE TABLE realiza (
  id_paciente int NOT NULL REFERENCES paciente (id_paciente),
  id_exame int NOT NULL REFERENCES exame (id_exame),
  codigo_amostra varchar(255),
  data_de_realizacao timestamp,
  data_de_solicitacao timestamp,
  UNIQUE (id_paciente, id_exame, data_de_realizacao)) --Agregado amostra
CREATE TABLE amostra (
  id_paciente int NOT NULL REFERENCES paciente (id_paciente),
  id_exame int NOT NULL REFERENCES exame (id_exame),
  codigo_amostra varchar(255) NOT NULL,
  metodo_de_coleta varchar(255) NOT NULL,
  material varchar(255) NOT NULL,
  UNIQUE (id_paciente, id_exame, codigo_amostra))
CREATE TABLE registro_de_uso (
  id_registro_de_uso serial PRIMARY KEY,
  id_usuario int NOT NULL REFERENCES usuario (id_usuario),
  id_perfil int NOT NULL REFERENCES perfil (id_perfil),
  id_servico int NOT NULL REFERENCES servico (id_servico),
  data_de_uso timestamp NOT NULL
);

SET search_path TO exam_tracker;

CREATE FUNCTION inserir_usuario (cpf char(11), nome varchar(255), area_de_pesquisa varchar(255), instituicao varchar(255), data_de_nascimento date, LOGIN VARCHAR(255), senha varchar(255), id_tutor int DEFAULT NULL)
  RETURNS int
  LANGUAGE SQL
  AS $$
  INSERT INTO usuario (cpf, nome, area_de_pesquisa, instituicao, data_de_nascimento, LOGIN, senha, id_tutor)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
  RETURNING
    id_usuario;

$$;

SET search_path TO exam_tracker;

CREATE FUNCTION inserir_perfil (codigo varchar(255), tipo varchar(255))
  RETURNS int
  LANGUAGE SQL
  AS $$
  INSERT INTO perfil (codigo, tipo)
    VALUES ($1, $2)
  RETURNING
    id_perfil;

$$;
