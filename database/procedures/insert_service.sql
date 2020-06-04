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
