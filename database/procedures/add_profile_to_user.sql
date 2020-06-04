SET search_path TO exam_tracker;

CREATE FUNCTION adicionar_perfil_a_usuario (id_perfil int, id_usuario int)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO possui (id_perfil, id_usuario)
    VALUES ($1, $2);

$$;
