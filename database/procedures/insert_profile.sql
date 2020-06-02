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
