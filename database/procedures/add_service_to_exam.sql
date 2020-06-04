SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_servico_a_exame (id_servico int, id_exame int)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO gerencia (id_servico, id_exame)
    VALUES ($1, $2);

$$;
