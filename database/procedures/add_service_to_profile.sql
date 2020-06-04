SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_servico_a_perfil (id_servico int, id_perfil int)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO pertence (id_servico, id_perfil)
    VALUES ($1, $2);

$$;
