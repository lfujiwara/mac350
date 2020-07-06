PGDMP     ,                    x            MAC350_2020    12.3    12.3 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    MAC350_2020    DATABASE     }   CREATE DATABASE "MAC350_2020" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.utf8' LC_CTYPE = 'en_US.utf8';
    DROP DATABASE "MAC350_2020";
                MAC350_2020    false                        2615    16385    exam_tracker    SCHEMA        CREATE SCHEMA exam_tracker;
    DROP SCHEMA exam_tracker;
                MAC350_2020    false            �            1255    16620 \   adicionar_amostra(integer, integer, character varying, character varying, character varying)    FUNCTION     f  CREATE FUNCTION exam_tracker.adicionar_amostra(id_paciente integer, id_exame integer, codigo_amostra character varying, metodo_de_coleta character varying, material character varying) RETURNS void
    LANGUAGE sql
    AS $_$
  INSERT INTO amostra (id_paciente, id_exame, codigo_amostra, metodo_de_coleta, material)
    VALUES ($1, $2, $3, $4, $5);

$_$;
 �   DROP FUNCTION exam_tracker.adicionar_amostra(id_paciente integer, id_exame integer, codigo_amostra character varying, metodo_de_coleta character varying, material character varying);
       exam_tracker          MAC350_2020    false    8            �            1255    16612 ,   adicionar_perfil_a_usuario(integer, integer)    FUNCTION     �   CREATE FUNCTION exam_tracker.adicionar_perfil_a_usuario(id_perfil integer, id_usuario integer) RETURNS void
    LANGUAGE sql
    AS $_$
  INSERT INTO possui (id_perfil, id_usuario)
    VALUES ($1, $2);

$_$;
 ^   DROP FUNCTION exam_tracker.adicionar_perfil_a_usuario(id_perfil integer, id_usuario integer);
       exam_tracker          MAC350_2020    false    8            �            1255    16618 +   adicionar_servico_a_exame(integer, integer)    FUNCTION     �   CREATE FUNCTION exam_tracker.adicionar_servico_a_exame(id_servico integer, id_exame integer) RETURNS void
    LANGUAGE sql
    AS $_$
  INSERT INTO gerencia (id_servico, id_exame)
    VALUES ($1, $2);

$_$;
 \   DROP FUNCTION exam_tracker.adicionar_servico_a_exame(id_servico integer, id_exame integer);
       exam_tracker          MAC350_2020    false    8            �            1255    16614 ,   adicionar_servico_a_perfil(integer, integer)    FUNCTION     �   CREATE FUNCTION exam_tracker.adicionar_servico_a_perfil(id_servico integer, id_perfil integer) RETURNS void
    LANGUAGE sql
    AS $_$
  INSERT INTO pertence (id_servico, id_perfil)
    VALUES ($1, $2);

$_$;
 ^   DROP FUNCTION exam_tracker.adicionar_servico_a_perfil(id_servico integer, id_perfil integer);
       exam_tracker          MAC350_2020    false    8            �            1255    16615 I   adicionar_tutor_a_usuario(integer, integer, integer, integer, date, date)    FUNCTION     �  CREATE FUNCTION exam_tracker.adicionar_tutor_a_usuario(id_usuario_tutelado integer, id_tutor integer, id_servico integer, id_perfil integer, data_de_inicio date, data_de_termino date DEFAULT NULL::date) RETURNS void
    LANGUAGE sql
    AS $_$
  UPDATE pessoa SET id_tutor = $2 WHERE id = $1;
  INSERT INTO tutelamento (id_usuario_tutelado, id_tutor, id_servico, id_perfil, data_de_inicio, data_de_termino)
    VALUES ($1, $2, $3, $4, $5, $6);

$_$;
 �   DROP FUNCTION exam_tracker.adicionar_tutor_a_usuario(id_usuario_tutelado integer, id_tutor integer, id_servico integer, id_perfil integer, data_de_inicio date, data_de_termino date);
       exam_tracker          MAC350_2020    false    8                       1255    16622    get_exames_realizados()    FUNCTION     
  CREATE FUNCTION exam_tracker.get_exames_realizados() RETURNS TABLE(nome character varying, tipo character varying, virus character varying, data_de_solicitacao timestamp without time zone, data_de_realizacao timestamp without time zone)
    LANGUAGE sql
    AS $$
  SELECT
    p.nome,
    e.tipo,
    e.virus,
    r.data_de_realizacao,
    r.data_de_solicitacao
  FROM
    realiza r
    INNER JOIN exam_tracker.exame e ON r.id_exame = e.id_exame
    INNER JOIN exam_tracker.pessoa p ON r.id_paciente = p.id
$$;
 4   DROP FUNCTION exam_tracker.get_exames_realizados();
       exam_tracker          MAC350_2020    false    8                       1255    16623    get_top_fast()    FUNCTION     }  CREATE FUNCTION exam_tracker.get_top_fast() RETURNS TABLE(codigo_amostra character varying, tipo character varying, virus character varying, data_de_realizacao timestamp without time zone, data_de_solicitacao timestamp without time zone, tempo interval)
    LANGUAGE sql
    AS $$
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
$$;
 +   DROP FUNCTION exam_tracker.get_top_fast();
       exam_tracker          MAC350_2020    false    8                        1255    16621 7   insere_registro_de_uso(integer, integer, integer, date)    FUNCTION     ~  CREATE FUNCTION exam_tracker.insere_registro_de_uso(id_usuario integer, id_perfil integer, id_servico integer, data_de_uso date DEFAULT '2020-07-05'::date) RETURNS integer
    LANGUAGE sql
    AS $$
  INSERT INTO registro_de_uso (id_perfil, id_servico, id_usuario, data_de_uso)
    VALUES (id_perfil, id_servico, id_usuario, data_de_uso)
  RETURNING
    id_registro_de_uso
$$;
 �   DROP FUNCTION exam_tracker.insere_registro_de_uso(id_usuario integer, id_perfil integer, id_servico integer, data_de_uso date);
       exam_tracker          MAC350_2020    false    8            �            1255    16617 3   inserir_exame(character varying, character varying)    FUNCTION     �   CREATE FUNCTION exam_tracker.inserir_exame(tipo character varying, virus character varying) RETURNS integer
    LANGUAGE sql
    AS $_$
  INSERT INTO exame (tipo, virus)
    VALUES ($1, $2)
  RETURNING
    id_exame;

$_$;
 [   DROP FUNCTION exam_tracker.inserir_exame(tipo character varying, virus character varying);
       exam_tracker          MAC350_2020    false    8            �            1255    16616 O   inserir_paciente(character varying, character varying, character varying, date)    FUNCTION     9  CREATE FUNCTION exam_tracker.inserir_paciente(cpf character varying, nome character varying, endereco character varying, data_de_nascimento date) RETURNS integer
    LANGUAGE sql
    AS $_$
  INSERT INTO pessoa (cpf, nome, endereco, data_de_nascimento)
    VALUES ($1, $2, $3, $4)
  RETURNING
    id;

$_$;
 �   DROP FUNCTION exam_tracker.inserir_paciente(cpf character varying, nome character varying, endereco character varying, data_de_nascimento date);
       exam_tracker          MAC350_2020    false    8            �            1255    16611 4   inserir_perfil(character varying, character varying)    FUNCTION     �   CREATE FUNCTION exam_tracker.inserir_perfil(codigo character varying, tipo character varying) RETURNS integer
    LANGUAGE sql
    AS $_$
  INSERT INTO perfil (codigo, tipo)
    VALUES ($1, $2)
  RETURNING
    id_perfil;

$_$;
 ]   DROP FUNCTION exam_tracker.inserir_perfil(codigo character varying, tipo character varying);
       exam_tracker          MAC350_2020    false    8            �            1255    16613 5   inserir_servico(character varying, character varying)    FUNCTION     �   CREATE FUNCTION exam_tracker.inserir_servico(nome character varying, classe character varying) RETURNS integer
    LANGUAGE sql
    AS $_$
  INSERT INTO servico (nome, classe)
    VALUES ($1, $2)
  RETURNING
    id_servico;

