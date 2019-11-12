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
-- Name: Account; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Account" (
    id integer NOT NULL,
    "isAdmin" boolean DEFAULT false NOT NULL,
    "isActive" boolean DEFAULT false NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    "latestLogin" timestamp without time zone DEFAULT now(),
    name character varying(255),
    "mainEmail" character varying(255),
    "isVip" boolean DEFAULT false NOT NULL,
    "uniqueNameId" bigint NOT NULL,
    "inactiveSince" timestamp without time zone DEFAULT now() NOT NULL,
    timezone character varying(255),
    "subscriptionId" bigint,
    state text,
    "showPardotForm" boolean
);


ALTER TABLE public."Account" OWNER TO codacy;

--
-- Name: AccountFeatures; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."AccountFeatures" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "teamKPI" boolean DEFAULT false NOT NULL,
    "automaticGithubBadges" boolean DEFAULT true NOT NULL,
    "canAnalyseAllBranches" boolean DEFAULT false NOT NULL,
    "githubMarketplace" boolean DEFAULT false NOT NULL,
    dashboards2018 boolean DEFAULT false NOT NULL
);


ALTER TABLE public."AccountFeatures" OWNER TO codacy;

--
-- Name: AccountFeatures_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."AccountFeatures_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AccountFeatures_id_seq" OWNER TO codacy;

--
-- Name: AccountFeatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."AccountFeatures_id_seq" OWNED BY public."AccountFeatures".id;


--
-- Name: AccountHeroku; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."AccountHeroku" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "herokuId" character varying(255) NOT NULL
);


ALTER TABLE public."AccountHeroku" OWNER TO codacy;

--
-- Name: AccountHeroku_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."AccountHeroku_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AccountHeroku_id_seq" OWNER TO codacy;

--
-- Name: AccountHeroku_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."AccountHeroku_id_seq" OWNED BY public."AccountHeroku".id;


--
-- Name: AccountPattern; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."AccountPattern" (
    id integer NOT NULL,
    "patternId" bigint NOT NULL,
    "accountId" bigint NOT NULL,
    parameters text,
    enabled boolean NOT NULL
);


ALTER TABLE public."AccountPattern" OWNER TO codacy;

--
-- Name: AccountPattern_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."AccountPattern_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AccountPattern_id_seq" OWNER TO codacy;

--
-- Name: AccountPattern_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."AccountPattern_id_seq" OWNED BY public."AccountPattern".id;


--
-- Name: AccountTokens; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."AccountTokens" (
    id integer NOT NULL,
    "userId" bigint,
    provider character varying(255) NOT NULL,
    token text NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    scopes text,
    "refreshToken" text
);


ALTER TABLE public."AccountTokens" OWNER TO codacy;

--
-- Name: AccountTokens_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."AccountTokens_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."AccountTokens_id_seq" OWNER TO codacy;

--
-- Name: AccountTokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."AccountTokens_id_seq" OWNED BY public."AccountTokens".id;


--
-- Name: Account_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Account_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Account_id_seq" OWNER TO codacy;

--
-- Name: Account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Account_id_seq" OWNED BY public."Account".id;


--
-- Name: ApiTokens; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ApiTokens" (
    id integer NOT NULL,
    "accountId" bigint NOT NULL,
    "clientId" character varying(1024) NOT NULL,
    "secretId" character varying(1024) NOT NULL
);


ALTER TABLE public."ApiTokens" OWNER TO codacy;

--
-- Name: ApiTokens_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ApiTokens_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ApiTokens_id_seq" OWNER TO codacy;

--
-- Name: ApiTokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ApiTokens_id_seq" OWNED BY public."ApiTokens".id;


--
-- Name: Branch; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Branch" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    name character varying(254) NOT NULL,
    status character varying(254) NOT NULL,
    "isDefault" boolean DEFAULT false NOT NULL,
    "branchType" character varying(64) DEFAULT 'Branch'::character varying NOT NULL,
    "lastCommit" character varying(255) DEFAULT NULL::character varying,
    "lastUpdate" timestamp without time zone
);


ALTER TABLE public."Branch" OWNER TO codacy;

--
-- Name: Branch_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Branch_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Branch_id_seq" OWNER TO codacy;

--
-- Name: Branch_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Branch_id_seq" OWNED BY public."Branch".id;


--
-- Name: Bundle; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Bundle" (
    id integer NOT NULL,
    language character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public."Bundle" OWNER TO codacy;

--
-- Name: Bundle_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Bundle_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Bundle_id_seq" OWNER TO codacy;

--
-- Name: Bundle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Bundle_id_seq" OWNED BY public."Bundle".id;


--
-- Name: Email; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Email" (
    id integer NOT NULL,
    "userId" bigint,
    email character varying(255) NOT NULL,
    "default" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."Email" OWNER TO codacy;

--
-- Name: Email_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Email_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Email_id_seq" OWNER TO codacy;

--
-- Name: Email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Email_id_seq" OWNED BY public."Email".id;


--
-- Name: EnterpriseAccount; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."EnterpriseAccount" (
    id integer NOT NULL,
    "userId" bigint NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(1024) NOT NULL,
    "forceChangePassword" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."EnterpriseAccount" OWNER TO codacy;

--
-- Name: EnterpriseAccount_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."EnterpriseAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."EnterpriseAccount_id_seq" OWNER TO codacy;

--
-- Name: EnterpriseAccount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."EnterpriseAccount_id_seq" OWNED BY public."EnterpriseAccount".id;


--
-- Name: EnterpriseResetToken; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."EnterpriseResetToken" (
    id bigint NOT NULL,
    "enterpriseAccountId" bigint NOT NULL,
    token character varying(128) NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "wasUsed" boolean DEFAULT false
);


ALTER TABLE public."EnterpriseResetToken" OWNER TO codacy;

--
-- Name: EnterpriseResetToken_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."EnterpriseResetToken_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."EnterpriseResetToken_id_seq" OWNER TO codacy;

--
-- Name: EnterpriseResetToken_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."EnterpriseResetToken_id_seq" OWNED BY public."EnterpriseResetToken".id;


--
-- Name: Enterprise_License; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Enterprise_License" (
    id bigint NOT NULL,
    "licenseUUID" character varying(2047) NOT NULL,
    application character varying(2047) NOT NULL,
    cache character varying(2047) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Enterprise_License" OWNER TO codacy;

--
-- Name: Enterprise_License_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Enterprise_License_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Enterprise_License_id_seq" OWNER TO codacy;

--
-- Name: Enterprise_License_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Enterprise_License_id_seq" OWNED BY public."Enterprise_License".id;


--
-- Name: Enterprise_Plugin; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Enterprise_Plugin" (
    id integer NOT NULL,
    "pluginType" character varying(50) NOT NULL,
    data text DEFAULT '{}'::text NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."Enterprise_Plugin" OWNER TO codacy;

--
-- Name: Enterprise_Plugin_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Enterprise_Plugin_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Enterprise_Plugin_id_seq" OWNER TO codacy;

--
-- Name: Enterprise_Plugin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Enterprise_Plugin_id_seq" OWNED BY public."Enterprise_Plugin".id;


--
-- Name: Integration_ProjectIntegration; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Integration_ProjectIntegration" (
    id bigint NOT NULL,
    "projectId" bigint,
    "integrationType" character varying(50) NOT NULL,
    "isActive" boolean DEFAULT false NOT NULL,
    data text,
    "accountTokenId" bigint,
    "projectTokenId" bigint,
    "accountId" bigint
);


ALTER TABLE public."Integration_ProjectIntegration" OWNER TO codacy;

--
-- Name: Integration_ProjectIntegration_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Integration_ProjectIntegration_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Integration_ProjectIntegration_id_seq" OWNER TO codacy;

--
-- Name: Integration_ProjectIntegration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Integration_ProjectIntegration_id_seq" OWNED BY public."Integration_ProjectIntegration".id;


--
-- Name: Integration_ProjectNotification; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Integration_ProjectNotification" (
    id bigint NOT NULL,
    "projectIntegrationId" bigint,
    "eventType" character varying(50) NOT NULL,
    "notificationType" character varying(50) NOT NULL
);


ALTER TABLE public."Integration_ProjectNotification" OWNER TO codacy;

--
-- Name: Integration_ProjectNotification_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Integration_ProjectNotification_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Integration_ProjectNotification_id_seq" OWNER TO codacy;

--
-- Name: Integration_ProjectNotification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Integration_ProjectNotification_id_seq" OWNED BY public."Integration_ProjectNotification".id;


