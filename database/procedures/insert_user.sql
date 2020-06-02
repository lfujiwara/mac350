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
