SET search_path TO exam_tracker;

CREATE FUNCTION inserir_solicitacao_de_exame (id_paciente int, id_exame int, data_de_solicitacao timestamp DEFAULT NULL, data_de_realizacao timestamp DEFAULT NULL, codigo_amostra int DEFAULT NULL)
  RETURNS void
  LANGUAGE SQL
  AS $$
  INSERT INTO realiza (id_paciente, id_exame, codigo_amostra, data_de_realizacao, data_de_solicitacao)
    VALUES ($1, $2, $5, $4, $3);

$$;
