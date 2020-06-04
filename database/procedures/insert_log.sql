SET search_path TO exam_tracker;

CREATE OR REPLACE FUNCTION insere_registro_de_uso (id_usuario int, id_perfil int, id_servico int, data_de_uso date DEFAULT 'now()')
  RETURNS int
  LANGUAGE sql
  AS $function$
  INSERT INTO registro_de_uso (id_perfil, id_servico, id_usuario, data_de_uso)
    VALUES (id_perfil, id_servico, id_usuario, data_de_uso)
  RETURNING
    id_registro_de_uso
$function$;