--
-- Name: LoginSessions; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."LoginSessions" (
    id bigint NOT NULL,
    "sessionId" character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."LoginSessions" OWNER TO codacy;

--
-- Name: LoginSessions_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."LoginSessions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."LoginSessions_id_seq" OWNER TO codacy;

--
-- Name: LoginSessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."LoginSessions_id_seq" OWNED BY public."LoginSessions".id;


--
-- Name: Notification_NotificationLog; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Notification_NotificationLog" (
    id bigint NOT NULL,
    "targetId" bigint NOT NULL,
    "notificationChannel" character varying(255) NOT NULL,
    "notificationContent" character varying(255) NOT NULL,
    sent timestamp without time zone NOT NULL
);


ALTER TABLE public."Notification_NotificationLog" OWNER TO codacy;

--
-- Name: Notification_NotificationLog_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Notification_NotificationLog_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Notification_NotificationLog_id_seq" OWNER TO codacy;

--
-- Name: Notification_NotificationLog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Notification_NotificationLog_id_seq" OWNED BY public."Notification_NotificationLog".id;


--
-- Name: Notification_ProjectUserNotificationSettings; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Notification_ProjectUserNotificationSettings" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "eventType" character varying(255) NOT NULL,
    "notificationType" character varying(255) NOT NULL
);


ALTER TABLE public."Notification_ProjectUserNotificationSettings" OWNER TO codacy;

--
-- Name: Notification_ProjectUserNotificationSettings_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Notification_ProjectUserNotificationSettings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Notification_ProjectUserNotificationSettings_id_seq" OWNER TO codacy;

--
-- Name: Notification_ProjectUserNotificationSettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Notification_ProjectUserNotificationSettings_id_seq" OWNED BY public."Notification_ProjectUserNotificationSettings".id;


--
-- Name: Notification_UserNotificationQueue; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Notification_UserNotificationQueue" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "eventType" character varying(255) NOT NULL,
    "notificationChannel" character varying(255) NOT NULL,
    "notificationDate" timestamp without time zone NOT NULL,
    "lastUpdated" timestamp without time zone NOT NULL,
    "serverId" character varying(255)
);


ALTER TABLE public."Notification_UserNotificationQueue" OWNER TO codacy;

--
-- Name: Notification_UserNotificationQueue_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Notification_UserNotificationQueue_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Notification_UserNotificationQueue_id_seq" OWNER TO codacy;

--
-- Name: Notification_UserNotificationQueue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Notification_UserNotificationQueue_id_seq" OWNED BY public."Notification_UserNotificationQueue".id;


--
-- Name: PaymentPlan; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."PaymentPlan" (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    value bigint DEFAULT 0 NOT NULL,
    active boolean DEFAULT false NOT NULL,
    "default" boolean DEFAULT false NOT NULL,
    title character varying(100) DEFAULT ''::character varying NOT NULL,
    users integer DEFAULT 1 NOT NULL,
    repos integer DEFAULT 20 NOT NULL,
    "hasDedicatedServer" boolean DEFAULT false NOT NULL,
    "pricedPerUser" boolean DEFAULT false NOT NULL,
    "pricedPerMonth" boolean DEFAULT true NOT NULL,
    "remoteId" bigint
);


ALTER TABLE public."PaymentPlan" OWNER TO codacy;

--
-- Name: PaymentPlan_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."PaymentPlan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PaymentPlan_id_seq" OWNER TO codacy;

--
-- Name: PaymentPlan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."PaymentPlan_id_seq" OWNED BY public."PaymentPlan".id;


--
-- Name: Project; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Project" (
    id integer NOT NULL,
    name character varying(254) NOT NULL,
    provider character varying(254) NOT NULL,
    url character varying(254) NOT NULL,
    data text,
    "creationMode" character varying(254) NOT NULL,
    "fetchRetries" integer NOT NULL,
    created timestamp without time zone NOT NULL,
    "startedFirstAnalysis" timestamp without time zone,
    "endedFirstAnalysis" timestamp without time zone,
    "nextAnalysis" timestamp without time zone DEFAULT now() NOT NULL,
    "creatorId" bigint,
    pinned boolean DEFAULT false NOT NULL,
    owner text,
    deleted boolean DEFAULT false NOT NULL,
    "fromManualWizard" boolean DEFAULT false NOT NULL,
    access character varying(255) DEFAULT 'Private'::character varying NOT NULL,
    "ownerId" bigint,
    sync text,
    "remoteIdentifier" text,
    "organizationId" bigint
);


ALTER TABLE public."Project" OWNER TO codacy;

--
-- Name: ProjectSettings; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectSettings" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    kpi boolean DEFAULT false NOT NULL,
    analysis_stopped boolean DEFAULT false NOT NULL,
    "projectState" character varying(64) DEFAULT 'Cloned'::character varying,
    "timeToReviewPR" bigint,
    "oneCommitPerDay" boolean DEFAULT false,
    "useRedis" boolean DEFAULT false,
    "useAzure" boolean DEFAULT false,
    "editedTools" text DEFAULT '[]'::text NOT NULL,
    "detectedTools" text,
    test_autocomments boolean DEFAULT false NOT NULL,
    new_file_creation boolean DEFAULT false NOT NULL,
    belongs_to_user boolean DEFAULT false,
    duplication_retries text,
    analyse_all_branches boolean DEFAULT false NOT NULL,
    "disabledTools" text,
    dashboard boolean DEFAULT false NOT NULL,
    enabled_tools text,
    "autoCommentsLimitPR" integer DEFAULT 25 NOT NULL,
    has_codacy_config_file boolean DEFAULT false,
    clone_submodules boolean DEFAULT false,
    remote boolean DEFAULT false NOT NULL
);


ALTER TABLE public."ProjectSettings" OWNER TO codacy;

--
-- Name: ProjectAddOns_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ProjectAddOns_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProjectAddOns_id_seq" OWNER TO codacy;

--
-- Name: ProjectAddOns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ProjectAddOns_id_seq" OWNED BY public."ProjectSettings".id;


--
-- Name: ProjectAudit; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectAudit" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    target character varying(255) NOT NULL,
    "targetType" character varying(255) NOT NULL,
    "targetId" bigint NOT NULL,
    "userId" bigint,
    "createdOn" timestamp without time zone NOT NULL
);


ALTER TABLE public."ProjectAudit" OWNER TO codacy;

--
-- Name: ProjectAudit_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ProjectAudit_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProjectAudit_id_seq" OWNER TO codacy;

--
-- Name: ProjectAudit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ProjectAudit_id_seq" OWNED BY public."ProjectAudit".id;


--
-- Name: ProjectIgnoreRules; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectIgnoreRules" (
    id integer NOT NULL,
    filename character varying(1024) NOT NULL,
    "projectId" bigint NOT NULL,
    toolignore text DEFAULT 'File'::text,
    ignore_type text DEFAULT 'Exclude'::text,
    reason character varying(64)
);


ALTER TABLE public."ProjectIgnoreRules" OWNER TO codacy;

--
-- Name: ProjectIgnoredFiles_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ProjectIgnoredFiles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProjectIgnoredFiles_id_seq" OWNER TO codacy;

--
-- Name: ProjectIgnoredFiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ProjectIgnoredFiles_id_seq" OWNED BY public."ProjectIgnoreRules".id;


--
-- Name: ProjectKeys; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectKeys" (
    id integer NOT NULL,
    "publicHash" text NOT NULL,
    "publicKey" text NOT NULL,
    "privateKey" text NOT NULL
);


ALTER TABLE public."ProjectKeys" OWNER TO codacy;

--
-- Name: ProjectKeys_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ProjectKeys_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProjectKeys_id_seq" OWNER TO codacy;

--
-- Name: ProjectKeys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ProjectKeys_id_seq" OWNED BY public."ProjectKeys".id;


--
-- Name: ProjectLanguageExtensions; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectLanguageExtensions" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    language character varying(255) NOT NULL,
    extensions character varying(255) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."ProjectLanguageExtensions" OWNER TO codacy;

--
-- Name: ProjectLanguageExtensions_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ProjectLanguageExtensions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProjectLanguageExtensions_id_seq" OWNER TO codacy;

--
-- Name: ProjectLanguageExtensions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ProjectLanguageExtensions_id_seq" OWNED BY public."ProjectLanguageExtensions".id;


--
-- Name: ProjectLanguages; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectLanguages" (
    id integer NOT NULL,
    language character varying(255) NOT NULL,
    "projectId" bigint
);


ALTER TABLE public."ProjectLanguages" OWNER TO codacy;

--
-- Name: ProjectLanguages_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ProjectLanguages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProjectLanguages_id_seq" OWNER TO codacy;

--
-- Name: ProjectLanguages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ProjectLanguages_id_seq" OWNED BY public."ProjectLanguages".id;


--
-- Name: ProjectRedirect; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectRedirect" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    "projectName" character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    deprecated boolean DEFAULT false NOT NULL
);


ALTER TABLE public."ProjectRedirect" OWNER TO codacy;

--
-- Name: ProjectTokens; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectTokens" (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    "projectId" integer NOT NULL,
    type text NOT NULL
);


