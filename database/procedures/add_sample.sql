SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_amostra (id_paciente int, id_exame int, codigo_amostra varchar(255), metodo_de_coleta varchar(255), material varchar(255))
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO amostra (id_paciente, id_exame, codigo_amostra, metodo_de_coleta, material)
    VALUES ($1, $2, $3, $4, $5);

$$;
