SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;
CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
SET default_tablespace = '';
SET default_with_oids = false;
CREATE TABLE public."FileStore_FileContents" (
    id bigint NOT NULL,
    uuid character varying(43) NOT NULL,
    contents text NOT NULL,
    "lastAccess" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."FileStore_FileContents" OWNER TO codacy;
CREATE SEQUENCE public."FileStore_FileContents_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."FileStore_FileContents_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."FileStore_FileContents_id_seq" OWNED BY public."FileStore_FileContents".id;
CREATE TABLE public.play_evolutions (
    id integer NOT NULL,
    hash character varying(255) NOT NULL,
    applied_at timestamp without time zone NOT NULL,
    apply_script text,
    revert_script text,
    state character varying(255),
    last_problem text
);
ALTER TABLE public.play_evolutions OWNER TO codacy;
ALTER TABLE ONLY public."FileStore_FileContents" ALTER COLUMN id SET DEFAULT nextval('public."FileStore_FileContents_id_seq"'::regclass);
ALTER TABLE ONLY public."FileStore_FileContents"
    ADD CONSTRAINT "FileStore_FileContents_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."FileStore_FileContents"
    ADD CONSTRAINT "FileStore_FileContents_uuid_key" UNIQUE (uuid);
ALTER TABLE ONLY public.play_evolutions
    ADD CONSTRAINT play_evolutions_pkey PRIMARY KEY (id);
