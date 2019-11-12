--
-- PostgreSQL database dump
--

-- Dumped from database version 10.8
-- Dumped by pg_dump version 10.8

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

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: Jobs_Job; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Jobs_Job" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "commitUUID" character varying(255),
    "jobType" character varying(255) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    retries integer NOT NULL,
    priority integer NOT NULL,
    "progressTasksLeft" integer,
    "progressLastChanged" timestamp without time zone,
    "serverType" character varying(255) DEFAULT false NOT NULL,
    owner character varying(255) DEFAULT 'Owner_0'::character varying NOT NULL,
    "startedAnalysis" timestamp without time zone,
    "useAzure" boolean DEFAULT false NOT NULL,
    "cleanCache" boolean DEFAULT false NOT NULL,
    "pullRequestId" bigint,
    "paymentPlanType" character varying(255),
    detected_analysis timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Jobs_Job" OWNER TO codacy;

--
-- Name: Jobs_JobDependency; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Jobs_JobDependency" (
    id bigint NOT NULL,
    "jobId" bigint NOT NULL,
    "jobDependentId" bigint NOT NULL
);


ALTER TABLE public."Jobs_JobDependency" OWNER TO codacy;

--
-- Name: Jobs_JobDependency_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Jobs_JobDependency_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Jobs_JobDependency_id_seq" OWNER TO codacy;

--
-- Name: Jobs_JobDependency_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Jobs_JobDependency_id_seq" OWNED BY public."Jobs_JobDependency".id;


--
-- Name: Jobs_Job_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Jobs_Job_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Jobs_Job_id_seq" OWNER TO codacy;

--
-- Name: Jobs_Job_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Jobs_Job_id_seq" OWNED BY public."Jobs_Job".id;


--
-- Name: Jobs_ProjectJob; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Jobs_ProjectJob" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    stopped boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Jobs_ProjectJob" OWNER TO codacy;

--
-- Name: Jobs_ProjectJob_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Jobs_ProjectJob_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Jobs_ProjectJob_id_seq" OWNER TO codacy;

--
-- Name: Jobs_ProjectJob_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Jobs_ProjectJob_id_seq" OWNED BY public."Jobs_ProjectJob".id;


--
-- Name: Jobs_Server; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Jobs_Server" (
    id bigint NOT NULL,
    "serverIP" character varying(255) NOT NULL,
    "workerVersion" character varying(255) DEFAULT 'dev'::character varying,
    "serverState" character varying(255) DEFAULT 'Zombie'::character varying NOT NULL,
    "serverType" character varying(255) DEFAULT 'Generic'::character varying NOT NULL,
    "lastUpdated" timestamp without time zone DEFAULT now() NOT NULL,
    owner character varying(255) DEFAULT NULL::character varying,
    name character varying(255) DEFAULT 'no-name'::character varying NOT NULL,
    "instanceId" character varying(255) DEFAULT 'no-instance'::character varying NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    "jobCount" integer DEFAULT 0 NOT NULL,
    "lastDockerUpdate" timestamp without time zone DEFAULT now() NOT NULL,
    "lastStart" timestamp without time zone DEFAULT now() NOT NULL,
    "dockerUpdating" boolean DEFAULT false NOT NULL,
    "serviceProvider" character varying(63) DEFAULT 'Amazon'::character varying NOT NULL
);


ALTER TABLE public."Jobs_Server" OWNER TO codacy;

--
-- Name: Jobs_Server_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Jobs_Server_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Jobs_Server_id_seq" OWNER TO codacy;

--
-- Name: Jobs_Server_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Jobs_Server_id_seq" OWNED BY public."Jobs_Server".id;


--
-- Name: Jobs_Worker; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Jobs_Worker" (
    id bigint NOT NULL,
    "workerUUID" character varying(255) NOT NULL,
    "serverId" bigint NOT NULL,
    port integer NOT NULL,
    status character varying(255),
    created timestamp without time zone,
    "jobId" bigint,
    "startedAnalysis" timestamp without time zone
);


ALTER TABLE public."Jobs_Worker" OWNER TO codacy;

--
-- Name: Jobs_WorkerManagerSettings; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Jobs_WorkerManagerSettings" (
    id bigint NOT NULL,
    "isRunning" boolean DEFAULT true NOT NULL
);


ALTER TABLE public."Jobs_WorkerManagerSettings" OWNER TO codacy;

--
-- Name: Jobs_WorkerManagerSettings_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Jobs_WorkerManagerSettings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Jobs_WorkerManagerSettings_id_seq" OWNER TO codacy;

--
-- Name: Jobs_WorkerManagerSettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Jobs_WorkerManagerSettings_id_seq" OWNED BY public."Jobs_WorkerManagerSettings".id;


--
-- Name: Jobs_Worker_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Jobs_Worker_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Jobs_Worker_id_seq" OWNER TO codacy;

--
-- Name: Jobs_Worker_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Jobs_Worker_id_seq" OWNED BY public."Jobs_Worker".id;


--
-- Name: jobs_worker_v2; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.jobs_worker_v2 (
    id bigint NOT NULL,
    worker_uuid character varying NOT NULL,
    job_id bigint,
    status character varying NOT NULL,
    created timestamp without time zone NOT NULL,
    started_analysis timestamp without time zone,
    maintain_retry_left integer DEFAULT 3 NOT NULL
);


ALTER TABLE public.jobs_worker_v2 OWNER TO codacy;

--
-- Name: jobs_worker_v2_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.jobs_worker_v2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.jobs_worker_v2_id_seq OWNER TO codacy;

