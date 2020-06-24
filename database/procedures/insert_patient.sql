SET search_path TO exam_tracker;

CREATE FUNCTION inserir_paciente (cpf varchar(11), nome varchar(255), endereco varchar(255), data_de_nascimento date)
  RETURNS int
  LANGUAGE SQL
  AS $$
  INSERT INTO pessoa (cpf, nome, endereco, data_de_nascimento)
    VALUES ($1, $2, $3, $4)
  RETURNING
    id;

$$;
