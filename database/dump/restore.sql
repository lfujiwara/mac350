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

CREATE FUNCTION inserir_usuario_tutorcpf (cpf char(11), nome varchar(255), area_de_pesquisa varchar(255), instituicao varchar(255), data_de_nascimento date, LOGIN VARCHAR(255), senha varchar(255), cpf_tutor varchar(11))
  RETURNS int
  LANGUAGE SQL
  AS $$
  INSERT INTO usuario (cpf, nome, area_de_pesquisa, instituicao, data_de_nascimento, LOGIN, senha, id_tutor)
    VALUES ($1, $2, $3, $4, $5, $6, $7, (
        SELECT
          id_usuario
        FROM
          usuario
        WHERE
          usuario.cpf = $8
        LIMIT 1))
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
SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_perfil_a_usuario (id_perfil int, id_usuario int)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO possui (id_perfil, id_usuario)
    VALUES ($1, $2);

$$;
SET search_path TO exam_tracker;

CREATE FUNCTION inserir_servico (nome varchar(255), classe varchar(255))
  RETURNS int
  LANGUAGE SQL
  AS $$
  INSERT INTO servico (nome, classe)
    VALUES ($1, $2)
  RETURNING
    id_servico;

$$;
SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_servico_a_perfil (id_servico int, id_perfil int)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO pertence (id_servico, id_perfil)
    VALUES ($1, $2);

$$;
SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_tutor_a_usuario (id_usuario_tutelado int, id_tutor int, id_servico int, id_perfil int, data_de_inicio date, data_de_termino date DEFAULT NULL)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO tutelamento (id_usuario_tutelado, id_tutor, id_servico, id_perfil, data_de_inicio, data_de_termino)
    VALUES ($1, $2, $3, $4, $5, $6);

$$;
SET search_path TO exam_tracker;

CREATE FUNCTION inserir_paciente (cpf varchar(11), nome varchar(255), endereco varchar(255), nascimento date)
  RETURNS int
  LANGUAGE SQL
  AS $$
  INSERT INTO paciente (cpf, nome, endereco, nascimento)
    VALUES ($1, $2, $3, $4)
  RETURNING
    id_paciente;

$$;
SET search_path TO exam_tracker;

CREATE FUNCTION inserir_exame (tipo varchar(255), virus varchar(255))
  RETURNS int
  LANGUAGE SQL
  AS $$
  INSERT INTO exame (tipo, virus)
    VALUES ($1, $2)
  RETURNING
    id_exame;

$$;
SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_servico_a_exame (id_servico int, id_exame int)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO gerencia (id_servico, id_exame)
    VALUES ($1, $2);

$$;
SET search_path TO exam_tracker;

CREATE FUNCTION inserir_solicitacao_de_exame (id_paciente int, id_exame int, data_de_solicitacao timestamp DEFAULT NULL, data_de_realizacao timestamp DEFAULT NULL, codigo_amostra int DEFAULT NULL)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO realiza (id_paciente, id_exame, codigo_amostra, data_de_realizacao, data_de_solicitacao)
    VALUES ($1, $2, $5, $4, $3);

$$;
SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_amostra (id_paciente int, id_exame int, codigo_amostra varchar(255), metodo_de_coleta varchar(255), material varchar(255))
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO amostra (id_paciente, id_exame, codigo_amostra, metodo_de_coleta, material)
    VALUES ($1, $2, $3, $4, $5);

$$;
SET search_path TO exam_tracker;

CREATE OR REPLACE FUNCTION insere_registro_de_uso (id_usuario int, id_perfil int, id_servico int, data_de_uso date DEFAULT 'now()')
  RETURNS int
  LANGUAGE sql
  AS $function$
  INSERT INTO registro_de_uso (id_perfil, id_servico, id_usuario, data_de_uso)
    VALUES (id_perfil, id_servico, id_usuario, data_de_uso)
  RETURNING
    id_registro_de_uso
