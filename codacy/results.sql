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
CREATE FUNCTION public.result_partition_function_create_month_table(table_date character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
_tablename       TEXT;
_startmonthstamp TEXT;
_endmonthstamp   TEXT;
BEGIN
_startmonthstamp := table_date;
_tablename := 'Result_Result_' || _startmonthstamp;
_startmonthstamp := _startmonthstamp || '-01';
PERFORM 1
FROM pg_catalog.pg_class c
JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE c.relkind = 'r'
AND c.relname = _tablename
AND n.nspname = 'public';
IF NOT FOUND
THEN
_endmonthstamp:= to_char(_startmonthstamp :: TIMESTAMP + INTERVAL '1 month', 'YYYY-MM-DD');
EXECUTE 'CREATE TABLE public.' || quote_ident(_tablename) || ' ( ' ||
'  CHECK ( ' ||
'           "timestamp" >= ' || quote_literal(_startmonthstamp) || ' AND ' ||
'           "timestamp" <  ' || quote_literal(_endmonthstamp) ||
'        ) ' ||
') INHERITS (public."Result_Result")';
EXECUTE 'CREATE INDEX ' || quote_ident(_tablename || '_timestamp_id') ||
' ON public.' || quote_ident(_tablename) || ' (timestamp, id)';
EXECUTE 'CREATE INDEX ' || quote_ident(_tablename || '_commitId') || ' ON ' || quote_ident(_tablename) ||
' ("commitId")';
EXECUTE 'CREATE INDEX ' || quote_ident(_tablename || '_fileId') || ' ON ' || quote_ident(_tablename) ||
' ("fileId")';
EXECUTE 'CREATE INDEX ' || quote_ident(_tablename || '_resultDataId') || ' ON ' || quote_ident(_tablename) ||
' ("resultDataId")';
EXECUTE 'CREATE INDEX ' || quote_ident(_tablename || '_resultOverviewId') || ' ON ' || quote_ident(_tablename) ||
' ("resultOverviewId")';
EXECUTE
'ALTER TABLE ' || quote_ident(_tablename) || 'ADD CONSTRAINT ' || quote_ident(_tablename || '_resultDataId_fkey') ||
'FOREIGN KEY ("resultDataId") REFERENCES "Result_ResultData" ON DELETE CASCADE';
EXECUTE 'ALTER TABLE ' || quote_ident(_tablename) || 'ADD CONSTRAINT ' ||
quote_ident(_tablename || '_resultOverviewId_fkey') ||
'FOREIGN KEY ("resultOverviewId") REFERENCES "ResultOverview_ResultOverview" ON DELETE CASCADE';
RETURN 1;
END IF;
RETURN 0;
END;
$$;
ALTER FUNCTION public.result_partition_function_create_month_table(table_date character varying) OWNER TO codacy;
CREATE FUNCTION public.result_partition_function_generate_table(months integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
_startmonthstamp TEXT;
_result          BOOLEAN;
BEGIN
_startmonthstamp := to_char(NOW() + (months || ' months') :: INTERVAL, 'YYYY-MM');
SELECT public.result_partition_function_create_month_table(_startmonthstamp)
INTO _result;
RETURN _result;
END;
$$;
ALTER FUNCTION public.result_partition_function_generate_table(months integer) OWNER TO codacy;
CREATE FUNCTION public.result_partition_function_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
_tablename       TEXT;
_startmonthstamp TEXT;
BEGIN
IF NEW."timestamp" < '2014-12-01'
THEN
_startmonthstamp := 'Old';
ELSE
_startmonthstamp := to_char(NEW."timestamp", 'YYYY-MM');
EXECUTE 'SELECT public.result_partition_function_create_month_table(' || quote_literal(_startmonthstamp) || ')';
END IF;
_tablename := 'Result_Result_' || _startmonthstamp;
EXECUTE 'INSERT INTO public.' || quote_ident(_tablename) || ' VALUES ($1.*)'
USING NEW;
RETURN NULL;
END;
$_$;
ALTER FUNCTION public.result_partition_function_insert() OWNER TO codacy;
CREATE SEQUENCE public.commitcomparison_id_seq
    START WITH 9000000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.commitcomparison_id_seq OWNER TO codacy;
SET default_tablespace = '';
SET default_with_oids = false;
CREATE TABLE public."CommitComparison" (
    id bigint DEFAULT nextval('public.commitcomparison_id_seq'::regclass) NOT NULL,
    "srcCommitId" bigint NOT NULL,
    "destCommitId" bigint NOT NULL,
    "resultId" bigint NOT NULL,
    "deltaType" character varying(32) NOT NULL
);
ALTER TABLE public."CommitComparison" OWNER TO codacy;
CREATE SEQUENCE public.resultoverview_deltaoverview_id_seq
    START WITH 9000000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.resultoverview_deltaoverview_id_seq OWNER TO codacy;
CREATE TABLE public."ResultOverview_DeltaOverview" (
    id bigint DEFAULT nextval('public.resultoverview_deltaoverview_id_seq'::regclass) NOT NULL,
    "commitId" bigint NOT NULL,
    "resultId" bigint NOT NULL,
    "deltaType" character varying(64) NOT NULL
);
ALTER TABLE public."ResultOverview_DeltaOverview" OWNER TO codacy;
CREATE SEQUENCE public.resultoverview_resultoverview_id_seq
    START WITH 9000000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.resultoverview_resultoverview_id_seq OWNER TO codacy;
CREATE TABLE public."ResultOverview_ResultOverview" (
    id bigint DEFAULT nextval('public.resultoverview_resultoverview_id_seq'::regclass) NOT NULL,
    level character varying(100) NOT NULL,
    "patternId" bigint NOT NULL,
    "commitId" bigint NOT NULL,
    count integer DEFAULT 0 NOT NULL,
    "totalCost" integer DEFAULT 0 NOT NULL,
    language character varying(50)
);
ALTER TABLE public."ResultOverview_ResultOverview" OWNER TO codacy;
CREATE SEQUENCE public.result_resultdata_id_seq
    START WITH 90000000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.result_resultdata_id_seq OWNER TO codacy;
CREATE TABLE public."Result_Result" (
    id bigint DEFAULT nextval('public.result_resultdata_id_seq'::regclass) NOT NULL,
    "commitId" bigint NOT NULL,
    "fileId" bigint NOT NULL,
    "resultDataId" bigint NOT NULL,
    "resultOverviewId" bigint NOT NULL,
    "startLine" integer NOT NULL,
    dirty boolean NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);
ALTER TABLE public."Result_Result" OWNER TO codacy;
CREATE TABLE public."Result_ResultData" (
    id bigint DEFAULT nextval('public.result_resultdata_id_seq'::regclass) NOT NULL,
    "projectId" bigint NOT NULL,
    "patternId" bigint NOT NULL,
    level character varying(100) NOT NULL,
    message character varying(2048) NOT NULL,
    "lineText" character varying(2048) NOT NULL,
    uuid character varying(255) NOT NULL,
    cost integer NOT NULL,
    "fileDataId" bigint NOT NULL
);
ALTER TABLE public."Result_ResultData" OWNER TO codacy;
CREATE SEQUENCE public.result_resultmetadata_id_seq
    START WITH 90000000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.result_resultmetadata_id_seq OWNER TO codacy;
CREATE TABLE public."Result_ResultMetadata" (
    id bigint DEFAULT nextval('public.result_resultmetadata_id_seq'::regclass) NOT NULL,
    "projectId" bigint NOT NULL,
    "blameCommitId" bigint,
    "originalFile" character varying(2048),
    "originalLine" integer,
    "commentId" integer,
    "commentUrl" character varying(500) DEFAULT NULL::character varying,
    "commentTimestamp" timestamp without time zone,
    "resultDataId" bigint NOT NULL,
    "authorId" bigint,
    "resultDataUuid" character varying(255)
);
ALTER TABLE public."Result_ResultMetadata" OWNER TO codacy;
CREATE TABLE public."Result_Result_Old" (
    CONSTRAINT "Result_Result_Old_timestamp_check" CHECK (("timestamp" < '2014-12-01 00:00:00'::timestamp without time zone))
)
INHERITS (public."Result_Result");
ALTER TABLE public."Result_Result_Old" OWNER TO codacy;
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
CREATE SEQUENCE public.result_result_id_seq
    START WITH 900000000000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.result_result_id_seq OWNER TO codacy;
ALTER TABLE ONLY public."Result_Result_Old" ALTER COLUMN id SET DEFAULT nextval('public.result_resultdata_id_seq'::regclass);
ALTER TABLE ONLY public."CommitComparison"
    ADD CONSTRAINT "CommitComparison_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_DeltaOverview"
    ADD CONSTRAINT "ResultOverview_DeltaOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_ResultOverview"
    ADD CONSTRAINT "ResultOverview_ResultOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_ResultData"
    ADD CONSTRAINT "Result_ResultData_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_ResultMetadata"
    ADD CONSTRAINT "Result_ResultMetadata_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_Result"
    ADD CONSTRAINT "Result_Result_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public.play_evolutions
    ADD CONSTRAINT play_evolutions_pkey PRIMARY KEY (id);
CREATE INDEX "CommitComparison_destCommitId" ON public."CommitComparison" USING btree ("destCommitId");
CREATE INDEX "CommitComparison_resultId" ON public."CommitComparison" USING btree ("resultId");
CREATE INDEX "CommitComparison_srcCommitId" ON public."CommitComparison" USING btree ("srcCommitId");
CREATE INDEX "CommitComparison_srcCommitId_destCommitId" ON public."CommitComparison" USING btree ("srcCommitId", "destCommitId");
CREATE INDEX "DeltaOverview_commitId" ON public."ResultOverview_DeltaOverview" USING btree ("commitId");
CREATE INDEX "DeltaOverview_resultId" ON public."ResultOverview_DeltaOverview" USING btree ("resultId");
CREATE INDEX "ResultData_fileDataId" ON public."Result_ResultData" USING btree ("fileDataId");
CREATE INDEX "ResultData_patternId" ON public."Result_ResultData" USING btree ("patternId");
CREATE INDEX "ResultData_projectId_uuid_key" ON public."Result_ResultData" USING btree ("projectId", uuid);
CREATE INDEX "ResultMetadata_blameCommitId" ON public."Result_ResultMetadata" USING btree ("blameCommitId");
CREATE INDEX "ResultMetadata_projectId" ON public."Result_ResultMetadata" USING btree ("projectId");
CREATE INDEX "ResultOverview_commitId" ON public."ResultOverview_ResultOverview" USING btree ("commitId");
CREATE INDEX "ResultOverview_patternId" ON public."ResultOverview_ResultOverview" USING btree ("patternId");
CREATE INDEX "Result_ResultMetadata_authorId" ON public."Result_ResultMetadata" USING btree ("authorId");
CREATE INDEX "Result_ResultMetadata_resultDataId" ON public."Result_ResultMetadata" USING btree ("resultDataId");
CREATE INDEX "Result_Result_Old_commitId" ON public."Result_Result_Old" USING btree ("commitId");
CREATE INDEX "Result_Result_Old_fileId" ON public."Result_Result_Old" USING btree ("fileId");
CREATE INDEX "Result_Result_Old_resultDataId" ON public."Result_Result_Old" USING btree ("resultDataId");
CREATE INDEX "Result_Result_Old_resultOverviewId" ON public."Result_Result_Old" USING btree ("resultOverviewId");
CREATE INDEX "Result_Result_Old_timestamp_id" ON public."Result_Result_Old" USING btree ("timestamp", id);
CREATE INDEX "Result_Result_commitId" ON public."Result_Result" USING btree ("commitId");
CREATE INDEX "Result_Result_fileId" ON public."Result_Result" USING btree ("fileId");
CREATE INDEX "Result_Result_resultDataId" ON public."Result_Result" USING btree ("resultDataId");
CREATE INDEX "Result_Result_resultOverviewId" ON public."Result_Result" USING btree ("resultOverviewId");
CREATE INDEX "Result_Result_timestamp_id" ON public."Result_Result" USING btree ("timestamp", id);
CREATE TRIGGER result_result_partition_trigger_insert BEFORE INSERT ON public."Result_Result" FOR EACH ROW EXECUTE PROCEDURE public.result_partition_function_insert();
ALTER TABLE ONLY public."Result_ResultMetadata"
    ADD CONSTRAINT "Result_ResultMetadata_resultDataId_fkey" FOREIGN KEY ("resultDataId") REFERENCES public."Result_ResultData"(id);
ALTER TABLE ONLY public."Result_Result_Old"
    ADD CONSTRAINT "Result_Result_Old_resultDataId_fkey" FOREIGN KEY ("resultDataId") REFERENCES public."Result_ResultData"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_Result_Old"
    ADD CONSTRAINT "Result_Result_Old_resultOverviewId_fkey" FOREIGN KEY ("resultOverviewId") REFERENCES public."ResultOverview_ResultOverview"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_Result"
    ADD CONSTRAINT "Result_Result_resultDataId_fkey" FOREIGN KEY ("resultDataId") REFERENCES public."Result_ResultData"(id);
ALTER TABLE ONLY public."Result_Result"
    ADD CONSTRAINT "Result_Result_resultOverviewId_fkey" FOREIGN KEY ("resultOverviewId") REFERENCES public."ResultOverview_ResultOverview"(id);
