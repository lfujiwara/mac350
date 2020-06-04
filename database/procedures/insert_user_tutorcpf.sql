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
