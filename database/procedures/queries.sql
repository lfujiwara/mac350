SET search_path TO exam_tracker;

-- 4.1
CREATE OR REPLACE FUNCTION exam_tracker.get_exames_realizados ()
  RETURNS TABLE (
    nome character varying,
    tipo character varying,
    virus character varying,
    data_de_solicitacao timestamp,
    data_de_realizacao timestamp)
  LANGUAGE sql
  AS $function$
  SELECT
    p.nome,
    e.tipo,
    e.virus,
    r.data_de_realizacao,
    r.data_de_solicitacao
  FROM
    realiza r
    INNER JOIN exam_tracker.exame e ON r.id_exame = e.id_exame
    INNER JOIN exam_tracker.paciente p ON r.id_paciente = p.id_paciente
$function$;

-- 4.2
CREATE OR REPLACE FUNCTION exam_tracker.get_top_fast ()
  RETURNS TABLE (
    codigo_amostra character varying,
    tipo character varying,
    virus character varying,
    data_de_realizacao timestamp,
    data_de_solicitacao timestamp,
    tempo interval)
  LANGUAGE sql
  AS $function$
  SELECT
    r.codigo_amostra,
    e.tipo,
    e.virus,
    r.data_de_realizacao,
    r.data_de_solicitacao,
    (r.data_de_solicitacao - r.data_de_realizacao) AS tempo
  FROM
    exam_tracker.realiza r
    INNER JOIN exam_tracker.exame e ON r.id_exame = e.id_exame
  ORDER BY
    (r.data_de_solicitacao - r.data_de_realizacao)
  LIMIT 5
$function$;

-- 4.3
CREATE OR REPLACE FUNCTION exam_tracker.seleciona_servico_usuario ()
  RETURNS TABLE (
    nome character varying,
    classe character varying,
    nome_de_usuario character varying,
    area_de_pesquisa character varying,
    instituicao character varying)
  LANGUAGE sql
  AS $function$
  SELECT
    s.nome,
    s.classe,
    u.nome AS nome_de_usuario,
    u.area_de_pesquisa,
    u.instituicao
  FROM
    exam_tracker.servico s
    INNER JOIN exam_tracker.pertence p ON s.id_servico = p.id_servico
    INNER JOIN exam_tracker.possui pos ON p.id_perfil = pos.id_perfil
    INNER JOIN exam_tracker.usuario u ON pos.id_usuario = u.id_usuario;

$function$;

-- 4.4
CREATE OR REPLACE FUNCTION exam_tracker.seleciona_servico_usuario_tutelado ()
  RETURNS TABLE (
    nome character varying,
    classe character varying,
    nome_de_usuario character varying,
    area_de_pesquisa character varying,
    instituicao character varying)
  LANGUAGE sql
  AS $function$
  SELECT
    s.nome,
    s.classe,
    u.nome AS nome_de_usuario,
    u.area_de_pesquisa,
    u.instituicao
  FROM
    exam_tracker.servico s
    INNER JOIN exam_tracker.tutelamento t ON s.id_servico = t.id_servico
    INNER JOIN exam_tracker.usuario u ON t.id_usuario_tutelado = u.id_usuario;

$function$;

-- 4.5
CREATE OR REPLACE FUNCTION exam_tracker.seleciona_servico_utilizados ()
  RETURNS TABLE (
    nome character varying,
    codigo character varying,
    qty bigint)
  LANGUAGE sql
  AS $function$
  SELECT
    s.nome,
    p.codigo,
    count(rdu.id_servico) AS qty
  FROM
    exam_tracker.registro_de_uso rdu
    INNER JOIN exam_tracker.servico s ON rdu.id_servico = s.id_servico
    INNER JOIN exam_tracker.perfil p ON rdu.id_perfil = p.id_perfil
  GROUP BY
    rdu.id_servico,
    s.nome,
    p.codigo
  ORDER BY
    qty
$function$;
