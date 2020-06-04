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
