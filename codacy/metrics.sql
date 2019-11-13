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
CREATE FUNCTION public.create_index_if_not_exists(table_name text, index_name text, column_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
l_count integer;
BEGIN
SELECT COUNT(*) INTO l_count
FROM pg_class t, pg_index ix, pg_attribute a
WHERE t.oid = ix.indrelid
AND a.attrelid = t.oid
AND a.attnum = ANY(ix.indkey)
AND t.relkind = 'r'
AND lower(t.relname) LIKE lower(table_name)
AND lower(a.attname) LIKE lower(column_name);
if l_count = 0 THEN
EXECUTE 'CREATE index "' || index_name || '" ON "' || table_name || '"("' || column_name || '")';
END if;
end;
$$;
ALTER FUNCTION public.create_index_if_not_exists(table_name text, index_name text, column_name text) OWNER TO codacy;
SET default_tablespace = '';
SET default_with_oids = false;
CREATE TABLE public.commit_coverage_statistics (
    id bigint NOT NULL,
    commit_stats_id bigint NOT NULL,
    files_with_low_coverage bigint
);
ALTER TABLE public.commit_coverage_statistics OWNER TO codacy;
CREATE SEQUENCE public.commit_coverage_statistics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.commit_coverage_statistics_id_seq OWNER TO codacy;
ALTER SEQUENCE public.commit_coverage_statistics_id_seq OWNED BY public.commit_coverage_statistics.id;
CREATE TABLE public.commit_statistics (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    commit_id bigint NOT NULL,
    number_of_issues bigint NOT NULL,
    number_of_loc bigint NOT NULL,
    issues_per_category text NOT NULL,
    issue_percentage bigint NOT NULL,
    total_complexity bigint,
    number_complex_files bigint,
    complex_files_percentage bigint,
    files_changed_to_increase_complexity bigint,
    number_duplicated_lines bigint,
    duplication_percentage bigint,
    coverage_percentage bigint,
    number_files_uncovered bigint,
    tech_debt bigint NOT NULL,
    total_files_added bigint NOT NULL,
    total_files_removed bigint NOT NULL,
    total_files_changed bigint NOT NULL,
    commit_author_name text NOT NULL,
    commit_timestamp timestamp without time zone NOT NULL,
    commit_short_uuid text NOT NULL
);
ALTER TABLE public.commit_statistics OWNER TO codacy;
CREATE SEQUENCE public.commit_statistics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.commit_statistics_id_seq OWNER TO codacy;
ALTER SEQUENCE public.commit_statistics_id_seq OWNED BY public.commit_statistics.id;
CREATE TABLE public.dashboard_stats (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    branch_id bigint NOT NULL,
    commit_stats_id bigint NOT NULL,
    date timestamp without time zone NOT NULL
);
ALTER TABLE public.dashboard_stats OWNER TO codacy;
CREATE SEQUENCE public.dashboard_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.dashboard_stats_id_seq OWNER TO codacy;
ALTER SEQUENCE public.dashboard_stats_id_seq OWNED BY public.dashboard_stats.id;
CREATE TABLE public.file_complexity (
    id bigint NOT NULL,
    commit_id bigint NOT NULL,
    file_id bigint NOT NULL,
    value text NOT NULL,
    file_unique_id bigint
);
ALTER TABLE public.file_complexity OWNER TO codacy;
CREATE SEQUENCE public.file_complexity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.file_complexity_id_seq OWNER TO codacy;
ALTER SEQUENCE public.file_complexity_id_seq OWNED BY public.file_complexity.id;
CREATE TABLE public.file_metrics (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    revision integer NOT NULL,
    file_unique_id bigint NOT NULL,
    buildtime bigint,
    complexity integer,
    line_complexities text,
    loc integer,
    cloc integer,
    nr_methods integer,
    nr_classes integer
);
ALTER TABLE public.file_metrics OWNER TO codacy;
CREATE SEQUENCE public.file_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.file_metrics_id_seq OWNER TO codacy;
ALTER SEQUENCE public.file_metrics_id_seq OWNED BY public.file_metrics.id;
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
CREATE TABLE public.report_files (
    id bigint NOT NULL,
    name text NOT NULL,
    content text NOT NULL,
    creation_date timestamp without time zone NOT NULL,
    report_type text
);
ALTER TABLE public.report_files OWNER TO codacy;
CREATE SEQUENCE public.report_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.report_files_id_seq OWNER TO codacy;
ALTER SEQUENCE public.report_files_id_seq OWNED BY public.report_files.id;
ALTER TABLE ONLY public.commit_coverage_statistics ALTER COLUMN id SET DEFAULT nextval('public.commit_coverage_statistics_id_seq'::regclass);
ALTER TABLE ONLY public.commit_statistics ALTER COLUMN id SET DEFAULT nextval('public.commit_statistics_id_seq'::regclass);
ALTER TABLE ONLY public.dashboard_stats ALTER COLUMN id SET DEFAULT nextval('public.dashboard_stats_id_seq'::regclass);
ALTER TABLE ONLY public.file_complexity ALTER COLUMN id SET DEFAULT nextval('public.file_complexity_id_seq'::regclass);
ALTER TABLE ONLY public.file_metrics ALTER COLUMN id SET DEFAULT nextval('public.file_metrics_id_seq'::regclass);
ALTER TABLE ONLY public.report_files ALTER COLUMN id SET DEFAULT nextval('public.report_files_id_seq'::regclass);
ALTER TABLE ONLY public.commit_coverage_statistics
    ADD CONSTRAINT commit_coverage_statistics_commit_stats_id_key UNIQUE (commit_stats_id);
ALTER TABLE ONLY public.commit_coverage_statistics
    ADD CONSTRAINT commit_coverage_statistics_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.commit_statistics
    ADD CONSTRAINT commit_statistics_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.dashboard_stats
    ADD CONSTRAINT dashboard_stats_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.file_complexity
    ADD CONSTRAINT file_complexity_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.file_metrics
    ADD CONSTRAINT file_metrics_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.file_metrics
    ADD CONSTRAINT file_metrics_project_id_revision_file_unique_id_key UNIQUE (project_id, revision, file_unique_id);
ALTER TABLE ONLY public.play_evolutions
    ADD CONSTRAINT play_evolutions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.report_files
    ADD CONSTRAINT report_files_pkey PRIMARY KEY (id);
CREATE INDEX "CommitStatistics_projectId_commitId" ON public.commit_statistics USING btree (project_id, commit_id);
CREATE INDEX dashboard_stats_commit_stats_id ON public.dashboard_stats USING btree (commit_stats_id);
CREATE INDEX dashboard_stats_project_id_branch_id_idx ON public.dashboard_stats USING btree (project_id, branch_id);
CREATE INDEX file_complexity_commit_id_file_id_idx ON public.file_complexity USING btree (commit_id, file_id);
CREATE INDEX file_complexity_file_unique_id_idx ON public.file_complexity USING btree (file_unique_id);
CREATE INDEX file_metrics_project_id_file_unique_id_idx ON public.file_metrics USING btree (project_id, file_unique_id);
ALTER TABLE ONLY public.commit_coverage_statistics
    ADD CONSTRAINT commit_coverage_statistics_commit_stats_id_fkey FOREIGN KEY (commit_stats_id) REFERENCES public.commit_statistics(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.dashboard_stats
    ADD CONSTRAINT dashboard_stats_commit_stats_id_fkey FOREIGN KEY (commit_stats_id) REFERENCES public.commit_statistics(id) ON DELETE CASCADE;