$_$;
 ^   DROP FUNCTION exam_tracker.inserir_servico(nome character varying, classe character varying);
       exam_tracker          MAC350_2020    false    8            �            1255    16619 q   inserir_solicitacao_de_exame(integer, integer, timestamp without time zone, timestamp without time zone, integer)    FUNCTION     �  CREATE FUNCTION exam_tracker.inserir_solicitacao_de_exame(id_paciente integer, id_exame integer, data_de_solicitacao timestamp without time zone DEFAULT NULL::timestamp without time zone, data_de_realizacao timestamp without time zone DEFAULT NULL::timestamp without time zone, codigo_amostra integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE sql
    AS $_$
  INSERT INTO realiza (id_paciente, id_exame, codigo_amostra, data_de_realizacao, data_de_solicitacao)
    VALUES ($1, $2, $5, $4, $3);

$_$;
 �   DROP FUNCTION exam_tracker.inserir_solicitacao_de_exame(id_paciente integer, id_exame integer, data_de_solicitacao timestamp without time zone, data_de_realizacao timestamp without time zone, codigo_amostra integer);
       exam_tracker          MAC350_2020    false    8            �            1255    16609 �   inserir_usuario(character, character varying, character varying, character varying, date, character varying, character varying, integer)    FUNCTION     �  CREATE FUNCTION exam_tracker.inserir_usuario(cpf character, nome character varying, area_de_pesquisa character varying, instituicao character varying, data_de_nascimento date, login character varying, senha character varying, id_tutor integer DEFAULT NULL::integer) RETURNS integer
    LANGUAGE sql
    AS $_$
  INSERT INTO pessoa (cpf, nome, area_de_pesquisa, instituicao, data_de_nascimento, LOGIN, senha, id_tutor)
    VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
  RETURNING
    id;

$_$;
 �   DROP FUNCTION exam_tracker.inserir_usuario(cpf character, nome character varying, area_de_pesquisa character varying, instituicao character varying, data_de_nascimento date, login character varying, senha character varying, id_tutor integer);
       exam_tracker          MAC350_2020    false    8            �            1255    16610 �   inserir_usuario_tutorcpf(character, character varying, character varying, character varying, date, character varying, character varying, character varying, integer, integer, date, date)    FUNCTION     �  CREATE FUNCTION exam_tracker.inserir_usuario_tutorcpf(cpf character, nome character varying, area_de_pesquisa character varying, instituicao character varying, data_de_nascimento date, login character varying, senha character varying, cpf_tutor character varying, id_servico integer, id_perfil integer, data_de_inicio date, data_de_termino date DEFAULT NULL::date) RETURNS integer
    LANGUAGE sql
    AS $_$
  INSERT INTO pessoa (cpf, nome, area_de_pesquisa, instituicao, data_de_nascimento, LOGIN, senha, id_tutor)
    VALUES ($1, $2, $3, $4, $5, $6, $7, (SELECT id FROM pessoa WHERE pessoa.cpf = $8 LIMIT 1));
  INSERT INTO tutelamento (id_usuario_tutelado, id_tutor, id_servico, id_perfil, data_de_inicio, data_de_termino)
    VALUES (
      (SELECT id FROM pessoa WHERE pessoa.cpf = $1 LIMIT 1),
      (SELECT id FROM pessoa WHERE pessoa.cpf = $8 LIMIT 1),
      $9, $10, $11, $12)
  RETURNING
    id_usuario_tutelado;
$_$;
 Y  DROP FUNCTION exam_tracker.inserir_usuario_tutorcpf(cpf character, nome character varying, area_de_pesquisa character varying, instituicao character varying, data_de_nascimento date, login character varying, senha character varying, cpf_tutor character varying, id_servico integer, id_perfil integer, data_de_inicio date, data_de_termino date);
       exam_tracker          MAC350_2020    false    8                       1255    16624    seleciona_servico_usuario()    FUNCTION     �  CREATE FUNCTION exam_tracker.seleciona_servico_usuario() RETURNS TABLE(nome character varying, classe character varying, nome_de_usuario character varying, area_de_pesquisa character varying, instituicao character varying)
    LANGUAGE sql
    AS $$
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
    INNER JOIN exam_tracker.pessoa u ON pos.id_usuario = u.id
  group by nome_de_usuario, s.nome,s.classe,u.area_de_pesquisa,u.instituicao;
$$;
 8   DROP FUNCTION exam_tracker.seleciona_servico_usuario();
       exam_tracker          MAC350_2020    false    8                       1255    16625 $   seleciona_servico_usuario_tutelado()    FUNCTION     s  CREATE FUNCTION exam_tracker.seleciona_servico_usuario_tutelado() RETURNS TABLE(nome character varying, classe character varying, nome_de_usuario character varying, area_de_pesquisa character varying, instituicao character varying)
    LANGUAGE sql
    AS $$
  SELECT
    s.nome,
    s.classe,
    u.nome AS nome_de_usuario,
    u.area_de_pesquisa,
    u.instituicao
  FROM
    exam_tracker.servico s
    INNER JOIN exam_tracker.tutelamento t ON s.id_servico = t.id_servico
    INNER JOIN exam_tracker.pessoa u ON t.id_usuario_tutelado = u.id
  WHERE t.data_de_inicio <= now() AND t.data_de_termino >= now();

$$;
 A   DROP FUNCTION exam_tracker.seleciona_servico_usuario_tutelado();
       exam_tracker          MAC350_2020    false    8                       1255    16626    seleciona_servico_utilizados()    FUNCTION       CREATE FUNCTION exam_tracker.seleciona_servico_utilizados() RETURNS TABLE(nome character varying, codigo character varying, qty bigint)
    LANGUAGE sql
    AS $$
  SELECT
    s.nome,
    p.codigo,
    count(rdu.id_servico) AS qty
  FROM
    exam_tracker.registro_de_uso rdu
    INNER JOIN exam_tracker.servico s ON rdu.id_servico = s.id_servico
    INNER JOIN exam_tracker.perfil p ON rdu.id_perfil = p.id_perfil
  GROUP by
    s.classe,
    rdu.id_servico,
    s.nome,
    p.codigo
  ORDER BY
    qty
$$;
 ;   DROP FUNCTION exam_tracker.seleciona_servico_utilizados();
       exam_tracker          MAC350_2020    false    8            �            1259    16558    amostra    TABLE       CREATE TABLE exam_tracker.amostra (
    id integer NOT NULL,
    id_paciente integer NOT NULL,
    id_exame integer NOT NULL,
    codigo_amostra character varying(255) NOT NULL,
    metodo_de_coleta character varying(255) NOT NULL,
    material character varying(255) NOT NULL
);
 !   DROP TABLE exam_tracker.amostra;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16556    amostra_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.amostra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE exam_tracker.amostra_id_seq;
       exam_tracker          MAC350_2020    false    222    8            �           0    0    amostra_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE exam_tracker.amostra_id_seq OWNED BY exam_tracker.amostra.id;
          exam_tracker          MAC350_2020    false    221            �            1259    16658 
   auth_group    TABLE     l   CREATE TABLE exam_tracker.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);
 $   DROP TABLE exam_tracker.auth_group;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16656    auth_group_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE exam_tracker.auth_group_id_seq;
       exam_tracker          MAC350_2020    false    232    8            �           0    0    auth_group_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE exam_tracker.auth_group_id_seq OWNED BY exam_tracker.auth_group.id;
          exam_tracker          MAC350_2020    false    231            �            1259    16668    auth_group_permissions    TABLE     �   CREATE TABLE exam_tracker.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);
 0   DROP TABLE exam_tracker.auth_group_permissions;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16666    auth_group_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 :   DROP SEQUENCE exam_tracker.auth_group_permissions_id_seq;
       exam_tracker          MAC350_2020    false    234    8            �           0    0    auth_group_permissions_id_seq    SEQUENCE OWNED BY     k   ALTER SEQUENCE exam_tracker.auth_group_permissions_id_seq OWNED BY exam_tracker.auth_group_permissions.id;
          exam_tracker          MAC350_2020    false    233            �            1259    16650    auth_permission    TABLE     �   CREATE TABLE exam_tracker.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);
 )   DROP TABLE exam_tracker.auth_permission;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16648    auth_permission_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE exam_tracker.auth_permission_id_seq;
       exam_tracker          MAC350_2020    false    230    8            �           0    0    auth_permission_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE exam_tracker.auth_permission_id_seq OWNED BY exam_tracker.auth_permission.id;
          exam_tracker          MAC350_2020    false    229            �            1259    16676 	   auth_user    TABLE     �  CREATE TABLE exam_tracker.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);
 #   DROP TABLE exam_tracker.auth_user;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16686    auth_user_groups    TABLE     �   CREATE TABLE exam_tracker.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);
 *   DROP TABLE exam_tracker.auth_user_groups;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16684    auth_user_groups_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE exam_tracker.auth_user_groups_id_seq;
       exam_tracker          MAC350_2020    false    8    238            �           0    0    auth_user_groups_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE exam_tracker.auth_user_groups_id_seq OWNED BY exam_tracker.auth_user_groups.id;
          exam_tracker          MAC350_2020    false    237            �            1259    16674    auth_user_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE exam_tracker.auth_user_id_seq;
       exam_tracker          MAC350_2020    false    236    8            �           0    0    auth_user_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE exam_tracker.auth_user_id_seq OWNED BY exam_tracker.auth_user.id;
          exam_tracker          MAC350_2020    false    235            �            1259    16694    auth_user_user_permissions    TABLE     �   CREATE TABLE exam_tracker.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);
 4   DROP TABLE exam_tracker.auth_user_user_permissions;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16692 !   auth_user_user_permissions_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE exam_tracker.auth_user_user_permissions_id_seq;
       exam_tracker          MAC350_2020    false    8    240            �           0    0 !   auth_user_user_permissions_id_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE exam_tracker.auth_user_user_permissions_id_seq OWNED BY exam_tracker.auth_user_user_permissions.id;
          exam_tracker          MAC350_2020    false    239            �            1259    16754    django_admin_log    TABLE     �  CREATE TABLE exam_tracker.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);
 *   DROP TABLE exam_tracker.django_admin_log;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16752    django_admin_log_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE exam_tracker.django_admin_log_id_seq;
       exam_tracker          MAC350_2020    false    8    242            �           0    0    django_admin_log_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE exam_tracker.django_admin_log_id_seq OWNED BY exam_tracker.django_admin_log.id;
          exam_tracker          MAC350_2020    false    241            �            1259    16640    django_content_type    TABLE     �   CREATE TABLE exam_tracker.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);
 -   DROP TABLE exam_tracker.django_content_type;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16638    django_content_type_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE exam_tracker.django_content_type_id_seq;
       exam_tracker          MAC350_2020    false    228    8            �           0    0    django_content_type_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE exam_tracker.django_content_type_id_seq OWNED BY exam_tracker.django_content_type.id;
          exam_tracker          MAC350_2020    false    227            �            1259    16629    django_migrations    TABLE     �   CREATE TABLE exam_tracker.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);
 +   DROP TABLE exam_tracker.django_migrations;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16627    django_migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE exam_tracker.django_migrations_id_seq;
       exam_tracker          MAC350_2020    false    8    226            �           0    0    django_migrations_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE exam_tracker.django_migrations_id_seq OWNED BY exam_tracker.django_migrations.id;
          exam_tracker          MAC350_2020    false    225            �            1259    16785    django_session    TABLE     �   CREATE TABLE exam_tracker.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);
 (   DROP TABLE exam_tracker.django_session;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16505    exame    TABLE     �   CREATE TABLE exam_tracker.exame (
    id_exame integer NOT NULL,
    tipo character varying(255) NOT NULL,
    virus character varying(255) NOT NULL
);
    DROP TABLE exam_tracker.exame;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16503    exame_id_exame_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.exame_id_exame_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE exam_tracker.exame_id_exame_seq;
       exam_tracker          MAC350_2020    false    8    216            �           0    0    exame_id_exame_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE exam_tracker.exame_id_exame_seq OWNED BY exam_tracker.exame.id_exame;
          exam_tracker          MAC350_2020    false    215            �            1259    16518    gerencia    TABLE     �   CREATE TABLE exam_tracker.gerencia (
    id integer NOT NULL,
    id_servico integer NOT NULL,
    id_exame integer NOT NULL
);
 "   DROP TABLE exam_tracker.gerencia;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16516    gerencia_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.gerencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE exam_tracker.gerencia_id_seq;
       exam_tracker          MAC350_2020    false    8    218            �           0    0    gerencia_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE exam_tracker.gerencia_id_seq OWNED BY exam_tracker.gerencia.id;
          exam_tracker          MAC350_2020    false    217            �            1259    16408    perfil    TABLE     �   CREATE TABLE exam_tracker.perfil (
    id_perfil integer NOT NULL,
    codigo character varying(255) NOT NULL,
    tipo character varying(255)
);
     DROP TABLE exam_tracker.perfil;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16406    perfil_id_perfil_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.perfil_id_perfil_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE exam_tracker.perfil_id_perfil_seq;
       exam_tracker          MAC350_2020    false    8    206            �           0    0    perfil_id_perfil_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE exam_tracker.perfil_id_perfil_seq OWNED BY exam_tracker.perfil.id_perfil;
          exam_tracker          MAC350_2020    false    205            �            1259    16455    pertence    TABLE     �   CREATE TABLE exam_tracker.pertence (
    id integer NOT NULL,
    id_servico integer NOT NULL,
    id_perfil integer NOT NULL
);
 "   DROP TABLE exam_tracker.pertence;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16453    pertence_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.pertence_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE exam_tracker.pertence_id_seq;
       exam_tracker          MAC350_2020    false    212    8            �           0    0    pertence_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE exam_tracker.pertence_id_seq OWNED BY exam_tracker.pertence.id;
          exam_tracker          MAC350_2020    false    211            �            1259    16388    pessoa    TABLE     y  CREATE TABLE exam_tracker.pessoa (
    id integer NOT NULL,
    cpf character(11) NOT NULL,
    nome character varying(255) NOT NULL,
    area_de_pesquisa character varying(255),
    instituicao character varying(255),
    data_de_nascimento date,
    endereco character varying(255),
    login character varying(255),
    senha character varying(255),
    id_tutor integer
);
     DROP TABLE exam_tracker.pessoa;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16386    pessoa_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.pessoa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE exam_tracker.pessoa_id_seq;
       exam_tracker          MAC350_2020    false    8    204            �           0    0    pessoa_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE exam_tracker.pessoa_id_seq OWNED BY exam_tracker.pessoa.id;
          exam_tracker          MAC350_2020    false    203            �            1259    16421    possui    TABLE        CREATE TABLE exam_tracker.possui (
    id integer NOT NULL,
    id_usuario integer NOT NULL,
    id_perfil integer NOT NULL
);
     DROP TABLE exam_tracker.possui;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16419    possui_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.possui_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE exam_tracker.possui_id_seq;
       exam_tracker          MAC350_2020    false    8    208            �           0    0    possui_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE exam_tracker.possui_id_seq OWNED BY exam_tracker.possui.id;
          exam_tracker          MAC350_2020    false    207            �            1259    16538    realiza    TABLE       CREATE TABLE exam_tracker.realiza (
    id integer NOT NULL,
    id_paciente integer NOT NULL,
    id_exame integer NOT NULL,
    codigo_amostra character varying(255),
    data_de_realizacao timestamp without time zone,
    data_de_solicitacao timestamp without time zone
);
 !   DROP TABLE exam_tracker.realiza;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16536    realiza_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.realiza_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE exam_tracker.realiza_id_seq;
       exam_tracker          MAC350_2020    false    8    220            �           0    0    realiza_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE exam_tracker.realiza_id_seq OWNED BY exam_tracker.realiza.id;
          exam_tracker          MAC350_2020    false    219            �            1259    16581    registro_de_uso    TABLE       CREATE TABLE exam_tracker.registro_de_uso (
    id_registro_de_uso integer NOT NULL,
    id_usuario integer NOT NULL,
    id_perfil integer NOT NULL,
    id_servico integer NOT NULL,
    id_exame integer NOT NULL,
    data_de_uso timestamp without time zone NOT NULL
);
 )   DROP TABLE exam_tracker.registro_de_uso;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16579 &   registro_de_uso_id_registro_de_uso_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.registro_de_uso_id_registro_de_uso_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE exam_tracker.registro_de_uso_id_registro_de_uso_seq;
       exam_tracker          MAC350_2020    false    224    8            �           0    0 &   registro_de_uso_id_registro_de_uso_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE exam_tracker.registro_de_uso_id_registro_de_uso_seq OWNED BY exam_tracker.registro_de_uso.id_registro_de_uso;
          exam_tracker          MAC350_2020    false    223            �            1259    16441    servico    TABLE     {  CREATE TABLE exam_tracker.servico (
    id_servico integer NOT NULL,
    nome character varying(255) NOT NULL,
    classe character varying(255) NOT NULL,
    CONSTRAINT servico_classe_check CHECK (((classe)::text = ANY ((ARRAY['visualização'::character varying, 'inserção'::character varying, 'alteração'::character varying, 'remoção'::character varying])::text[])))
);
 !   DROP TABLE exam_tracker.servico;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16439    servico_id_servico_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.servico_id_servico_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE exam_tracker.servico_id_servico_seq;
       exam_tracker          MAC350_2020    false    210    8            �           0    0    servico_id_servico_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE exam_tracker.servico_id_servico_seq OWNED BY exam_tracker.servico.id_servico;
          exam_tracker          MAC350_2020    false    209            �            1259    16475    tutelamento    TABLE     	  CREATE TABLE exam_tracker.tutelamento (
    id integer NOT NULL,
    id_usuario_tutelado integer NOT NULL,
    id_tutor integer NOT NULL,
    id_servico integer NOT NULL,
    id_perfil integer NOT NULL,
    data_de_inicio date NOT NULL,
    data_de_termino date
);
 %   DROP TABLE exam_tracker.tutelamento;
       exam_tracker         heap    MAC350_2020    false    8            �            1259    16473    tutelamento_id_seq    SEQUENCE     �   CREATE SEQUENCE exam_tracker.tutelamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE exam_tracker.tutelamento_id_seq;
       exam_tracker          MAC350_2020    false    8    214            �           0    0    tutelamento_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE exam_tracker.tutelamento_id_seq OWNED BY exam_tracker.tutelamento.id;
          exam_tracker          MAC350_2020    false    213            �           2604    16561 
   amostra id    DEFAULT     t   ALTER TABLE ONLY exam_tracker.amostra ALTER COLUMN id SET DEFAULT nextval('exam_tracker.amostra_id_seq'::regclass);
 ?   ALTER TABLE exam_tracker.amostra ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    222    221    222            �           2604    16661    auth_group id    DEFAULT     z   ALTER TABLE ONLY exam_tracker.auth_group ALTER COLUMN id SET DEFAULT nextval('exam_tracker.auth_group_id_seq'::regclass);
 B   ALTER TABLE exam_tracker.auth_group ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    231    232    232            �           2604    16671    auth_group_permissions id    DEFAULT     �   ALTER TABLE ONLY exam_tracker.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('exam_tracker.auth_group_permissions_id_seq'::regclass);
 N   ALTER TABLE exam_tracker.auth_group_permissions ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    234    233    234            �           2604    16653    auth_permission id    DEFAULT     �   ALTER TABLE ONLY exam_tracker.auth_permission ALTER COLUMN id SET DEFAULT nextval('exam_tracker.auth_permission_id_seq'::regclass);
 G   ALTER TABLE exam_tracker.auth_permission ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    229    230    230            �           2604    16679    auth_user id    DEFAULT     x   ALTER TABLE ONLY exam_tracker.auth_user ALTER COLUMN id SET DEFAULT nextval('exam_tracker.auth_user_id_seq'::regclass);
 A   ALTER TABLE exam_tracker.auth_user ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    235    236    236            �           2604    16689    auth_user_groups id    DEFAULT     �   ALTER TABLE ONLY exam_tracker.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('exam_tracker.auth_user_groups_id_seq'::regclass);
 H   ALTER TABLE exam_tracker.auth_user_groups ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    238    237    238            �           2604    16697    auth_user_user_permissions id    DEFAULT     �   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('exam_tracker.auth_user_user_permissions_id_seq'::regclass);
 R   ALTER TABLE exam_tracker.auth_user_user_permissions ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    240    239    240            �           2604    16757    django_admin_log id    DEFAULT     �   ALTER TABLE ONLY exam_tracker.django_admin_log ALTER COLUMN id SET DEFAULT nextval('exam_tracker.django_admin_log_id_seq'::regclass);
 H   ALTER TABLE exam_tracker.django_admin_log ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    241    242    242            �           2604    16643    django_content_type id    DEFAULT     �   ALTER TABLE ONLY exam_tracker.django_content_type ALTER COLUMN id SET DEFAULT nextval('exam_tracker.django_content_type_id_seq'::regclass);
 K   ALTER TABLE exam_tracker.django_content_type ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    228    227    228            �           2604    16632    django_migrations id    DEFAULT     �   ALTER TABLE ONLY exam_tracker.django_migrations ALTER COLUMN id SET DEFAULT nextval('exam_tracker.django_migrations_id_seq'::regclass);
 I   ALTER TABLE exam_tracker.django_migrations ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    226    225    226            �           2604    16508    exame id_exame    DEFAULT     |   ALTER TABLE ONLY exam_tracker.exame ALTER COLUMN id_exame SET DEFAULT nextval('exam_tracker.exame_id_exame_seq'::regclass);
 C   ALTER TABLE exam_tracker.exame ALTER COLUMN id_exame DROP DEFAULT;
       exam_tracker          MAC350_2020    false    215    216    216            �           2604    16521    gerencia id    DEFAULT     v   ALTER TABLE ONLY exam_tracker.gerencia ALTER COLUMN id SET DEFAULT nextval('exam_tracker.gerencia_id_seq'::regclass);
 @   ALTER TABLE exam_tracker.gerencia ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    218    217    218            �           2604    16411    perfil id_perfil    DEFAULT     �   ALTER TABLE ONLY exam_tracker.perfil ALTER COLUMN id_perfil SET DEFAULT nextval('exam_tracker.perfil_id_perfil_seq'::regclass);
 E   ALTER TABLE exam_tracker.perfil ALTER COLUMN id_perfil DROP DEFAULT;
       exam_tracker          MAC350_2020    false    206    205    206            �           2604    16458    pertence id    DEFAULT     v   ALTER TABLE ONLY exam_tracker.pertence ALTER COLUMN id SET DEFAULT nextval('exam_tracker.pertence_id_seq'::regclass);
 @   ALTER TABLE exam_tracker.pertence ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    211    212    212            �           2604    16391 	   pessoa id    DEFAULT     r   ALTER TABLE ONLY exam_tracker.pessoa ALTER COLUMN id SET DEFAULT nextval('exam_tracker.pessoa_id_seq'::regclass);
 >   ALTER TABLE exam_tracker.pessoa ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    203    204    204            �           2604    16424 	   possui id    DEFAULT     r   ALTER TABLE ONLY exam_tracker.possui ALTER COLUMN id SET DEFAULT nextval('exam_tracker.possui_id_seq'::regclass);
 >   ALTER TABLE exam_tracker.possui ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    208    207    208            �           2604    16541 
   realiza id    DEFAULT     t   ALTER TABLE ONLY exam_tracker.realiza ALTER COLUMN id SET DEFAULT nextval('exam_tracker.realiza_id_seq'::regclass);
 ?   ALTER TABLE exam_tracker.realiza ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    220    219    220            �           2604    16584 "   registro_de_uso id_registro_de_uso    DEFAULT     �   ALTER TABLE ONLY exam_tracker.registro_de_uso ALTER COLUMN id_registro_de_uso SET DEFAULT nextval('exam_tracker.registro_de_uso_id_registro_de_uso_seq'::regclass);
 W   ALTER TABLE exam_tracker.registro_de_uso ALTER COLUMN id_registro_de_uso DROP DEFAULT;
       exam_tracker          MAC350_2020    false    224    223    224            �           2604    16444    servico id_servico    DEFAULT     �   ALTER TABLE ONLY exam_tracker.servico ALTER COLUMN id_servico SET DEFAULT nextval('exam_tracker.servico_id_servico_seq'::regclass);
 G   ALTER TABLE exam_tracker.servico ALTER COLUMN id_servico DROP DEFAULT;
       exam_tracker          MAC350_2020    false    210    209    210            �           2604    16478    tutelamento id    DEFAULT     |   ALTER TABLE ONLY exam_tracker.tutelamento ALTER COLUMN id SET DEFAULT nextval('exam_tracker.tutelamento_id_seq'::regclass);
 C   ALTER TABLE exam_tracker.tutelamento ALTER COLUMN id DROP DEFAULT;
       exam_tracker          MAC350_2020    false    214    213    214            �          0    16558    amostra 
   TABLE DATA           n   COPY exam_tracker.amostra (id, id_paciente, id_exame, codigo_amostra, metodo_de_coleta, material) FROM stdin;
    exam_tracker          MAC350_2020    false    222   5S      �          0    16658 
   auth_group 
   TABLE DATA           4   COPY exam_tracker.auth_group (id, name) FROM stdin;
    exam_tracker          MAC350_2020    false    232   RS      �          0    16668    auth_group_permissions 
   TABLE DATA           S   COPY exam_tracker.auth_group_permissions (id, group_id, permission_id) FROM stdin;
    exam_tracker          MAC350_2020    false    234   oS      �          0    16650    auth_permission 
   TABLE DATA           T   COPY exam_tracker.auth_permission (id, name, content_type_id, codename) FROM stdin;
    exam_tracker          MAC350_2020    false    230   �S      �          0    16676 	   auth_user 
   TABLE DATA           �   COPY exam_tracker.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
    exam_tracker          MAC350_2020    false    236   6V      �          0    16686    auth_user_groups 
   TABLE DATA           G   COPY exam_tracker.auth_user_groups (id, user_id, group_id) FROM stdin;
    exam_tracker          MAC350_2020    false    238   �V      �          0    16694    auth_user_user_permissions 
   TABLE DATA           V   COPY exam_tracker.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
    exam_tracker          MAC350_2020    false    240   W      �          0    16754    django_admin_log 
   TABLE DATA           �   COPY exam_tracker.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
    exam_tracker          MAC350_2020    false    242   W      �          0    16640    django_content_type 
   TABLE DATA           I   COPY exam_tracker.django_content_type (id, app_label, model) FROM stdin;
    exam_tracker          MAC350_2020    false    228   YX      �          0    16629    django_migrations 
   TABLE DATA           I   COPY exam_tracker.django_migrations (id, app, name, applied) FROM stdin;
    exam_tracker          MAC350_2020    false    226   Y      �          0    16785    django_session 
   TABLE DATA           V   COPY exam_tracker.django_session (session_key, session_data, expire_date) FROM stdin;
    exam_tracker          MAC350_2020    false    243   �Z      �          0    16505    exame 
   TABLE DATA           <   COPY exam_tracker.exame (id_exame, tipo, virus) FROM stdin;
    exam_tracker          MAC350_2020    false    216   �[      �          0    16518    gerencia 
   TABLE DATA           B   COPY exam_tracker.gerencia (id, id_servico, id_exame) FROM stdin;
    exam_tracker          MAC350_2020    false    218   \      �          0    16408    perfil 
   TABLE DATA           ?   COPY exam_tracker.perfil (id_perfil, codigo, tipo) FROM stdin;
    exam_tracker          MAC350_2020    false    206    \      �          0    16455    pertence 
   TABLE DATA           C   COPY exam_tracker.pertence (id, id_servico, id_perfil) FROM stdin;
    exam_tracker          MAC350_2020    false    212   }\      �          0    16388    pessoa 
   TABLE DATA           �   COPY exam_tracker.pessoa (id, cpf, nome, area_de_pesquisa, instituicao, data_de_nascimento, endereco, login, senha, id_tutor) FROM stdin;
    exam_tracker          MAC350_2020    false    204   �\      �          0    16421    possui 
   TABLE DATA           A   COPY exam_tracker.possui (id, id_usuario, id_perfil) FROM stdin;
    exam_tracker          MAC350_2020    false    208   �      �          0    16538    realiza 
   TABLE DATA           {   COPY exam_tracker.realiza (id, id_paciente, id_exame, codigo_amostra, data_de_realizacao, data_de_solicitacao) FROM stdin;
    exam_tracker          MAC350_2020    false    220   ��      �          0    16581    registro_de_uso 
   TABLE DATA           }   COPY exam_tracker.registro_de_uso (id_registro_de_uso, id_usuario, id_perfil, id_servico, id_exame, data_de_uso) FROM stdin;
    exam_tracker          MAC350_2020    false    224   ��      �          0    16441    servico 
   TABLE DATA           A   COPY exam_tracker.servico (id_servico, nome, classe) FROM stdin;
    exam_tracker          MAC350_2020    false    210   !�      �          0    16475    tutelamento 
   TABLE DATA           �   COPY exam_tracker.tutelamento (id, id_usuario_tutelado, id_tutor, id_servico, id_perfil, data_de_inicio, data_de_termino) FROM stdin;
    exam_tracker          MAC350_2020    false    214   ��      �           0    0    amostra_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('exam_tracker.amostra_id_seq', 1, false);
          exam_tracker          MAC350_2020    false    221            �           0    0    auth_group_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('exam_tracker.auth_group_id_seq', 1, false);
          exam_tracker          MAC350_2020    false    231            �           0    0    auth_group_permissions_id_seq    SEQUENCE SET     R   SELECT pg_catalog.setval('exam_tracker.auth_group_permissions_id_seq', 1, false);
          exam_tracker          MAC350_2020    false    233            �           0    0    auth_permission_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('exam_tracker.auth_permission_id_seq', 68, true);
          exam_tracker          MAC350_2020    false    229            �           0    0    auth_user_groups_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('exam_tracker.auth_user_groups_id_seq', 1, false);
          exam_tracker          MAC350_2020    false    237            �           0    0    auth_user_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('exam_tracker.auth_user_id_seq', 1, true);
          exam_tracker          MAC350_2020    false    235            �           0    0 !   auth_user_user_permissions_id_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('exam_tracker.auth_user_user_permissions_id_seq', 1, false);
          exam_tracker          MAC350_2020    false    239            �           0    0    django_admin_log_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('exam_tracker.django_admin_log_id_seq', 7, true);
          exam_tracker          MAC350_2020    false    241            �           0    0    django_content_type_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('exam_tracker.django_content_type_id_seq', 17, true);
          exam_tracker          MAC350_2020    false    227            �           0    0    django_migrations_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('exam_tracker.django_migrations_id_seq', 18, true);
          exam_tracker          MAC350_2020    false    225            �           0    0    exame_id_exame_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('exam_tracker.exame_id_exame_seq', 1, true);
          exam_tracker          MAC350_2020    false    215            �           0    0    gerencia_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('exam_tracker.gerencia_id_seq', 1, false);
          exam_tracker          MAC350_2020    false    217            �           0    0    perfil_id_perfil_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('exam_tracker.perfil_id_perfil_seq', 3, true);
          exam_tracker          MAC350_2020    false    205            �           0    0    pertence_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('exam_tracker.pertence_id_seq', 7, true);
          exam_tracker          MAC350_2020    false    211            �           0    0    pessoa_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('exam_tracker.pessoa_id_seq', 625, true);
          exam_tracker          MAC350_2020    false    203            �           0    0    possui_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('exam_tracker.possui_id_seq', 100, true);
          exam_tracker          MAC350_2020    false    207            �           0    0    realiza_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('exam_tracker.realiza_id_seq', 2, true);
          exam_tracker          MAC350_2020    false    219            �           0    0 &   registro_de_uso_id_registro_de_uso_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('exam_tracker.registro_de_uso_id_registro_de_uso_seq', 4, true);
          exam_tracker          MAC350_2020    false    223            �           0    0    servico_id_servico_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('exam_tracker.servico_id_servico_seq', 4, true);
          exam_tracker          MAC350_2020    false    209            �           0    0    tutelamento_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('exam_tracker.tutelamento_id_seq', 25, true);
          exam_tracker          MAC350_2020    false    213            �           2606    16568 7   amostra amostra_id_paciente_id_exame_codigo_amostra_key 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.amostra
    ADD CONSTRAINT amostra_id_paciente_id_exame_codigo_amostra_key UNIQUE (id_paciente, id_exame, codigo_amostra);
 g   ALTER TABLE ONLY exam_tracker.amostra DROP CONSTRAINT amostra_id_paciente_id_exame_codigo_amostra_key;
       exam_tracker            MAC350_2020    false    222    222    222            �           2606    16566    amostra amostra_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY exam_tracker.amostra
    ADD CONSTRAINT amostra_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY exam_tracker.amostra DROP CONSTRAINT amostra_pkey;
       exam_tracker            MAC350_2020    false    222            �           2606    16783    auth_group auth_group_name_key 
   CONSTRAINT     _   ALTER TABLE ONLY exam_tracker.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);
 N   ALTER TABLE ONLY exam_tracker.auth_group DROP CONSTRAINT auth_group_name_key;
       exam_tracker            MAC350_2020    false    232            �           2606    16710 R   auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);
 �   ALTER TABLE ONLY exam_tracker.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
       exam_tracker            MAC350_2020    false    234    234            �           2606    16673 2   auth_group_permissions auth_group_permissions_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY exam_tracker.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);
 b   ALTER TABLE ONLY exam_tracker.auth_group_permissions DROP CONSTRAINT auth_group_permissions_pkey;
       exam_tracker            MAC350_2020    false    234            �           2606    16663    auth_group auth_group_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY exam_tracker.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY exam_tracker.auth_group DROP CONSTRAINT auth_group_pkey;
       exam_tracker            MAC350_2020    false    232            �           2606    16701 F   auth_permission auth_permission_content_type_id_codename_01ab375a_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);
 v   ALTER TABLE ONLY exam_tracker.auth_permission DROP CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq;
       exam_tracker            MAC350_2020    false    230    230            �           2606    16655 $   auth_permission auth_permission_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY exam_tracker.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY exam_tracker.auth_permission DROP CONSTRAINT auth_permission_pkey;
       exam_tracker            MAC350_2020    false    230            �           2606    16691 &   auth_user_groups auth_user_groups_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY exam_tracker.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY exam_tracker.auth_user_groups DROP CONSTRAINT auth_user_groups_pkey;
       exam_tracker            MAC350_2020    false    238            �           2606    16725 @   auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);
 p   ALTER TABLE ONLY exam_tracker.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq;
       exam_tracker            MAC350_2020    false    238    238            �           2606    16681    auth_user auth_user_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY exam_tracker.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY exam_tracker.auth_user DROP CONSTRAINT auth_user_pkey;
       exam_tracker            MAC350_2020    false    236                       2606    16699 :   auth_user_user_permissions auth_user_user_permissions_pkey 
   CONSTRAINT     ~   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);
 j   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_pkey;
       exam_tracker            MAC350_2020    false    240                       2606    16739 Y   auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);
 �   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
       exam_tracker            MAC350_2020    false    240    240            �           2606    16777     auth_user auth_user_username_key 
   CONSTRAINT     e   ALTER TABLE ONLY exam_tracker.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);
 P   ALTER TABLE ONLY exam_tracker.auth_user DROP CONSTRAINT auth_user_username_key;
       exam_tracker            MAC350_2020    false    236                       2606    16763 &   django_admin_log django_admin_log_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY exam_tracker.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY exam_tracker.django_admin_log DROP CONSTRAINT django_admin_log_pkey;
       exam_tracker            MAC350_2020    false    242            �           2606    16647 E   django_content_type django_content_type_app_label_model_76bd3d3b_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);
 u   ALTER TABLE ONLY exam_tracker.django_content_type DROP CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq;
       exam_tracker            MAC350_2020    false    228    228            �           2606    16645 ,   django_content_type django_content_type_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY exam_tracker.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY exam_tracker.django_content_type DROP CONSTRAINT django_content_type_pkey;
       exam_tracker            MAC350_2020    false    228            �           2606    16637 (   django_migrations django_migrations_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY exam_tracker.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY exam_tracker.django_migrations DROP CONSTRAINT django_migrations_pkey;
       exam_tracker            MAC350_2020    false    226                       2606    16792 "   django_session django_session_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY exam_tracker.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);
 R   ALTER TABLE ONLY exam_tracker.django_session DROP CONSTRAINT django_session_pkey;
       exam_tracker            MAC350_2020    false    243            �           2606    16513    exame exame_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY exam_tracker.exame
    ADD CONSTRAINT exame_pkey PRIMARY KEY (id_exame);
 @   ALTER TABLE ONLY exam_tracker.exame DROP CONSTRAINT exame_pkey;
       exam_tracker            MAC350_2020    false    216            �           2606    16515    exame exame_tipo_virus_key 
   CONSTRAINT     b   ALTER TABLE ONLY exam_tracker.exame
    ADD CONSTRAINT exame_tipo_virus_key UNIQUE (tipo, virus);
 J   ALTER TABLE ONLY exam_tracker.exame DROP CONSTRAINT exame_tipo_virus_key;
       exam_tracker            MAC350_2020    false    216    216            �           2606    16525 )   gerencia gerencia_id_servico_id_exame_key 
   CONSTRAINT     z   ALTER TABLE ONLY exam_tracker.gerencia
    ADD CONSTRAINT gerencia_id_servico_id_exame_key UNIQUE (id_servico, id_exame);
 Y   ALTER TABLE ONLY exam_tracker.gerencia DROP CONSTRAINT gerencia_id_servico_id_exame_key;
       exam_tracker            MAC350_2020    false    218    218            �           2606    16523    gerencia gerencia_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY exam_tracker.gerencia
    ADD CONSTRAINT gerencia_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY exam_tracker.gerencia DROP CONSTRAINT gerencia_pkey;
       exam_tracker            MAC350_2020    false    218            �           2606    16418    perfil perfil_codigo_key 
   CONSTRAINT     [   ALTER TABLE ONLY exam_tracker.perfil
    ADD CONSTRAINT perfil_codigo_key UNIQUE (codigo);
 H   ALTER TABLE ONLY exam_tracker.perfil DROP CONSTRAINT perfil_codigo_key;
       exam_tracker            MAC350_2020    false    206            �           2606    16416    perfil perfil_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY exam_tracker.perfil
    ADD CONSTRAINT perfil_pkey PRIMARY KEY (id_perfil);
 B   ALTER TABLE ONLY exam_tracker.perfil DROP CONSTRAINT perfil_pkey;
       exam_tracker            MAC350_2020    false    206            �           2606    16462 *   pertence pertence_id_servico_id_perfil_key 
   CONSTRAINT     |   ALTER TABLE ONLY exam_tracker.pertence
    ADD CONSTRAINT pertence_id_servico_id_perfil_key UNIQUE (id_servico, id_perfil);
 Z   ALTER TABLE ONLY exam_tracker.pertence DROP CONSTRAINT pertence_id_servico_id_perfil_key;
       exam_tracker            MAC350_2020    false    212    212            �           2606    16460    pertence pertence_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY exam_tracker.pertence
    ADD CONSTRAINT pertence_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY exam_tracker.pertence DROP CONSTRAINT pertence_pkey;
       exam_tracker            MAC350_2020    false    212            �           2606    16398    pessoa pessoa_cpf_key 
   CONSTRAINT     U   ALTER TABLE ONLY exam_tracker.pessoa
    ADD CONSTRAINT pessoa_cpf_key UNIQUE (cpf);
 E   ALTER TABLE ONLY exam_tracker.pessoa DROP CONSTRAINT pessoa_cpf_key;
       exam_tracker            MAC350_2020    false    204            �           2606    16400    pessoa pessoa_login_key 
   CONSTRAINT     Y   ALTER TABLE ONLY exam_tracker.pessoa
    ADD CONSTRAINT pessoa_login_key UNIQUE (login);
 G   ALTER TABLE ONLY exam_tracker.pessoa DROP CONSTRAINT pessoa_login_key;
       exam_tracker            MAC350_2020    false    204            �           2606    16396    pessoa pessoa_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY exam_tracker.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY exam_tracker.pessoa DROP CONSTRAINT pessoa_pkey;
       exam_tracker            MAC350_2020    false    204            �           2606    16428 &   possui possui_id_usuario_id_perfil_key 
   CONSTRAINT     x   ALTER TABLE ONLY exam_tracker.possui
    ADD CONSTRAINT possui_id_usuario_id_perfil_key UNIQUE (id_usuario, id_perfil);
 V   ALTER TABLE ONLY exam_tracker.possui DROP CONSTRAINT possui_id_usuario_id_perfil_key;
       exam_tracker            MAC350_2020    false    208    208            �           2606    16426    possui possui_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY exam_tracker.possui
    ADD CONSTRAINT possui_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY exam_tracker.possui DROP CONSTRAINT possui_pkey;
       exam_tracker            MAC350_2020    false    208            �           2606    16545 ;   realiza realiza_id_paciente_id_exame_data_de_realizacao_key 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.realiza
    ADD CONSTRAINT realiza_id_paciente_id_exame_data_de_realizacao_key UNIQUE (id_paciente, id_exame, data_de_realizacao);
 k   ALTER TABLE ONLY exam_tracker.realiza DROP CONSTRAINT realiza_id_paciente_id_exame_data_de_realizacao_key;
       exam_tracker            MAC350_2020    false    220    220    220            �           2606    16543    realiza realiza_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY exam_tracker.realiza
    ADD CONSTRAINT realiza_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY exam_tracker.realiza DROP CONSTRAINT realiza_pkey;
       exam_tracker            MAC350_2020    false    220            �           2606    16588 N   registro_de_uso registro_de_uso_id_exame_id_servico_id_usuario_data_de_uso_key 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.registro_de_uso
    ADD CONSTRAINT registro_de_uso_id_exame_id_servico_id_usuario_data_de_uso_key UNIQUE (id_exame, id_servico, id_usuario, data_de_uso);
 ~   ALTER TABLE ONLY exam_tracker.registro_de_uso DROP CONSTRAINT registro_de_uso_id_exame_id_servico_id_usuario_data_de_uso_key;
       exam_tracker            MAC350_2020    false    224    224    224    224            �           2606    16586 $   registro_de_uso registro_de_uso_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY exam_tracker.registro_de_uso
    ADD CONSTRAINT registro_de_uso_pkey PRIMARY KEY (id_registro_de_uso);
 T   ALTER TABLE ONLY exam_tracker.registro_de_uso DROP CONSTRAINT registro_de_uso_pkey;
       exam_tracker            MAC350_2020    false    224            �           2606    16452    servico servico_nome_classe_key 
   CONSTRAINT     h   ALTER TABLE ONLY exam_tracker.servico
    ADD CONSTRAINT servico_nome_classe_key UNIQUE (nome, classe);
 O   ALTER TABLE ONLY exam_tracker.servico DROP CONSTRAINT servico_nome_classe_key;
       exam_tracker            MAC350_2020    false    210    210            �           2606    16450    servico servico_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY exam_tracker.servico
    ADD CONSTRAINT servico_pkey PRIMARY KEY (id_servico);
 D   ALTER TABLE ONLY exam_tracker.servico DROP CONSTRAINT servico_pkey;
       exam_tracker            MAC350_2020    false    210            �           2606    16482 K   tutelamento tutelamento_id_usuario_tutelado_id_tutor_id_servico_id_perf_key 
   CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.tutelamento
    ADD CONSTRAINT tutelamento_id_usuario_tutelado_id_tutor_id_servico_id_perf_key UNIQUE (id_usuario_tutelado, id_tutor, id_servico, id_perfil);
 {   ALTER TABLE ONLY exam_tracker.tutelamento DROP CONSTRAINT tutelamento_id_usuario_tutelado_id_tutor_id_servico_id_perf_key;
       exam_tracker            MAC350_2020    false    214    214    214    214            �           2606    16480    tutelamento tutelamento_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY exam_tracker.tutelamento
    ADD CONSTRAINT tutelamento_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY exam_tracker.tutelamento DROP CONSTRAINT tutelamento_pkey;
       exam_tracker            MAC350_2020    false    214            �           1259    16784    auth_group_name_a6ea08ec_like    INDEX     n   CREATE INDEX auth_group_name_a6ea08ec_like ON exam_tracker.auth_group USING btree (name varchar_pattern_ops);
 7   DROP INDEX exam_tracker.auth_group_name_a6ea08ec_like;
       exam_tracker            MAC350_2020    false    232            �           1259    16721 (   auth_group_permissions_group_id_b120cbf9    INDEX     u   CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON exam_tracker.auth_group_permissions USING btree (group_id);
 B   DROP INDEX exam_tracker.auth_group_permissions_group_id_b120cbf9;
       exam_tracker            MAC350_2020    false    234            �           1259    16722 -   auth_group_permissions_permission_id_84c5c92e    INDEX        CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON exam_tracker.auth_group_permissions USING btree (permission_id);
 G   DROP INDEX exam_tracker.auth_group_permissions_permission_id_84c5c92e;
       exam_tracker            MAC350_2020    false    234            �           1259    16707 (   auth_permission_content_type_id_2f476e4b    INDEX     u   CREATE INDEX auth_permission_content_type_id_2f476e4b ON exam_tracker.auth_permission USING btree (content_type_id);
 B   DROP INDEX exam_tracker.auth_permission_content_type_id_2f476e4b;
       exam_tracker            MAC350_2020    false    230            �           1259    16737 "   auth_user_groups_group_id_97559544    INDEX     i   CREATE INDEX auth_user_groups_group_id_97559544 ON exam_tracker.auth_user_groups USING btree (group_id);
 <   DROP INDEX exam_tracker.auth_user_groups_group_id_97559544;
       exam_tracker            MAC350_2020    false    238            �           1259    16736 !   auth_user_groups_user_id_6a12ed8b    INDEX     g   CREATE INDEX auth_user_groups_user_id_6a12ed8b ON exam_tracker.auth_user_groups USING btree (user_id);
 ;   DROP INDEX exam_tracker.auth_user_groups_user_id_6a12ed8b;
       exam_tracker            MAC350_2020    false    238            �           1259    16751 1   auth_user_user_permissions_permission_id_1fbb5f2c    INDEX     �   CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON exam_tracker.auth_user_user_permissions USING btree (permission_id);
 K   DROP INDEX exam_tracker.auth_user_user_permissions_permission_id_1fbb5f2c;
       exam_tracker            MAC350_2020    false    240                       1259    16750 +   auth_user_user_permissions_user_id_a95ead1b    INDEX     {   CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON exam_tracker.auth_user_user_permissions USING btree (user_id);
 E   DROP INDEX exam_tracker.auth_user_user_permissions_user_id_a95ead1b;
       exam_tracker            MAC350_2020    false    240            �           1259    16778     auth_user_username_6821ab7c_like    INDEX     t   CREATE INDEX auth_user_username_6821ab7c_like ON exam_tracker.auth_user USING btree (username varchar_pattern_ops);
 :   DROP INDEX exam_tracker.auth_user_username_6821ab7c_like;
       exam_tracker            MAC350_2020    false    236                       1259    16774 )   django_admin_log_content_type_id_c4bce8eb    INDEX     w   CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON exam_tracker.django_admin_log USING btree (content_type_id);
 C   DROP INDEX exam_tracker.django_admin_log_content_type_id_c4bce8eb;
       exam_tracker            MAC350_2020    false    242                       1259    16775 !   django_admin_log_user_id_c564eba6    INDEX     g   CREATE INDEX django_admin_log_user_id_c564eba6 ON exam_tracker.django_admin_log USING btree (user_id);
 ;   DROP INDEX exam_tracker.django_admin_log_user_id_c564eba6;
       exam_tracker            MAC350_2020    false    242            	           1259    16794 #   django_session_expire_date_a5c62663    INDEX     k   CREATE INDEX django_session_expire_date_a5c62663 ON exam_tracker.django_session USING btree (expire_date);
 =   DROP INDEX exam_tracker.django_session_expire_date_a5c62663;
       exam_tracker            MAC350_2020    false    243                       1259    16793 (   django_session_session_key_c0390e0f_like    INDEX     �   CREATE INDEX django_session_session_key_c0390e0f_like ON exam_tracker.django_session USING btree (session_key varchar_pattern_ops);
 B   DROP INDEX exam_tracker.django_session_session_key_c0390e0f_like;
       exam_tracker            MAC350_2020    false    243                       2606    16574    amostra amostra_id_exame_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.amostra
    ADD CONSTRAINT amostra_id_exame_fkey FOREIGN KEY (id_exame) REFERENCES exam_tracker.exame(id_exame);
 M   ALTER TABLE ONLY exam_tracker.amostra DROP CONSTRAINT amostra_id_exame_fkey;
       exam_tracker          MAC350_2020    false    3019    216    222                       2606    16569     amostra amostra_id_paciente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.amostra
    ADD CONSTRAINT amostra_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES exam_tracker.pessoa(id);
 P   ALTER TABLE ONLY exam_tracker.amostra DROP CONSTRAINT amostra_id_paciente_fkey;
       exam_tracker          MAC350_2020    false    2997    222    204            "           2606    16716 O   auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES exam_tracker.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
    ALTER TABLE ONLY exam_tracker.auth_group_permissions DROP CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
       exam_tracker          MAC350_2020    false    234    3048    230            !           2606    16711 P   auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES exam_tracker.auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 �   ALTER TABLE ONLY exam_tracker.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
       exam_tracker          MAC350_2020    false    232    3053    234                        2606    16702 E   auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES exam_tracker.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 u   ALTER TABLE ONLY exam_tracker.auth_permission DROP CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co;
       exam_tracker          MAC350_2020    false    228    230    3043            $           2606    16731 D   auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES exam_tracker.auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 t   ALTER TABLE ONLY exam_tracker.auth_user_groups DROP CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id;
       exam_tracker          MAC350_2020    false    3053    232    238            #           2606    16726 B   auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES exam_tracker.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 r   ALTER TABLE ONLY exam_tracker.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
       exam_tracker          MAC350_2020    false    236    3061    238            &           2606    16745 S   auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES exam_tracker.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 �   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
       exam_tracker          MAC350_2020    false    230    240    3048            %           2606    16740 V   auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES exam_tracker.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 �   ALTER TABLE ONLY exam_tracker.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
       exam_tracker          MAC350_2020    false    236    240    3061            '           2606    16764 G   django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES exam_tracker.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 w   ALTER TABLE ONLY exam_tracker.django_admin_log DROP CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co;
       exam_tracker          MAC350_2020    false    3043    228    242            (           2606    16769 B   django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES exam_tracker.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 r   ALTER TABLE ONLY exam_tracker.django_admin_log DROP CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id;
       exam_tracker          MAC350_2020    false    3061    242    236                       2606    16531    gerencia gerencia_id_exame_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.gerencia
    ADD CONSTRAINT gerencia_id_exame_fkey FOREIGN KEY (id_exame) REFERENCES exam_tracker.exame(id_exame);
 O   ALTER TABLE ONLY exam_tracker.gerencia DROP CONSTRAINT gerencia_id_exame_fkey;
       exam_tracker          MAC350_2020    false    3019    216    218                       2606    16526 !   gerencia gerencia_id_servico_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.gerencia
    ADD CONSTRAINT gerencia_id_servico_fkey FOREIGN KEY (id_servico) REFERENCES exam_tracker.servico(id_servico);
 Q   ALTER TABLE ONLY exam_tracker.gerencia DROP CONSTRAINT gerencia_id_servico_fkey;
       exam_tracker          MAC350_2020    false    210    218    3009                       2606    16468     pertence pertence_id_perfil_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.pertence
    ADD CONSTRAINT pertence_id_perfil_fkey FOREIGN KEY (id_perfil) REFERENCES exam_tracker.perfil(id_perfil);
 P   ALTER TABLE ONLY exam_tracker.pertence DROP CONSTRAINT pertence_id_perfil_fkey;
       exam_tracker          MAC350_2020    false    206    3001    212                       2606    16463 !   pertence pertence_id_servico_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.pertence
    ADD CONSTRAINT pertence_id_servico_fkey FOREIGN KEY (id_servico) REFERENCES exam_tracker.servico(id_servico);
 Q   ALTER TABLE ONLY exam_tracker.pertence DROP CONSTRAINT pertence_id_servico_fkey;
       exam_tracker          MAC350_2020    false    212    3009    210                       2606    16401    pessoa pessoa_id_tutor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.pessoa
    ADD CONSTRAINT pessoa_id_tutor_fkey FOREIGN KEY (id_tutor) REFERENCES exam_tracker.pessoa(id);
 K   ALTER TABLE ONLY exam_tracker.pessoa DROP CONSTRAINT pessoa_id_tutor_fkey;
       exam_tracker          MAC350_2020    false    2997    204    204                       2606    16434    possui possui_id_perfil_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.possui
    ADD CONSTRAINT possui_id_perfil_fkey FOREIGN KEY (id_perfil) REFERENCES exam_tracker.perfil(id_perfil);
 L   ALTER TABLE ONLY exam_tracker.possui DROP CONSTRAINT possui_id_perfil_fkey;
       exam_tracker          MAC350_2020    false    206    3001    208                       2606    16429    possui possui_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.possui
    ADD CONSTRAINT possui_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES exam_tracker.pessoa(id);
 M   ALTER TABLE ONLY exam_tracker.possui DROP CONSTRAINT possui_id_usuario_fkey;
       exam_tracker          MAC350_2020    false    2997    208    204                       2606    16551    realiza realiza_id_exame_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.realiza
    ADD CONSTRAINT realiza_id_exame_fkey FOREIGN KEY (id_exame) REFERENCES exam_tracker.exame(id_exame);
 M   ALTER TABLE ONLY exam_tracker.realiza DROP CONSTRAINT realiza_id_exame_fkey;
       exam_tracker          MAC350_2020    false    3019    216    220                       2606    16546     realiza realiza_id_paciente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.realiza
    ADD CONSTRAINT realiza_id_paciente_fkey FOREIGN KEY (id_paciente) REFERENCES exam_tracker.pessoa(id);
 P   ALTER TABLE ONLY exam_tracker.realiza DROP CONSTRAINT realiza_id_paciente_fkey;
       exam_tracker          MAC350_2020    false    2997    220    204                       2606    16604 -   registro_de_uso registro_de_uso_id_exame_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.registro_de_uso
    ADD CONSTRAINT registro_de_uso_id_exame_fkey FOREIGN KEY (id_exame) REFERENCES exam_tracker.exame(id_exame);
 ]   ALTER TABLE ONLY exam_tracker.registro_de_uso DROP CONSTRAINT registro_de_uso_id_exame_fkey;
       exam_tracker          MAC350_2020    false    216    224    3019                       2606    16594 .   registro_de_uso registro_de_uso_id_perfil_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.registro_de_uso
    ADD CONSTRAINT registro_de_uso_id_perfil_fkey FOREIGN KEY (id_perfil) REFERENCES exam_tracker.perfil(id_perfil);
 ^   ALTER TABLE ONLY exam_tracker.registro_de_uso DROP CONSTRAINT registro_de_uso_id_perfil_fkey;
       exam_tracker          MAC350_2020    false    206    224    3001                       2606    16599 /   registro_de_uso registro_de_uso_id_servico_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.registro_de_uso
    ADD CONSTRAINT registro_de_uso_id_servico_fkey FOREIGN KEY (id_servico) REFERENCES exam_tracker.servico(id_servico);
 _   ALTER TABLE ONLY exam_tracker.registro_de_uso DROP CONSTRAINT registro_de_uso_id_servico_fkey;
       exam_tracker          MAC350_2020    false    210    224    3009                       2606    16589 /   registro_de_uso registro_de_uso_id_usuario_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.registro_de_uso
    ADD CONSTRAINT registro_de_uso_id_usuario_fkey FOREIGN KEY (id_usuario) REFERENCES exam_tracker.pessoa(id);
 _   ALTER TABLE ONLY exam_tracker.registro_de_uso DROP CONSTRAINT registro_de_uso_id_usuario_fkey;
       exam_tracker          MAC350_2020    false    204    224    2997                       2606    16498 &   tutelamento tutelamento_id_perfil_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.tutelamento
    ADD CONSTRAINT tutelamento_id_perfil_fkey FOREIGN KEY (id_perfil) REFERENCES exam_tracker.perfil(id_perfil);
 V   ALTER TABLE ONLY exam_tracker.tutelamento DROP CONSTRAINT tutelamento_id_perfil_fkey;
       exam_tracker          MAC350_2020    false    206    3001    214                       2606    16493 '   tutelamento tutelamento_id_servico_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.tutelamento
    ADD CONSTRAINT tutelamento_id_servico_fkey FOREIGN KEY (id_servico) REFERENCES exam_tracker.servico(id_servico);
 W   ALTER TABLE ONLY exam_tracker.tutelamento DROP CONSTRAINT tutelamento_id_servico_fkey;
       exam_tracker          MAC350_2020    false    214    3009    210                       2606    16488 %   tutelamento tutelamento_id_tutor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.tutelamento
    ADD CONSTRAINT tutelamento_id_tutor_fkey FOREIGN KEY (id_tutor) REFERENCES exam_tracker.pessoa(id);
 U   ALTER TABLE ONLY exam_tracker.tutelamento DROP CONSTRAINT tutelamento_id_tutor_fkey;
       exam_tracker          MAC350_2020    false    2997    204    214                       2606    16483 0   tutelamento tutelamento_id_usuario_tutelado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY exam_tracker.tutelamento
    ADD CONSTRAINT tutelamento_id_usuario_tutelado_fkey FOREIGN KEY (id_usuario_tutelado) REFERENCES exam_tracker.pessoa(id);
 `   ALTER TABLE ONLY exam_tracker.tutelamento DROP CONSTRAINT tutelamento_id_usuario_tutelado_fkey;
       exam_tracker          MAC350_2020    false    204    214    2997            �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�m�ݎ� F��)�+���}�J����RbG����ӗ�ʝ��	���1·�r9ܖ�����e�	��PSikB�����2�x�7�k0e�%�s���P�f�ާm���Ԥ�l/�;���b!(�SVT$9
n`��<�!Az���ri^@�tJt��Y%d����_MK�G�Z�>f�|:�: ,�>��iZ:Ny��2�����7`�5b�I�0�?H������*k4�*ֱ���W�I��U�g���n����!�b$w��7޽9�=�Z5x����	���	 L2k���9����6U�H��tE('��Z�*")R4�dۖ�0y�i�	6�P�M �I�zi&8�>Y?��bB�c�Pi��n��S��S��V�\[�Va
�&w��Ӷ�K��̀�c;_|��j�7���xK����`^�%Z��;�?�7r�����B/�{��)/�l�bP���W�(x�+^���[����m��k��Tڮһ��68���9�_p��Y���`Dr�m{N�ū V���a$e��S)<�dx���q�'J8|�޸.*T��T+���P�-L��%�}���*����04����@�m��#�t�3��"�t�3)"�x�3�S1ޗ����+��U5�T
1�D������Z��kb      �   �   x�3�,H�NI3�/�H425S1�0 ���r�_���`3�`���r7����|c�*��0S��
m#Oǈ��D3�����B�H[N##]s]S#c+CK+S#=KKKCm����dcSNN(�B�%��%K0�����Z�Y�s��qqq �-z      �      x������ � �      �      x������ � �      �   +  x���=O�0�9�V'�6��l眬���X�(�UP���CJ�f���wzO$P9(A�Js�f����Ӯϯnձ1���vb��U��mw�������Km8$�������)!�%�R^ �[��vMX��6����(����*Qp#��1Y}�H�9I �#r��m姢R�{P��j��t�")P�8�!��o�sm���6�}��e��i����<�W޽���?Ֆ-B��W��(M���t��P���l�[��߱��� s��?�ήC��2���~<�4M 6p�A      �   �   x�M��� E�������l� ](����f|�p�5n��L`���:�jy�s$��f|�@ߠ
f�ĩh���?�h�i�p6���\D�4Е;��$�챡N<ib��qFOR2�XEm�l��V����t����o�,R	��[�C';6�1+��#]d]rp; ��`<      �   �  x����n� F���7m��girCf�%A������2�T�l��w�<�����b��:T!f0�([D�o��z��D�;�����Tj�_�	J[BiN�J]z3Gj	c9���u����׽�jH�w�.�mi�3蝑r��Ѹ>������9�d��j2�����m��70�^o�8]j�⏀�Q{��M�R�C�~��KOm�D��(YPtAM!�W�R&�gJ[(쑒�����"0*�Ȱ*Ĭޤ/����[����P�d�{2�蝽C��Y����)�*We�EE��<}�����T�3x^ӂ��v4s���Bj�9z
Ea�����hAu�M�sVT5�a�"�w?�����å�Q�m{���]#�
z����w�㽮�_�0N�      �     x�=�Mo�0 �����Mi%��.S15�R�Gv�Ci�U�� �~�ݟ�}�e���5��~�:躮^T����v�4���c&GŔ�Mj�x%����.2�%=��d��<kIC[2�؆��U�lTb�ybb�lz#`�W;}�����S<hqs5jwӅ�G�%}�I��|���������p�9���?�~	���Z���m"�"K���_$$Hr2(w��l���IO7�S����c9|o ����_ Z��*@3 �%Z��}�<��{�h�      �       x�3�I-.I�N,*�u��5����� WX(      �      x������ � �      �   M   x�3�tqus�	�tLN-.�W(HL):�8�ˈ�=�5.���W������e����\Z�ZTZ\zxaQf>W� �z�      �   .   x���	  ���0B�N]���Bh-�)U�
�&�Y��kn�x����      �      x����n#K�%8��
��l ��ߏ!ER%Rd��(@p�.�C]�$��f�kpq/���Q��n�F]��Ə�Zf�N3*N�8'�&��P���m�{��2׊�(�\�\��U/���>)֋��Z/ٲȾ����wi�vwV�ʧ"��=ɾ��yn�.'���j:�'W��7۝�=��/���i�ewv���?.۽�����p0��������:䏎Z�V�58���M����f��]�ٿ��s�M����	��r���z���
���V��]����'��]?�0���j-���}V>�b�h]������a��S���V���ia�o�s�V�ju�K,f�~o|~�w��M�ޓnk��BGc.���I~qR.TLTO�֧e/[ߖ�4y�p��~�q�D�uQVw��oW��~�.W֠���rm�ߞ��H��X��ܞ���������eG-�;������}��b��|rz͕MF\Y����qer����O�ױ��G���o\Q`qǑ�{��N��d��.���ja����cS̲�=������_��2[�_2.�2r��7BZ~�ͭ˳���Uw�:����d8�[�-|Q�۞N��JC�Q?J,�H[jY�������{��}>}������IB���:���2�;e��wV�*��C���>.䯸�����r�=��y��m��UQ�������bu��f��r�}o�{9!�W}���ݝ�����z�x1��^̑\�cM>�z�/�.�Au��2��#�q�8pC�Ib~��"�%������No��M��k��g�n���޴5�z�� ��i��v'Xi����j�1�3�}�8�֏�WexN��Sl���:��Nlu��la��U��Z��ܭ�p�rw��뛴.�S����q{6�J-�z����Scɱ���^�,>\}q{C.$�\?I"?J�(���c�܆~y�$���RGwuٻ�'����n㎝)���d2������P�ܧ���w�:9ᑚ������i��?O���\_jE��E^�����)��>/����;����|�������k���^�s��^��_ye�7��ygi�}�/�X��������_�7��8�c*�?��	O�uǷ��:{*Ws�8�7���Q���-݆֙B���AvW댗B��A�w�*�ɶ�W�)l���ؾI[�z!f5�+T}=筚3�F����Y֙�j$���tA�Gn��o���=�d+���}�{���0��:��M¯N?�=�r�R^K7V�����|�~zh���{�f�&&��dy��GA`�s\:���,~��~,_��K��v��{R۵�R�C��T3݊���Z�������[Y��<�6�
]7v=/�M?߮7�ʾ)�K�2[��|�jn�|��=e��͢�t;P�}���ؽ�ta�ONӜb�\e��G�"�������Cg����|��E,)�b�O�ăj��j��k�Y��|)fVou_VO�k�O[����D��^&��ޥE`��c.;_g�*����c�$ʥ���;v�ҧI�trtb���J����w�Ժ�v���`[eoţ%�A����U��0��7�1������
�o�O[��?�\��mw��c3v�s����&��η�4�NG,'&J#
�К�OOEn_��%���ѯ��_ۢ�}9�nك���@�H�V(�)7��˕���tU��ˤ�^����l%T.�c�y~E��a�C�N�y1[�~{�{e���@�a������`/v�;�$1�Q3�������`�m��_:�XLAz��{!T�t�CsA�
�鷏�;i�-c�&]մ5�� �a��K@ث6��;��(�Е��&������ık�����ק$o�S�xS�K||a셩ku2X�/����=+�{d�*��Z�a��Yp Y�o(;��?˟�[x�J��A�z������痗�s}.��v,'��MR/�%:�3���Z�A��c�8�ڟ��dLed�&��D��`r܈D��I�����@3����Fo��뻇$[���V�aƩ�V;�5:� K��r�Sb��o��A��^N���:�.t:�88¸�)f��f���!�xo�O�Ň�X�gy�0&�c������Zf��O��F6&v��VF��kl���
jc�З�S~�"~�7i5��BI	�)Wq�V�@+g��k������6�|+��$p�b���u�Z?�x��c�$H/ڽ�e�GZ1�5�Z���*D.(��s�ro�raQ����>��?�-W�{����8TJ�k\�iE���;!�ƅxm'X�`<����ĮP{��VM�%��3�N���q���7ba����DP�Д�c����	�}]T��l#N�C�ɥ��D`�Q�[��s�~���[�����bE�!p�8qC���v5�nWy� ���ۘI��������{�wp��0����9�2��>>_��^\\JY�aB|/�|p�.s�?�ʶO}�b#w�׮Zw������Z7T�
�գ�D|��⼴�<-?���N�2+	���"�ƱٖڃKY-�j��~��xx�mĬ�����mɛ �i焲�����	<�&9�'���O��cv�����!�\��Ԋ��s��j-�o�j^+"9���r�3�_��C���� ��TSw��/��)��R]q���Оw���oZ����y�<�,5<8��X�fn@��ﹻ &���SP��ڧbA��&)2('𭷛�������{;��?�n��>����
��I�z�)3d�Ű�����$;����X�^1ϙG���8JG�Ïm�K�=+q� �*�SǺ��C&�hp� `�n���n�"��N:g���b_��7L���(��6�ۏۇˠ���-/���&��0A @6�6NdRΊژ�V8���w'd��ה�_��v�>��������1�! ��Y��e���I�{"�b��#� HU+�o����u�u{/��v��g0q
���9�e4�u�k��l�.��Sm�2���T�k��>_����2/�`x->
�LNؔ��tg���I��H�$�C�n�&�tw�|z�*}����?8�`����|i���Лu��v������%�e[�~*�����%/ ��U3^�*���*�/�yr��q���	S������j?9����{t���F,5��ȅ�D���=���7�r�8Pٿ��鷮�-���/�	?��Hj�#1t`Ug���͟?��͗�X�G$q�/Sv�K ���Ax����e���͋���!�}k{���;�j�zHks�'N��u�k�ln�d4O�?�쵽 �B���ݪ��P�W�o�M��������k�O�kj�X�Ξ��Sw��d�겥t��uڥO�֏�Q�b	Ij���������O�/�����0%ԫ�]C.�d�+I�|ϣ������ݹ҉t���o�C��>wv4��2�n^'Q.K������އ���*��=_���'@���~^���������.}�N,�G���{=|:�W�������i@�I��j� )P��*�[f��V�H1�������{����[#�1�[�c��E��T�k-�t�{:���f8��= �g��Nq�]a��؇l�]����[�ɠ�w2:T�5�]e�b��Zu��z<zj��~b-�8����	�>��|���!ԫ��?��t\W�ӕ[׆Y��W��*c��^�<'�D��V_×��ex���i8�����S?u#h�����m2{��Ve���_�SgW�֥��Y���F}(o�����"O� �3�k�gPF{)}�B�˕ɕŞ�;:��U����k)�%��Rߏa�]kvoOfh�?��Xp ��1�0cxT���K)��n! ����-�/I|�y�[���N��5������؁����
&�︾�5`޸{�؏�&CM�k��pHm�/�I5W�9���i$ؼPKb�G��Ͻ�s������Uu%xG[az�q�Y'�R ��|XK���2a�n۞�[ҕ����F$BH�Q+�%�L���������Ӯ@�
+HB�L/NR���y��wv��=��o�����BhO�1�m=r��:��������|�kI-�	=?��8q�ȗ�    re_�������r8�d����6�e�� !���&w-0�R~����2s:�wC,$%�v#������>��߳�Mf�ɖ�nCY�����0��W y����pB1��������p��Wԡ��	������0�-�v�W�4����ȇ�E�s�@��$��f���*F�.�(��P��5i\��9/��j�[5��}\����~����9 �^�0���[VG�q���lm��M��_���MF�q.q�`��#5�[֕{q��l��<��u��Qr%�S��-T���/�}��ge��HU�K��������J3�_�)"	����z	��6m����u~|%��� �Į���U��7�jN��;,�hܝ�p�{�u�ik0^R�t�ĝt%��d��dE4>���z3��?
o3� � h�Qd1Ȼ�aG1�t�� ׿7�]Cl�F{Wf��9rB�ePŕ��C�[	�rY��^�0��Q��Q��ʟ�����=t����7�끻���5��	����ߙ�k�/Ȁ���a����l�����>����ٍ`ͦ�ܾ���2�Xa5���;%�z��ݓ�TG��>���Bg}��Wo�=~g�����7r�v���sN�TF�3�]��i��p,�W
��r��]f����DGj"l㦕t�n�]}��/W�be)а�D�@O�)�
��,���W��=8�����%@˟�����*\�B1ᑚ���b=�M�t�����!���3Fw|k�K��C��d������A��i���MF=+��wh�nf��3���������˗�J"�r"�7��jC��ei������������4a��.���s�?R�CO�+����x��p�D��A�;�,���e6��fv2��?��G�L�M{zՃ��_E*Ckt��Չ����I�ĤXD?Z<O?~��Z7�H,�(�w��|�,_�@����bP��:�D}bg�D��Ha�H��n�|����?������{�&|=��^�@����B���riC�ϳ�0&t8�}ʄ��c������ep�����IR+̂��*Z�ݧ�S��Њ<߉�ƃh��>[�q��$�ء��\��������&��z]�^O^,Ξ8??�o�ΟR�2s��)uc7L�0�v��g1\���X��u5��B(',cҺ���+�~ ��Xz�aND������5)΋�v�r�}ܝͅq�S7�b/v\�:����n0�gۇ��:�&?��RgJ��36Ԍqh=�xo�o����t�����@�B��$q&0m�f�)�H�Ϣ�&� &��
��JO.��:!�*� gI|��r��xq�2{�굟>��,�^�_\�A	���A^mބ9��O�8��
p���Ϊ'8������I��H��޶��F]�6?����?���o_*�Nv%����n���R�^S��4�ڏ�7�������/"�;��@��Dִ\�t[��砘U�]qx���z��!�����Uq���������O��a�cp(���	"���&��T��&�x������\�%$iRE��o��˛�q|�%����/�T�Y����Lb��U���]��3���MX��z'����������.ɾ�(g!f��gJ�z'����!�x��Q\�ط7�&�[��v�??C�A�~���#<���lb5󭜹����|�X$��5� h�������]d���],F&�EX;�����{CږIB.�P�aE���Gb�����mv��ofez"�t�; g����àC�y�-׎NZ��D���x�䲫�&�%��%ّ�ȋ���|���]?�?�߿	`�����%�uI_�\��ό�i^>��[2�u��{���Hw�\
8qu�[���{��}���8����$u�.K�g��~-�A��˓�x��_�B'?۸1򪌍�@%�aT`���\}9����erxb�~�$q�������ѝ�;�����nќ	W�C�M>]�c_�D9�m=��Xǽ����dt�HN���A|/LCX��n��s�,6��=��Oz}Z��}>m�8�8C9㭚��{����x��_��a�8L��#k�����"{�^��ˡ#�0Ι���4�H��^01��~2��S�\�����|��|+t-lL�%LcY	���G���K8��#3�5���~-|*�u)XƟGWm��~]a��*Մ��0�>�����->�.�ۙȦM<�*!�^���1����:�=�3����<n�m��bRWa5=L��q�!>w_��������K1���op�϶��@y�y����7�W3��}��ߛ����ewp�)a���r&߳���G������I_��H�)i���]��*��r��b�H��%���r�qRw�_�}��>>��w��^>ܝ}\�ՆV�C�����z��冎x����.a���J@��]����:'c&���r1ʵ��ܞ������6�Y��1�~��z~����}Z���ߛ�g��$�UR�=Nd"�>Rc�7�����r�l�Rb���~�`ѫ�����y��O���}�������ݺ����_���ð#��X `a���l���X��)�W�{yu�w_F"�B�C�Z�����f4���l���`%=P�8I(Q�c:��	���� �P�:�}����l�&m��{���}R	�ȕ �$I�u_���Ǿw,bZ�3�o7���(s�f����,��k6?-y�J�����G3�����AHKɤ���� ���Xt�_.����pv��-3yK��y��"��4�p��J�sn�z���7�j��n��+�Y�7�l�۸N�l�n*��d�������a��%��a�k�<�(�0�]\#��E��E=�,�c�)�a&����<��#M���l/1C���Ey�y�mG�8��m�A��聛�+A����<�'��L��qGF���YQ��&�'�����)n�.��E:����n�g�Q BSi`%��N
���E�\�乬~����)E�B�Y�g��t��̺WYB1[Z�i��궺�>�/v���B+��/
���
آ��/�|�\�v!��5�	����A},M��Ԡ���g�׷���s㽞���2"�I��4�Y)��ϳ�����CLm�U��V�L>\�&2��j���vw���q*j�UP���5�r�e׺�>����*l0-���X}��@�e�p��>�vW^���,��lF�FIŌ��Z׳���ެ²5�M,ύ@�/JS�.����j��y�Mֆ��-��Fҭ(<3k��	oń~`}�����U/�0*_nĚX���3�0�mz!��n5[����?��_}h�B��H���1x������:�z-k<Ǌ�4�����U�Y�Hf������l��ߠ5e>͐J(m0ݗǅ�SB��P+�mV��������?�P,��{\+�(�G0t��bU�j��NU��E��$�'?@Y�Vg�I��KZ�̣z�g�U�^�/�O��V����Y	=���S�\�dt��2�	 �k{ߛ�ί�%��t{�ꨛ�m�s�ʹ��ip���U�C~��
R�ͷ��(0� y�q�Pk-������唭��VO\��e��
H�}e�X'6e�a�g������O,�)��'qtЗ�9��0l�/���_U�C`�����N����|��M�S$�p��c��Xhԕ��Mo���S��?�f�Xzh��C�7�6��w�x�b�?�>9����1ّ$������*z��:VS��RkUx��kv���d38.-?��������bF����oㇽZ�ԫ����\�E]��{�D"@��vr�#�W��ǻ����;�(O�8�S���8�R /|�j�Wg˗R9��Y������������T��2�%-�Z��~7����.�>�ݝ+ء?1����G�ϡ
U7�����P�lk"�ٟO&���LD�E:��LGj&p���nV�kW뻷O�q�.���3�BQ`�-���(K�~�7��>\���*?4�/e�2']NsTO�{R]ޝ���������r�?�.+i=W 6\�ɂ���)�~��Sm]����]����n    )u����s�r-n���b�ы�x[� �����E���Y�o��"�Ĭ ��m��QWM���8����:�q�h0}�ד�XMZ�_���.�<n����	�u{�6.8�xb�B�����-��&I��߂�ۗ�yV�~������|�u���}6�p�5Ȫ��������7	ѿ��'�}d[%:�z�f�#L�Y~��o����տK�V����F�+<�w�CV,��l��i������4���F��s:T@1Q@��H��<��/���ͷ?���,���\�òB�:�3�|��N��a-u�?J�׳�D���׺bÕ��%�Ϟ�&�()e��ZБZ �xQ䣓����a8�O-��WD8y짗��[ݗ|I�['Z��/@�O�<e"��׺���kj��z�buσ��E��'
cQ�E/>4�d�/��w�(z�����UX�P4�靪L����>�1k*N�E�r���N|?��x2�~�i�%'����%�������ߙ��U�;}.]R�{�{��q1ͭ6Ͳ}_t����,�>X�4,�e��$$���Nx\>e[�����l7�r-��	���)��)�o���n��]�� �|ϱ���*�8�j�9�dOO��D��e�U�7���L �������d�[ǽ�ſ߮/�g����Jq@�=�PK�0��n�՜ef�z�6���^N������	ͱ��+F^��M�t�6�F����ia_>��o��q��x|p�5�I��C֘Ոw�Z�o����A��k�d܈P�	��DI�E�F5,RXN=�_�W_�ç��8>�Ϸ��b7pcG�/�J��?v���>m}�-aӋ�+O���w�GvK��P���á��Yx�j�L�Z��H0Q�FŊ��e�'���[�~����	p���Ա`��/ɞ��=[ٟ�e��Q���^;G�m��0k|��Ex�ِ:����S ��{L��HZ�f5O~�����a�M� �4O��1P����.�C�.����	hb���`�9}چۯ��
y�C�qb�솼Q-��X��3)E�{l�e���V[����$Gj���V�b{��vW��oV��.Ai�
��|�Y�a���?Y8	�%v{�8�=(�k�5�9~��Q��>(s�Įծ�R���lьʴ-��%��Y��y�hm^�j-G��H5���� �1�c�������hiT�*�A.='u����WO@���,V��=�,����>ljy��8���dDES��1#_5�2ޣ��S�eoO�|cH
�B�2�F]'��s ԗ��e�T7K �$�}��@�إiU�ӑM�Q]�-���oY�;ٔ˺]F3��,�Tڼ #c���\k�{��@�,$�/Mb�;�;�l�rYh�%�R�X7������je���\��)�ڨ>��s#�db��2ہ����'�!��"�D1!{F��?��a��X��Oj�X[`�گވ���㰥'�����=�k�X����򩅓��VO$6_l� Y�G�E�@l1DrR}ړgX��z�a��b�\'0r����)7\���pT�.vo��	Dw�U�\]-	}P��W�[ �������� ���|\ٛ��Ҍ�7�u�~�.v@��F�YQ�7;Zx}DR��B��蓲����ƞ���FP�|;���}	�����*k�p�(�k�Y��MR�b�B��@����3H���V��B��b��P�͗��ѿ��!%q�Cz�D��;ԇ��J!���3:z��/��HE�1\3�GoB�b�d��TТ���%��P*� q�S*���2��X�m�b�}W�vv�X�*MKѩ�Ҏ&�9�fKyJ��`6�Q|��P���X���?L�vf23t���D7��`m7����VKC\?t�S��i1D��~����$��1"3��z��8|��p�sH�nU�����!���i��by>ڨ�VQLȔ8RU֠��|0/�?�=n�v��kM�L��9r<�X�b-\��(5�"i)7�/
2�S/�F�e�#��ҵ�ڪA��|1W�
��J]�B��'�����_��㇮d���j/��:�a��qY�ơ�'�.c�U�RO7�8�J���Y@B߄k��tWu?��>�^
�P�ػ>�TW&�g��(L=�+���M�j�QhLE	U���rh�&j0�[��9� �	Q��M��.G�*HO��G��41n(L2�xpKq� � �+�0��٬�P�ʀ���rG���v5ۈ�4"�~��d�!z��1Y ��M���E��T�7@.����i��[9p��h*	Kq���{�J �&��� ����BIx7WP��eq_Ul~�y1�Rl+�S�l����ە�|e�6@ӧ�!�!,�	jt����%ݘ��ߑ��;��U��(���1�C��
��i�����!'����`krq��"W���R?u�RSq^T��GaM�6 �8��}>74J����р~�*���H�h����YA����E�s}K]]��b,�����x�,h�j�@*T���0���}�u�{�1Ii�x�gA�\�6Y.��~D���	,p	�v���?��,�JC:����?e�' ��B�'��0����@��y-�&�`QP�/�Il�,@�m��{c��J졿���R�L}y���pl�|�N�ɵB]��Bz`e,�x������N�z,Z
""?�<���=f��|ZQF;`Eat`��g*f�Ӽ64v � ̠y� ��k���4;�P�pJ��3:+��B'N�㈈��H���e�Y�-Vj(��w?��ӟ�HִJٲ�N�~�cP(��=�^�-�l�ߛ�U�;8T`��<�?]�����������|f��J�l�仰u*�Z���'O�R��(���I��b&�o/��bf�ҐVi�co ��u���`z�<a0��X�-�$s֑�K����v2�W����7�i(�FT��yFfч^(�O��sE�e��._X�Un�_\5��f�&�0(� ��3�of��o��G�2q
Ǟ�p}�M�jM�f4�,@
��)�ǳ;*&X�٣NF"Wu����C���6���(f�/�@F0�֧aO�s��% 'uL<�n�*,~CG}C��!�^qKάU�>�JO�"8�]���3g:�!SR:0��U���ú�Ky=�LQs�(%U^�X�|)83}ky!,�-�����J���:šz��6yRB����$�@ ��3_Y$��.�и,Ҥ&���E��y�n��~��@=�Ș=(�qVn�����n�bՇ�iKD������	t����Q �'��"Չ�V�|�X��*���z�W���\4�$1|I@��GTW�*ÑvaPD�ps���@ۍ����ojbh|H,8+�&�9��	SiW�x��}���
�\��u%�5tԯhY0�@�>(C�ʖPK�� nhR���F��j~�y�O��5=��f���@x��a\Y��z�#�aƮ�AD����P�0 V�y�<�4#����|>�m:?{�Qe���y!tB�s\e+6�9��l�Ԭ�v@�"<��Ǎ�(2�h
�����n�ֱLP���������g_2�@��]'��>*��2x0� ����oO�7�:B+2��åzl�Ƒ�XC����Kݱ'3�`oPv���2���+kG�c�|�T����[�[6�F��_�b#���t�Ξ�A�j�#��GQ�(��z��&����6o���|�:a�$��Ҏv�%���z�Ϛ�0P^υ�D�a�CT���=6��b���DVF7��t+{ic���e
3��Ic�L RqK��Lt�<.7k�jD�&&�@�893n���8��4�͇�s]ȪcI�����G�I�ٓư�|�mh}��tR�ot��}^'�+�,�#��HD�_����WJ60!�AC�@�y$^1��_q��\��b]�i(I��}���[����J��]�ɣ��:�3��(���KF�N�Y���у�bM�:�E˕�5J�	�"��J�wtx�Ƙl���|I����,_����M�

�    ��R�SU�F��D{��P��ı�uY�KS�QHA� J��^n�j�#g�����E����e�n����=΅3_��Ԏ��c�n�8eTyZlJ�zG���@n8"�� c�<�� �����yw�x�9�/TK5e{"݅���ᘀ�u�䛅}�^��`Ll��iZ�	�e���R"��! ͹���uw�_���x[�P��.�R2$ �`���-��J�,]��X�c��ʧB�s�3�TV�eIզc�Y{)o�qu�qs��Ȟ�y���S�I<cP��i. ���J?�{%�ԅ���P���^�>p���B�p���������8j���fĪuQ�s���ոp���J6�N��� ��������2E���B(�Q�^��=076$�^��M���^L�n��u��aE��D`ց&�ӥ�V0��e*��V�gwټ0cMO dyP�%˰�
9�:T���(ڣ/�"�T*8��^d�����e������ԣ�q�xL<`g�m� A6�h1,i��q�~l��"<ZۑԸ	)���^@�&�/�f����v�-�@��{LF�-98(3 	(���-�,f��$�bFpA+`�x�WOu�x�MA�7�q;e�4��i�|l+�T�y�*Jw{0;\���+��� 1�ᕆnĻ��Q���]H��%�2���� �Ôi�TN'��X|E<q7����Ɠ�^]PC�yl���N0��d��4��h���S��X�.=��֗�<��"3T�m��e�_H]�x�R8�bU;.c�x�b���j]<U�6��\��$��7-!C0�H���cG<�=�& ����m}�#�T��0�h�񶪯z�剱�(
�ZS����t�$
{ �����x��j��>^mh��%_�� L�>�u��z���>�s��6ꑽ�rYu�G\6J:��0y�䴫-6za�h�����	D��oA$��S��39z��p�vd�*�r�E(��{�z:e+P��	)��O�jw>rk�5D�p\�~���Bc�t�����Bv�D��*�/��nQ��1:{Q;�|���1"�a�#7b[ӗ��KT9�#�ڗ��}�V����.���|���]d�Z�D�MpK��J��|�n���z�:�c��w�?��ҋ�$�t�ݦ,��)�X�dK{��ʭ�jNCC�b�>�5
�ܭV̮i^idT���w��x��f�����qp�� 9��Kų �޺���U���4�^��1��+L�1t"PJt��k]�O5S4�:�s�w�N}�w5��!�8F�����Q0��@f�0�SY� [�L1Ju-�̇���5k�M#�R��~�D<��ľY��W�4wʗ�k*@iH��o��|�T�t> d�\׳�2�kغ v#B�>lӝ����M������|.��Ŗd�f����ξ� �	�4�li��ˑ�l;���.I*u���O�m����.�)1jgݰv�]FQ"�/c ��D嗛qp�2T�1$
Zw��C��O=��7�)���ݼPn̚��wh?�@��`�PdFo^�ʍ��]afz���]�I���M�c>�X�|y��2��(H�8@H�WԄG�>(��3��ĥ/�DgU�ŏ�r$���j����b�@��>��~������6�U����-�\�(`ؖ����X��`)w��)��X3��u	E�h��Ⱋ:��b�MY5���;�a��r\�(��ٔ2�R^&�	��:M���yi����m�4 )��8��KO�~�H�Hd��,���H�S�	�	`��?f���t��Dq� ul�-X<9k�Ơ!ht���a*��b)2f��ƜS������+�_m0��8�l"3 y�RW�>�X���,�6x�E5t�[�C`j�AI9!����-�� ��nDjzc�Ԋ��� �P����}��uH��юR����Hw����C���&	#�mb����/�Pc� �-�� ֩@�u��
�itE�:�/�D#8�fU�{z�
�Mp��SCOМ�J�A=��c6! 85Ԗ%�'��{KX#k�)�M�f;{z��D�҆�fVX�yX?��i��k@H��}��[A����D��T�aY�U����%
<��u���M�v��#�x��B��i��k-�G�}1�I�]��Ta�~k���T	�$�,��&�d���5�*��m���{0���z�߁�b�|53f���{��P�S��s�v��d���,t�,3[,�X���1E��b_���BC�vk)�&��Fź�m����6vR�8Y�K�^�y!��7�K"��,g�Q�ob�tY�W@���)��Ø���-��ep@Ğ
V�O/5��dn�p����W�t��^ԠP���~���S����� v��ҙ@g�/�U�����2�R6�&Eftð�k��c�(�*(k;�	���6�� ��c���|�Lc�t� I�a��8f��;���J�C�iR�N�Y{�����"���Y7��=�{ j|�>��&������^2�'����{`@C��f~�H�:��ݕ���$� �r=�j\�����F:���+/< �}]���\p��ӕF�%eJ�_\~��يI��7+��L?r��=���D��=��v�'���G��a����9U���P*�Hp�Z�D,�(���I�n>n�ʐ~��f]��H��l��T�*{SHX�VCP�+0��=Ơ��Mn��	��8�|����-=\ά���N�8��m6ϖ[������%��~�&C�� �V;����D	.V���c϶�����`���j�2�0�8�Uw��y��b�C2FRF8A��Ü;�b�A�FL����B¨F�EV{[m�8���u!�a�������BcB� �pu�&�� 2�`oS���������Nh��]P0�nX�v��B_D�`:C���m6�j�L��v�	F���B����w��X��:��t�k8��4<|>$���\^�c|I����`�ԓ���; �RW׈w�!=�1�& ̝�b��{#���0EV$��X�䅡ڠ�Cy�������ϵ�^S��L��o�N��1\M))D����P���+�-TP���R�$I *3��=�Ō$����@���P|���Kߚf���T��Z!ֆP�ةo�s����V�A��J����4�n���>��K`2>��<�����Hz�C���[�|��__)���7�S�8�5�]Z�����FOd����E��.�+��q�J�e�w�����P���O�u�dP\�$�kH U��2�MV�b�2��+�nu�O�sp1�*:�!	�i#�FG��Q��ޕ�I2��ېuf�ji6��MM�`�C{�C��n�+kli��O�+��z�"ս�>�R #�ՅN��<4WQ�`(�;_�"G��񣰨��1��O��>L�B�nE0��.�&:�����Ɓ
�؝|)����T�2����=��]}���D���[*�>�t0�o&��(�nz8�Y9�cXE_=L�o~���xևm.�h�R-�A=���Rޯ	���6�PPq��8n�L��I�e�^��Jq<��-+pe�#c���⒰š|-�Ϸ?j��Xf[�f���*��9�[Y���3�x%C?���<���Z;��S}k�$�4�tdY��(xƷ�yt�Bl�2i��v�pVFOG��l�$�1N�/�7��"�o��D��|D�*�c=��&��`c)���x@$|�
8�����p(*t} ,f�ʸ+����j�� >����)�ڲ��k�d�L�զx3�Mj���N<z�>Y�}zډ�r��FY���-yS�^�����?�J� :�2���${!}^�(�-�ހ�a��uTY�=��,6���9���r��we�J��l�ܬ���EO�AY ���G�V�țWp��* ��b�o�s�D���>*n3HC�]l��o�������=`�,�OU�*��:%����-�H@��R<��1�
d    �KG@���i��H�n��q�b���Sݑ�)�ߏ�(��x��h�(ƀ"�e;��n��}��f`�o=�5����@wM�B�E�4׏��Q���I��ꅬR���/�2��X&��)Ữ!P(�>�2�I �P��:
n�z;:R��0āK`��ME���<��|z��	
�۽'vn˵�)G�s��{1ӥ�w`����f��zhl����U��CW��`���t�u�z�b#��D*���}������1��2�l4�����us6��=���"���*����dyF�# ��:�5�1�n�����U4�sԎe�P�7l2�f㐘?1k zW{�OWfw�A�����5_G�������)f��}��46�<�ǒ�jD���4��3�M���?��2����.����{�5�m!tm�6����n_4� c�S6	[���W~�����j	�Ń ���Q�*ԷV4�pYe�1��.Q���Nɘ~2��n:���׭�xڸ�t7�/:�~B
��>�F�d��zS�e����GPWRkU�~b|�/
��cv��Ѥ�)�\����oa�c�)��S�u7hA����l}����U�}b?l�|�X �Ĳ�dFY]�����;\0ǳ��dV�^��N�]sbϱ;����i���ϸR,�bI����a��ȿ	"c�ǡ��7�nIsq���%,�O`]&<�XAX�[.���NUU�P�1GZxz��Ow�1��D bIq]!�Wm�_�;���g+��M#�F�5A�
��+\�E�x��ƈ1��|�97T�Q�Űj���P�&*�@��7�:��0�K��zV���^��[�u6�����z�#d=� [B���$0����5�e*�[��d^Bब{�!f��۩;�q/�[ѓ�z��E( ��?G�Of���*3��ن������������i�:��>��Y���F��_��q�&����0�����4&1�uz��QK������fEH�2���
��B��̼_�����BF�2��j
Ug)��rp�EJ3���=�� �hȂA�K�}��أ��Z/��?&H9.�h��X5ۍ"��2��1��L��Y����D�[G���!��İ�{/=.�â��063d� dσ���틋���B�"иI��d�l���D	s<��->֋mv�w/K�\Q��M�ׂ �ԍ
�� %�1C׋}?�g" ���uJӂ�I�}�_�Y���>"���ߟ�����~��wo4�g�~Fd@�?kj�l�{�UWČ��Y�&*���e~�;CB�- I�1J��憬��U>"�ev�~P�7�:��I_n����躉�U3���?�>�5�kTU��,U�#����V"k�v8�"��a.}�t�Ȳ�l�~َ�Ub� ~�Q��b߇'1>=��'t�2��kޕҮ����H}�f�Z�ď�����v���0v^���)�t�j�7U)�n��؏����-�8��hD��^�.]e�Lbv̩�f �GT3�3L��</:�x,׿,�W���D�?M�7���F �b-{dz:��{V�����f��7;���kY�U�V]5y��g	��([qd�b'�l��z*u*�ձ/�>F��&cư�̘�<�w�Yʹ�ۻ��j"W�����'Y��#<N�`�l���⡘q���;6e�,n�IC�4�k�3�Ez���6�N_��`�������Iq�2��Q�[,`~b��F��B�cƎ�t��״. ��3��*b�#>�&t��T��~��#�|�ƾ��VH�r��<���2�H4�z�?��B2�?d�ֆF��TT)���-�'P�,�8����H��$,�yj�5����Ʌ:�ۍQ��2����;�w���4;��2�vL:�ȰU>@4��'��J$��	Sj&���!����}e[s�b��$�:g<b�N�8�6�E=4VJ׀L����ȋ�3�=�f�c�Ы�]e�\�De㎖�[��� �q*��Yg��*p�f�SR�:#��5�i���D�x����BS_vX�8��i�eZ��	���A����G���|�6��I/�"�I��q�t�����T�~��i`�i�7k}��PS���U8΋�c	s��d��/M]��c4 A�ͦ�����^,�dT��K�z���nRCB���	�&C�+r��Ii�ir���'�!�_������L�ق�(��ܱ��aۤ��F�9QݢR�	�kc2�	�@'��ڨ��s��"���2������k���V@ �e���!�������F�N�����@~�C�I�&o`=I,�I���[�MUR���H��ӻ4��ѽ=���s��cm�M�d�i�ou�+�:Q�&��(�1|2��n�AM�i�\#Q�ķ>���cR��}K.�P5	a��N:]:S�J>ʅ~dYZ��Z6IXƐ,㍡������챼��KC�;��H4���<�.;-7{jp��+2���8�5{����5���� HP��x�=�fi����)��]��2���"���(_D^硯� �)��E���U���lQ]a�7>�NI���|^�^�5����'��'5`?h���@�4�b{��-K	Sk"����4��D`�pe%/����~3@�&Ra��2�>��n"��,��!/{%F�������>u*aԭ�)��:�[@��c�?d(����T��N�00Ξ]u�ǌ6@���.��.$�.���L���9O�|6�n�]��GUۖ�%L�Wf�xP(Y*x^�7�J���nOR�&7�݄}X�DWֶ,�zɄZ���^lC=��0�u������*��-�)ҵ�O��Nj�@�l�\�<A'S�y�RA� X�����W�i**�U8B�X�!�u����es�d!���Eԝ���Yv`;w��!u��z�#�c|�;bMW����j�ʬl�i���G���驼\�1&S)=v�� P�u!:�C�7����M��r�N�+�#�O3��H�ur!=�mFg���_2��yn9^�w�l����g�. "}� *XV�������~.� �j�Uq9v�����e�QjGGj��>�?�0R(~�:P�����o���@_�YQ�~Б3N�= �ѕ0�m}�l�Ƣ���7 vv?�V(8�"�:99�L	��Z;���K��6�|~���T:3��=�J�iU�~ ��W��=>�����x����F����3`b�[���|8fu0-��@_$��$^���7?��3T���(��Z��z�쎠o(�{�D/;�2�=�4B?h�� ;�:�$ o���|��r
�
߃��y}L�~9z��M�X��y�ia�P��\'a�?c��-��	�9�>�/`�Xm,ߍ�e.�����f7_�4����ޤ����щ[���X�0�(���T��;B�):L��@�ԩ,�%�ӸN�:�PoxPS��,>��0��ԭ[���k�A`�ӛ���7���|���,@53�=U�T��.r�n�֖�����L�9�Y���	�{�M�DI_�ا�u�(򼌎��0c� ��h���'�OG;,ў�\�	�&�T��j��ǣ���Y�|����fM��a��.��Q1 �S��w���3A��C���"�n�̥R��#�"`!ξ���Ñ1��Th��}��"Q�`���2o��$��q~@� y���B���K#����_�������#Fטq&�3_�I<�pc�u�WMr}zER�%���&�p�t^8l���\�;6�H�O�&����T�y��l��]h�&��hJqA�dx��D1<`X@�Y�w^��@s#v�dnf�r�Xuh��.���,���RB�cc�d�,-O;�E厘���$�i��zh�A�|H�]�@�߀�mKZ�,��[��o�">���a@� �O����0�.{��Zx�y����,��g��.;��8G�H@�l�|���`dO C@���M]�ˇb���A���"t�2�CBp��d|w�E��G$�Y��F�W�TG^f�y��@��Sg��    U8�}�E�[f�9|j��)��a��t?��ZA`������́��C�������;O�1a_�Z��l,zG^�⃃��H�b�Re���2���j���,�y�P���K(4�>����yL��jϳ���wd)U�\�R�,n0��	�M1�"�i�V���<H��� ���q9G���0D|WP1�	�N�S����Ԏ��Nt<4[j�z�o�{�BpS����H�����������N�@�q�&�z�Id(��^=�<�	wlwu!JU�V��1��+�yf _lґ�(!J�ϝ��w��U.��~0�+�3���Mc/��e������VB<~�呫�\��z؈:�.-�g&�GtV�%��p�|������<��$p�c��6��Z�'����{����Z�}��$����qb��.&Z,|�B��Z&F�Bb��}=^�p�=�-���.s��0��
96B�HM��������lj�L-����	�>�d/�x�t�n2�����U�0�Mɒ������ش�@X)Y=�wE�%vV��;�Ҟ�P$,	@N����{(���x���PD<�x_���BĆ���jU��@�ҡA�BO��H��Y�u^�����UgF:�D����7M9���B���#���V~���0��*�
����=��eiNɔ@��X����=��J�q�m�.|`��=+ʤ�)_���M� �(�P�+�6�L�<�H���l��x�&Pf���i�N�.3n�%�ɈrR�cB��o_�"�-j��Y���-���O��[v����k,��s�sA�܇��q��D�I�[+vz6�~�7���D>�([f�K�d)���G�D�@�Z����<x��1�<�I�&���|�)��;�U�;&{@�r�D@偫���#��n�[��I���<}V��&]�)��c4����bs�k;�"_�ma���]?8b4��3Oش: ��j9������P�_�vf�,*ݛ2�'6����5^�c�9k��E��_7�Ǝ��l��|�gT�eb���e���&�_r0^1!Y�nG�>�]�&	����5���q���FP�3�$�
ن�X&�����w�:7
?���i*17TT��T�v�)iͳ'-$2�Ȏ���Q�ms�����1b���g�`��K���8a;�B|/�������߬_$�B�>{��Q:k*�Ÿ5������.�n�^�wjyߡ��b�E� ��;-C����WՎ��Y��7x��AX(�l_����x�;.N����.���4�gtNb^#V��<�d��w��|�2tAl<s��	;���:[o�)s���34]R�>�
��b��3�����+)�<b��A��ޗ9)�e�g����\U�og�&�N�@�`ՀI���%n���S�5@�V��:�����@<��E,a�Ym�V�OKC$��U�~�$��u��= ��ȋ�ù[a4!�l��w��|R�p�V�6Ll��{�S4e�dy�HA��:�ݛ����7$KM]���I����)u��)仞�~fn3���{��z�/��^���+�x����$��9*�Ř/��lO�����+<㮳5з��"Qz��Y��BD�zD�ԫ~�T��1.��y�H�-�͠�r���u�������� >}�!���(`7�����p�R�{k]s�!�I�H��~H�X�M "���-f�	�ĭ�.ǧ��KD�Q�.i�îƻF��2��(����lk]fR�l�i-v|vp�`��zSO�J 2�2}2�Ys��- ���I!��d�^� ��F�Qi��+��&0>�w�_�y�0��J���0i�M���t���z9HY:��j�p���W���g)p .SG�ey�l,666e+�&p�i�J������i�k��Z�POD��fA3K�U
��z[�o4����e}�"H���[��sv��w�=b*��xd�x����N�]n��k�yi`1!#5���|�,7�yR��#�*PU� T��}U b��p-y����ð�M\����JF1��MUܘ]J��G�XsW�v����q�T����Z&��L�r��4��X.S�S�ҧ���g@I#��w�r�SJX}Ѳb�R4��uu;T�����=\��Wv����ۨl�N���[Q)����A�[��٬�S9�Ebe���j|�-�����l���C�R���bQ)Um^+Q�a8t�D�e`�`c���&_p�w���D�qivl�h�E�x�G�ュ�˳O�fw���e��|��+<��-�����#ҟ�2�>I�n�����|��Y�F^���zy�<Twd��#�H��|Ѷ�*�r����WAO?�7X���P��p�;�m;����>l�g!�|#�ve5j�H��=��@���nqLۅ&T��;��jʈ�t�>�>Ƽ�2�	�؎(�=|9UY4tN�Zm��Q���8u���;eE�$cZ�iY�޲���,�b�
ڭe��Ը�Id��ê����aV֢P6�>_*Q��G�D� #_�_!���ر?�p��h�NS�U˵ N��W��:a��(?O�К>	��.2+�:�<d��v|�u�̓O½L����D�
��F������,z�	W�<0��:].��)�>���7�]���d���#�>'^^6)
��}6�l��_Qq��9�&�MRcKCQ"���C?/��1���� H��V>�'����cl+��U�)_�>(S]`R��E�|�@��e�@�M�\V�����i���g�L�B��w|sf H��D�1��>�+%�J8
�>�@_m$R=�sNc����|��QB�0a3v:��eX�aq��)��E�����uPX-ݬ�g�e�.*��2CCyr��}Y�X�x�B5qѷ�ݣ}��}���~_s ��s��n��&m�����'��tU��n�1ߕI��>P�$���Ձ�C�v�fҕ&����YO���-�TW쨕<1�wJ�$AbH]�7�<���l�		����JG���0��0a.�e�y[ϴ,�&��5v��A6Q�鉇�Ta�~�D���'��"ʹ���Y#�c>��b��򅭨�3d�#vp�'�X�����V�6ʉY�J��:�7��T���a"j���z�ʮv����O�Y��bL��!�Z�����}z)�9�w�ˬ�*�Ը���1&�\�0|��WH�ZӨn�t���X�/l�V����=���~O�G�xV�[�>H#�fd�A_�XS�OC���߽xp�c��Ța�R�0*'\ݹ��By�����5�U���J.��\PWi�p�fX��-�8"> $��AE{$�8���2�yf���u���P�$T�>Kڙd�=3�1I���,o�Yf����a���A9��`L�١����m`���\U	����D|z��S�PR�#��6�;�9@j����s��H���+��ۂ��"yk����1v�j̝iLkZ��d��;��b3�ݫ� N�X������p�w��a�vw�ɓ�kΤ	�TUR�܏~�ۖ=~}�hw��&t�h�L_�./�4�d���x����@f��Tѓ�9��(���%�] ��4�x`FP2�& �l��K�����T�-��|
���˞%�'��XdJ�{���O�*Ҝ�J�{�.1���xj�f�$h<k��y�}���J��a{q�~���\�$2(�'�$�ˇ�`4�F���A��+�3�sU����U�bL�'�=10.�H0�咻�����HA��gg��������U�H{;��[ӐO'�������Q�@1@iD�I���s3{-�������eR�!!��F�svvva1�R�������I��Vꄭ�O�\���P����M�u 	�dq<G�KEڡ�!�i�dႵ���*~vA�>���=�rL%[� ���������\����%.����gy��PW����d��3�f��Qu"0���dӢ�_WvV⽇HU ��4n?�d8��A�h�b7y@���?S-݌H����'��]+��I�c�6;|ٳ�k�P�-y�D�<5w5�׉A��$<4u��QE %	  靶��P�&)������#������zTTn<3ϛEU����~fT�R�l	lMqx*�.#�.t�&9`r5�����ț���.V@��ȴ#����D�'WS�n��)3m��&�|��]C}�2������3h�Yx@���l6m���h��"1 �/�[a	e ����<:�n(���-�Y�����,�d� cDWb�p� �}��}�Z�J��,Ĵ-k�0g�v�&9VT'����x�̦0P���2ܰ���^;�0���P�z�����~5��>h
́����������XG�&C����=���ge�/���o���N&E��lj����'h[��������\��9�ۢ�~��l�ƙ"	Yj�z|E�%����-ˢVŨl�����=�k��;�.=���˧�x�{�h�h�2O���T%�����:�h�����+�.�$nYK([̅�!"D$}8��Gi��[6��*�_ZRn��ra{�����������Lvf~�.�/�.e��-��8��7��HC�N6h7ӟ��S�㘝�`GeN�����V�V::c��Z���/���Jͥ\�6��4�v�"�{3�Ħ\l�6Je�y�ݷ�2t%t��r�83G	�0&*I�ѴU�L����l�
'O6�V��͡�V�!:D���}ˍ p1)VM�ύ�*�����-m�ƈ��T�SOX2�=�p��9��"Y^���'��*3�2ONڛF�	�]>�N3�#.��0,���D%�Ҷ���Z�����:u��VV���͛�[��S�X�6�R���fr����i�;�@���H���n/`g0b�����O�s�����3lv\\����p:�5)Zya'װ�c�u�,2	����ue��1|�%%~y;=y���zDP�')6�7l��N�������N����
CX���"-�q
?s��Yڏ�r�eZ���wo�^l�'NC��|+�o�ft�st��������3����� }��?��#�kW�{m(HjY�f6����lVMtU��m`|!p��:�d"!m�kD�nnvK�������K�}���B֒���t�>0���l����T$OYڔ�4���"W6"b����̥���'�c�������2�a���fv�*K-�����`���p�j��r���\�!��}3�Y`v����[���rRi4�N�Ee��?9�Vr���o豦M����dj��!����/m;��c����	�$�	�&~+�Mg��H�[<��gAnsڌj�J���a\ײמ �1�{�泳[�̅������G��Y�P�g�~
�Oe�r�����E�I扚�)���H��\�^��&$�nz����rlI9�9�ެT��\"��%򮯭�zZ��JheBF��{w'םN���p5��Γ~�)_%r���mRe�_�������E��Q�	
�������+��.���_���O��ͯ��u�X;0�?��ccY��G�` E�
"��i�ۂ=IT�$���$iY:��}&���'z˘�?d���#f���`��!CGxKل��eM�^�'s��g��D�i�-+2W�>��=��Z+s���s���@��X�z��^��>�a� }'����mVM�Q	�������;���R|6| �0���~�J
&t#n���;* ��׷{�a����U���'d�عZQ��}�j3 Ɓ��=pS�/� W���n�us����N�<9�h���� գ�Hѳ󓧣E1����a�����զ��5�Xg����B�%�����Iw������5�.+���!$�|�I£�^�Ow�S��{l͝_7ؗ�R)-��z�mW3�)u�\�[�ʶC�t��UI��p�E����n(T�dȁ��x�[�%l�:6m�B��@��g㯒�\$���p�ha'�J$���I��������7'Bp��(��o&@�WI���5_d��r�6ݟh:uu�c��_����)�UdJV��Frd�����+����7�*���ֶ�*�@5����'۷̜�y8��nKΛ$��"�H�������$)y�\|��8�U,�� N�h#���./U�]޽�̎sez�}�C�~��|!�8y��I���K(<�)��x����͈��ra���Sy���T�������C�M5���󐝔s���IP�<�=|�eױ�W��孫Zu�|��vN��5�K)��Y5Y������趧X~�PQ5�1ˆ�K�ә|%��+���
V�,A1���
A�@K*j�٨��:܂�	ne-J���E�Mf��+�n�`��?���ŋ ���      �   k  x�%���0D��Q1�)��K��#�,a�^�`H�dz��������w�]�r���7���h�j��c&�{��/�'���s�p,eH����FԹ��6�ik�7�}�d���wC[�jk屢w[�.�[�m8����bxo1����ކ#�+Q�-ּ�f���ӯ�ϯ�����f�Ccjr�����KN>o9����ŧ _��~�*��)���]�m _�/JA�h^�/?%^��|y�x���G�/C����X�,%^����(�>��������W�b~*�U�~'e�
�V��W�"_j�65��U��S��]M�5^��KM��ÇףƛOC�c�����Ӑo\�7�����Mi�7���=���3��s�?cn-      �   >   x�3�465�4���4202�50�50S00�20�2� 
sq���,���Za����� �:�      �   :   x�3�4B#602�50�50S00�22�21�2�bʚXYr���kbeb����� �;@      �   ]   x�3���+N-�,RH�H�M���/?�8�ˈ3,��41'�*�H��(,M�)+��@�s:攤a�KC�p��日b(*
C���qqq ��9%      �   M  x�U�Kr� C��]H��7�%�?G�f�*l䖐����h��<����K)�l�C��z�#�X��C������^jX�RBf??�kT;��*��'�"��<z�����IZ������<����W(GwC�tܶm˳(�c�)[/JA���3�.���ab�~I1��"u�݇U}�,��sP�	��6G�D����|©�T-\�t��u{1J�*�K+�+��"�uI��1�}�$�q"d�ʎǱC����y:�7�I`�Rҹ8m6�V�G*��X\bR�^�R��y�rR���:���9s����)g�O�,��O�&�����g     