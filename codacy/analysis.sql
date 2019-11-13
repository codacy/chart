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
CREATE FUNCTION public.autofillnewid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
NEW."newId" := NEW."id";
RETURN NEW;
END $$;
ALTER FUNCTION public.autofillnewid() OWNER TO codacy;
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
CREATE TABLE public."Algorithm" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    uuid character varying(255) NOT NULL,
    "analysisType" character varying(255) NOT NULL,
    "algorithmEngine" character varying(255) NOT NULL,
    requirement character varying(255) DEFAULT 'Node'::character varying NOT NULL,
    "isExternal" boolean DEFAULT false NOT NULL,
    "needsAst" boolean DEFAULT false NOT NULL,
    "hasConfigParser" boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "hasUIConfiguration" boolean DEFAULT true NOT NULL,
    "default" boolean DEFAULT true NOT NULL,
    "toolDescription" text,
    version character varying(255)
);
ALTER TABLE public."Algorithm" OWNER TO codacy;
CREATE TABLE public."AlgorithmLanguages" (
    id integer NOT NULL,
    "algorithmId" bigint,
    language character varying(255) NOT NULL
);
ALTER TABLE public."AlgorithmLanguages" OWNER TO codacy;
CREATE SEQUENCE public."AlgorithmLanguages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."AlgorithmLanguages_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."AlgorithmLanguages_id_seq" OWNED BY public."AlgorithmLanguages".id;
CREATE SEQUENCE public."Algorithm_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Algorithm_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Algorithm_id_seq" OWNED BY public."Algorithm".id;
CREATE TABLE public."AnalysisStatus" (
    id integer NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    status character varying(255) NOT NULL,
    "startedAnalysis" timestamp without time zone,
    "endedAnalysis" timestamp without time zone,
    "payloadId" bigint NOT NULL,
    "cacheHit" integer,
    "analysisFiles" integer
);
ALTER TABLE public."AnalysisStatus" OWNER TO codacy;
CREATE SEQUENCE public."AnalysisStatus_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."AnalysisStatus_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."AnalysisStatus_id_seq" OWNED BY public."AnalysisStatus".id;
CREATE TABLE public."AutoComment_PullRequestComment" (
    id integer NOT NULL,
    "pullRequestId" bigint NOT NULL,
    "commentId" bigint NOT NULL,
    "commitUUID" text,
    "resultDataId" bigint,
    "resultDataUuid" character varying(255)
);
ALTER TABLE public."AutoComment_PullRequestComment" OWNER TO codacy;
CREATE SEQUENCE public."AutoComment_PullRequestComment_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."AutoComment_PullRequestComment_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."AutoComment_PullRequestComment_id_seq" OWNED BY public."AutoComment_PullRequestComment".id;
CREATE TABLE public."AutoComment_PullRequestSummary" (
    id bigint NOT NULL,
    "pullRequestId" bigint NOT NULL,
    "commentId" bigint NOT NULL
);
ALTER TABLE public."AutoComment_PullRequestSummary" OWNER TO codacy;
CREATE SEQUENCE public."AutoComment_PullRequestSummary_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."AutoComment_PullRequestSummary_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."AutoComment_PullRequestSummary_id_seq" OWNED BY public."AutoComment_PullRequestSummary".id;
CREATE TABLE public."BranchCommit" (
    id integer NOT NULL,
    "branchId" bigint,
    "commitId" bigint,
    "newId" bigint
);
ALTER TABLE public."BranchCommit" OWNER TO codacy;
CREATE SEQUENCE public."BranchCommit_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."BranchCommit_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."BranchCommit_id_seq" OWNED BY public."BranchCommit".id;
CREATE TABLE public."BundlePattern" (
    id integer NOT NULL,
    "bundleId" bigint NOT NULL,
    "patternId" bigint NOT NULL,
    parameters character varying DEFAULT '{}'::character varying NOT NULL
);
ALTER TABLE public."BundlePattern" OWNER TO codacy;
CREATE SEQUENCE public."BundlePattern_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."BundlePattern_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."BundlePattern_id_seq" OWNED BY public."BundlePattern".id;
CREATE TABLE public."BypassedFiles" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    "ignoreType" character varying(255) DEFAULT ''::character varying NOT NULL,
    "fileId" bigint NOT NULL,
    "payloadId" bigint NOT NULL
);
ALTER TABLE public."BypassedFiles" OWNER TO codacy;
CREATE SEQUENCE public."BypassedFiles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."BypassedFiles_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."BypassedFiles_id_seq" OWNED BY public."BypassedFiles".id;
CREATE TABLE public."Cache_AnalysisUUID" (
    id integer NOT NULL,
    uuid text NOT NULL
);
ALTER TABLE public."Cache_AnalysisUUID" OWNER TO codacy;
CREATE SEQUENCE public."Cache_AnalysisUUID_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Cache_AnalysisUUID_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Cache_AnalysisUUID_id_seq" OWNED BY public."Cache_AnalysisUUID".id;
CREATE TABLE public."Cache_CacheEntry" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    "fileUniqueId" bigint NOT NULL,
    "analysisUniqueId" bigint NOT NULL,
    "fileId" bigint NOT NULL,
    dirty boolean DEFAULT false NOT NULL,
    "lastUpdate" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."Cache_CacheEntry" OWNER TO codacy;
CREATE SEQUENCE public."Cache_CacheEntry_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Cache_CacheEntry_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Cache_CacheEntry_id_seq" OWNED BY public."Cache_CacheEntry".id;
CREATE TABLE public."Category" (
    id integer NOT NULL,
    "categoryType" character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);
