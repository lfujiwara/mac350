SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_tutor_a_usuario (id_usuario_tutelado int, id_tutor int, id_servico int, id_perfil int, data_de_inicio date, data_de_termino date DEFAULT NULL)
  RETURNS void
  LANGUAGE SQL
  AS $$
  UPDATE pessoa SET id_tutor = $2 WHERE id = $1;
  INSERT INTO tutelamento (id_usuario_tutelado, id_tutor, id_servico, id_perfil, data_de_inicio, data_de_termino)
    VALUES ($1, $2, $3, $4, $5, $6);

$$;