ALTER TABLE public."ProjectTokens" OWNER TO codacy;

--
-- Name: ProjectTokens_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ProjectTokens_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProjectTokens_id_seq" OWNER TO codacy;

--
-- Name: ProjectTokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ProjectTokens_id_seq" OWNED BY public."ProjectTokens".id;


--
-- Name: ProjectUser; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."ProjectUser" (
    id integer NOT NULL,
    "userId" bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "associationTimestamp" timestamp without time zone DEFAULT now() NOT NULL,
    permission character varying(128) DEFAULT 'None'::character varying NOT NULL
);


ALTER TABLE public."ProjectUser" OWNER TO codacy;

--
-- Name: ProjectUser_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."ProjectUser_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."ProjectUser_id_seq" OWNER TO codacy;

--
-- Name: ProjectUser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."ProjectUser_id_seq" OWNED BY public."ProjectUser".id;


--
-- Name: Project_id_seq1; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Project_id_seq1"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Project_id_seq1" OWNER TO codacy;

--
-- Name: Project_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Project_id_seq1" OWNED BY public."Project".id;


--
-- Name: PromoCode; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."PromoCode" (
    id integer NOT NULL,
    "promoCode" character varying(128) NOT NULL,
    discount integer NOT NULL,
    "daysValid" integer NOT NULL
);


ALTER TABLE public."PromoCode" OWNER TO codacy;

--
-- Name: PromoCode_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."PromoCode_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PromoCode_id_seq" OWNER TO codacy;

--
-- Name: PromoCode_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."PromoCode_id_seq" OWNED BY public."PromoCode".id;


--
-- Name: PublicProject_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."PublicProject_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."PublicProject_id_seq" OWNER TO codacy;

--
-- Name: PublicProject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."PublicProject_id_seq" OWNED BY public."ProjectRedirect".id;


--
-- Name: Request; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Request" (
    id integer NOT NULL,
    "userId" bigint,
    method character varying(10) NOT NULL,
    request character varying(2048) NOT NULL,
    duration bigint NOT NULL,
    "responseCode" integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    component character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public."Request" OWNER TO codacy;

--
-- Name: Request_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Request_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Request_id_seq" OWNER TO codacy;

--
-- Name: Request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Request_id_seq" OWNED BY public."Request".id;


--
-- Name: Settings_ProjectQuality; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Settings_ProjectQuality" (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    value text NOT NULL,
    CONSTRAINT "Settings_ProjectQuality_value_check" CHECK ((character_length(value) > 0))
);


ALTER TABLE public."Settings_ProjectQuality" OWNER TO codacy;

--
-- Name: Settings_ProjectQuality_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Settings_ProjectQuality_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Settings_ProjectQuality_id_seq" OWNER TO codacy;

--
-- Name: Settings_ProjectQuality_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Settings_ProjectQuality_id_seq" OWNED BY public."Settings_ProjectQuality".id;


--
-- Name: StripeCostumer; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."StripeCostumer" (
    id integer NOT NULL,
    "stripeId" character varying(255) NOT NULL,
    "subscriptionId" bigint
);


ALTER TABLE public."StripeCostumer" OWNER TO codacy;

--
-- Name: StripeCostumer_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."StripeCostumer_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."StripeCostumer_id_seq" OWNER TO codacy;

--
-- Name: StripeCostumer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."StripeCostumer_id_seq" OWNED BY public."StripeCostumer".id;


--
-- Name: System_Components; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."System_Components" (
    id bigint NOT NULL,
    component text NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


ALTER TABLE public."System_Components" OWNER TO codacy;

--
-- Name: System_Components_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."System_Components_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."System_Components_id_seq" OWNER TO codacy;

--
-- Name: System_Components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."System_Components_id_seq" OWNED BY public."System_Components".id;


--
-- Name: Teams_Organization; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Teams_Organization" (
    id bigint NOT NULL,
    "uniqueNameId" bigint,
    "subscriptionId" bigint,
    "billingEmail" character varying(255) DEFAULT NULL::character varying,
    "creationMode" character varying(30),
    "providerIdentifier" bigint,
    "createdAt" timestamp without time zone DEFAULT now(),
    "cloneSubmodules" boolean DEFAULT false,
    state text,
    sync text,
    "remoteName" text,
    avatar text,
    "remoteIdentifier" text,
    provider text,
    "joinMode" text
);


ALTER TABLE public."Teams_Organization" OWNER TO codacy;

--
-- Name: Teams_OrganizationMember; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Teams_OrganizationMember" (
    id bigint NOT NULL,
    "organizationId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    permission character varying(64) NOT NULL
);


ALTER TABLE public."Teams_OrganizationMember" OWNER TO codacy;

--
-- Name: Teams_OrganizationMember_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Teams_OrganizationMember_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Teams_OrganizationMember_id_seq" OWNER TO codacy;

--
-- Name: Teams_OrganizationMember_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Teams_OrganizationMember_id_seq" OWNED BY public."Teams_OrganizationMember".id;


--
-- Name: Teams_Organization_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Teams_Organization_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Teams_Organization_id_seq" OWNER TO codacy;

--
-- Name: Teams_Organization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Teams_Organization_id_seq" OWNED BY public."Teams_Organization".id;


--
-- Name: Teams_ProjectTeam; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Teams_ProjectTeam" (
    id bigint NOT NULL,
    "teamId" bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);


ALTER TABLE public."Teams_ProjectTeam" OWNER TO codacy;

--
-- Name: Teams_ProjectTeam_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Teams_ProjectTeam_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Teams_ProjectTeam_id_seq" OWNER TO codacy;

--
-- Name: Teams_ProjectTeam_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Teams_ProjectTeam_id_seq" OWNED BY public."Teams_ProjectTeam".id;


--
-- Name: Teams_Team; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Teams_Team" (
    id bigint NOT NULL,
    "organizationId" bigint NOT NULL,
    name character varying(128) NOT NULL
);


ALTER TABLE public."Teams_Team" OWNER TO codacy;

--
-- Name: Teams_TeamMember; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."Teams_TeamMember" (
    id bigint NOT NULL,
    "teamId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    permission character varying(64) NOT NULL
);


ALTER TABLE public."Teams_TeamMember" OWNER TO codacy;

--
-- Name: Teams_TeamMember_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Teams_TeamMember_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Teams_TeamMember_id_seq" OWNER TO codacy;

--
-- Name: Teams_TeamMember_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Teams_TeamMember_id_seq" OWNED BY public."Teams_TeamMember".id;


--
-- Name: Teams_Team_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."Teams_Team_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Teams_Team_id_seq" OWNER TO codacy;

--
-- Name: Teams_Team_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."Teams_Team_id_seq" OWNED BY public."Teams_Team".id;


--
-- Name: UniqueName; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."UniqueName" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    deprecated boolean DEFAULT false NOT NULL,
    "lastChanged" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."UniqueName" OWNER TO codacy;

--
-- Name: UniqueName_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."UniqueName_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."UniqueName_id_seq" OWNER TO codacy;

--
-- Name: UniqueName_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."UniqueName_id_seq" OWNED BY public."UniqueName".id;