ALTER TABLE public."Category" OWNER TO codacy;
CREATE SEQUENCE public."Category_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Category_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Category_id_seq" OWNED BY public."Category".id;
CREATE TABLE public."Commit" (
    id integer NOT NULL,
    uuid character varying(255) NOT NULL,
    "parentUuid" character varying(255) NOT NULL,
    "authorTimestamp" timestamp without time zone NOT NULL,
    "commitTimestamp" timestamp without time zone NOT NULL,
    "authorName" character varying(255) NOT NULL,
    message character varying NOT NULL,
    seen boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    "startedAnalysis" timestamp without time zone,
    "endedAnalysis" timestamp without time zone,
    "projectId" bigint NOT NULL,
    "notificationSent" boolean DEFAULT false NOT NULL,
    "authorEmail" character varying(255) DEFAULT ''::character varying NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "retentionStatus" integer DEFAULT 10 NOT NULL,
    "cloneStarted" timestamp without time zone,
    "cloneEnded" timestamp without time zone,
    configuration_uuid character varying(64),
    idx integer
);
ALTER TABLE public."Commit" OWNER TO codacy;
CREATE TABLE public."CommitComparisonFile" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "srcCommitId" bigint NOT NULL,
    "destCommitId" bigint NOT NULL,
    "fileId" bigint NOT NULL,
    "newIssues" integer NOT NULL,
    "fixedIssues" integer NOT NULL,
    "complexityChange" integer,
    "coverageChange" integer,
    "nrClonesChange" integer
);
ALTER TABLE public."CommitComparisonFile" OWNER TO codacy;
CREATE SEQUENCE public."CommitComparisonFile_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."CommitComparisonFile_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."CommitComparisonFile_id_seq" OWNED BY public."CommitComparisonFile".id;
CREATE TABLE public."CommitComparisonOverview" (
    id integer NOT NULL,
    "srcCommitId" bigint NOT NULL,
    "destCommitId" bigint NOT NULL,
    "newIssues" bigint NOT NULL,
    "fixedIssues" bigint NOT NULL,
    "pullRequestGrade" character varying(255) DEFAULT NULL::character varying,
    "complexityAvgDelta" integer,
    "complexityDelta" integer,
    "complexityDeltaWithThreshold" integer,
    "nrClonesDelta" integer,
    "coverageDelta" integer,
    "failedAnalysisSteps" integer,
    "coverageGrade" text
);
ALTER TABLE public."CommitComparisonOverview" OWNER TO codacy;
CREATE SEQUENCE public."CommitComparisonOverview_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."CommitComparisonOverview_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."CommitComparisonOverview_id_seq" OWNED BY public."CommitComparisonOverview".id;
CREATE TABLE public."Commit_AnalysisStatus" (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    status text NOT NULL,
    CONSTRAINT "Commit_AnalysisStatus_status_check" CHECK ((character_length(status) > 0)),
    CONSTRAINT "Commit_AnalysisStatus_uuid_check" CHECK ((character_length((uuid)::text) > 0))
);
ALTER TABLE public."Commit_AnalysisStatus" OWNER TO codacy;
CREATE SEQUENCE public."Commit_AnalysisStatus_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Commit_AnalysisStatus_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Commit_AnalysisStatus_id_seq" OWNED BY public."Commit_AnalysisStatus".id;
CREATE TABLE public."Commit_Author" (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    "possibleUserId" bigint,
    created timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."Commit_Author" OWNER TO codacy;
CREATE SEQUENCE public."Commit_Author_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Commit_Author_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Commit_Author_id_seq" OWNED BY public."Commit_Author".id;
CREATE TABLE public."Commit_CommitAuthor" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "commitId" bigint NOT NULL,
    "authorId" bigint NOT NULL,
    "nrResults" integer DEFAULT 0 NOT NULL
);
ALTER TABLE public."Commit_CommitAuthor" OWNER TO codacy;
CREATE SEQUENCE public."Commit_CommitAuthor_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Commit_CommitAuthor_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Commit_CommitAuthor_id_seq" OWNED BY public."Commit_CommitAuthor".id;
CREATE TABLE public."Commit_FirstCommit" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "commitId" bigint NOT NULL
);
ALTER TABLE public."Commit_FirstCommit" OWNER TO codacy;
CREATE SEQUENCE public."Commit_FirstCommit_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Commit_FirstCommit_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Commit_FirstCommit_id_seq" OWNED BY public."Commit_FirstCommit".id;
CREATE SEQUENCE public."Commit_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Commit_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Commit_id_seq" OWNED BY public."Commit".id;
CREATE TABLE public."ConfigParser" (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);
ALTER TABLE public."ConfigParser" OWNER TO codacy;
CREATE SEQUENCE public."ConfigParser_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ConfigParser_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ConfigParser_id_seq" OWNED BY public."ConfigParser".id;
CREATE TABLE public."Coverage_Coverage" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    "fileId" bigint NOT NULL,
    total integer NOT NULL,
    coverage character varying NOT NULL
);
ALTER TABLE public."Coverage_Coverage" OWNER TO codacy;
CREATE TABLE public."Coverage_CoverageOverview" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    "commitId" bigint NOT NULL,
    total integer NOT NULL,
    language character varying(100) DEFAULT 'Scala'::character varying NOT NULL,
    delta integer
);
ALTER TABLE public."Coverage_CoverageOverview" OWNER TO codacy;
CREATE SEQUENCE public."Coverage_CoverageOverview_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Coverage_CoverageOverview_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Coverage_CoverageOverview_id_seq" OWNED BY public."Coverage_CoverageOverview".id;
CREATE TABLE public."Coverage_CoveragePending" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    "commitUuid" character varying(255) NOT NULL,
    report character varying NOT NULL,
    language character varying(100) DEFAULT 'Scala'::character varying NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    partial boolean
);
ALTER TABLE public."Coverage_CoveragePending" OWNER TO codacy;
CREATE SEQUENCE public."Coverage_CoveragePending_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Coverage_CoveragePending_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Coverage_CoveragePending_id_seq" OWNED BY public."Coverage_CoveragePending".id;
CREATE SEQUENCE public."Coverage_Coverage_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Coverage_Coverage_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Coverage_Coverage_id_seq" OWNED BY public."Coverage_Coverage".id;
CREATE TABLE public."Diff_CommitDiff" (
    id integer NOT NULL,
    "sourceCommitId" bigint NOT NULL,
    diffs character varying NOT NULL,
    "destinationCommitId" bigint,
    "tooLarge" boolean
);
ALTER TABLE public."Diff_CommitDiff" OWNER TO codacy;
CREATE SEQUENCE public."Diff_CommitDiff_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Diff_CommitDiff_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Diff_CommitDiff_id_seq" OWNED BY public."Diff_CommitDiff".id;
CREATE TABLE public."Diff_FileDiff" (
    id integer NOT NULL,
    "commitDiffId" bigint NOT NULL,
    "fileId" bigint,
    "newOffset" integer NOT NULL,
    "linesType" character varying NOT NULL,
    "diffLines" text DEFAULT '[{}]'::text NOT NULL,
    "fileDataId" bigint,
    file_change_type text
);
ALTER TABLE public."Diff_FileDiff" OWNER TO codacy;
CREATE SEQUENCE public."Diff_FileDiff_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Diff_FileDiff_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Diff_FileDiff_id_seq" OWNED BY public."Diff_FileDiff".id;
CREATE TABLE public."Integration_RemoteIssue" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    "issueId" integer,
    "issueUrl" character varying(500) DEFAULT NULL::character varying,
    "issueTimestamp" timestamp without time zone DEFAULT now() NOT NULL,
    "resultDataId" bigint NOT NULL,
    integration character varying(255) DEFAULT 'Github'::character varying NOT NULL,
    "resultDataUuid" character varying(255)
);
ALTER TABLE public."Integration_RemoteIssue" OWNER TO codacy;
CREATE SEQUENCE public."Integration_RemoteIssue_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Integration_RemoteIssue_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Integration_RemoteIssue_id_seq" OWNED BY public."Integration_RemoteIssue".id;
CREATE TABLE public."Pattern" (
    id integer NOT NULL,
    "internalId" character varying(255) NOT NULL,
    "algorithmId" bigint NOT NULL,
    "categoryId" bigint NOT NULL,
    title character varying(255) NOT NULL,
    description character varying(500) NOT NULL,
    explanation text NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    rating integer DEFAULT 1 NOT NULL,
    "timeToFix" integer DEFAULT 5 NOT NULL,
    "isExternal" boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT '2002-05-16 00:00:00'::timestamp without time zone NOT NULL
);
ALTER TABLE public."Pattern" OWNER TO codacy;
CREATE TABLE public."PatternParameter" (
    id integer NOT NULL,
    "patternId" bigint NOT NULL,
    key character varying(250) NOT NULL,
    title character varying(250) NOT NULL,
    "defaultValue" text NOT NULL,
    "parameterType" character varying(256),
    visible boolean DEFAULT true NOT NULL
);
ALTER TABLE public."PatternParameter" OWNER TO codacy;
CREATE SEQUENCE public."PatternParameter_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."PatternParameter_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."PatternParameter_id_seq" OWNED BY public."PatternParameter".id;
CREATE SEQUENCE public."Pattern_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Pattern_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Pattern_id_seq" OWNED BY public."Pattern".id;
CREATE TABLE public."ProjectActivity" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "cacheLastSaved" timestamp without time zone DEFAULT to_timestamp((0)::double precision) NOT NULL,
    last_commit timestamp without time zone
);
ALTER TABLE public."ProjectActivity" OWNER TO codacy;
CREATE SEQUENCE public."ProjectActivity_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectActivity_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectActivity_id_seq" OWNED BY public."ProjectActivity".id;
CREATE TABLE public."ProjectAnalysisCount" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "branchId" bigint NOT NULL,
    date date DEFAULT now() NOT NULL,
    "commitsAnalysed" integer DEFAULT 0 NOT NULL,
    "pullRequestsAnalysed" integer DEFAULT 0 NOT NULL
);
ALTER TABLE public."ProjectAnalysisCount" OWNER TO codacy;
CREATE SEQUENCE public."ProjectAnalysisCount_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectAnalysisCount_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectAnalysisCount_id_seq" OWNED BY public."ProjectAnalysisCount".id;
CREATE TABLE public."ProjectAnalysisCounter" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    date date DEFAULT now() NOT NULL,
    "commitsAnalysed" integer DEFAULT 0 NOT NULL,
    "pullRequestsAnalysed" integer DEFAULT 0 NOT NULL
);
ALTER TABLE public."ProjectAnalysisCounter" OWNER TO codacy;
CREATE SEQUENCE public."ProjectAnalysisCounter_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectAnalysisCounter_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectAnalysisCounter_id_seq" OWNED BY public."ProjectAnalysisCounter".id;
CREATE TABLE public."ProjectIgnoredResult" (
    id integer NOT NULL,
    uuid character varying(255) NOT NULL,
    incorrect boolean DEFAULT false NOT NULL,
    "projectId" bigint NOT NULL,
    "resultDataId" bigint,
    "authorId" bigint NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."ProjectIgnoredResult" OWNER TO codacy;
CREATE SEQUENCE public."ProjectIgnoredResult_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectIgnoredResult_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectIgnoredResult_id_seq" OWNED BY public."ProjectIgnoredResult".id;
CREATE TABLE public."ProjectPattern" (
    id integer NOT NULL,
    "patternId" bigint NOT NULL,
    parameters character varying DEFAULT '{}'::character varying NOT NULL,
    "projectId" bigint NOT NULL,
    "associationTimestamp" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."ProjectPattern" OWNER TO codacy;
CREATE SEQUENCE public."ProjectPattern_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectPattern_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectPattern_id_seq" OWNED BY public."ProjectPattern".id;
CREATE TABLE public."PullRequest" (
    id integer NOT NULL,
    "branchId" bigint NOT NULL,
    "destBranchId" bigint NOT NULL,
    number integer NOT NULL,
    url character varying(256) NOT NULL,
    title text NOT NULL,
    state character varying(256) NOT NULL,
    "ownerUsername" character varying(256) NOT NULL,
    "isMergeable" boolean NOT NULL,
    "latestCommitUuid" character varying(64) DEFAULT ''::character varying NOT NULL,
    "statusCommitUuid" character varying(64) DEFAULT ''::character varying NOT NULL,
    updated timestamp without time zone DEFAULT now() NOT NULL,
    "commonCommitId" bigint,
    analysing boolean DEFAULT false NOT NULL,
    "projectId" bigint NOT NULL,
    "avatarUrl" character varying(512) DEFAULT NULL::character varying,
    "originBranch" character varying(512) DEFAULT NULL::character varying,
    created timestamp without time zone DEFAULT now() NOT NULL,
    closed timestamp without time zone,
    "retentionStatus" integer,
    "startedAnalysis" timestamp without time zone,
    "endedAnalysis" timestamp without time zone,
    author text,
    provider text
);
ALTER TABLE public."PullRequest" OWNER TO codacy;
CREATE TABLE public."PullRequestCommit" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "pullRequestId" bigint NOT NULL,
    "commitId" bigint NOT NULL
);
ALTER TABLE public."PullRequestCommit" OWNER TO codacy;
CREATE SEQUENCE public."PullRequestCommit_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."PullRequestCommit_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."PullRequestCommit_id_seq" OWNED BY public."PullRequestCommit".id;
CREATE SEQUENCE public."PullRequest_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."PullRequest_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."PullRequest_id_seq" OWNED BY public."PullRequest".id;
CREATE TABLE public."ResultOverview_CommitComparisonClone" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "srcCommitId" bigint NOT NULL,
    "destCommitId" bigint NOT NULL,
    "cloneId" bigint NOT NULL,
    "deltaType" text NOT NULL
);
ALTER TABLE public."ResultOverview_CommitComparisonClone" OWNER TO codacy;
CREATE SEQUENCE public."ResultOverview_CommitComparisonClone_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ResultOverview_CommitComparisonClone_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ResultOverview_CommitComparisonClone_id_seq" OWNED BY public."ResultOverview_CommitComparisonClone".id;
CREATE TABLE public."ResultOverview_CommitMetricsOverview" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    language character varying(63) NOT NULL,
    loc integer,
    cloc integer,
    "duplicateLines" integer,
    "nrClasses" integer,
    "nrMethods" integer,
    complexity integer,
    "nrClones" integer,
    "complexityAvg" double precision
);
ALTER TABLE public."ResultOverview_CommitMetricsOverview" OWNER TO codacy;
CREATE SEQUENCE public."ResultOverview_CommitMetricsOverview_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ResultOverview_CommitMetricsOverview_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ResultOverview_CommitMetricsOverview_id_seq" OWNED BY public."ResultOverview_CommitMetricsOverview".id;
CREATE TABLE public."ResultOverview_CommitOverview" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    "newIssues" integer NOT NULL,
    "fixedIssues" integer NOT NULL,
    "totalIssues" integer NOT NULL,
    "projectGrade" integer NOT NULL,
    "patternsAdded" integer DEFAULT 0 NOT NULL,
    "patternsRemoved" integer DEFAULT 0 NOT NULL,
    "commitGrade" character varying(255) DEFAULT NULL::character varying,
    "complexityAvgDelta" integer,
    "complexityDelta" integer,
    "complexityDeltaWithThreshold" integer,
    "nrClonesDelta" integer,
    "coverageDelta" integer,
    "totalCoverage" integer,
    "failedAnalysisSteps" integer,
    "coverageGrade" text
);
ALTER TABLE public."ResultOverview_CommitOverview" OWNER TO codacy;
CREATE SEQUENCE public."ResultOverview_CommitOverview_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ResultOverview_CommitOverview_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ResultOverview_CommitOverview_id_seq" OWNED BY public."ResultOverview_CommitOverview".id;
CREATE TABLE public."ResultOverview_DuplicationOverview" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    "fileId" bigint NOT NULL,
    "nrClones" integer NOT NULL,
    "duplicatedLines" integer NOT NULL
);
ALTER TABLE public."ResultOverview_DuplicationOverview" OWNER TO codacy;
CREATE SEQUENCE public."ResultOverview_DuplicationOverview_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ResultOverview_DuplicationOverview_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ResultOverview_DuplicationOverview_id_seq" OWNED BY public."ResultOverview_DuplicationOverview".id;
CREATE TABLE public."ResultOverview_FilesOverview" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    "newIssues" integer NOT NULL,
    "fixedIssues" integer NOT NULL,
    "totalIssues" integer NOT NULL,
    "fileGrade" integer NOT NULL,
    "fileId" bigint NOT NULL,
    complexity integer,
    "nrMethods" integer NOT NULL,
    loc integer,
    churn integer,
    coverage integer,
    "nrClones" integer,
    "nrClasses" integer DEFAULT 0 NOT NULL,
    "duplicatedLines" integer,
    "timeToFix" integer,
    "coverableLines" integer
);
ALTER TABLE public."ResultOverview_FilesOverview" OWNER TO codacy;
CREATE TABLE public."ResultOverview_FilesOverviewDelta" (
    id integer NOT NULL,
    "commitId" bigint,
    "fileId" bigint,
    "newIssues" integer NOT NULL,
    "fixedIssues" integer NOT NULL,
    complexity integer,
    coverage integer,
    "nrClones" integer
);
ALTER TABLE public."ResultOverview_FilesOverviewDelta" OWNER TO codacy;
CREATE SEQUENCE public."ResultOverview_FilesOverviewDelta_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ResultOverview_FilesOverviewDelta_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ResultOverview_FilesOverviewDelta_id_seq" OWNED BY public."ResultOverview_FilesOverviewDelta".id;
CREATE SEQUENCE public."ResultOverview_FilesOverview_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ResultOverview_FilesOverview_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ResultOverview_FilesOverview_id_seq" OWNED BY public."ResultOverview_FilesOverview".id;
CREATE TABLE public."ResultOverview_ProjectOverview" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    date date DEFAULT now(),
    "fixedIssues" integer DEFAULT 0,
    "newIssues" integer DEFAULT 0,
    "totalIssues" integer DEFAULT 0,
    "nrClones" integer DEFAULT 0,
    coverage integer DEFAULT 0,
    "nrMethods" integer DEFAULT 0,
    "nrClasses" integer DEFAULT 0,
    "timeToFix" integer DEFAULT 0,
    complexity integer DEFAULT 0,
    "userEmail" text DEFAULT ''::text NOT NULL
);
ALTER TABLE public."ResultOverview_ProjectOverview" OWNER TO codacy;
CREATE SEQUENCE public."ResultOverview_ProjectOverview_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ResultOverview_ProjectOverview_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ResultOverview_ProjectOverview_id_seq" OWNED BY public."ResultOverview_ProjectOverview".id;
CREATE TABLE public."ResultOverview_UserOverview" (
    id bigint NOT NULL,
    "userId" integer NOT NULL,
    date date DEFAULT now(),
    "fixedIssues" integer DEFAULT 0,
    "newIssues" integer DEFAULT 0,
    "totalIssues" integer DEFAULT 0,
    "nrClones" integer DEFAULT 0,
    coverage integer DEFAULT 0,
    "nrMethods" integer DEFAULT 0,
    "nrClasses" integer DEFAULT 0
);
ALTER TABLE public."ResultOverview_UserOverview" OWNER TO codacy;
CREATE SEQUENCE public."ResultOverview_UserOverview_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ResultOverview_UserOverview_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ResultOverview_UserOverview_id_seq" OWNED BY public."ResultOverview_UserOverview".id;
CREATE TABLE public."Result_Class" (
    id integer NOT NULL,
    "fileId" bigint NOT NULL,
    name character varying(255) NOT NULL,
    line integer
);
ALTER TABLE public."Result_Class" OWNER TO codacy;
CREATE TABLE public."Result_ClassMetrics" (
    id integer NOT NULL,
    "classId" bigint NOT NULL,
    complexity integer,
    loc integer,
    cloc integer
);
ALTER TABLE public."Result_ClassMetrics" OWNER TO codacy;
CREATE SEQUENCE public."Result_ClassMetrics_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_ClassMetrics_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_ClassMetrics_id_seq" OWNED BY public."Result_ClassMetrics".id;
CREATE SEQUENCE public."Result_Class_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_Class_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_Class_id_seq" OWNED BY public."Result_Class".id;
CREATE TABLE public."Result_Clone" (
    id integer NOT NULL,
    "tokensNumber" integer NOT NULL,
    "linesNumber" integer NOT NULL,
    "codeHash" character varying(63) NOT NULL
);
ALTER TABLE public."Result_Clone" OWNER TO codacy;
CREATE TABLE public."Result_CloneFile" (
    id integer NOT NULL,
    "cloneId" bigint NOT NULL,
    "fileId" bigint NOT NULL,
    "startLine" integer NOT NULL,
    "endLine" integer DEFAULT 1 NOT NULL
);
ALTER TABLE public."Result_CloneFile" OWNER TO codacy;
CREATE SEQUENCE public."Result_CloneFile_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_CloneFile_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_CloneFile_id_seq" OWNED BY public."Result_CloneFile".id;
CREATE SEQUENCE public."Result_Clone_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_Clone_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_Clone_id_seq" OWNED BY public."Result_Clone".id;
CREATE TABLE public."Result_File" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    "fileDataId" bigint NOT NULL,
    changed boolean NOT NULL,
    "fileUniqueId" bigint
);
ALTER TABLE public."Result_File" OWNER TO codacy;
CREATE TABLE public."Result_FileChurn" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    "fileDataId" bigint NOT NULL,
    "nrChanges" integer DEFAULT 0 NOT NULL
);
ALTER TABLE public."Result_FileChurn" OWNER TO codacy;
CREATE SEQUENCE public."Result_FileChurn_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_FileChurn_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_FileChurn_id_seq" OWNED BY public."Result_FileChurn".id;
CREATE TABLE public."Result_FileData" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    filename character varying(4096) NOT NULL,
    ignored boolean NOT NULL,
    language character varying(63) NOT NULL
);
ALTER TABLE public."Result_FileData" OWNER TO codacy;
CREATE SEQUENCE public."Result_FileData_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_FileData_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_FileData_id_seq" OWNED BY public."Result_FileData".id;
CREATE TABLE public."Result_FileMetrics" (
    id integer NOT NULL,
    "commitId" bigint NOT NULL,
    "fileId" bigint NOT NULL,
    complexity integer,
    churn integer,
    buildtime integer,
    loc integer,
    cloc integer,
    "nrMethods" integer,
    "nrClasses" integer
);
ALTER TABLE public."Result_FileMetrics" OWNER TO codacy;
CREATE SEQUENCE public."Result_FileMetrics_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_FileMetrics_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_FileMetrics_id_seq" OWNED BY public."Result_FileMetrics".id;
CREATE SEQUENCE public."Result_File_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_File_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_File_id_seq" OWNED BY public."Result_File".id;
CREATE TABLE public."Result_GitFileHash" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "fileStoreId" bigint NOT NULL,
    hash text
);
ALTER TABLE public."Result_GitFileHash" OWNER TO codacy;
CREATE SEQUENCE public."Result_GitFileHash_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_GitFileHash_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_GitFileHash_id_seq" OWNED BY public."Result_GitFileHash".id;
CREATE TABLE public."Result_Method" (
    id integer NOT NULL,
    "fileId" bigint NOT NULL,
    name character varying(255) NOT NULL,
    line integer
);
ALTER TABLE public."Result_Method" OWNER TO codacy;
CREATE TABLE public."Result_MethodMetrics" (
    id integer NOT NULL,
    "methodId" bigint NOT NULL,
    complexity integer,
    loc integer,
    cloc integer
);
ALTER TABLE public."Result_MethodMetrics" OWNER TO codacy;
CREATE SEQUENCE public."Result_MethodMetrics_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_MethodMetrics_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_MethodMetrics_id_seq" OWNED BY public."Result_MethodMetrics".id;
CREATE SEQUENCE public."Result_Method_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Result_Method_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Result_Method_id_seq" OWNED BY public."Result_Method".id;
CREATE TABLE public."Retention_RetentionData" (
    id integer NOT NULL,
    "projectId" bigint,
    "commitsToReduce" integer NOT NULL,
    "lastClean" timestamp without time zone DEFAULT now() NOT NULL,
    "lastGlobalClean" timestamp without time zone DEFAULT now() NOT NULL,
    "serverName" character varying(63) DEFAULT NULL::character varying
);
ALTER TABLE public."Retention_RetentionData" OWNER TO codacy;
CREATE SEQUENCE public."Retention_RetentionData_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Retention_RetentionData_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Retention_RetentionData_id_seq" OWNED BY public."Retention_RetentionData".id;
CREATE TABLE public."System_Task" (
    id integer NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    "requiredAlgorithm" character varying(255) NOT NULL,
    retries integer DEFAULT 0 NOT NULL,
    priority integer DEFAULT 50 NOT NULL,
    "payloadId" bigint NOT NULL,
    cost integer DEFAULT 20 NOT NULL,
    "commitId" bigint,
    "projectId" bigint NOT NULL,
    "serverName" character varying(63) DEFAULT NULL::character varying,
    "cleanCache" boolean DEFAULT false NOT NULL,
    "pullRequestId" bigint
);
ALTER TABLE public."System_Task" OWNER TO codacy;
CREATE TABLE public."System_TaskDependency" (
    id bigint NOT NULL,
    "taskId" bigint NOT NULL,
    "taskDependentId" bigint NOT NULL
);
ALTER TABLE public."System_TaskDependency" OWNER TO codacy;
CREATE SEQUENCE public."System_TaskDependency_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."System_TaskDependency_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."System_TaskDependency_id_seq" OWNED BY public."System_TaskDependency".id;
CREATE TABLE public."System_TaskLog" (
    id integer NOT NULL,
    "payloadId" bigint NOT NULL,
    "serverId" bigint,
    "logReason" character varying(255) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."System_TaskLog" OWNER TO codacy;
CREATE SEQUENCE public."System_TaskLog_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."System_TaskLog_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."System_TaskLog_id_seq" OWNED BY public."System_TaskLog".id;
CREATE TABLE public."System_TaskPayload" (
    id integer NOT NULL,
    "commitId" bigint,
    "projectId" bigint NOT NULL,
    "runnerId" bigint,
    "taskType" character varying(63) NOT NULL,
    language character varying(63),
    "analysisUniqueId" bigint,
    "fileOffset" integer,
    "fileLimit" integer
);
ALTER TABLE public."System_TaskPayload" OWNER TO codacy;
CREATE TABLE public."System_TaskPayloadPullRequest" (
    id bigint NOT NULL,
    "taskPayloadId" bigint NOT NULL,
    "pullRequestId" bigint NOT NULL
);
ALTER TABLE public."System_TaskPayloadPullRequest" OWNER TO codacy;
CREATE SEQUENCE public."System_TaskPayloadPullRequest_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."System_TaskPayloadPullRequest_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."System_TaskPayloadPullRequest_id_seq" OWNED BY public."System_TaskPayloadPullRequest".id;
CREATE SEQUENCE public."System_TaskPayload_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."System_TaskPayload_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."System_TaskPayload_id_seq" OWNED BY public."System_TaskPayload".id;
CREATE SEQUENCE public."System_Task_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."System_Task_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."System_Task_id_seq" OWNED BY public."System_Task".id;
CREATE TABLE public.algorithm_language (
    id bigint NOT NULL,
    algorithm_id bigint NOT NULL,
    language text NOT NULL
);
ALTER TABLE public.algorithm_language OWNER TO codacy;
CREATE SEQUENCE public.algorithm_language_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.algorithm_language_id_seq OWNER TO codacy;
ALTER SEQUENCE public.algorithm_language_id_seq OWNED BY public.algorithm_language.id;
CREATE TABLE public.coverage_commit_status (
    project_id bigint NOT NULL,
    commit_uuid text NOT NULL,
    partial_status text NOT NULL
);
ALTER TABLE public.coverage_commit_status OWNER TO codacy;
CREATE TABLE public.diff_file_diff (
    id bigint NOT NULL,
    commit_diff_id bigint,
    source_commit_id bigint NOT NULL,
    destination_commit_id bigint,
    file_data_id bigint,
    new_offset integer NOT NULL,
    lines_type character varying NOT NULL,
    diff_lines text DEFAULT '[{}]'::text NOT NULL,
    file_change_type text
);
ALTER TABLE public.diff_file_diff OWNER TO codacy;
CREATE SEQUENCE public.diff_file_diff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.diff_file_diff_id_seq OWNER TO codacy;
ALTER SEQUENCE public.diff_file_diff_id_seq OWNED BY public.diff_file_diff.id;
CREATE TABLE public.pattern_language (
    id bigint NOT NULL,
    pattern_id bigint NOT NULL,
    language text NOT NULL
);
ALTER TABLE public.pattern_language OWNER TO codacy;
CREATE SEQUENCE public.pattern_language_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.pattern_language_id_seq OWNER TO codacy;
ALTER SEQUENCE public.pattern_language_id_seq OWNED BY public.pattern_language.id;
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
CREATE TABLE public.project_authorized_authors (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    name text NOT NULL,
    email text NOT NULL
);
ALTER TABLE public.project_authorized_authors OWNER TO codacy;
CREATE SEQUENCE public.project_authorized_authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.project_authorized_authors_id_seq OWNER TO codacy;
ALTER SEQUENCE public.project_authorized_authors_id_seq OWNED BY public.project_authorized_authors.id;
CREATE TABLE public.pull_request_impact (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    pr_id bigint NOT NULL,
    issues_impact integer,
    complexity_impact integer,
    clones_impact integer,
    coverage_impact integer
);
ALTER TABLE public.pull_request_impact OWNER TO codacy;
CREATE SEQUENCE public.pull_request_impact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.pull_request_impact_id_seq OWNER TO codacy;
ALTER SEQUENCE public.pull_request_impact_id_seq OWNED BY public.pull_request_impact.id;
ALTER TABLE ONLY public."Algorithm" ALTER COLUMN id SET DEFAULT nextval('public."Algorithm_id_seq"'::regclass);
ALTER TABLE ONLY public."AlgorithmLanguages" ALTER COLUMN id SET DEFAULT nextval('public."AlgorithmLanguages_id_seq"'::regclass);
ALTER TABLE ONLY public."AnalysisStatus" ALTER COLUMN id SET DEFAULT nextval('public."AnalysisStatus_id_seq"'::regclass);
ALTER TABLE ONLY public."AutoComment_PullRequestComment" ALTER COLUMN id SET DEFAULT nextval('public."AutoComment_PullRequestComment_id_seq"'::regclass);
ALTER TABLE ONLY public."AutoComment_PullRequestSummary" ALTER COLUMN id SET DEFAULT nextval('public."AutoComment_PullRequestSummary_id_seq"'::regclass);
ALTER TABLE ONLY public."BranchCommit" ALTER COLUMN id SET DEFAULT nextval('public."BranchCommit_id_seq"'::regclass);
ALTER TABLE ONLY public."BundlePattern" ALTER COLUMN id SET DEFAULT nextval('public."BundlePattern_id_seq"'::regclass);
ALTER TABLE ONLY public."BypassedFiles" ALTER COLUMN id SET DEFAULT nextval('public."BypassedFiles_id_seq"'::regclass);
ALTER TABLE ONLY public."Cache_AnalysisUUID" ALTER COLUMN id SET DEFAULT nextval('public."Cache_AnalysisUUID_id_seq"'::regclass);
ALTER TABLE ONLY public."Cache_CacheEntry" ALTER COLUMN id SET DEFAULT nextval('public."Cache_CacheEntry_id_seq"'::regclass);
ALTER TABLE ONLY public."Category" ALTER COLUMN id SET DEFAULT nextval('public."Category_id_seq"'::regclass);
ALTER TABLE ONLY public."Commit" ALTER COLUMN id SET DEFAULT nextval('public."Commit_id_seq"'::regclass);
ALTER TABLE ONLY public."CommitComparisonFile" ALTER COLUMN id SET DEFAULT nextval('public."CommitComparisonFile_id_seq"'::regclass);
ALTER TABLE ONLY public."CommitComparisonOverview" ALTER COLUMN id SET DEFAULT nextval('public."CommitComparisonOverview_id_seq"'::regclass);
ALTER TABLE ONLY public."Commit_AnalysisStatus" ALTER COLUMN id SET DEFAULT nextval('public."Commit_AnalysisStatus_id_seq"'::regclass);
ALTER TABLE ONLY public."Commit_Author" ALTER COLUMN id SET DEFAULT nextval('public."Commit_Author_id_seq"'::regclass);
ALTER TABLE ONLY public."Commit_CommitAuthor" ALTER COLUMN id SET DEFAULT nextval('public."Commit_CommitAuthor_id_seq"'::regclass);
ALTER TABLE ONLY public."Commit_FirstCommit" ALTER COLUMN id SET DEFAULT nextval('public."Commit_FirstCommit_id_seq"'::regclass);
ALTER TABLE ONLY public."ConfigParser" ALTER COLUMN id SET DEFAULT nextval('public."ConfigParser_id_seq"'::regclass);
ALTER TABLE ONLY public."Coverage_Coverage" ALTER COLUMN id SET DEFAULT nextval('public."Coverage_Coverage_id_seq"'::regclass);
ALTER TABLE ONLY public."Coverage_CoverageOverview" ALTER COLUMN id SET DEFAULT nextval('public."Coverage_CoverageOverview_id_seq"'::regclass);
ALTER TABLE ONLY public."Coverage_CoveragePending" ALTER COLUMN id SET DEFAULT nextval('public."Coverage_CoveragePending_id_seq"'::regclass);
ALTER TABLE ONLY public."Diff_CommitDiff" ALTER COLUMN id SET DEFAULT nextval('public."Diff_CommitDiff_id_seq"'::regclass);
ALTER TABLE ONLY public."Diff_FileDiff" ALTER COLUMN id SET DEFAULT nextval('public."Diff_FileDiff_id_seq"'::regclass);
ALTER TABLE ONLY public."Integration_RemoteIssue" ALTER COLUMN id SET DEFAULT nextval('public."Integration_RemoteIssue_id_seq"'::regclass);
ALTER TABLE ONLY public."Pattern" ALTER COLUMN id SET DEFAULT nextval('public."Pattern_id_seq"'::regclass);
ALTER TABLE ONLY public."PatternParameter" ALTER COLUMN id SET DEFAULT nextval('public."PatternParameter_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectActivity" ALTER COLUMN id SET DEFAULT nextval('public."ProjectActivity_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectAnalysisCount" ALTER COLUMN id SET DEFAULT nextval('public."ProjectAnalysisCount_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectAnalysisCounter" ALTER COLUMN id SET DEFAULT nextval('public."ProjectAnalysisCounter_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectIgnoredResult" ALTER COLUMN id SET DEFAULT nextval('public."ProjectIgnoredResult_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectPattern" ALTER COLUMN id SET DEFAULT nextval('public."ProjectPattern_id_seq"'::regclass);
ALTER TABLE ONLY public."PullRequest" ALTER COLUMN id SET DEFAULT nextval('public."PullRequest_id_seq"'::regclass);
ALTER TABLE ONLY public."PullRequestCommit" ALTER COLUMN id SET DEFAULT nextval('public."PullRequestCommit_id_seq"'::regclass);
ALTER TABLE ONLY public."ResultOverview_CommitComparisonClone" ALTER COLUMN id SET DEFAULT nextval('public."ResultOverview_CommitComparisonClone_id_seq"'::regclass);
ALTER TABLE ONLY public."ResultOverview_CommitMetricsOverview" ALTER COLUMN id SET DEFAULT nextval('public."ResultOverview_CommitMetricsOverview_id_seq"'::regclass);
ALTER TABLE ONLY public."ResultOverview_CommitOverview" ALTER COLUMN id SET DEFAULT nextval('public."ResultOverview_CommitOverview_id_seq"'::regclass);
ALTER TABLE ONLY public."ResultOverview_DuplicationOverview" ALTER COLUMN id SET DEFAULT nextval('public."ResultOverview_DuplicationOverview_id_seq"'::regclass);
ALTER TABLE ONLY public."ResultOverview_FilesOverview" ALTER COLUMN id SET DEFAULT nextval('public."ResultOverview_FilesOverview_id_seq"'::regclass);
ALTER TABLE ONLY public."ResultOverview_FilesOverviewDelta" ALTER COLUMN id SET DEFAULT nextval('public."ResultOverview_FilesOverviewDelta_id_seq"'::regclass);
ALTER TABLE ONLY public."ResultOverview_ProjectOverview" ALTER COLUMN id SET DEFAULT nextval('public."ResultOverview_ProjectOverview_id_seq"'::regclass);
ALTER TABLE ONLY public."ResultOverview_UserOverview" ALTER COLUMN id SET DEFAULT nextval('public."ResultOverview_UserOverview_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_Class" ALTER COLUMN id SET DEFAULT nextval('public."Result_Class_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_ClassMetrics" ALTER COLUMN id SET DEFAULT nextval('public."Result_ClassMetrics_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_Clone" ALTER COLUMN id SET DEFAULT nextval('public."Result_Clone_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_CloneFile" ALTER COLUMN id SET DEFAULT nextval('public."Result_CloneFile_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_File" ALTER COLUMN id SET DEFAULT nextval('public."Result_File_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_FileChurn" ALTER COLUMN id SET DEFAULT nextval('public."Result_FileChurn_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_FileData" ALTER COLUMN id SET DEFAULT nextval('public."Result_FileData_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_FileMetrics" ALTER COLUMN id SET DEFAULT nextval('public."Result_FileMetrics_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_GitFileHash" ALTER COLUMN id SET DEFAULT nextval('public."Result_GitFileHash_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_Method" ALTER COLUMN id SET DEFAULT nextval('public."Result_Method_id_seq"'::regclass);
ALTER TABLE ONLY public."Result_MethodMetrics" ALTER COLUMN id SET DEFAULT nextval('public."Result_MethodMetrics_id_seq"'::regclass);
ALTER TABLE ONLY public."Retention_RetentionData" ALTER COLUMN id SET DEFAULT nextval('public."Retention_RetentionData_id_seq"'::regclass);
ALTER TABLE ONLY public."System_Task" ALTER COLUMN id SET DEFAULT nextval('public."System_Task_id_seq"'::regclass);
ALTER TABLE ONLY public."System_TaskDependency" ALTER COLUMN id SET DEFAULT nextval('public."System_TaskDependency_id_seq"'::regclass);
ALTER TABLE ONLY public."System_TaskLog" ALTER COLUMN id SET DEFAULT nextval('public."System_TaskLog_id_seq"'::regclass);
ALTER TABLE ONLY public."System_TaskPayload" ALTER COLUMN id SET DEFAULT nextval('public."System_TaskPayload_id_seq"'::regclass);
ALTER TABLE ONLY public."System_TaskPayloadPullRequest" ALTER COLUMN id SET DEFAULT nextval('public."System_TaskPayloadPullRequest_id_seq"'::regclass);
ALTER TABLE ONLY public.algorithm_language ALTER COLUMN id SET DEFAULT nextval('public.algorithm_language_id_seq'::regclass);
ALTER TABLE ONLY public.diff_file_diff ALTER COLUMN id SET DEFAULT nextval('public.diff_file_diff_id_seq'::regclass);
ALTER TABLE ONLY public.pattern_language ALTER COLUMN id SET DEFAULT nextval('public.pattern_language_id_seq'::regclass);
ALTER TABLE ONLY public.project_authorized_authors ALTER COLUMN id SET DEFAULT nextval('public.project_authorized_authors_id_seq'::regclass);
ALTER TABLE ONLY public.pull_request_impact ALTER COLUMN id SET DEFAULT nextval('public.pull_request_impact_id_seq'::regclass);
ALTER TABLE ONLY public."AlgorithmLanguages"
    ADD CONSTRAINT "AlgorithmLanguages_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Algorithm"
    ADD CONSTRAINT "Algorithm_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."AnalysisStatus"
    ADD CONSTRAINT "AnalysisStatus_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."AutoComment_PullRequestComment"
    ADD CONSTRAINT "AutoComment_PullRequestComment_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."AutoComment_PullRequestSummary"
    ADD CONSTRAINT "AutoComment_PullRequestSummary_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."BranchCommit"
    ADD CONSTRAINT "BranchCommit_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."BundlePattern"
    ADD CONSTRAINT "BundlePattern_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."BypassedFiles"
    ADD CONSTRAINT "BypassedFiles_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Cache_AnalysisUUID"
    ADD CONSTRAINT "Cache_AnalysisUUID_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Cache_CacheEntry"
    ADD CONSTRAINT "Cache_CacheEntry_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Category"
    ADD CONSTRAINT "Category_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."CommitComparisonFile"
    ADD CONSTRAINT "CommitComparisonFile_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."CommitComparisonOverview"
    ADD CONSTRAINT "CommitComparisonOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Commit_AnalysisStatus"
    ADD CONSTRAINT "Commit_AnalysisStatus_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Commit_AnalysisStatus"
    ADD CONSTRAINT "Commit_AnalysisStatus_project_id_uuid_key" UNIQUE (project_id, uuid);
ALTER TABLE ONLY public."Commit_Author"
    ADD CONSTRAINT "Commit_Author_email_name_key" UNIQUE (email, name);
ALTER TABLE ONLY public."Commit_Author"
    ADD CONSTRAINT "Commit_Author_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Commit_CommitAuthor"
    ADD CONSTRAINT "Commit_CommitAuthor_commitId_authorId_key" UNIQUE ("commitId", "authorId");
ALTER TABLE ONLY public."Commit_CommitAuthor"
    ADD CONSTRAINT "Commit_CommitAuthor_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Commit_FirstCommit"
    ADD CONSTRAINT "Commit_FirstCommit_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Commit_FirstCommit"
    ADD CONSTRAINT "Commit_FirstCommit_projectId_key" UNIQUE ("projectId");
ALTER TABLE ONLY public."Commit"
    ADD CONSTRAINT "Commit_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ConfigParser"
    ADD CONSTRAINT "ConfigParser_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ConfigParser"
    ADD CONSTRAINT "ConfigParser_uuid_key" UNIQUE (uuid);
ALTER TABLE ONLY public."Diff_CommitDiff"
    ADD CONSTRAINT "Diff_CommitDiff_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Diff_FileDiff"
    ADD CONSTRAINT "Diff_FileDiff_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Integration_RemoteIssue"
    ADD CONSTRAINT "Integration_RemoteIssue_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."PatternParameter"
    ADD CONSTRAINT "PatternParameter_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Pattern"
    ADD CONSTRAINT "Pattern_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectActivity"
    ADD CONSTRAINT "ProjectActivity_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectActivity"
    ADD CONSTRAINT "ProjectActivity_projectId_key" UNIQUE ("projectId");
ALTER TABLE ONLY public."ProjectAnalysisCount"
    ADD CONSTRAINT "ProjectAnalysisCount_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectAnalysisCounter"
    ADD CONSTRAINT "ProjectAnalysisCounter_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectIgnoredResult"
    ADD CONSTRAINT "ProjectIgnoredResult_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectPattern"
    ADD CONSTRAINT "ProjectPattern_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."PullRequestCommit"
    ADD CONSTRAINT "PullRequestCommit_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."PullRequestCommit"
    ADD CONSTRAINT "PullRequestCommit_pullRequestId_commitId_key" UNIQUE ("pullRequestId", "commitId");
ALTER TABLE ONLY public."PullRequest"
    ADD CONSTRAINT "PullRequest_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_CommitComparisonClone"
    ADD CONSTRAINT "ResultOverview_CommitComparisonClone_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_CommitMetricsOverview"
    ADD CONSTRAINT "ResultOverview_CommitMetricsOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_CommitOverview"
    ADD CONSTRAINT "ResultOverview_CommitOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_DuplicationOverview"
    ADD CONSTRAINT "ResultOverview_DuplicationOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_FilesOverviewDelta"
    ADD CONSTRAINT "ResultOverview_FilesOverviewDelta_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_FilesOverview"
    ADD CONSTRAINT "ResultOverview_FilesOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_ProjectOverview"
    ADD CONSTRAINT "ResultOverview_ProjectOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_ProjectOverview"
    ADD CONSTRAINT "ResultOverview_ProjectOverview_projectId_date_userEmail_key" UNIQUE ("projectId", date, "userEmail");
ALTER TABLE ONLY public."ResultOverview_UserOverview"
    ADD CONSTRAINT "ResultOverview_UserOverview_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ResultOverview_UserOverview"
    ADD CONSTRAINT "ResultOverview_UserOverview_userId_date_key" UNIQUE ("userId", date);
ALTER TABLE ONLY public."Result_ClassMetrics"
    ADD CONSTRAINT "Result_ClassMetrics_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_Class"
    ADD CONSTRAINT "Result_Class_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_CloneFile"
    ADD CONSTRAINT "Result_CloneFile_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_Clone"
    ADD CONSTRAINT "Result_Clone_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_FileChurn"
    ADD CONSTRAINT "Result_FileChurn_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_FileData"
    ADD CONSTRAINT "Result_FileData_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_FileMetrics"
    ADD CONSTRAINT "Result_FileMetrics_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_File"
    ADD CONSTRAINT "Result_File_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_GitFileHash"
    ADD CONSTRAINT "Result_GitFileHash_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_MethodMetrics"
    ADD CONSTRAINT "Result_MethodMetrics_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Result_Method"
    ADD CONSTRAINT "Result_Method_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Retention_RetentionData"
    ADD CONSTRAINT "Retention_RetentionData_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."System_TaskDependency"
    ADD CONSTRAINT "System_TaskDependency_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."System_TaskLog"
    ADD CONSTRAINT "System_TaskLog_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."System_TaskPayloadPullRequest"
    ADD CONSTRAINT "System_TaskPayloadPullRequest_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."System_TaskPayload"
    ADD CONSTRAINT "System_TaskPayload_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."System_Task"
    ADD CONSTRAINT "System_Task_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public.algorithm_language
    ADD CONSTRAINT algorithm_language_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.diff_file_diff
    ADD CONSTRAINT diff_file_diff_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pattern_language
    ADD CONSTRAINT pattern_language_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.play_evolutions
    ADD CONSTRAINT play_evolutions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.project_authorized_authors
    ADD CONSTRAINT project_authorized_authors_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.pull_request_impact
    ADD CONSTRAINT pull_request_impact_pkey PRIMARY KEY (id);
CREATE UNIQUE INDEX "Algorithm_uuid_key" ON public."Algorithm" USING btree (uuid);
CREATE INDEX "AnalysisStatus_payloadId" ON public."AnalysisStatus" USING btree ("payloadId");
CREATE INDEX "AutoComment_PullRequestComment_pullRequestId_idx" ON public."AutoComment_PullRequestComment" USING btree ("pullRequestId");
CREATE INDEX "AutoComment_PullRequestSummary_pullRequestId" ON public."AutoComment_PullRequestSummary" USING btree ("pullRequestId");
CREATE UNIQUE INDEX "BranchCommit_branchId_commitId_key" ON public."BranchCommit" USING btree ("branchId", "commitId");
CREATE INDEX "BranchCommit_commitId" ON public."BranchCommit" USING btree ("commitId");
CREATE UNIQUE INDEX "BundlePattern_patternId_bundleId_key" ON public."BundlePattern" USING btree ("patternId", "bundleId");
CREATE INDEX "BypassedFiles_commitId" ON public."BypassedFiles" USING btree ("commitId");
CREATE INDEX "BypassedFiles_fileId" ON public."BypassedFiles" USING btree ("fileId");
CREATE INDEX "BypassedFiles_payloadId" ON public."BypassedFiles" USING btree ("payloadId");
CREATE UNIQUE INDEX "Cache_AnalysisUUID_uuid_key" ON public."Cache_AnalysisUUID" USING btree (uuid);
CREATE INDEX "Cache_CacheEntry_commitId" ON public."Cache_CacheEntry" USING btree ("commitId");
CREATE INDEX "Cache_CacheEntry_fileId" ON public."Cache_CacheEntry" USING btree ("fileId");
CREATE INDEX "Cache_CacheEntry_fileUniqueId_analysisUniqueId_not_dirty" ON public."Cache_CacheEntry" USING btree ("fileUniqueId", "analysisUniqueId");
CREATE UNIQUE INDEX "Category_categoryType_key" ON public."Category" USING btree ("categoryType");
CREATE INDEX "ClassMetrics_classId" ON public."Result_ClassMetrics" USING btree ("classId");
CREATE INDEX "Class_fileId" ON public."Result_Class" USING btree ("fileId");
CREATE INDEX "CloneFile_cloneId" ON public."Result_CloneFile" USING btree ("cloneId");
CREATE INDEX "CloneFile_fileId" ON public."Result_CloneFile" USING btree ("fileId");
CREATE INDEX "CommitComparisonFile_fileId" ON public."CommitComparisonFile" USING btree ("fileId");
CREATE INDEX "CommitComparisonFile_srcCommitId_destCommitId" ON public."CommitComparisonFile" USING btree ("srcCommitId", "destCommitId");
CREATE UNIQUE INDEX "CommitComparisonOverview_srcCommitId_destCommitId" ON public."CommitComparisonOverview" USING btree ("srcCommitId", "destCommitId");
CREATE INDEX "CommitDiff_commitId" ON public."Diff_CommitDiff" USING btree ("sourceCommitId");
CREATE UNIQUE INDEX "CommitMetricsOverview_commitId_language_key" ON public."ResultOverview_CommitMetricsOverview" USING btree ("commitId", language);
CREATE UNIQUE INDEX "CommitOverview_commitId_key" ON public."ResultOverview_CommitOverview" USING btree ("commitId");
CREATE UNIQUE INDEX "Commit_projectId_uuid" ON public."Commit" USING btree ("projectId", uuid);
CREATE INDEX "Coverage_Coverage_fileId" ON public."Coverage_Coverage" USING btree ("fileId");
CREATE INDEX "Diff_FileDiff_fileDataId" ON public."Diff_FileDiff" USING btree ("fileDataId");
CREATE UNIQUE INDEX "FileData_projectId_filename_key" ON public."Result_FileData" USING btree ("projectId", filename);
CREATE UNIQUE INDEX "FileMetrics_commitId_fileId_key" ON public."Result_FileMetrics" USING btree ("commitId", "fileId");
CREATE INDEX "FileMetrics_fileId" ON public."Result_FileMetrics" USING btree ("fileId");
CREATE UNIQUE INDEX "File_commitId_fileDataId_key" ON public."Result_File" USING btree ("commitId", "fileDataId");
CREATE INDEX "File_fileDataId" ON public."Result_File" USING btree ("fileDataId");
CREATE INDEX "File_fileUniqueId" ON public."Result_File" USING btree ("fileUniqueId");
CREATE INDEX "FilesOverview_commitId" ON public."ResultOverview_FilesOverview" USING btree ("commitId");
CREATE INDEX "FilesOverview_fileId" ON public."ResultOverview_FilesOverview" USING btree ("fileId");
CREATE INDEX "MethodMetrics_methodId" ON public."Result_MethodMetrics" USING btree ("methodId");
CREATE INDEX "Method_fileId" ON public."Result_Method" USING btree ("fileId");
CREATE UNIQUE INDEX "PatternParameter_patternId_key_key" ON public."PatternParameter" USING btree ("patternId", key);
CREATE UNIQUE INDEX "Pattern_internalId_key" ON public."Pattern" USING btree ("internalId");
CREATE INDEX "ProjectAnalysisCount_projectId_branchId" ON public."ProjectAnalysisCount" USING btree ("projectId", "branchId");
CREATE INDEX "ProjectAnalysisCounter_projectId" ON public."ProjectAnalysisCounter" USING btree ("projectId");
CREATE INDEX "ProjectIgnoredResult_projectId_idx" ON public."ProjectIgnoredResult" USING btree ("projectId");
CREATE INDEX "ProjectIgnoredResult_resultDataId" ON public."ProjectIgnoredResult" USING btree ("resultDataId");
CREATE UNIQUE INDEX "ProjectPattern_projectId_patternId_key" ON public."ProjectPattern" USING btree ("projectId", "patternId");
CREATE INDEX "PullRequestCommit_projectId" ON public."PullRequestCommit" USING btree ("projectId");
CREATE INDEX "PullRequest_branchId" ON public."PullRequest" USING btree ("branchId");
CREATE INDEX "PullRequest_destBranchId" ON public."PullRequest" USING btree ("destBranchId");
CREATE INDEX "PullRequest_projectId" ON public."PullRequest" USING btree ("projectId");
CREATE INDEX "ResultOverview_CommitComparisonClone_cloneId" ON public."ResultOverview_CommitComparisonClone" USING btree ("cloneId");
CREATE INDEX "ResultOverview_CommitComparisonClone_projectId" ON public."ResultOverview_CommitComparisonClone" USING btree ("projectId");
CREATE INDEX "ResultOverview_CommitComparisonClone_srcCommitId_destCommitId" ON public."ResultOverview_CommitComparisonClone" USING btree ("srcCommitId", "destCommitId");
CREATE INDEX "ResultOverview_DuplicationOverview_commitId" ON public."ResultOverview_DuplicationOverview" USING btree ("commitId");
CREATE INDEX "ResultOverview_DuplicationOverview_fileId" ON public."ResultOverview_DuplicationOverview" USING btree ("fileId");
CREATE INDEX "Result_CloneFile_cloneId" ON public."Result_CloneFile" USING btree ("cloneId");
CREATE INDEX "Result_CloneFile_fileId" ON public."Result_CloneFile" USING btree ("fileId");
CREATE UNIQUE INDEX "Result_FileChurn_projectId_fileDataId_key" ON public."Result_FileChurn" USING btree ("projectId", "fileDataId");
CREATE INDEX "Result_GitFileHash_projectId" ON public."Result_GitFileHash" USING btree ("projectId");
CREATE INDEX "Result_MethodMetrics_methodId" ON public."Result_MethodMetrics" USING btree ("methodId");
CREATE UNIQUE INDEX "Retention_RetentionData_projectId_key" ON public."Retention_RetentionData" USING btree ("projectId");
CREATE UNIQUE INDEX "System_TaskDependency_taskId_taskDependentId_key" ON public."System_TaskDependency" USING btree ("taskId", "taskDependentId");
CREATE INDEX "System_TaskLog_taskPayloadId" ON public."System_TaskLog" USING btree ("payloadId");
CREATE INDEX "System_TaskPayloadPullRequest_pullRequestId" ON public."System_TaskPayloadPullRequest" USING btree ("pullRequestId");
CREATE UNIQUE INDEX "System_TaskPayloadPullRequest_taskPayloadId" ON public."System_TaskPayloadPullRequest" USING btree ("taskPayloadId");
CREATE INDEX "System_TaskPayload_commitId" ON public."System_TaskPayload" USING btree ("commitId");
CREATE INDEX "System_Task_commitId" ON public."System_Task" USING btree ("commitId");
CREATE INDEX "System_Task_payloadId" ON public."System_Task" USING btree ("payloadId");
CREATE INDEX "System_Task_projectId" ON public."System_Task" USING btree ("projectId");
CREATE INDEX "System_Task_pullRequestId" ON public."System_Task" USING btree ("pullRequestId");
CREATE INDEX "System_Task_serverName" ON public."System_Task" USING btree ("serverName");
CREATE UNIQUE INDEX algorithm_language_algorithm_id_language_idx ON public.algorithm_language USING btree (algorithm_id, language);
CREATE UNIQUE INDEX coverage_commit_status_project_id_commit_uuid ON public.coverage_commit_status USING btree (project_id, commit_uuid);
CREATE INDEX diff_file_diff_file_data_id_idx ON public.diff_file_diff USING btree (file_data_id);
CREATE INDEX diff_file_diff_source_commit_id_destination_commit_id_idx ON public.diff_file_diff USING btree (source_commit_id, destination_commit_id);
CREATE INDEX diff_file_diff_source_commit_id_idx ON public.diff_file_diff USING btree (source_commit_id);
CREATE UNIQUE INDEX pattern_language_pattern_id_language_idx ON public.pattern_language USING btree (pattern_id, language);
CREATE UNIQUE INDEX project_authorized_authors_project_id_email_key ON public.project_authorized_authors USING btree (project_id, email);
CREATE INDEX pull_request_impact_pr_id_idx ON public.pull_request_impact USING btree (pr_id);
CREATE INDEX pull_request_impact_project_id_idx ON public.pull_request_impact USING btree (project_id);
CREATE TRIGGER "newIdAutoFill" BEFORE INSERT OR UPDATE ON public."BranchCommit" FOR EACH ROW EXECUTE PROCEDURE public.autofillnewid();
ALTER TABLE ONLY public."AlgorithmLanguages"
    ADD CONSTRAINT "AlgorithmLanguages_algorithmId_fkey" FOREIGN KEY ("algorithmId") REFERENCES public."Algorithm"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."AnalysisStatus"
    ADD CONSTRAINT "AnalysisStatus_payloadId_fkey" FOREIGN KEY ("payloadId") REFERENCES public."System_TaskPayload"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."BranchCommit"
    ADD CONSTRAINT "BranchCommit_commitId_fkey" FOREIGN KEY ("commitId") REFERENCES public."Commit"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."BundlePattern"
    ADD CONSTRAINT "BundlePattern_patternId_fkey" FOREIGN KEY ("patternId") REFERENCES public."Pattern"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."BypassedFiles"
    ADD CONSTRAINT "BypassedFiles_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."BypassedFiles"
    ADD CONSTRAINT "BypassedFiles_payloadId_fkey" FOREIGN KEY ("payloadId") REFERENCES public."System_TaskPayload"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Cache_CacheEntry"
    ADD CONSTRAINT "Cache_CacheEntry_analysisUniqueId_fkey" FOREIGN KEY ("analysisUniqueId") REFERENCES public."Cache_AnalysisUUID"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Cache_CacheEntry"
    ADD CONSTRAINT "Cache_CacheEntry_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."CommitComparisonFile"
    ADD CONSTRAINT "CommitComparisonFile_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Commit_CommitAuthor"
    ADD CONSTRAINT "Commit_CommitAuthor_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES public."Commit_Author"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Coverage_Coverage"
    ADD CONSTRAINT "Coverage_Coverage_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Diff_FileDiff"
    ADD CONSTRAINT "Diff_FileDiff_commitDiffId_fkey" FOREIGN KEY ("commitDiffId") REFERENCES public."Diff_CommitDiff"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Diff_FileDiff"
    ADD CONSTRAINT "Diff_FileDiff_fileDataId_fkey" FOREIGN KEY ("fileDataId") REFERENCES public."Result_FileData"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Diff_FileDiff"
    ADD CONSTRAINT "Diff_FileDiff_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."PatternParameter"
    ADD CONSTRAINT "PatternParameter_patternId_fkey" FOREIGN KEY ("patternId") REFERENCES public."Pattern"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Pattern"
    ADD CONSTRAINT "Pattern_algorithmId_fkey" FOREIGN KEY ("algorithmId") REFERENCES public."Algorithm"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Pattern"
    ADD CONSTRAINT "Pattern_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES public."Category"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectPattern"
    ADD CONSTRAINT "ProjectPattern_patternId_fkey" FOREIGN KEY ("patternId") REFERENCES public."Pattern"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."PullRequestCommit"
    ADD CONSTRAINT "PullRequestCommit_commitId_fkey" FOREIGN KEY ("commitId") REFERENCES public."Commit"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."PullRequestCommit"
    ADD CONSTRAINT "PullRequestCommit_pullRequestId_fkey" FOREIGN KEY ("pullRequestId") REFERENCES public."PullRequest"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."PullRequest"
    ADD CONSTRAINT "PullRequest_commonCommitId_fkey" FOREIGN KEY ("commonCommitId") REFERENCES public."Commit"(id) ON DELETE CASCADE NOT VALID;
ALTER TABLE ONLY public."ResultOverview_CommitComparisonClone"
    ADD CONSTRAINT "ResultOverview_CommitComparisonClone_cloneId_fkey" FOREIGN KEY ("cloneId") REFERENCES public."Result_Clone"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ResultOverview_DuplicationOverview"
    ADD CONSTRAINT "ResultOverview_DuplicationOverview_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ResultOverview_FilesOverviewDelta"
    ADD CONSTRAINT "ResultOverview_FilesOverviewDelta_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ResultOverview_FilesOverview"
    ADD CONSTRAINT "ResultOverview_FilesOverview_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_ClassMetrics"
    ADD CONSTRAINT "Result_ClassMetrics_classId_fkey" FOREIGN KEY ("classId") REFERENCES public."Result_Class"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_Class"
    ADD CONSTRAINT "Result_Class_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_CloneFile"
    ADD CONSTRAINT "Result_CloneFile_cloneId_fkey" FOREIGN KEY ("cloneId") REFERENCES public."Result_Clone"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_CloneFile"
    ADD CONSTRAINT "Result_CloneFile_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_FileChurn"
    ADD CONSTRAINT "Result_FileChurn_fileDataId_fkey" FOREIGN KEY ("fileDataId") REFERENCES public."Result_FileData"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_FileMetrics"
    ADD CONSTRAINT "Result_FileMetrics_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_File"
    ADD CONSTRAINT "Result_File_fileDataId_fkey" FOREIGN KEY ("fileDataId") REFERENCES public."Result_FileData"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_MethodMetrics"
    ADD CONSTRAINT "Result_MethodMetrics_methodId_fkey" FOREIGN KEY ("methodId") REFERENCES public."Result_Method"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Result_Method"
    ADD CONSTRAINT "Result_Method_fileId_fkey" FOREIGN KEY ("fileId") REFERENCES public."Result_File"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."System_TaskDependency"
    ADD CONSTRAINT "System_TaskDependency_taskDependentId_fkey" FOREIGN KEY ("taskDependentId") REFERENCES public."System_Task"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."System_TaskDependency"
    ADD CONSTRAINT "System_TaskDependency_taskId_fkey" FOREIGN KEY ("taskId") REFERENCES public."System_Task"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."System_TaskLog"
    ADD CONSTRAINT "System_TaskLog_payloadId_fkey" FOREIGN KEY ("payloadId") REFERENCES public."System_TaskPayload"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."System_TaskPayloadPullRequest"
    ADD CONSTRAINT "System_TaskPayloadPullRequest_taskPayloadId_fkey" FOREIGN KEY ("taskPayloadId") REFERENCES public."System_TaskPayload"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."System_TaskPayload"
    ADD CONSTRAINT "System_TaskPayload_analysisUniqueId_fkey" FOREIGN KEY ("analysisUniqueId") REFERENCES public."Cache_AnalysisUUID"(id) ON DELETE SET NULL;
ALTER TABLE ONLY public."System_Task"
    ADD CONSTRAINT "System_Task_payloadId_fkey" FOREIGN KEY ("payloadId") REFERENCES public."System_TaskPayload"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.algorithm_language
    ADD CONSTRAINT algorithm_language_algorithm_id_fkey FOREIGN KEY (algorithm_id) REFERENCES public."Algorithm"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.diff_file_diff
    ADD CONSTRAINT diff_file_diff_file_data_id_fkey FOREIGN KEY (file_data_id) REFERENCES public."Result_FileData"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.pattern_language
    ADD CONSTRAINT pattern_language_pattern_id_fkey FOREIGN KEY (pattern_id) REFERENCES public."Pattern"(id) ON DELETE CASCADE;