--
-- Name: jobs_worker_v2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.jobs_worker_v2_id_seq OWNED BY public.jobs_worker_v2.id;


--
-- Name: play_evolutions; Type: TABLE; Schema: public; Owner: codacy
--

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

--
-- Name: Jobs_Job id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_Job" ALTER COLUMN id SET DEFAULT nextval('public."Jobs_Job_id_seq"'::regclass);


--
-- Name: Jobs_JobDependency id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_JobDependency" ALTER COLUMN id SET DEFAULT nextval('public."Jobs_JobDependency_id_seq"'::regclass);


--
-- Name: Jobs_ProjectJob id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_ProjectJob" ALTER COLUMN id SET DEFAULT nextval('public."Jobs_ProjectJob_id_seq"'::regclass);


--
-- Name: Jobs_Server id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_Server" ALTER COLUMN id SET DEFAULT nextval('public."Jobs_Server_id_seq"'::regclass);


--
-- Name: Jobs_Worker id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_Worker" ALTER COLUMN id SET DEFAULT nextval('public."Jobs_Worker_id_seq"'::regclass);


--
-- Name: Jobs_WorkerManagerSettings id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_WorkerManagerSettings" ALTER COLUMN id SET DEFAULT nextval('public."Jobs_WorkerManagerSettings_id_seq"'::regclass);


--
-- Name: jobs_worker_v2 id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.jobs_worker_v2 ALTER COLUMN id SET DEFAULT nextval('public.jobs_worker_v2_id_seq'::regclass);


--
-- Name: Jobs_JobDependency Jobs_JobDependency_jobId_jobDependentId_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_JobDependency"
    ADD CONSTRAINT "Jobs_JobDependency_jobId_jobDependentId_key" UNIQUE ("jobId", "jobDependentId");


--
-- Name: Jobs_JobDependency Jobs_JobDependency_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_JobDependency"
    ADD CONSTRAINT "Jobs_JobDependency_pkey" PRIMARY KEY (id);


--
-- Name: Jobs_Job Jobs_Job_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_Job"
    ADD CONSTRAINT "Jobs_Job_pkey" PRIMARY KEY (id);


--
-- Name: Jobs_ProjectJob Jobs_ProjectJob_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_ProjectJob"
    ADD CONSTRAINT "Jobs_ProjectJob_pkey" PRIMARY KEY (id);


--
-- Name: Jobs_Server Jobs_Server_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_Server"
    ADD CONSTRAINT "Jobs_Server_pkey" PRIMARY KEY (id);


--
-- Name: Jobs_WorkerManagerSettings Jobs_WorkerManagerSettings_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_WorkerManagerSettings"
    ADD CONSTRAINT "Jobs_WorkerManagerSettings_pkey" PRIMARY KEY (id);


--
-- Name: Jobs_Worker Jobs_Worker_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_Worker"
    ADD CONSTRAINT "Jobs_Worker_pkey" PRIMARY KEY (id);


--
-- Name: jobs_worker_v2 jobs_worker_v2_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.jobs_worker_v2
    ADD CONSTRAINT jobs_worker_v2_pkey PRIMARY KEY (id);


--
-- Name: play_evolutions play_evolutions_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.play_evolutions
    ADD CONSTRAINT play_evolutions_pkey PRIMARY KEY (id);


--
-- Name: Jobs_Job_owner_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Jobs_Job_owner_idx" ON public."Jobs_Job" USING btree (owner);


--
-- Name: Jobs_Job_projectId_commitUUID_jobType_key; Type: INDEX; Schema: public; Owner: codacy
--

CREATE UNIQUE INDEX "Jobs_Job_projectId_commitUUID_jobType_key" ON public."Jobs_Job" USING btree ("projectId", "commitUUID", "jobType") WHERE ("commitUUID" IS NOT NULL);


--
-- Name: Jobs_Job_pullRequestId_jobType_key; Type: INDEX; Schema: public; Owner: codacy
--

CREATE UNIQUE INDEX "Jobs_Job_pullRequestId_jobType_key" ON public."Jobs_Job" USING btree ("pullRequestId", "jobType") WHERE ("pullRequestId" IS NOT NULL);


--
-- Name: Jobs_JobDependency Jobs_JobDependency_jobDependentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_JobDependency"
    ADD CONSTRAINT "Jobs_JobDependency_jobDependentId_fkey" FOREIGN KEY ("jobDependentId") REFERENCES public."Jobs_Job"(id) ON DELETE CASCADE;


--
-- Name: Jobs_JobDependency Jobs_JobDependency_jobId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_JobDependency"
    ADD CONSTRAINT "Jobs_JobDependency_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES public."Jobs_Job"(id) ON DELETE CASCADE;


--
-- Name: Jobs_Worker Jobs_Worker_jobId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_Worker"
    ADD CONSTRAINT "Jobs_Worker_jobId_fkey" FOREIGN KEY ("jobId") REFERENCES public."Jobs_Job"(id) ON DELETE SET NULL;


--
-- Name: Jobs_Worker Jobs_Worker_serverId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Jobs_Worker"
    ADD CONSTRAINT "Jobs_Worker_serverId_fkey" FOREIGN KEY ("serverId") REFERENCES public."Jobs_Server"(id) ON DELETE CASCADE;


--
-- Name: jobs_worker_v2 jobs_worker_v2_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.jobs_worker_v2
    ADD CONSTRAINT jobs_worker_v2_job_id_fkey FOREIGN KEY (job_id) REFERENCES public."Jobs_Job"(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

