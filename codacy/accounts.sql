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
CREATE SEQUENCE public."AccountFeatures_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."AccountFeatures_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."AccountFeatures_id_seq" OWNED BY public."AccountFeatures".id;
CREATE TABLE public."AccountHeroku" (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "herokuId" character varying(255) NOT NULL
);
ALTER TABLE public."AccountHeroku" OWNER TO codacy;
CREATE SEQUENCE public."AccountHeroku_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."AccountHeroku_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."AccountHeroku_id_seq" OWNED BY public."AccountHeroku".id;
CREATE TABLE public."AccountPattern" (
    id integer NOT NULL,
    "patternId" bigint NOT NULL,
    "accountId" bigint NOT NULL,
    parameters text,
    enabled boolean NOT NULL
);
ALTER TABLE public."AccountPattern" OWNER TO codacy;
CREATE SEQUENCE public."AccountPattern_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."AccountPattern_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."AccountPattern_id_seq" OWNED BY public."AccountPattern".id;
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
CREATE SEQUENCE public."AccountTokens_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."AccountTokens_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."AccountTokens_id_seq" OWNED BY public."AccountTokens".id;
CREATE SEQUENCE public."Account_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Account_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Account_id_seq" OWNED BY public."Account".id;
CREATE TABLE public."ApiTokens" (
    id integer NOT NULL,
    "accountId" bigint NOT NULL,
    "clientId" character varying(1024) NOT NULL,
    "secretId" character varying(1024) NOT NULL
);
ALTER TABLE public."ApiTokens" OWNER TO codacy;
CREATE SEQUENCE public."ApiTokens_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ApiTokens_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ApiTokens_id_seq" OWNED BY public."ApiTokens".id;
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
CREATE SEQUENCE public."Branch_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Branch_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Branch_id_seq" OWNED BY public."Branch".id;
CREATE TABLE public."Bundle" (
    id integer NOT NULL,
    language character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    description text NOT NULL
);
ALTER TABLE public."Bundle" OWNER TO codacy;
CREATE SEQUENCE public."Bundle_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Bundle_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Bundle_id_seq" OWNED BY public."Bundle".id;
CREATE TABLE public."Email" (
    id integer NOT NULL,
    "userId" bigint,
    email character varying(255) NOT NULL,
    "default" boolean DEFAULT false NOT NULL
);
ALTER TABLE public."Email" OWNER TO codacy;
CREATE SEQUENCE public."Email_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Email_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Email_id_seq" OWNED BY public."Email".id;
CREATE TABLE public."EnterpriseAccount" (
    id integer NOT NULL,
    "userId" bigint NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(1024) NOT NULL,
    "forceChangePassword" boolean DEFAULT false NOT NULL
);
ALTER TABLE public."EnterpriseAccount" OWNER TO codacy;
CREATE SEQUENCE public."EnterpriseAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."EnterpriseAccount_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."EnterpriseAccount_id_seq" OWNED BY public."EnterpriseAccount".id;
CREATE TABLE public."EnterpriseResetToken" (
    id bigint NOT NULL,
    "enterpriseAccountId" bigint NOT NULL,
    token character varying(128) NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    "wasUsed" boolean DEFAULT false
);
ALTER TABLE public."EnterpriseResetToken" OWNER TO codacy;
CREATE SEQUENCE public."EnterpriseResetToken_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."EnterpriseResetToken_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."EnterpriseResetToken_id_seq" OWNED BY public."EnterpriseResetToken".id;
CREATE TABLE public."Enterprise_License" (
    id bigint NOT NULL,
    "licenseUUID" character varying(2047) NOT NULL,
    application character varying(2047) NOT NULL,
    cache character varying(2047) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."Enterprise_License" OWNER TO codacy;
CREATE SEQUENCE public."Enterprise_License_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Enterprise_License_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Enterprise_License_id_seq" OWNED BY public."Enterprise_License".id;
CREATE TABLE public."Enterprise_Plugin" (
    id integer NOT NULL,
    "pluginType" character varying(50) NOT NULL,
    data text DEFAULT '{}'::text NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."Enterprise_Plugin" OWNER TO codacy;
CREATE SEQUENCE public."Enterprise_Plugin_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Enterprise_Plugin_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Enterprise_Plugin_id_seq" OWNED BY public."Enterprise_Plugin".id;
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
CREATE SEQUENCE public."Integration_ProjectIntegration_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Integration_ProjectIntegration_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Integration_ProjectIntegration_id_seq" OWNED BY public."Integration_ProjectIntegration".id;
CREATE TABLE public."Integration_ProjectNotification" (
    id bigint NOT NULL,
    "projectIntegrationId" bigint,
    "eventType" character varying(50) NOT NULL,
    "notificationType" character varying(50) NOT NULL
);
ALTER TABLE public."Integration_ProjectNotification" OWNER TO codacy;
CREATE SEQUENCE public."Integration_ProjectNotification_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Integration_ProjectNotification_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Integration_ProjectNotification_id_seq" OWNED BY public."Integration_ProjectNotification".id;
CREATE TABLE public."LoginSessions" (
    id bigint NOT NULL,
    "sessionId" character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."LoginSessions" OWNER TO codacy;
CREATE SEQUENCE public."LoginSessions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."LoginSessions_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."LoginSessions_id_seq" OWNED BY public."LoginSessions".id;
CREATE TABLE public."Notification_NotificationLog" (
    id bigint NOT NULL,
    "targetId" bigint NOT NULL,
    "notificationChannel" character varying(255) NOT NULL,
    "notificationContent" character varying(255) NOT NULL,
    sent timestamp without time zone NOT NULL
);
ALTER TABLE public."Notification_NotificationLog" OWNER TO codacy;
CREATE SEQUENCE public."Notification_NotificationLog_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Notification_NotificationLog_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Notification_NotificationLog_id_seq" OWNED BY public."Notification_NotificationLog".id;
CREATE TABLE public."Notification_ProjectUserNotificationSettings" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "eventType" character varying(255) NOT NULL,
    "notificationType" character varying(255) NOT NULL
);
ALTER TABLE public."Notification_ProjectUserNotificationSettings" OWNER TO codacy;
CREATE SEQUENCE public."Notification_ProjectUserNotificationSettings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Notification_ProjectUserNotificationSettings_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Notification_ProjectUserNotificationSettings_id_seq" OWNED BY public."Notification_ProjectUserNotificationSettings".id;
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
CREATE SEQUENCE public."Notification_UserNotificationQueue_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Notification_UserNotificationQueue_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Notification_UserNotificationQueue_id_seq" OWNED BY public."Notification_UserNotificationQueue".id;
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
CREATE SEQUENCE public."PaymentPlan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."PaymentPlan_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."PaymentPlan_id_seq" OWNED BY public."PaymentPlan".id;
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
CREATE SEQUENCE public."ProjectAddOns_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectAddOns_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectAddOns_id_seq" OWNED BY public."ProjectSettings".id;
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
CREATE SEQUENCE public."ProjectAudit_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectAudit_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectAudit_id_seq" OWNED BY public."ProjectAudit".id;
CREATE TABLE public."ProjectIgnoreRules" (
    id integer NOT NULL,
    filename character varying(1024) NOT NULL,
    "projectId" bigint NOT NULL,
    toolignore text DEFAULT 'File'::text,
    ignore_type text DEFAULT 'Exclude'::text,
    reason character varying(64)
);
ALTER TABLE public."ProjectIgnoreRules" OWNER TO codacy;
CREATE SEQUENCE public."ProjectIgnoredFiles_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectIgnoredFiles_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectIgnoredFiles_id_seq" OWNED BY public."ProjectIgnoreRules".id;
CREATE TABLE public."ProjectKeys" (
    id integer NOT NULL,
    "publicHash" text NOT NULL,
    "publicKey" text NOT NULL,
    "privateKey" text NOT NULL
);
ALTER TABLE public."ProjectKeys" OWNER TO codacy;
CREATE SEQUENCE public."ProjectKeys_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectKeys_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectKeys_id_seq" OWNED BY public."ProjectKeys".id;
CREATE TABLE public."ProjectLanguageExtensions" (
    id bigint NOT NULL,
    "projectId" bigint NOT NULL,
    language character varying(255) NOT NULL,
    extensions character varying(255) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."ProjectLanguageExtensions" OWNER TO codacy;
CREATE SEQUENCE public."ProjectLanguageExtensions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectLanguageExtensions_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectLanguageExtensions_id_seq" OWNED BY public."ProjectLanguageExtensions".id;
CREATE TABLE public."ProjectLanguages" (
    id integer NOT NULL,
    language character varying(255) NOT NULL,
    "projectId" bigint
);
ALTER TABLE public."ProjectLanguages" OWNER TO codacy;
CREATE SEQUENCE public."ProjectLanguages_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectLanguages_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectLanguages_id_seq" OWNED BY public."ProjectLanguages".id;
CREATE TABLE public."ProjectRedirect" (
    id integer NOT NULL,
    "projectId" bigint NOT NULL,
    "projectName" character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    deprecated boolean DEFAULT false NOT NULL
);
ALTER TABLE public."ProjectRedirect" OWNER TO codacy;
CREATE TABLE public."ProjectTokens" (
    id integer NOT NULL,
    token character varying(255) NOT NULL,
    "projectId" integer NOT NULL,
    type text NOT NULL
);
ALTER TABLE public."ProjectTokens" OWNER TO codacy;
CREATE SEQUENCE public."ProjectTokens_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectTokens_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectTokens_id_seq" OWNED BY public."ProjectTokens".id;
CREATE TABLE public."ProjectUser" (
    id integer NOT NULL,
    "userId" bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "associationTimestamp" timestamp without time zone DEFAULT now() NOT NULL,
    permission character varying(128) DEFAULT 'None'::character varying NOT NULL
);
ALTER TABLE public."ProjectUser" OWNER TO codacy;
CREATE SEQUENCE public."ProjectUser_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."ProjectUser_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."ProjectUser_id_seq" OWNED BY public."ProjectUser".id;
CREATE SEQUENCE public."Project_id_seq1"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Project_id_seq1" OWNER TO codacy;
ALTER SEQUENCE public."Project_id_seq1" OWNED BY public."Project".id;
CREATE TABLE public."PromoCode" (
    id integer NOT NULL,
    "promoCode" character varying(128) NOT NULL,
    discount integer NOT NULL,
    "daysValid" integer NOT NULL
);
ALTER TABLE public."PromoCode" OWNER TO codacy;
CREATE SEQUENCE public."PromoCode_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."PromoCode_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."PromoCode_id_seq" OWNED BY public."PromoCode".id;
CREATE SEQUENCE public."PublicProject_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."PublicProject_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."PublicProject_id_seq" OWNED BY public."ProjectRedirect".id;
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
CREATE SEQUENCE public."Request_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Request_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Request_id_seq" OWNED BY public."Request".id;
CREATE TABLE public."Settings_ProjectQuality" (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    value text NOT NULL,
    CONSTRAINT "Settings_ProjectQuality_value_check" CHECK ((character_length(value) > 0))
);
ALTER TABLE public."Settings_ProjectQuality" OWNER TO codacy;
CREATE SEQUENCE public."Settings_ProjectQuality_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Settings_ProjectQuality_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Settings_ProjectQuality_id_seq" OWNED BY public."Settings_ProjectQuality".id;
CREATE TABLE public."StripeCostumer" (
    id integer NOT NULL,
    "stripeId" character varying(255) NOT NULL,
    "subscriptionId" bigint
);
ALTER TABLE public."StripeCostumer" OWNER TO codacy;
CREATE SEQUENCE public."StripeCostumer_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."StripeCostumer_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."StripeCostumer_id_seq" OWNED BY public."StripeCostumer".id;
CREATE TABLE public."System_Components" (
    id bigint NOT NULL,
    component text NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);
ALTER TABLE public."System_Components" OWNER TO codacy;
CREATE SEQUENCE public."System_Components_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."System_Components_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."System_Components_id_seq" OWNED BY public."System_Components".id;
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
CREATE TABLE public."Teams_OrganizationMember" (
    id bigint NOT NULL,
    "organizationId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    permission character varying(64) NOT NULL
);
ALTER TABLE public."Teams_OrganizationMember" OWNER TO codacy;
CREATE SEQUENCE public."Teams_OrganizationMember_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Teams_OrganizationMember_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Teams_OrganizationMember_id_seq" OWNED BY public."Teams_OrganizationMember".id;
CREATE SEQUENCE public."Teams_Organization_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Teams_Organization_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Teams_Organization_id_seq" OWNED BY public."Teams_Organization".id;
CREATE TABLE public."Teams_ProjectTeam" (
    id bigint NOT NULL,
    "teamId" bigint NOT NULL,
    "projectId" bigint NOT NULL,
    "timestamp" timestamp without time zone NOT NULL
);
ALTER TABLE public."Teams_ProjectTeam" OWNER TO codacy;
CREATE SEQUENCE public."Teams_ProjectTeam_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Teams_ProjectTeam_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Teams_ProjectTeam_id_seq" OWNED BY public."Teams_ProjectTeam".id;
CREATE TABLE public."Teams_Team" (
    id bigint NOT NULL,
    "organizationId" bigint NOT NULL,
    name character varying(128) NOT NULL
);
ALTER TABLE public."Teams_Team" OWNER TO codacy;
CREATE TABLE public."Teams_TeamMember" (
    id bigint NOT NULL,
    "teamId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    permission character varying(64) NOT NULL
);
ALTER TABLE public."Teams_TeamMember" OWNER TO codacy;
CREATE SEQUENCE public."Teams_TeamMember_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Teams_TeamMember_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Teams_TeamMember_id_seq" OWNED BY public."Teams_TeamMember".id;
CREATE SEQUENCE public."Teams_Team_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."Teams_Team_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."Teams_Team_id_seq" OWNED BY public."Teams_Team".id;
CREATE TABLE public."UniqueName" (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    deprecated boolean DEFAULT false NOT NULL,
    "lastChanged" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public."UniqueName" OWNER TO codacy;
CREATE SEQUENCE public."UniqueName_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."UniqueName_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."UniqueName_id_seq" OWNED BY public."UniqueName".id;
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
CREATE SEQUENCE public."UserPaymentPlan_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public."UserPaymentPlan_id_seq" OWNER TO codacy;
ALTER SEQUENCE public."UserPaymentPlan_id_seq" OWNED BY public."UserPaymentPlan".id;
CREATE TABLE public.account_cookies (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    token character varying(100) NOT NULL
);
ALTER TABLE public.account_cookies OWNER TO codacy;
CREATE SEQUENCE public.account_cookies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.account_cookies_id_seq OWNER TO codacy;
ALTER SEQUENCE public.account_cookies_id_seq OWNED BY public.account_cookies.id;
CREATE TABLE public.account_duplicate (
    id bigint NOT NULL,
    low_account_id bigint NOT NULL,
    high_account_id bigint NOT NULL
);
ALTER TABLE public.account_duplicate OWNER TO codacy;
CREATE SEQUENCE public.account_duplicate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.account_duplicate_id_seq OWNER TO codacy;
ALTER SEQUENCE public.account_duplicate_id_seq OWNED BY public.account_duplicate.id;
CREATE TABLE public.account_flow (
    user_id bigint NOT NULL,
    onboarding boolean DEFAULT false NOT NULL
);
ALTER TABLE public.account_flow OWNER TO codacy;
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
CREATE SEQUENCE public.account_github_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.account_github_id_seq OWNER TO codacy;
ALTER SEQUENCE public.account_github_id_seq OWNED BY public.account_github.id;
CREATE TABLE public.app_configuration (
    id integer NOT NULL,
    environment character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    value text NOT NULL
);
ALTER TABLE public.app_configuration OWNER TO codacy;
CREATE SEQUENCE public.app_configuration_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.app_configuration_id_seq OWNER TO codacy;
ALTER SEQUENCE public.app_configuration_id_seq OWNED BY public.app_configuration.id;
CREATE TABLE public.notification_project_user_email_settings (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    project_id bigint NOT NULL,
    email_type character varying(255) NOT NULL,
    email_state character varying(255) NOT NULL
);
ALTER TABLE public.notification_project_user_email_settings OWNER TO codacy;
CREATE SEQUENCE public.notification_project_user_email_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.notification_project_user_email_settings_id_seq OWNER TO codacy;
ALTER SEQUENCE public.notification_project_user_email_settings_id_seq OWNED BY public.notification_project_user_email_settings.id;
CREATE TABLE public.notification_user_email_settings (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    commit boolean NOT NULL,
    pull_request boolean NOT NULL,
    my_activity boolean NOT NULL
);
ALTER TABLE public.notification_user_email_settings OWNER TO codacy;
CREATE SEQUENCE public.notification_user_email_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.notification_user_email_settings_id_seq OWNER TO codacy;
ALTER SEQUENCE public.notification_user_email_settings_id_seq OWNED BY public.notification_user_email_settings.id;
CREATE TABLE public.organization_hook_secret (
    org_id bigint NOT NULL,
    secret text NOT NULL
);
ALTER TABLE public.organization_hook_secret OWNER TO codacy;
CREATE TABLE public.organization_integration (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    organization_id bigint NOT NULL
);
ALTER TABLE public.organization_integration OWNER TO codacy;
CREATE SEQUENCE public.organization_integration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.organization_integration_id_seq OWNER TO codacy;
ALTER SEQUENCE public.organization_integration_id_seq OWNED BY public.organization_integration.id;
CREATE TABLE public.organization_join_request (
    user_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    creation_date timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.organization_join_request OWNER TO codacy;
CREATE TABLE public.organization_tokens (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    token_type character varying(255) NOT NULL,
    token text NOT NULL
);
ALTER TABLE public.organization_tokens OWNER TO codacy;
CREATE SEQUENCE public.organization_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.organization_tokens_id_seq OWNER TO codacy;
ALTER SEQUENCE public.organization_tokens_id_seq OWNED BY public.organization_tokens.id;
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
CREATE TABLE public.project_outside_collaborator (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    account_id bigint NOT NULL
);
ALTER TABLE public.project_outside_collaborator OWNER TO codacy;
CREATE SEQUENCE public.project_outside_collaborator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.project_outside_collaborator_id_seq OWNER TO codacy;
ALTER SEQUENCE public.project_outside_collaborator_id_seq OWNED BY public.project_outside_collaborator.id;
CREATE TABLE public.project_user_settings (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    user_id bigint NOT NULL,
    starred boolean NOT NULL
);
ALTER TABLE public.project_user_settings OWNER TO codacy;
CREATE SEQUENCE public.project_user_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.project_user_settings_id_seq OWNER TO codacy;
ALTER SEQUENCE public.project_user_settings_id_seq OWNED BY public.project_user_settings.id;
CREATE TABLE public.share_dashboard (
    project_id bigint NOT NULL,
    user_id bigint NOT NULL,
    token text NOT NULL,
    creation_date timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.share_dashboard OWNER TO codacy;
CREATE TABLE public.website_configurations (
    id bigint NOT NULL,
    key text NOT NULL,
    value text NOT NULL
);
ALTER TABLE public.website_configurations OWNER TO codacy;
CREATE SEQUENCE public.website_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.website_configurations_id_seq OWNER TO codacy;
ALTER SEQUENCE public.website_configurations_id_seq OWNED BY public.website_configurations.id;
CREATE TABLE public.wizard_project (
    id integer NOT NULL,
    user_id bigint NOT NULL,
    project_id bigint NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.wizard_project OWNER TO codacy;
CREATE SEQUENCE public.wizard_project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER TABLE public.wizard_project_id_seq OWNER TO codacy;
ALTER SEQUENCE public.wizard_project_id_seq OWNED BY public.wizard_project.id;
ALTER TABLE ONLY public."Account" ALTER COLUMN id SET DEFAULT nextval('public."Account_id_seq"'::regclass);
ALTER TABLE ONLY public."AccountFeatures" ALTER COLUMN id SET DEFAULT nextval('public."AccountFeatures_id_seq"'::regclass);
ALTER TABLE ONLY public."AccountHeroku" ALTER COLUMN id SET DEFAULT nextval('public."AccountHeroku_id_seq"'::regclass);
ALTER TABLE ONLY public."AccountPattern" ALTER COLUMN id SET DEFAULT nextval('public."AccountPattern_id_seq"'::regclass);
ALTER TABLE ONLY public."AccountTokens" ALTER COLUMN id SET DEFAULT nextval('public."AccountTokens_id_seq"'::regclass);
ALTER TABLE ONLY public."ApiTokens" ALTER COLUMN id SET DEFAULT nextval('public."ApiTokens_id_seq"'::regclass);
ALTER TABLE ONLY public."Branch" ALTER COLUMN id SET DEFAULT nextval('public."Branch_id_seq"'::regclass);
ALTER TABLE ONLY public."Bundle" ALTER COLUMN id SET DEFAULT nextval('public."Bundle_id_seq"'::regclass);
ALTER TABLE ONLY public."Email" ALTER COLUMN id SET DEFAULT nextval('public."Email_id_seq"'::regclass);
ALTER TABLE ONLY public."EnterpriseAccount" ALTER COLUMN id SET DEFAULT nextval('public."EnterpriseAccount_id_seq"'::regclass);
ALTER TABLE ONLY public."EnterpriseResetToken" ALTER COLUMN id SET DEFAULT nextval('public."EnterpriseResetToken_id_seq"'::regclass);
ALTER TABLE ONLY public."Enterprise_License" ALTER COLUMN id SET DEFAULT nextval('public."Enterprise_License_id_seq"'::regclass);
ALTER TABLE ONLY public."Enterprise_Plugin" ALTER COLUMN id SET DEFAULT nextval('public."Enterprise_Plugin_id_seq"'::regclass);
ALTER TABLE ONLY public."Integration_ProjectIntegration" ALTER COLUMN id SET DEFAULT nextval('public."Integration_ProjectIntegration_id_seq"'::regclass);
ALTER TABLE ONLY public."Integration_ProjectNotification" ALTER COLUMN id SET DEFAULT nextval('public."Integration_ProjectNotification_id_seq"'::regclass);
ALTER TABLE ONLY public."LoginSessions" ALTER COLUMN id SET DEFAULT nextval('public."LoginSessions_id_seq"'::regclass);
ALTER TABLE ONLY public."Notification_NotificationLog" ALTER COLUMN id SET DEFAULT nextval('public."Notification_NotificationLog_id_seq"'::regclass);
ALTER TABLE ONLY public."Notification_ProjectUserNotificationSettings" ALTER COLUMN id SET DEFAULT nextval('public."Notification_ProjectUserNotificationSettings_id_seq"'::regclass);
ALTER TABLE ONLY public."Notification_UserNotificationQueue" ALTER COLUMN id SET DEFAULT nextval('public."Notification_UserNotificationQueue_id_seq"'::regclass);
ALTER TABLE ONLY public."PaymentPlan" ALTER COLUMN id SET DEFAULT nextval('public."PaymentPlan_id_seq"'::regclass);
ALTER TABLE ONLY public."Project" ALTER COLUMN id SET DEFAULT nextval('public."Project_id_seq1"'::regclass);
ALTER TABLE ONLY public."ProjectAudit" ALTER COLUMN id SET DEFAULT nextval('public."ProjectAudit_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectIgnoreRules" ALTER COLUMN id SET DEFAULT nextval('public."ProjectIgnoredFiles_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectKeys" ALTER COLUMN id SET DEFAULT nextval('public."ProjectKeys_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectLanguageExtensions" ALTER COLUMN id SET DEFAULT nextval('public."ProjectLanguageExtensions_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectLanguages" ALTER COLUMN id SET DEFAULT nextval('public."ProjectLanguages_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectRedirect" ALTER COLUMN id SET DEFAULT nextval('public."PublicProject_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectSettings" ALTER COLUMN id SET DEFAULT nextval('public."ProjectAddOns_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectTokens" ALTER COLUMN id SET DEFAULT nextval('public."ProjectTokens_id_seq"'::regclass);
ALTER TABLE ONLY public."ProjectUser" ALTER COLUMN id SET DEFAULT nextval('public."ProjectUser_id_seq"'::regclass);
ALTER TABLE ONLY public."PromoCode" ALTER COLUMN id SET DEFAULT nextval('public."PromoCode_id_seq"'::regclass);
ALTER TABLE ONLY public."Request" ALTER COLUMN id SET DEFAULT nextval('public."Request_id_seq"'::regclass);
ALTER TABLE ONLY public."Settings_ProjectQuality" ALTER COLUMN id SET DEFAULT nextval('public."Settings_ProjectQuality_id_seq"'::regclass);
ALTER TABLE ONLY public."StripeCostumer" ALTER COLUMN id SET DEFAULT nextval('public."StripeCostumer_id_seq"'::regclass);
ALTER TABLE ONLY public."System_Components" ALTER COLUMN id SET DEFAULT nextval('public."System_Components_id_seq"'::regclass);
ALTER TABLE ONLY public."Teams_Organization" ALTER COLUMN id SET DEFAULT nextval('public."Teams_Organization_id_seq"'::regclass);
ALTER TABLE ONLY public."Teams_OrganizationMember" ALTER COLUMN id SET DEFAULT nextval('public."Teams_OrganizationMember_id_seq"'::regclass);
ALTER TABLE ONLY public."Teams_ProjectTeam" ALTER COLUMN id SET DEFAULT nextval('public."Teams_ProjectTeam_id_seq"'::regclass);
ALTER TABLE ONLY public."Teams_Team" ALTER COLUMN id SET DEFAULT nextval('public."Teams_Team_id_seq"'::regclass);
ALTER TABLE ONLY public."Teams_TeamMember" ALTER COLUMN id SET DEFAULT nextval('public."Teams_TeamMember_id_seq"'::regclass);
ALTER TABLE ONLY public."UniqueName" ALTER COLUMN id SET DEFAULT nextval('public."UniqueName_id_seq"'::regclass);
ALTER TABLE ONLY public."UserPaymentPlan" ALTER COLUMN id SET DEFAULT nextval('public."UserPaymentPlan_id_seq"'::regclass);
ALTER TABLE ONLY public.account_cookies ALTER COLUMN id SET DEFAULT nextval('public.account_cookies_id_seq'::regclass);
ALTER TABLE ONLY public.account_duplicate ALTER COLUMN id SET DEFAULT nextval('public.account_duplicate_id_seq'::regclass);
ALTER TABLE ONLY public.account_github ALTER COLUMN id SET DEFAULT nextval('public.account_github_id_seq'::regclass);
ALTER TABLE ONLY public.app_configuration ALTER COLUMN id SET DEFAULT nextval('public.app_configuration_id_seq'::regclass);
ALTER TABLE ONLY public.notification_project_user_email_settings ALTER COLUMN id SET DEFAULT nextval('public.notification_project_user_email_settings_id_seq'::regclass);
ALTER TABLE ONLY public.notification_user_email_settings ALTER COLUMN id SET DEFAULT nextval('public.notification_user_email_settings_id_seq'::regclass);
ALTER TABLE ONLY public.organization_integration ALTER COLUMN id SET DEFAULT nextval('public.organization_integration_id_seq'::regclass);
ALTER TABLE ONLY public.organization_tokens ALTER COLUMN id SET DEFAULT nextval('public.organization_tokens_id_seq'::regclass);
ALTER TABLE ONLY public.project_outside_collaborator ALTER COLUMN id SET DEFAULT nextval('public.project_outside_collaborator_id_seq'::regclass);
ALTER TABLE ONLY public.project_user_settings ALTER COLUMN id SET DEFAULT nextval('public.project_user_settings_id_seq'::regclass);
ALTER TABLE ONLY public.website_configurations ALTER COLUMN id SET DEFAULT nextval('public.website_configurations_id_seq'::regclass);
ALTER TABLE ONLY public.wizard_project ALTER COLUMN id SET DEFAULT nextval('public.wizard_project_id_seq'::regclass);
ALTER TABLE ONLY public."AccountFeatures"
    ADD CONSTRAINT "AccountFeatures_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."AccountHeroku"
    ADD CONSTRAINT "AccountHeroku_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."AccountPattern"
    ADD CONSTRAINT "AccountPattern_accountId_patternId_key" UNIQUE ("accountId", "patternId");
ALTER TABLE ONLY public."AccountPattern"
    ADD CONSTRAINT "AccountPattern_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."AccountTokens"
    ADD CONSTRAINT "AccountTokens_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_uniqueNameId_key" UNIQUE ("uniqueNameId");
ALTER TABLE ONLY public."ApiTokens"
    ADD CONSTRAINT "ApiTokens_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Branch"
    ADD CONSTRAINT "Branch_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Branch"
    ADD CONSTRAINT "Branch_projectId_name_key" UNIQUE ("projectId", name);
ALTER TABLE ONLY public."Bundle"
    ADD CONSTRAINT "Bundle_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Email"
    ADD CONSTRAINT "Email_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Email"
    ADD CONSTRAINT "Email_unique_email" UNIQUE (email);
ALTER TABLE ONLY public."EnterpriseAccount"
    ADD CONSTRAINT "EnterpriseAccount_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."EnterpriseAccount"
    ADD CONSTRAINT "EnterpriseAccount_username_key" UNIQUE (username);
ALTER TABLE ONLY public."EnterpriseResetToken"
    ADD CONSTRAINT "EnterpriseResetToken_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."EnterpriseResetToken"
    ADD CONSTRAINT "EnterpriseResetToken_token_key" UNIQUE (token);
ALTER TABLE ONLY public."Enterprise_License"
    ADD CONSTRAINT "Enterprise_License_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Enterprise_Plugin"
    ADD CONSTRAINT "Enterprise_Plugin_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Integration_ProjectNotification"
    ADD CONSTRAINT "Integration_ProjectNotification_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."LoginSessions"
    ADD CONSTRAINT "LoginSessions_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Notification_NotificationLog"
    ADD CONSTRAINT "Notification_NotificationLog_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Notification_UserNotificationQueue"
    ADD CONSTRAINT "Notification_UserNotification_userId_eventType_notification_key" UNIQUE ("userId", "eventType", "notificationChannel");
ALTER TABLE ONLY public."PaymentPlan"
    ADD CONSTRAINT "PaymentPlan_code_key" UNIQUE (code);
ALTER TABLE ONLY public."PaymentPlan"
    ADD CONSTRAINT "PaymentPlan_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectSettings"
    ADD CONSTRAINT "ProjectAddOns_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectAudit"
    ADD CONSTRAINT "ProjectAudit_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectIgnoreRules"
    ADD CONSTRAINT "ProjectIgnoredFiles_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectKeys"
    ADD CONSTRAINT "ProjectKeys_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectKeys"
    ADD CONSTRAINT "ProjectKeys_publicHash_key" UNIQUE ("publicHash");
ALTER TABLE ONLY public."ProjectLanguageExtensions"
    ADD CONSTRAINT "ProjectLanguageExtensions_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectLanguageExtensions"
    ADD CONSTRAINT "ProjectLanguageExtensions_projectId_language_key" UNIQUE ("projectId", language);
ALTER TABLE ONLY public."ProjectLanguages"
    ADD CONSTRAINT "ProjectLanguages_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectTokens"
    ADD CONSTRAINT "ProjectTokens_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectTokens"
    ADD CONSTRAINT "ProjectTokens_token_key" UNIQUE (token);
ALTER TABLE ONLY public."ProjectUser"
    ADD CONSTRAINT "ProjectUser_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectUser"
    ADD CONSTRAINT "ProjectUser_projectId_userId" UNIQUE ("projectId", "userId");
ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_pkey1" PRIMARY KEY (id);
ALTER TABLE ONLY public."PromoCode"
    ADD CONSTRAINT "PromoCode_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."PromoCode"
    ADD CONSTRAINT "PromoCode_promoCode_key" UNIQUE ("promoCode");
ALTER TABLE ONLY public."ProjectRedirect"
    ADD CONSTRAINT "PublicProject_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."ProjectRedirect"
    ADD CONSTRAINT "PublicProject_username_projectName_key" UNIQUE (username, "projectName");
ALTER TABLE ONLY public."Request"
    ADD CONSTRAINT "Request_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Settings_ProjectQuality"
    ADD CONSTRAINT "Settings_ProjectQuality_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."StripeCostumer"
    ADD CONSTRAINT "StripeCostumer_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."System_Components"
    ADD CONSTRAINT "System_Components_component_key" UNIQUE (component);
ALTER TABLE ONLY public."System_Components"
    ADD CONSTRAINT "System_Components_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Teams_OrganizationMember"
    ADD CONSTRAINT "Teams_OrganizationMember_organizationId_userId_key" UNIQUE ("organizationId", "userId");
ALTER TABLE ONLY public."Teams_OrganizationMember"
    ADD CONSTRAINT "Teams_OrganizationMember_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Teams_Organization"
    ADD CONSTRAINT "Teams_Organization_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Teams_Organization"
    ADD CONSTRAINT "Teams_Organization_uniqueNameId_key" UNIQUE ("uniqueNameId");
ALTER TABLE ONLY public."Teams_ProjectTeam"
    ADD CONSTRAINT "Teams_ProjectTeam_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Teams_ProjectTeam"
    ADD CONSTRAINT "Teams_ProjectTeam_teamId_projectId_key" UNIQUE ("teamId", "projectId");
ALTER TABLE ONLY public."Teams_TeamMember"
    ADD CONSTRAINT "Teams_TeamMember_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."Teams_TeamMember"
    ADD CONSTRAINT "Teams_TeamMember_teamId_userId_key" UNIQUE ("teamId", "userId");
ALTER TABLE ONLY public."Teams_Team"
    ADD CONSTRAINT "Teams_Team_organizationId_name_key" UNIQUE ("organizationId", name);
ALTER TABLE ONLY public."Teams_Team"
    ADD CONSTRAINT "Teams_Team_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."UniqueName"
    ADD CONSTRAINT "UniqueName_name_key" UNIQUE (name);
ALTER TABLE ONLY public."UniqueName"
    ADD CONSTRAINT "UniqueName_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public."UserPaymentPlan"
    ADD CONSTRAINT "UserPaymentPlan_pkey" PRIMARY KEY (id);
ALTER TABLE ONLY public.account_cookies
    ADD CONSTRAINT account_cookies_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.account_duplicate
    ADD CONSTRAINT account_duplicate_high_account_id_key UNIQUE (high_account_id);
ALTER TABLE ONLY public.account_duplicate
    ADD CONSTRAINT account_duplicate_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.account_flow
    ADD CONSTRAINT account_flow_pkey PRIMARY KEY (user_id);
ALTER TABLE ONLY public.account_github
    ADD CONSTRAINT account_github_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.app_configuration
    ADD CONSTRAINT app_configuration_environment_key_key UNIQUE (environment, key);
ALTER TABLE ONLY public.app_configuration
    ADD CONSTRAINT app_configuration_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.notification_project_user_email_settings
    ADD CONSTRAINT notification_project_user_ema_user_id_project_id_email_type_key UNIQUE (user_id, project_id, email_type);
ALTER TABLE ONLY public.notification_user_email_settings
    ADD CONSTRAINT notification_user_email_settings_user_id_key UNIQUE (user_id);
ALTER TABLE ONLY public.organization_hook_secret
    ADD CONSTRAINT organization_hook_secret_pkey PRIMARY KEY (org_id);
ALTER TABLE ONLY public.organization_integration
    ADD CONSTRAINT organization_integration_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.organization_join_request
    ADD CONSTRAINT organization_join_request_user_id_organization_id_key UNIQUE (organization_id, user_id);
ALTER TABLE ONLY public.organization_tokens
    ADD CONSTRAINT organization_tokens_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.play_evolutions
    ADD CONSTRAINT play_evolutions_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.project_outside_collaborator
    ADD CONSTRAINT project_outside_collaborator_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.project_user_settings
    ADD CONSTRAINT project_user_settings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.project_user_settings
    ADD CONSTRAINT project_user_settings_user_id_project_id_key UNIQUE (user_id, project_id);
ALTER TABLE ONLY public.share_dashboard
    ADD CONSTRAINT share_dashboard_pkey PRIMARY KEY (user_id, project_id);
ALTER TABLE ONLY public.share_dashboard
    ADD CONSTRAINT share_dashboard_token_key UNIQUE (token);
ALTER TABLE ONLY public.account_github
    ADD CONSTRAINT user_id_unique UNIQUE (user_id);
ALTER TABLE ONLY public.website_configurations
    ADD CONSTRAINT website_configurations_key_key UNIQUE (key);
ALTER TABLE ONLY public.website_configurations
    ADD CONSTRAINT website_configurations_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.wizard_project
    ADD CONSTRAINT wizard_project_pkey PRIMARY KEY (id);
CREATE INDEX "AccountFeatures_userId_idx" ON public."AccountFeatures" USING btree ("userId");
CREATE INDEX "AccountTokens_userId_provider_idx" ON public."AccountTokens" USING btree ("userId", provider);
CREATE INDEX "Account_mainEmail" ON public."Account" USING btree ("mainEmail");
CREATE INDEX "ApiTokens_accountId_idx" ON public."ApiTokens" USING btree ("accountId");
CREATE INDEX "ApiTokens_clientId_idx" ON public."ApiTokens" USING btree ("clientId");
CREATE INDEX "Audit_projectId" ON public."ProjectAudit" USING btree ("projectId");
CREATE INDEX "Email_userId_idx" ON public."Email" USING btree ("userId");
CREATE INDEX "Integration_ProjectIntegration_projectId_idx" ON public."Integration_ProjectIntegration" USING btree ("projectId");
CREATE INDEX "Integration_ProjectNotification_projectIntegrationId_idx" ON public."Integration_ProjectNotification" USING btree ("projectIntegrationId");
CREATE INDEX "LoginSessions_sessionId_idx" ON public."LoginSessions" USING btree ("sessionId");
CREATE INDEX "Notification_ProjectUserNotificationSettings_projectId_idx" ON public."Notification_ProjectUserNotificationSettings" USING btree ("projectId");
CREATE INDEX "Notification_ProjectUserNotificationSettings_userId_idx" ON public."Notification_ProjectUserNotificationSettings" USING btree ("userId");
CREATE INDEX "ProjectAudit_targetId" ON public."ProjectAudit" USING btree ("targetId");
CREATE INDEX "ProjectAudit_targetId_targetType_target_idx" ON public."ProjectAudit" USING btree ("targetId", "targetType", target);
CREATE INDEX "ProjectIgnoreRules_projectId" ON public."ProjectIgnoreRules" USING btree ("projectId");
CREATE INDEX "ProjectLanguages_projectId_idx" ON public."ProjectLanguages" USING btree ("projectId");
CREATE UNIQUE INDEX "ProjectLanguages_projectId_language_key" ON public."ProjectLanguages" USING btree ("projectId", language);
CREATE INDEX "ProjectRedirect_projectId" ON public."ProjectRedirect" USING btree ("projectId");
CREATE INDEX "ProjectSettings_projectId_idx" ON public."ProjectSettings" USING btree ("projectId");
CREATE INDEX "ProjectTokens_projectId_idx" ON public."ProjectTokens" USING btree ("projectId");
CREATE INDEX "ProjectTokens_token_idx" ON public."ProjectTokens" USING btree (token);
CREATE UNIQUE INDEX "Project_creationMode_remoteIdentifier_uniq_idx" ON public."Project" USING btree ("creationMode", "remoteIdentifier") WHERE (("creationMode" IS NOT NULL) AND ("remoteIdentifier" IS NOT NULL));
CREATE INDEX "Settings_ProjectQuality_project_id_idx" ON public."Settings_ProjectQuality" USING btree (project_id);
CREATE UNIQUE INDEX "Teams_Organization_provider_remoteIdentifier_uniq_idx" ON public."Teams_Organization" USING btree (provider, "remoteIdentifier") WHERE ((provider IS NOT NULL) AND ("remoteIdentifier" IS NOT NULL));
CREATE INDEX "Teams_Organization_subscriptionId_idx" ON public."Teams_Organization" USING btree ("subscriptionId");
CREATE INDEX account_cookies_token_idx ON public.account_cookies USING btree (token);
CREATE INDEX "account_cookies_userId_idx" ON public.account_cookies USING btree (user_id);
CREATE INDEX account_duplicate_low_account_id_high_account_id_idx ON public.account_duplicate USING btree (low_account_id, high_account_id);
CREATE INDEX account_github__github_id_idx ON public.account_github USING btree (github_id);
CREATE INDEX account_github__user_id_idx ON public.account_github USING btree (user_id);
CREATE INDEX notification_project_user_email_settings__project_id ON public.notification_project_user_email_settings USING btree (project_id);
CREATE INDEX notification_project_user_email_settings__user_id ON public.notification_project_user_email_settings USING btree (user_id);
CREATE INDEX notification_user_email_settings__user_id ON public.notification_user_email_settings USING btree (user_id);
CREATE INDEX organization_integration_organization_id ON public.organization_integration USING btree (organization_id);
CREATE INDEX project_owner_id_index ON public."Project" USING btree ("ownerId");
CREATE INDEX wizard_project_user_id ON public.wizard_project USING btree (user_id);
ALTER TABLE ONLY public."AccountFeatures"
    ADD CONSTRAINT "AccountFeatures_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."AccountHeroku"
    ADD CONSTRAINT "AccountHeroku_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."AccountPattern"
    ADD CONSTRAINT "AccountPattern_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."AccountTokens"
    ADD CONSTRAINT "AccountTokens_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id);
ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_UserPaymentPlan_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES public."UserPaymentPlan"(id) ON DELETE SET NULL;
ALTER TABLE ONLY public."Account"
    ADD CONSTRAINT "Account_uniqueNameId_fkey" FOREIGN KEY ("uniqueNameId") REFERENCES public."UniqueName"(id);
ALTER TABLE ONLY public."ApiTokens"
    ADD CONSTRAINT "ApiTokens_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Email"
    ADD CONSTRAINT "Email_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."EnterpriseAccount"
    ADD CONSTRAINT "EnterpriseAccount_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_accountId_fkey" FOREIGN KEY ("accountId") REFERENCES public."Account"(id) ON DELETE SET NULL;
ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_accountTokenId_fkey" FOREIGN KEY ("accountTokenId") REFERENCES public."AccountTokens"(id) ON DELETE SET NULL;
ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id);
ALTER TABLE ONLY public."Integration_ProjectIntegration"
    ADD CONSTRAINT "Integration_ProjectIntegration_projectTokenId_fkey" FOREIGN KEY ("projectTokenId") REFERENCES public."ProjectTokens"(id) ON DELETE SET NULL;
ALTER TABLE ONLY public."Integration_ProjectNotification"
    ADD CONSTRAINT "Integration_ProjectNotification_projectIntegrationId_fkey" FOREIGN KEY ("projectIntegrationId") REFERENCES public."Integration_ProjectIntegration"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Notification_ProjectUserNotificationSettings"
    ADD CONSTRAINT "Notification_ProjectUserNotificationSettings_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Notification_ProjectUserNotificationSettings"
    ADD CONSTRAINT "Notification_ProjectUserNotificationSettings_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Notification_UserNotificationQueue"
    ADD CONSTRAINT "Notification_UserNotificationQueue_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectSettings"
    ADD CONSTRAINT "ProjectAddOns_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectAudit"
    ADD CONSTRAINT "ProjectAudit_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectAudit"
    ADD CONSTRAINT "ProjectAudit_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectIgnoreRules"
    ADD CONSTRAINT "ProjectIgnoredFiles_projectId_fkey1" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectLanguageExtensions"
    ADD CONSTRAINT "ProjectLanguageExtensions_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectLanguages"
    ADD CONSTRAINT "ProjectLanguages_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "ProjectOrganizationId_organizationId_fk" FOREIGN KEY ("organizationId") REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectTokens"
    ADD CONSTRAINT "ProjectTokens_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectUser"
    ADD CONSTRAINT "ProjectUser_projectId_fkey1" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."ProjectUser"
    ADD CONSTRAINT "ProjectUser_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES public."Account"(id) ON DELETE SET NULL;
ALTER TABLE ONLY public."Project"
    ADD CONSTRAINT "Project_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES public."Account"(id);
ALTER TABLE ONLY public."ProjectRedirect"
    ADD CONSTRAINT "PublicProject_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Settings_ProjectQuality"
    ADD CONSTRAINT "Settings_ProjectQuality_project_id_fkey" FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."StripeCostumer"
    ADD CONSTRAINT "StripeCostumer_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES public."UserPaymentPlan"(id);
ALTER TABLE ONLY public."Teams_OrganizationMember"
    ADD CONSTRAINT "Teams_OrganizationMember_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Teams_OrganizationMember"
    ADD CONSTRAINT "Teams_OrganizationMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Teams_Organization"
    ADD CONSTRAINT "Teams_Organization_UserPaymentPlan_subscriptionId_fkey" FOREIGN KEY ("subscriptionId") REFERENCES public."UserPaymentPlan"(id) ON DELETE SET NULL;
ALTER TABLE ONLY public."Teams_Organization"
    ADD CONSTRAINT "Teams_Organization_uniqueNameId_fkey" FOREIGN KEY ("uniqueNameId") REFERENCES public."UniqueName"(id);
ALTER TABLE ONLY public."Teams_ProjectTeam"
    ADD CONSTRAINT "Teams_ProjectTeam_projectId_fkey" FOREIGN KEY ("projectId") REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Teams_ProjectTeam"
    ADD CONSTRAINT "Teams_ProjectTeam_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams_Team"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Teams_TeamMember"
    ADD CONSTRAINT "Teams_TeamMember_teamId_fkey" FOREIGN KEY ("teamId") REFERENCES public."Teams_Team"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Teams_TeamMember"
    ADD CONSTRAINT "Teams_TeamMember_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."Teams_Team"
    ADD CONSTRAINT "Teams_Team_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public."UserPaymentPlan"
    ADD CONSTRAINT "UserPaymentPlan_planId_fkey" FOREIGN KEY ("planId") REFERENCES public."PaymentPlan"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.account_duplicate
    ADD CONSTRAINT account_duplicate_high_account_id_fkey FOREIGN KEY (high_account_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.account_duplicate
    ADD CONSTRAINT account_duplicate_low_account_id_fkey FOREIGN KEY (low_account_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.account_flow
    ADD CONSTRAINT account_flow_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.account_github
    ADD CONSTRAINT account_github_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.notification_project_user_email_settings
    ADD CONSTRAINT notification_project_user_email_settings_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.notification_project_user_email_settings
    ADD CONSTRAINT notification_project_user_email_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.notification_user_email_settings
    ADD CONSTRAINT notification_user_email_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.organization_hook_secret
    ADD CONSTRAINT organization_hook_secret_org_id_fkey FOREIGN KEY (org_id) REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.organization_integration
    ADD CONSTRAINT organization_integration_account_id_fkey FOREIGN KEY (account_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.organization_integration
    ADD CONSTRAINT organization_integration_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.organization_join_request
    ADD CONSTRAINT organization_join_request_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.organization_join_request
    ADD CONSTRAINT organization_join_request_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.organization_tokens
    ADD CONSTRAINT organization_tokens_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public."Teams_Organization"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.project_outside_collaborator
    ADD CONSTRAINT project_outside_collaborator_account_id_fkey FOREIGN KEY (account_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.project_outside_collaborator
    ADD CONSTRAINT project_outside_collaborator_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.project_user_settings
    ADD CONSTRAINT project_user_settings_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.project_user_settings
    ADD CONSTRAINT project_user_settings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.share_dashboard
    ADD CONSTRAINT share_dashboard_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.share_dashboard
    ADD CONSTRAINT share_dashboard_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.wizard_project
    ADD CONSTRAINT wizard_project_project_id_fkey FOREIGN KEY (project_id) REFERENCES public."Project"(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.wizard_project
    ADD CONSTRAINT wizard_project_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."Account"(id) ON DELETE CASCADE;