--
-- Name: UserPaymentPlan; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public."UserPaymentPlan" (
    id integer NOT NULL,
    "planId" bigint NOT NULL,
    users integer DEFAULT 0 NOT NULL,
    value bigint DEFAULT 0 NOT NULL,
    "startOfPeriod" timestamp without time zone DEFAULT now() NOT NULL,
    "endOfPeriod" timestamp without time zone DEFAULT (now() + '15 days'::interval),
    repos integer DEFAULT 20 NOT NULL,
    "paymentGateway" character varying(128),
    "thirdPartyId" character varying(255) DEFAULT NULL::character varying,
    "hasUnlimitedSlots" boolean DEFAULT false NOT NULL,
    "lastRemoteSync" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public."UserPaymentPlan" OWNER TO codacy;

--
-- Name: UserPaymentPlan_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public."UserPaymentPlan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."UserPaymentPlan_id_seq" OWNER TO codacy;

--
-- Name: UserPaymentPlan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public."UserPaymentPlan_id_seq" OWNED BY public."UserPaymentPlan".id;


--
-- Name: account_cookies; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.account_cookies (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    token character varying(100) NOT NULL
);


ALTER TABLE public.account_cookies OWNER TO codacy;

--
-- Name: account_cookies_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.account_cookies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_cookies_id_seq OWNER TO codacy;

--
-- Name: account_cookies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.account_cookies_id_seq OWNED BY public.account_cookies.id;


--
-- Name: account_duplicate; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.account_duplicate (
    id bigint NOT NULL,
    low_account_id bigint NOT NULL,
    high_account_id bigint NOT NULL
);


ALTER TABLE public.account_duplicate OWNER TO codacy;

--
-- Name: account_duplicate_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.account_duplicate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_duplicate_id_seq OWNER TO codacy;

--
-- Name: account_duplicate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.account_duplicate_id_seq OWNED BY public.account_duplicate.id;


--
-- Name: account_flow; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.account_flow (
    user_id bigint NOT NULL,
    onboarding boolean DEFAULT false NOT NULL
);


ALTER TABLE public.account_flow OWNER TO codacy;

--
-- Name: account_github; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.account_github (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    github_id bigint,
    gitlab_id text,
    bitbucket_id text,
    stash_id text,
    bitbucket_uuid text
);


ALTER TABLE public.account_github OWNER TO codacy;

--
-- Name: account_github_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.account_github_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.account_github_id_seq OWNER TO codacy;

--
-- Name: account_github_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.account_github_id_seq OWNED BY public.account_github.id;


--
-- Name: app_configuration; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.app_configuration (
    id integer NOT NULL,
    environment character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.app_configuration OWNER TO codacy;

--
-- Name: app_configuration_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.app_configuration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.app_configuration_id_seq OWNER TO codacy;

--
-- Name: app_configuration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.app_configuration_id_seq OWNED BY public.app_configuration.id;


--
-- Name: notification_project_user_email_settings; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.notification_project_user_email_settings (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    project_id bigint NOT NULL,
    email_type character varying(255) NOT NULL,
    email_state character varying(255) NOT NULL
);


ALTER TABLE public.notification_project_user_email_settings OWNER TO codacy;

--
-- Name: notification_project_user_email_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.notification_project_user_email_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_project_user_email_settings_id_seq OWNER TO codacy;

--
-- Name: notification_project_user_email_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.notification_project_user_email_settings_id_seq OWNED BY public.notification_project_user_email_settings.id;


--
-- Name: notification_user_email_settings; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.notification_user_email_settings (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    commit boolean NOT NULL,
    pull_request boolean NOT NULL,
    my_activity boolean NOT NULL
);


ALTER TABLE public.notification_user_email_settings OWNER TO codacy;

--
-- Name: notification_user_email_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.notification_user_email_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_user_email_settings_id_seq OWNER TO codacy;

--
-- Name: notification_user_email_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.notification_user_email_settings_id_seq OWNED BY public.notification_user_email_settings.id;


--
-- Name: organization_hook_secret; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.organization_hook_secret (
    org_id bigint NOT NULL,
    secret text NOT NULL
);


ALTER TABLE public.organization_hook_secret OWNER TO codacy;

--
-- Name: organization_integration; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.organization_integration (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


ALTER TABLE public.organization_integration OWNER TO codacy;

--
-- Name: organization_integration_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.organization_integration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_integration_id_seq OWNER TO codacy;

--
-- Name: organization_integration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.organization_integration_id_seq OWNED BY public.organization_integration.id;


--
-- Name: organization_join_request; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.organization_join_request (
    user_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    creation_date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.organization_join_request OWNER TO codacy;

--
-- Name: organization_tokens; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.organization_tokens (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    token_type character varying(255) NOT NULL,
    token text NOT NULL
);


ALTER TABLE public.organization_tokens OWNER TO codacy;

--
-- Name: organization_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.organization_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organization_tokens_id_seq OWNER TO codacy;

--
-- Name: organization_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.organization_tokens_id_seq OWNED BY public.organization_tokens.id;


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
-- Name: project_outside_collaborator; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.project_outside_collaborator (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    account_id bigint NOT NULL
);


ALTER TABLE public.project_outside_collaborator OWNER TO codacy;

--
-- Name: project_outside_collaborator_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.project_outside_collaborator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_outside_collaborator_id_seq OWNER TO codacy;

--
-- Name: project_outside_collaborator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.project_outside_collaborator_id_seq OWNED BY public.project_outside_collaborator.id;


--
-- Name: project_user_settings; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.project_user_settings (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    user_id bigint NOT NULL,
    starred boolean NOT NULL
);


ALTER TABLE public.project_user_settings OWNER TO codacy;

--
-- Name: project_user_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.project_user_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.project_user_settings_id_seq OWNER TO codacy;

--
-- Name: project_user_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.project_user_settings_id_seq OWNED BY public.project_user_settings.id;


--
-- Name: share_dashboard; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.share_dashboard (
    project_id bigint NOT NULL,
    user_id bigint NOT NULL,
    token text NOT NULL,
    creation_date timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.share_dashboard OWNER TO codacy;

--
-- Name: website_configurations; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.website_configurations (
    id bigint NOT NULL,
    key text NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.website_configurations OWNER TO codacy;

--
-- Name: website_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.website_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.website_configurations_id_seq OWNER TO codacy;

--
-- Name: website_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.website_configurations_id_seq OWNED BY public.website_configurations.id;


--
-- Name: wizard_project; Type: TABLE; Schema: public; Owner: codacy
--

CREATE TABLE public.wizard_project (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    project_id bigint NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.wizard_project OWNER TO codacy;

--
-- Name: wizard_project_id_seq; Type: SEQUENCE; Schema: public; Owner: codacy
--

CREATE SEQUENCE public.wizard_project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wizard_project_id_seq OWNER TO codacy;

--
-- Name: wizard_project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: codacy
--

ALTER SEQUENCE public.wizard_project_id_seq OWNED BY public.wizard_project.id;


--
-- Name: Account id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Account" ALTER COLUMN id SET DEFAULT nextval('public."Account_id_seq"'::regclass);


--
-- Name: AccountFeatures id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountFeatures" ALTER COLUMN id SET DEFAULT nextval('public."AccountFeatures_id_seq"'::regclass);


--
-- Name: AccountHeroku id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountHeroku" ALTER COLUMN id SET DEFAULT nextval('public."AccountHeroku_id_seq"'::regclass);


--
-- Name: AccountPattern id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountPattern" ALTER COLUMN id SET DEFAULT nextval('public."AccountPattern_id_seq"'::regclass);


--
-- Name: AccountTokens id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountTokens" ALTER COLUMN id SET DEFAULT nextval('public."AccountTokens_id_seq"'::regclass);


--
-- Name: ApiTokens id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ApiTokens" ALTER COLUMN id SET DEFAULT nextval('public."ApiTokens_id_seq"'::regclass);


--
-- Name: Branch id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Branch" ALTER COLUMN id SET DEFAULT nextval('public."Branch_id_seq"'::regclass);


--
-- Name: Bundle id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Bundle" ALTER COLUMN id SET DEFAULT nextval('public."Bundle_id_seq"'::regclass);


--
-- Name: Email id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Email" ALTER COLUMN id SET DEFAULT nextval('public."Email_id_seq"'::regclass);


--
-- Name: EnterpriseAccount id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."EnterpriseAccount" ALTER COLUMN id SET DEFAULT nextval('public."EnterpriseAccount_id_seq"'::regclass);


--
-- Name: EnterpriseResetToken id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."EnterpriseResetToken" ALTER COLUMN id SET DEFAULT nextval('public."EnterpriseResetToken_id_seq"'::regclass);


--
-- Name: Enterprise_License id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Enterprise_License" ALTER COLUMN id SET DEFAULT nextval('public."Enterprise_License_id_seq"'::regclass);


--
-- Name: Enterprise_Plugin id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Enterprise_Plugin" ALTER COLUMN id SET DEFAULT nextval('public."Enterprise_Plugin_id_seq"'::regclass);


--
-- Name: Integration_ProjectIntegration id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectIntegration" ALTER COLUMN id SET DEFAULT nextval('public."Integration_ProjectIntegration_id_seq"'::regclass);


--
-- Name: Integration_ProjectNotification id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectNotification" ALTER COLUMN id SET DEFAULT nextval('public."Integration_ProjectNotification_id_seq"'::regclass);


--
-- Name: LoginSessions id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."LoginSessions" ALTER COLUMN id SET DEFAULT nextval('public."LoginSessions_id_seq"'::regclass);


--
-- Name: Notification_NotificationLog id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Notification_NotificationLog" ALTER COLUMN id SET DEFAULT nextval('public."Notification_NotificationLog_id_seq"'::regclass);


--
-- Name: Notification_ProjectUserNotificationSettings id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Notification_ProjectUserNotificationSettings" ALTER COLUMN id SET DEFAULT nextval('public."Notification_ProjectUserNotificationSettings_id_seq"'::regclass);


--
-- Name: Notification_UserNotificationQueue id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Notification_UserNotificationQueue" ALTER COLUMN id SET DEFAULT nextval('public."Notification_UserNotificationQueue_id_seq"'::regclass);


--
-- Name: PaymentPlan id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."PaymentPlan" ALTER COLUMN id SET DEFAULT nextval('public."PaymentPlan_id_seq"'::regclass);


--
-- Name: Project id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Project" ALTER COLUMN id SET DEFAULT nextval('public."Project_id_seq1"'::regclass);


--
-- Name: ProjectAudit id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectAudit" ALTER COLUMN id SET DEFAULT nextval('public."ProjectAudit_id_seq"'::regclass);


--
-- Name: ProjectIgnoreRules id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectIgnoreRules" ALTER COLUMN id SET DEFAULT nextval('public."ProjectIgnoredFiles_id_seq"'::regclass);


--
-- Name: ProjectKeys id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectKeys" ALTER COLUMN id SET DEFAULT nextval('public."ProjectKeys_id_seq"'::regclass);


--
-- Name: ProjectLanguageExtensions id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectLanguageExtensions" ALTER COLUMN id SET DEFAULT nextval('public."ProjectLanguageExtensions_id_seq"'::regclass);


--
-- Name: ProjectLanguages id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectLanguages" ALTER COLUMN id SET DEFAULT nextval('public."ProjectLanguages_id_seq"'::regclass);


--
-- Name: ProjectRedirect id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectRedirect" ALTER COLUMN id SET DEFAULT nextval('public."PublicProject_id_seq"'::regclass);


--
-- Name: ProjectSettings id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectSettings" ALTER COLUMN id SET DEFAULT nextval('public."ProjectAddOns_id_seq"'::regclass);


--
-- Name: ProjectTokens id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectTokens" ALTER COLUMN id SET DEFAULT nextval('public."ProjectTokens_id_seq"'::regclass);


--
-- Name: ProjectUser id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectUser" ALTER COLUMN id SET DEFAULT nextval('public."ProjectUser_id_seq"'::regclass);


--
-- Name: PromoCode id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."PromoCode" ALTER COLUMN id SET DEFAULT nextval('public."PromoCode_id_seq"'::regclass);


--
-- Name: Request id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Request" ALTER COLUMN id SET DEFAULT nextval('public."Request_id_seq"'::regclass);


--
-- Name: Settings_ProjectQuality id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Settings_ProjectQuality" ALTER COLUMN id SET DEFAULT nextval('public."Settings_ProjectQuality_id_seq"'::regclass);


--
-- Name: StripeCostumer id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."StripeCostumer" ALTER COLUMN id SET DEFAULT nextval('public."StripeCostumer_id_seq"'::regclass);


--
-- Name: System_Components id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."System_Components" ALTER COLUMN id SET DEFAULT nextval('public."System_Components_id_seq"'::regclass);


--
-- Name: Teams_Organization id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Organization" ALTER COLUMN id SET DEFAULT nextval('public."Teams_Organization_id_seq"'::regclass);


--
-- Name: Teams_OrganizationMember id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_OrganizationMember" ALTER COLUMN id SET DEFAULT nextval('public."Teams_OrganizationMember_id_seq"'::regclass);


--
-- Name: Teams_ProjectTeam id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_ProjectTeam" ALTER COLUMN id SET DEFAULT nextval('public."Teams_ProjectTeam_id_seq"'::regclass);


--
-- Name: Teams_Team id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Team" ALTER COLUMN id SET DEFAULT nextval('public."Teams_Team_id_seq"'::regclass);


--
-- Name: Teams_TeamMember id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_TeamMember" ALTER COLUMN id SET DEFAULT nextval('public."Teams_TeamMember_id_seq"'::regclass);


--
-- Name: UniqueName id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."UniqueName" ALTER COLUMN id SET DEFAULT nextval('public."UniqueName_id_seq"'::regclass);


--
-- Name: UserPaymentPlan id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."UserPaymentPlan" ALTER COLUMN id SET DEFAULT nextval('public."UserPaymentPlan_id_seq"'::regclass);


--
-- Name: account_cookies id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_cookies ALTER COLUMN id SET DEFAULT nextval('public.account_cookies_id_seq'::regclass);


--
-- Name: account_duplicate id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_duplicate ALTER COLUMN id SET DEFAULT nextval('public.account_duplicate_id_seq'::regclass);


--
-- Name: account_github id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_github ALTER COLUMN id SET DEFAULT nextval('public.account_github_id_seq'::regclass);


--
-- Name: app_configuration id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.app_configuration ALTER COLUMN id SET DEFAULT nextval('public.app_configuration_id_seq'::regclass);


--
-- Name: notification_project_user_email_settings id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.notification_project_user_email_settings ALTER COLUMN id SET DEFAULT nextval('public.notification_project_user_email_settings_id_seq'::regclass);


--
-- Name: notification_user_email_settings id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.notification_user_email_settings ALTER COLUMN id SET DEFAULT nextval('public.notification_user_email_settings_id_seq'::regclass);


--
-- Name: organization_integration id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_integration ALTER COLUMN id SET DEFAULT nextval('public.organization_integration_id_seq'::regclass);


--
-- Name: organization_tokens id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_tokens ALTER COLUMN id SET DEFAULT nextval('public.organization_tokens_id_seq'::regclass);


--
-- Name: project_outside_collaborator id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_outside_collaborator ALTER COLUMN id SET DEFAULT nextval('public.project_outside_collaborator_id_seq'::regclass);


--
-- Name: project_user_settings id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_user_settings ALTER COLUMN id SET DEFAULT nextval('public.project_user_settings_id_seq'::regclass);


--
-- Name: website_configurations id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.website_configurations ALTER COLUMN id SET DEFAULT nextval('public.website_configurations_id_seq'::regclass);


--
-- Name: wizard_project id; Type: DEFAULT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.wizard_project ALTER COLUMN id SET DEFAULT nextval('public.wizard_project_id_seq'::regclass);


--
-- Name: AccountFeatures AccountFeatures_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountFeatures"
    ADD CONSTRAINT "AccountFeatures_pkey" PRIMARY KEY (id);


--
-- Name: AccountHeroku AccountHeroku_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountHeroku"
    ADD CONSTRAINT "AccountHeroku_pkey" PRIMARY KEY (id);


--
-- Name: AccountPattern AccountPattern_accountId_patternId_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountPattern"
    ADD CONSTRAINT "AccountPattern_accountId_patternId_key" UNIQUE ("accountId", "patternId");


--
-- Name: AccountPattern AccountPattern_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountPattern"
    ADD CONSTRAINT "AccountPattern_pkey" PRIMARY KEY (id);


--
-- Name: AccountTokens AccountTokens_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountTokens"
    ADD CONSTRAINT "AccountTokens_pkey" PRIMARY KEY (id);


--
-- Name: Account Account_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_pkey" PRIMARY KEY (id);


--
-- Name: Account Account_uniqueNameId_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_uniqueNameId_key" UNIQUE ("uniqueNameId");


--
-- Name: ApiTokens ApiTokens_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ApiTokens"
    ADD CONSTRAINT "ApiTokens_pkey" PRIMARY KEY (id);


--
-- Name: Branch Branch_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Branch"
    ADD CONSTRAINT "Branch_pkey" PRIMARY KEY (id);


--
-- Name: Branch Branch_projectId_name_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Branch"
    ADD CONSTRAINT "Branch_projectId_name_key" UNIQUE ("projectId", name);


--
-- Name: Bundle Bundle_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Bundle"
    ADD CONSTRAINT "Bundle_pkey" PRIMARY KEY (id);


--
-- Name: Email Email_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Email"
    ADD CONSTRAINT "Email_pkey" PRIMARY KEY (id);


--
-- Name: Email Email_unique_email; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Email"
    ADD CONSTRAINT "Email_unique_email" UNIQUE (email);


--
-- Name: EnterpriseAccount EnterpriseAccount_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."EnterpriseAccount"
    ADD CONSTRAINT "EnterpriseAccount_pkey" PRIMARY KEY (id);


--
-- Name: EnterpriseAccount EnterpriseAccount_username_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."EnterpriseAccount"
    ADD CONSTRAINT "EnterpriseAccount_username_key" UNIQUE (username);


--
-- Name: EnterpriseResetToken EnterpriseResetToken_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."EnterpriseResetToken"
    ADD CONSTRAINT "EnterpriseResetToken_pkey" PRIMARY KEY (id);


--
-- Name: EnterpriseResetToken EnterpriseResetToken_token_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."EnterpriseResetToken"
    ADD CONSTRAINT "EnterpriseResetToken_token_key" UNIQUE (token);


--
-- Name: Enterprise_License Enterprise_License_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Enterprise_License"
    ADD CONSTRAINT "Enterprise_License_pkey" PRIMARY KEY (id);


--
-- Name: Enterprise_Plugin Enterprise_Plugin_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Enterprise_Plugin"
    ADD CONSTRAINT "Enterprise_Plugin_pkey" PRIMARY KEY (id);


--
-- Name: Integration_ProjectIntegration Integration_ProjectIntegration_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_pkey" PRIMARY KEY (id);


--
-- Name: Integration_ProjectNotification Integration_ProjectNotification_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectNotification"
    ADD CONSTRAINT "Integration_ProjectNotification_pkey" PRIMARY KEY (id);


--
-- Name: LoginSessions LoginSessions_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."LoginSessions"
    ADD CONSTRAINT "LoginSessions_pkey" PRIMARY KEY (id);


--
-- Name: Notification_NotificationLog Notification_NotificationLog_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Notification_NotificationLog"
    ADD CONSTRAINT "Notification_NotificationLog_pkey" PRIMARY KEY (id);


--
-- Name: Notification_UserNotificationQueue Notification_UserNotification_userId_eventType_notification_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Notification_UserNotificationQueue"
    ADD CONSTRAINT "Notification_UserNotification_userId_eventType_notification_key" UNIQUE ("userId", "eventType", "notificationChannel");


--
-- Name: PaymentPlan PaymentPlan_code_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."PaymentPlan"
    ADD CONSTRAINT "PaymentPlan_code_key" UNIQUE (code);


--
-- Name: PaymentPlan PaymentPlan_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."PaymentPlan"
    ADD CONSTRAINT "PaymentPlan_pkey" PRIMARY KEY (id);


--
-- Name: ProjectSettings ProjectAddOns_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectSettings"
    ADD CONSTRAINT "ProjectAddOns_pkey" PRIMARY KEY (id);


--
-- Name: ProjectAudit ProjectAudit_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectAudit"
    ADD CONSTRAINT "ProjectAudit_pkey" PRIMARY KEY (id);


--
-- Name: ProjectIgnoreRules ProjectIgnoredFiles_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectIgnoreRules"
    ADD CONSTRAINT "ProjectIgnoredFiles_pkey" PRIMARY KEY (id);


--
-- Name: ProjectKeys ProjectKeys_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectKeys"
    ADD CONSTRAINT "ProjectKeys_pkey" PRIMARY KEY (id);


--
-- Name: ProjectKeys ProjectKeys_publicHash_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectKeys"
    ADD CONSTRAINT "ProjectKeys_publicHash_key" UNIQUE ("publicHash");


--
-- Name: ProjectLanguageExtensions ProjectLanguageExtensions_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectLanguageExtensions"
    ADD CONSTRAINT "ProjectLanguageExtensions_pkey" PRIMARY KEY (id);


--
-- Name: ProjectLanguageExtensions ProjectLanguageExtensions_projectId_language_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectLanguageExtensions"
    ADD CONSTRAINT "ProjectLanguageExtensions_projectId_language_key" UNIQUE ("projectId", language);


--
-- Name: ProjectLanguages ProjectLanguages_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectLanguages"
    ADD CONSTRAINT "ProjectLanguages_pkey" PRIMARY KEY (id);


--
-- Name: ProjectTokens ProjectTokens_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectTokens"
    ADD CONSTRAINT "ProjectTokens_pkey" PRIMARY KEY (id);


--
-- Name: ProjectTokens ProjectTokens_token_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectTokens"
    ADD CONSTRAINT "ProjectTokens_token_key" UNIQUE (token);


--
-- Name: ProjectUser ProjectUser_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectUser"
    ADD CONSTRAINT "ProjectUser_pkey" PRIMARY KEY (id);


--
-- Name: ProjectUser ProjectUser_projectId_userId; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectUser"
    ADD CONSTRAINT "ProjectUser_projectId_userId" UNIQUE ("projectId", "userId");


--
-- Name: Project Project_pkey1; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_pkey1" PRIMARY KEY (id);


--
-- Name: PromoCode PromoCode_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."PromoCode"
    ADD CONSTRAINT "PromoCode_pkey" PRIMARY KEY (id);


--
-- Name: PromoCode PromoCode_promoCode_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."PromoCode"
    ADD CONSTRAINT "PromoCode_promoCode_key" UNIQUE ("promoCode");


--
-- Name: ProjectRedirect PublicProject_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectRedirect"
    ADD CONSTRAINT "PublicProject_pkey" PRIMARY KEY (id);


--
-- Name: ProjectRedirect PublicProject_username_projectName_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectRedirect"
    ADD CONSTRAINT "PublicProject_username_projectName_key" UNIQUE (username, "projectName");


--
-- Name: Request Request_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Request"
    ADD CONSTRAINT "Request_pkey" PRIMARY KEY (id);


--
-- Name: Settings_ProjectQuality Settings_ProjectQuality_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Settings_ProjectQuality"
    ADD CONSTRAINT "Settings_ProjectQuality_pkey" PRIMARY KEY (id);


--
-- Name: StripeCostumer StripeCostumer_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."StripeCostumer"
    ADD CONSTRAINT "StripeCostumer_pkey" PRIMARY KEY (id);


--
-- Name: System_Components System_Components_component_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."System_Components"
    ADD CONSTRAINT "System_Components_component_key" UNIQUE (component);


--
-- Name: System_Components System_Components_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."System_Components"
    ADD CONSTRAINT "System_Components_pkey" PRIMARY KEY (id);


--
-- Name: Teams_OrganizationMember Teams_OrganizationMember_organizationId_userId_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_OrganizationMember"
    ADD CONSTRAINT "Teams_OrganizationMember_organizationId_userId_key" UNIQUE ("organizationId", "userId");


--
-- Name: Teams_OrganizationMember Teams_OrganizationMember_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_OrganizationMember"
    ADD CONSTRAINT "Teams_OrganizationMember_pkey" PRIMARY KEY (id);


--
-- Name: Teams_Organization Teams_Organization_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Organization"
    ADD CONSTRAINT "Teams_Organization_pkey" PRIMARY KEY (id);


--
-- Name: Teams_Organization Teams_Organization_uniqueNameId_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Organization"
    ADD CONSTRAINT "Teams_Organization_uniqueNameId_key" UNIQUE ("uniqueNameId");


--
-- Name: Teams_ProjectTeam Teams_ProjectTeam_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_ProjectTeam"
    ADD CONSTRAINT "Teams_ProjectTeam_pkey" PRIMARY KEY (id);


--
-- Name: Teams_ProjectTeam Teams_ProjectTeam_teamId_projectId_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_ProjectTeam"
    ADD CONSTRAINT "Teams_ProjectTeam_teamId_projectId_key" UNIQUE ("teamId", "projectId");


--
-- Name: Teams_TeamMember Teams_TeamMember_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_TeamMember"
    ADD CONSTRAINT "Teams_TeamMember_pkey" PRIMARY KEY (id);


--
-- Name: Teams_TeamMember Teams_TeamMember_teamId_userId_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_TeamMember"
    ADD CONSTRAINT "Teams_TeamMember_teamId_userId_key" UNIQUE ("teamId", "userId");


--
-- Name: Teams_Team Teams_Team_organizationId_name_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Team"
    ADD CONSTRAINT "Teams_Team_organizationId_name_key" UNIQUE ("organizationId", name);


--
-- Name: Teams_Team Teams_Team_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Team"
    ADD CONSTRAINT "Teams_Team_pkey" PRIMARY KEY (id);


--
-- Name: UniqueName UniqueName_name_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."UniqueName"
    ADD CONSTRAINT "UniqueName_name_key" UNIQUE (name);


--
-- Name: UniqueName UniqueName_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."UniqueName"
    ADD CONSTRAINT "UniqueName_pkey" PRIMARY KEY (id);


--
-- Name: UserPaymentPlan UserPaymentPlan_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."UserPaymentPlan"
    ADD CONSTRAINT "UserPaymentPlan_pkey" PRIMARY KEY (id);


--
-- Name: account_cookies account_cookies_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_cookies
    ADD CONSTRAINT account_cookies_pkey PRIMARY KEY (id);


--
-- Name: account_duplicate account_duplicate_high_account_id_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_duplicate
    ADD CONSTRAINT account_duplicate_high_account_id_key UNIQUE (high_account_id);


--
-- Name: account_duplicate account_duplicate_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_duplicate
    ADD CONSTRAINT account_duplicate_pkey PRIMARY KEY (id);


--
-- Name: account_flow account_flow_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_flow
    ADD CONSTRAINT account_flow_pkey PRIMARY KEY (user_id);


--
-- Name: account_github account_github_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_github
    ADD CONSTRAINT account_github_pkey PRIMARY KEY (id);


--
-- Name: app_configuration app_configuration_environment_key_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.app_configuration
    ADD CONSTRAINT app_configuration_environment_key_key UNIQUE (environment, key);


--
-- Name: app_configuration app_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.app_configuration
    ADD CONSTRAINT app_configuration_pkey PRIMARY KEY (id);


--
-- Name: notification_project_user_email_settings notification_project_user_ema_user_id_project_id_email_type_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.notification_project_user_email_settings
    ADD CONSTRAINT notification_project_user_ema_user_id_project_id_email_type_key UNIQUE (user_id, project_id, email_type);


--
-- Name: notification_user_email_settings notification_user_email_settings_user_id_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.notification_user_email_settings
    ADD CONSTRAINT notification_user_email_settings_user_id_key UNIQUE (user_id);


--
-- Name: organization_hook_secret organization_hook_secret_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_hook_secret
    ADD CONSTRAINT organization_hook_secret_pkey PRIMARY KEY (org_id);


--
-- Name: organization_integration organization_integration_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_integration
    ADD CONSTRAINT organization_integration_pkey PRIMARY KEY (id);


--
-- Name: organization_join_request organization_join_request_user_id_organization_id_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_join_request
    ADD CONSTRAINT organization_join_request_user_id_organization_id_key UNIQUE (organization_id, user_id);


--
-- Name: organization_tokens organization_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_tokens
    ADD CONSTRAINT organization_tokens_pkey PRIMARY KEY (id);


--
-- Name: play_evolutions play_evolutions_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.play_evolutions
    ADD CONSTRAINT play_evolutions_pkey PRIMARY KEY (id);


--
-- Name: project_outside_collaborator project_outside_collaborator_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_outside_collaborator
    ADD CONSTRAINT project_outside_collaborator_pkey PRIMARY KEY (id);


--
-- Name: project_user_settings project_user_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_user_settings
    ADD CONSTRAINT project_user_settings_pkey PRIMARY KEY (id);


--
-- Name: project_user_settings project_user_settings_user_id_project_id_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_user_settings
    ADD CONSTRAINT project_user_settings_user_id_project_id_key UNIQUE (user_id, project_id);


--
-- Name: share_dashboard share_dashboard_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.share_dashboard
    ADD CONSTRAINT share_dashboard_pkey PRIMARY KEY (user_id, project_id);


--
-- Name: share_dashboard share_dashboard_token_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.share_dashboard
    ADD CONSTRAINT share_dashboard_token_key UNIQUE (token);


--
-- Name: account_github user_id_unique; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_github
    ADD CONSTRAINT user_id_unique UNIQUE (user_id);


--
-- Name: website_configurations website_configurations_key_key; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.website_configurations
    ADD CONSTRAINT website_configurations_key_key UNIQUE (key);


--
-- Name: website_configurations website_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.website_configurations
    ADD CONSTRAINT website_configurations_pkey PRIMARY KEY (id);


--
-- Name: wizard_project wizard_project_pkey; Type: CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.wizard_project
    ADD CONSTRAINT wizard_project_pkey PRIMARY KEY (id);


--
-- Name: AccountFeatures_userId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "AccountFeatures_userId_idx" ON public."AccountFeatures" USING btree ("userId");


--
-- Name: AccountTokens_userId_provider_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "AccountTokens_userId_provider_idx" ON public."AccountTokens" USING btree ("userId", provider);


--
-- Name: Account_mainEmail; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Account_mainEmail" ON public."Account" USING btree ("mainEmail");


--
-- Name: ApiTokens_accountId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ApiTokens_accountId_idx" ON public."ApiTokens" USING btree ("accountId");


--
-- Name: ApiTokens_clientId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ApiTokens_clientId_idx" ON public."ApiTokens" USING btree ("clientId");


--
-- Name: Audit_projectId; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Audit_projectId" ON public."ProjectAudit" USING btree ("projectId");


--
-- Name: Email_userId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Email_userId_idx" ON public."Email" USING btree ("userId");


--
-- Name: Integration_ProjectIntegration_projectId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Integration_ProjectIntegration_projectId_idx" ON public."Integration_ProjectIntegration" USING btree ("projectId");


--
-- Name: Integration_ProjectNotification_projectIntegrationId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Integration_ProjectNotification_projectIntegrationId_idx" ON public."Integration_ProjectNotification" USING btree ("projectIntegrationId");


--
-- Name: LoginSessions_sessionId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "LoginSessions_sessionId_idx" ON public."LoginSessions" USING btree ("sessionId");


--
-- Name: Notification_ProjectUserNotificationSettings_projectId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Notification_ProjectUserNotificationSettings_projectId_idx" ON public."Notification_ProjectUserNotificationSettings" USING btree ("projectId");


--
-- Name: Notification_ProjectUserNotificationSettings_userId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Notification_ProjectUserNotificationSettings_userId_idx" ON public."Notification_ProjectUserNotificationSettings" USING btree ("userId");


--
-- Name: ProjectAudit_targetId; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ProjectAudit_targetId" ON public."ProjectAudit" USING btree ("targetId");


--
-- Name: ProjectAudit_targetId_targetType_target_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ProjectAudit_targetId_targetType_target_idx" ON public."ProjectAudit" USING btree ("targetId", "targetType", target);


--
-- Name: ProjectIgnoreRules_projectId; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ProjectIgnoreRules_projectId" ON public."ProjectIgnoreRules" USING btree ("projectId");


--
-- Name: ProjectLanguages_projectId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ProjectLanguages_projectId_idx" ON public."ProjectLanguages" USING btree ("projectId");


--
-- Name: ProjectLanguages_projectId_language_key; Type: INDEX; Schema: public; Owner: codacy
--

CREATE UNIQUE INDEX "ProjectLanguages_projectId_language_key" ON public."ProjectLanguages" USING btree ("projectId", language);


--
-- Name: ProjectRedirect_projectId; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ProjectRedirect_projectId" ON public."ProjectRedirect" USING btree ("projectId");


--
-- Name: ProjectSettings_projectId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ProjectSettings_projectId_idx" ON public."ProjectSettings" USING btree ("projectId");


--
-- Name: ProjectTokens_projectId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ProjectTokens_projectId_idx" ON public."ProjectTokens" USING btree ("projectId");


--
-- Name: ProjectTokens_token_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "ProjectTokens_token_idx" ON public."ProjectTokens" USING btree (token);


--
-- Name: Project_creationMode_remoteIdentifier_uniq_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE UNIQUE INDEX "Project_creationMode_remoteIdentifier_uniq_idx" ON public."Project" USING btree ("creationMode", "remoteIdentifier") WHERE (("creationMode" IS NOT NULL) AND ("remoteIdentifier" IS NOT NULL));


--
-- Name: Settings_ProjectQuality_project_id_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Settings_ProjectQuality_project_id_idx" ON public."Settings_ProjectQuality" USING btree (project_id);


--
-- Name: Teams_Organization_provider_remoteIdentifier_uniq_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE UNIQUE INDEX "Teams_Organization_provider_remoteIdentifier_uniq_idx" ON public."Teams_Organization" USING btree (provider, "remoteIdentifier") WHERE ((provider IS NOT NULL) AND ("remoteIdentifier" IS NOT NULL));


--
-- Name: Teams_Organization_subscriptionId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "Teams_Organization_subscriptionId_idx" ON public."Teams_Organization" USING btree ("subscriptionId");


--
-- Name: account_cookies_token_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX account_cookies_token_idx ON public.account_cookies USING btree (token);


--
-- Name: account_cookies_userId_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX "account_cookies_userId_idx" ON public.account_cookies USING btree (user_id);


--
-- Name: account_duplicate_low_account_id_high_account_id_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX account_duplicate_low_account_id_high_account_id_idx ON public.account_duplicate USING btree (low_account_id, high_account_id);


--
-- Name: account_github__github_id_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX account_github__github_id_idx ON public.account_github USING btree (github_id);


--
-- Name: account_github__user_id_idx; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX account_github__user_id_idx ON public.account_github USING btree (user_id);


--
-- Name: notification_project_user_email_settings__project_id; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX notification_project_user_email_settings__project_id ON public.notification_project_user_email_settings USING btree (project_id);


--
-- Name: notification_project_user_email_settings__user_id; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX notification_project_user_email_settings__user_id ON public.notification_project_user_email_settings USING btree (user_id);


--
-- Name: notification_user_email_settings__user_id; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX notification_user_email_settings__user_id ON public.notification_user_email_settings USING btree (user_id);


--
-- Name: organization_integration_organization_id; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX organization_integration_organization_id ON public.organization_integration USING btree (organization_id);


--
-- Name: project_owner_id_index; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX project_owner_id_index ON public."Project" USING btree ("ownerId");


--
-- Name: wizard_project_user_id; Type: INDEX; Schema: public; Owner: codacy
--

CREATE INDEX wizard_project_user_id ON public.wizard_project USING btree (user_id);


--
-- Name: AccountFeatures AccountFeatures_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountFeatures"
    ADD CONSTRAINT "AccountFeatures_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: AccountHeroku AccountHeroku_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountHeroku"
    ADD CONSTRAINT "AccountHeroku_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: AccountPattern AccountPattern_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountPattern"
    ADD CONSTRAINT "AccountPattern_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: AccountTokens AccountTokens_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."AccountTokens"
    ADD CONSTRAINT "AccountTokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id);


--
-- Name: Account Account_UserPaymentPlan_subscriptionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_UserPaymentPlan_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES public."UserPaymentPlan"(id) ON DELETE SET NULL;


--
-- Name: Account Account_uniqueNameId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_uniqueNameId_fkey" FOREIGN KEY ("uniqueNameId") REFERENCES public."UniqueName"(id);


--
-- Name: ApiTokens ApiTokens_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ApiTokens"
    ADD CONSTRAINT "ApiTokens_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: Email Email_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Email"
    ADD CONSTRAINT "Email_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: EnterpriseAccount EnterpriseAccount_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."EnterpriseAccount"
    ADD CONSTRAINT "EnterpriseAccount_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: Integration_ProjectIntegration Integration_ProjectIntegration_accountId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES public."Account"(id) ON DELETE SET NULL;


--
-- Name: Integration_ProjectIntegration Integration_ProjectIntegration_accountTokenId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_accountTokenId_fkey" FOREIGN KEY ("accountTokenId") REFERENCES public."AccountTokens"(id) ON DELETE SET NULL;


--
-- Name: Integration_ProjectIntegration Integration_ProjectIntegration_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id);


--
-- Name: Integration_ProjectIntegration Integration_ProjectIntegration_projectTokenId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_projectTokenId_fkey" FOREIGN KEY ("projectTokenId") REFERENCES public."ProjectTokens"(id) ON DELETE SET NULL;


--
-- Name: Integration_ProjectNotification Integration_ProjectNotification_projectIntegrationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Integration_ProjectNotification"
    ADD CONSTRAINT "Integration_ProjectNotification_projectIntegrationId_fkey" FOREIGN KEY ("projectIntegrationId") REFERENCES public."Integration_ProjectIntegration"(id) ON DELETE CASCADE;


--
-- Name: Notification_ProjectUserNotificationSettings Notification_ProjectUserNotificationSettings_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Notification_ProjectUserNotificationSettings"
    ADD CONSTRAINT "Notification_ProjectUserNotificationSettings_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: Notification_ProjectUserNotificationSettings Notification_ProjectUserNotificationSettings_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Notification_ProjectUserNotificationSettings"
    ADD CONSTRAINT "Notification_ProjectUserNotificationSettings_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: Notification_UserNotificationQueue Notification_UserNotificationQueue_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Notification_UserNotificationQueue"
    ADD CONSTRAINT "Notification_UserNotificationQueue_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: ProjectSettings ProjectAddOns_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectSettings"
    ADD CONSTRAINT "ProjectAddOns_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: ProjectAudit ProjectAudit_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectAudit"
    ADD CONSTRAINT "ProjectAudit_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: ProjectAudit ProjectAudit_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectAudit"
    ADD CONSTRAINT "ProjectAudit_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: ProjectIgnoreRules ProjectIgnoredFiles_projectId_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectIgnoreRules"
    ADD CONSTRAINT "ProjectIgnoredFiles_projectId_fkey1" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: ProjectLanguageExtensions ProjectLanguageExtensions_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectLanguageExtensions"
    ADD CONSTRAINT "ProjectLanguageExtensions_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: ProjectLanguages ProjectLanguages_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectLanguages"
    ADD CONSTRAINT "ProjectLanguages_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: Project ProjectOrganizationId_organizationId_fk; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "ProjectOrganizationId_organizationId_fk" FOREIGN KEY ("organizationId") REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;


--
-- Name: ProjectTokens ProjectTokens_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectTokens"
    ADD CONSTRAINT "ProjectTokens_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: ProjectUser ProjectUser_projectId_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectUser"
    ADD CONSTRAINT "ProjectUser_projectId_fkey1" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: ProjectUser ProjectUser_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectUser"
    ADD CONSTRAINT "ProjectUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: Project Project_creatorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES public."Account"(id) ON DELETE SET NULL;


--
-- Name: Project Project_ownerId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public."Account"(id);


--
-- Name: ProjectRedirect PublicProject_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."ProjectRedirect"
    ADD CONSTRAINT "PublicProject_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: Settings_ProjectQuality Settings_ProjectQuality_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Settings_ProjectQuality"
    ADD CONSTRAINT "Settings_ProjectQuality_project_id_fkey" FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: StripeCostumer StripeCostumer_subscriptionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."StripeCostumer"
    ADD CONSTRAINT "StripeCostumer_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES public."UserPaymentPlan"(id);


--
-- Name: Teams_OrganizationMember Teams_OrganizationMember_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_OrganizationMember"
    ADD CONSTRAINT "Teams_OrganizationMember_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;


--
-- Name: Teams_OrganizationMember Teams_OrganizationMember_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_OrganizationMember"
    ADD CONSTRAINT "Teams_OrganizationMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: Teams_Organization Teams_Organization_UserPaymentPlan_subscriptionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Organization"
    ADD CONSTRAINT "Teams_Organization_UserPaymentPlan_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES public."UserPaymentPlan"(id) ON DELETE SET NULL;


--
-- Name: Teams_Organization Teams_Organization_uniqueNameId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Organization"
    ADD CONSTRAINT "Teams_Organization_uniqueNameId_fkey" FOREIGN KEY ("uniqueNameId") REFERENCES public."UniqueName"(id);


--
-- Name: Teams_ProjectTeam Teams_ProjectTeam_projectId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_ProjectTeam"
    ADD CONSTRAINT "Teams_ProjectTeam_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: Teams_ProjectTeam Teams_ProjectTeam_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_ProjectTeam"
    ADD CONSTRAINT "Teams_ProjectTeam_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams_Team"(id) ON DELETE CASCADE;


--
-- Name: Teams_TeamMember Teams_TeamMember_teamId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_TeamMember"
    ADD CONSTRAINT "Teams_TeamMember_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams_Team"(id) ON DELETE CASCADE;


--
-- Name: Teams_TeamMember Teams_TeamMember_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_TeamMember"
    ADD CONSTRAINT "Teams_TeamMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: Teams_Team Teams_Team_organizationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."Teams_Team"
    ADD CONSTRAINT "Teams_Team_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;


--
-- Name: UserPaymentPlan UserPaymentPlan_planId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public."UserPaymentPlan"
    ADD CONSTRAINT "UserPaymentPlan_planId_fkey" FOREIGN KEY ("planId") REFERENCES public."PaymentPlan"(id) ON DELETE CASCADE;


--
-- Name: account_duplicate account_duplicate_high_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_duplicate
    ADD CONSTRAINT account_duplicate_high_account_id_fkey FOREIGN KEY (high_account_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: account_duplicate account_duplicate_low_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_duplicate
    ADD CONSTRAINT account_duplicate_low_account_id_fkey FOREIGN KEY (low_account_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: account_flow account_flow_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_flow
    ADD CONSTRAINT account_flow_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: account_github account_github_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.account_github
    ADD CONSTRAINT account_github_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: notification_project_user_email_settings notification_project_user_email_settings_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.notification_project_user_email_settings
    ADD CONSTRAINT notification_project_user_email_settings_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: notification_project_user_email_settings notification_project_user_email_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.notification_project_user_email_settings
    ADD CONSTRAINT notification_project_user_email_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: notification_user_email_settings notification_user_email_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.notification_user_email_settings
    ADD CONSTRAINT notification_user_email_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: organization_hook_secret organization_hook_secret_org_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_hook_secret
    ADD CONSTRAINT organization_hook_secret_org_id_fkey FOREIGN KEY (org_id) REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;


--
-- Name: organization_integration organization_integration_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_integration
    ADD CONSTRAINT organization_integration_account_id_fkey FOREIGN KEY (account_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: organization_integration organization_integration_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_integration
    ADD CONSTRAINT organization_integration_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;


--
-- Name: organization_join_request organization_join_request_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_join_request
    ADD CONSTRAINT organization_join_request_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;


--
-- Name: organization_join_request organization_join_request_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_join_request
    ADD CONSTRAINT organization_join_request_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: organization_tokens organization_tokens_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.organization_tokens
    ADD CONSTRAINT organization_tokens_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;


--
-- Name: project_outside_collaborator project_outside_collaborator_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_outside_collaborator
    ADD CONSTRAINT project_outside_collaborator_account_id_fkey FOREIGN KEY (account_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: project_outside_collaborator project_outside_collaborator_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_outside_collaborator
    ADD CONSTRAINT project_outside_collaborator_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: project_user_settings project_user_settings_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_user_settings
    ADD CONSTRAINT project_user_settings_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: project_user_settings project_user_settings_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.project_user_settings
    ADD CONSTRAINT project_user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: share_dashboard share_dashboard_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.share_dashboard
    ADD CONSTRAINT share_dashboard_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: share_dashboard share_dashboard_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.share_dashboard
    ADD CONSTRAINT share_dashboard_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- Name: wizard_project wizard_project_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.wizard_project
    ADD CONSTRAINT wizard_project_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;


--
-- Name: wizard_project wizard_project_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: codacy
--

ALTER TABLE ONLY public.wizard_project
    ADD CONSTRAINT wizard_project_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