$function$;
SET search_path TO exam_tracker;

-- 4.1
CREATE OR REPLACE FUNCTION exam_tracker.get_exames_realizados ()
  RETURNS TABLE (
    nome character varying,
    tipo character varying,
    virus character varying,
    data_de_solicitacao timestamp,
    data_de_realizacao timestamp)
  LANGUAGE sql
  AS $function$
  SELECT
    p.nome,
    e.tipo,
    e.virus,
    r.data_de_realizacao,
    r.data_de_solicitacao
  FROM
    realiza r
    INNER JOIN exam_tracker.exame e ON r.id_exame = e.id_exame
    INNER JOIN exam_tracker.paciente p ON r.id_paciente = p.id_paciente
$function$;

-- 4.2
CREATE OR REPLACE FUNCTION exam_tracker.get_top_fast ()
  RETURNS TABLE (
    codigo_amostra character varying,
    tipo character varying,
    virus character varying,
    data_de_realizacao timestamp,
    data_de_solicitacao timestamp,
    tempo interval)
  LANGUAGE sql
  AS $function$
  SELECT
    r.codigo_amostra,
    e.tipo,
    e.virus,
    r.data_de_realizacao,
    r.data_de_solicitacao,
    (r.data_de_solicitacao - r.data_de_realizacao) AS tempo
  FROM
    exam_tracker.realiza r
    INNER JOIN exam_tracker.exame e ON r.id_exame = e.id_exame
  ORDER BY
    (r.data_de_solicitacao - r.data_de_realizacao)
  LIMIT 5
$function$;

-- 4.3
CREATE OR REPLACE FUNCTION exam_tracker.seleciona_servico_usuario ()
  RETURNS TABLE (
    nome character varying,
    classe character varying,
    nome_de_usuario character varying,
    area_de_pesquisa character varying,
    instituicao character varying)
  LANGUAGE sql
  AS $function$
  SELECT
    s.nome,
    s.classe,
    u.nome AS nome_de_usuario,
    u.area_de_pesquisa,
    u.instituicao
  FROM
    exam_tracker.servico s
    INNER JOIN exam_tracker.pertence p ON s.id_servico = p.id_servico
    INNER JOIN exam_tracker.possui pos ON p.id_perfil = pos.id_perfil
    INNER JOIN exam_tracker.usuario u ON pos.id_usuario = u.id_usuario;

$function$;

-- 4.4
CREATE OR REPLACE FUNCTION exam_tracker.seleciona_servico_usuario_tutelado ()
  RETURNS TABLE (
    nome character varying,
    classe character varying,
    nome_de_usuario character varying,
    area_de_pesquisa character varying,
    instituicao character varying)
  LANGUAGE sql
  AS $function$
  SELECT
    s.nome,
    s.classe,
    u.nome AS nome_de_usuario,
    u.area_de_pesquisa,
    u.instituicao
  FROM
    exam_tracker.servico s
    INNER JOIN exam_tracker.tutelamento t ON s.id_servico = t.id_servico
    INNER JOIN exam_tracker.usuario u ON t.id_usuario_tutelado = u.id_usuario;

$function$;

-- 4.5
CREATE OR REPLACE FUNCTION exam_tracker.seleciona_servico_utilizados ()
  RETURNS TABLE (
    nome character varying,
    codigo character varying,
    qty bigint)
  LANGUAGE sql
  AS $function$
  SELECT
    s.nome,
    p.codigo,
    count(rdu.id_servico) AS qty
  FROM
    exam_tracker.registro_de_uso rdu
    INNER JOIN exam_tracker.servico s ON rdu.id_servico = s.id_servico
    INNER JOIN exam_tracker.perfil p ON rdu.id_perfil = p.id_perfil
  GROUP BY
    rdu.id_servico,
    s.nome,
    p.codigo
  ORDER BY
    qty
$function$;
