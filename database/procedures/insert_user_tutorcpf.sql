SET search_path TO exam_tracker;

CREATE FUNCTION inserir_usuario_tutorcpf (
  cpf char(11), nome varchar(255), area_de_pesquisa varchar(255), instituicao varchar(255), data_de_nascimento date, LOGIN VARCHAR(255), senha varchar(255),
  cpf_tutor varchar(11), id_servico int, id_perfil int, data_de_inicio date, data_de_termino date DEFAULT NULL)
  RETURNS int
  LANGUAGE SQL
  AS $$
  INSERT INTO pessoa (cpf, nome, area_de_pesquisa, instituicao, data_de_nascimento, LOGIN, senha, id_tutor)
    VALUES ($1, $2, $3, $4, $5, $6, $7, (SELECT id FROM pessoa WHERE pessoa.cpf = $8 LIMIT 1));
  INSERT INTO tutelamento (id_usuario_tutelado, id_tutor, id_servico, id_perfil, data_de_inicio, data_de_termino)
    VALUES (
      (SELECT id FROM pessoa WHERE pessoa.cpf = $1 LIMIT 1),
      (SELECT id FROM pessoa WHERE pessoa.cpf = $8 LIMIT 1),
      $9, $10, $11, $12)
  RETURNING
    id_usuario_tutelado;
$$;
