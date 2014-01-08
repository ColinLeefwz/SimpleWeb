--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying(255),
    body text,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.active_admin_comments OWNER TO peterzd;

--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.active_admin_comments_id_seq OWNER TO peterzd;

--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.admin_users OWNER TO peterzd;

--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_users_id_seq OWNER TO peterzd;

--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.categories OWNER TO peterzd;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO peterzd;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: chapters; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE chapters (
    id integer NOT NULL,
    description text,
    course_id integer,
    "order" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255)
);


ALTER TABLE public.chapters OWNER TO peterzd;

--
-- Name: chapters_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE chapters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.chapters_id_seq OWNER TO peterzd;

--
-- Name: chapters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE chapters_id_seq OWNED BY chapters.id;


--
-- Name: ckeditor_assets; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE ckeditor_assets (
    id integer NOT NULL,
    data_file_name character varying(255) NOT NULL,
    data_content_type character varying(255),
    data_file_size integer,
    assetable_id integer,
    assetable_type character varying(30),
    type character varying(30),
    width integer,
    height integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.ckeditor_assets OWNER TO peterzd;

--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE ckeditor_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ckeditor_assets_id_seq OWNER TO peterzd;

--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE ckeditor_assets_id_seq OWNED BY ckeditor_assets.id;


--
-- Name: contact_messages; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE contact_messages (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    message text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.contact_messages OWNER TO peterzd;

--
-- Name: contact_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE contact_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_messages_id_seq OWNER TO peterzd;

--
-- Name: contact_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE contact_messages_id_seq OWNED BY contact_messages.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    categories character varying(255)[] DEFAULT '{}'::character varying[],
    title character varying(255),
    cover_file_name character varying(255),
    cover_content_type character varying(255),
    cover_file_size integer,
    cover_updated_at timestamp without time zone
);


ALTER TABLE public.courses OWNER TO peterzd;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_id_seq OWNER TO peterzd;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: courses_users; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE courses_users (
    id integer NOT NULL,
    course_id integer,
    expert_id integer
);


ALTER TABLE public.courses_users OWNER TO peterzd;

--
-- Name: courses_users_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE courses_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.courses_users_id_seq OWNER TO peterzd;

--
-- Name: courses_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE courses_users_id_seq OWNED BY courses_users.id;


--
-- Name: email_messages; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE email_messages (
    id integer NOT NULL,
    subject character varying(255),
    "to" character varying(255),
    message text,
    copy_me boolean,
    from_name character varying(255),
    from_address character varying(255),
    reply_to character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    user_id integer,
    invited_type character varying(255),
    invite_token character varying(255)
);


ALTER TABLE public.email_messages OWNER TO peterzd;

--
-- Name: email_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE email_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_messages_id_seq OWNER TO peterzd;

--
-- Name: email_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE email_messages_id_seq OWNED BY email_messages.id;


--
-- Name: followings; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE followings (
    id integer NOT NULL,
    the_followed integer,
    follower integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.followings OWNER TO peterzd;

--
-- Name: followings_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE followings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.followings_id_seq OWNER TO peterzd;

--
-- Name: followings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE followings_id_seq OWNED BY followings.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE languages (
    id integer NOT NULL,
    long_version character varying(255),
    short_version character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.languages OWNER TO peterzd;

--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.languages_id_seq OWNER TO peterzd;

--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE languages_id_seq OWNED BY languages.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE orders (
    id integer NOT NULL,
    user_id integer,
    session_id integer,
    payment_id character varying(255),
    state character varying(255),
    amount character varying(255),
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.orders OWNER TO peterzd;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO peterzd;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    title character varying(255),
    company character varying(255),
    location character varying(255),
    expertise text,
    favorite_quote text,
    career text,
    education text,
    web_site text,
    article_reports text,
    additional text,
    testimonials text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.profiles OWNER TO peterzd;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.profiles_id_seq OWNER TO peterzd;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: propose_topics; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE propose_topics (
    id integer NOT NULL,
    "Name" character varying(255),
    "Location" character varying(255),
    "Email" character varying(255),
    "Topic" text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.propose_topics OWNER TO peterzd;

--
-- Name: propose_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE propose_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.propose_topics_id_seq OWNER TO peterzd;

--
-- Name: propose_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE propose_topics_id_seq OWNED BY propose_topics.id;


--
-- Name: relationships; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE relationships (
    id integer NOT NULL,
    follower_id integer,
    followed_id integer,
    type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.relationships OWNER TO peterzd;

--
-- Name: relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relationships_id_seq OWNER TO peterzd;

--
-- Name: relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE relationships_id_seq OWNED BY relationships.id;


--
-- Name: resources; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE resources (
    id integer NOT NULL,
    expert_id integer,
    attached_file_file_path character varying(255),
    direct_upload_url character varying(255),
    attached_file_file_name character varying(255),
    attached_file_content_type character varying(255),
    attached_file_file_size integer,
    attached_file_updated_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    section_id integer,
    video_definition character varying(255)
);


ALTER TABLE public.resources OWNER TO peterzd;

--
-- Name: resources_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE resources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.resources_id_seq OWNER TO peterzd;

--
-- Name: resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE resources_id_seq OWNED BY resources.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO peterzd;

--
-- Name: sections; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE sections (
    id integer NOT NULL,
    description text,
    chapter_id integer,
    "order" integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying(255)
);


ALTER TABLE public.sections OWNER TO peterzd;

--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_id_seq OWNER TO peterzd;

--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE sessions (
    id integer NOT NULL,
    title character varying(255),
    expert_id integer,
    description text,
    status character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    content_type character varying(255),
    video_url character varying(255),
    cover_file_name character varying(255),
    cover_content_type character varying(255),
    cover_file_size integer,
    cover_updated_at timestamp without time zone,
    video_file_name character varying(255),
    video_content_type character varying(255),
    video_file_size integer,
    video_updated_at timestamp without time zone,
    location character varying(255),
    price numeric,
    language character varying(255),
    always_show boolean DEFAULT false,
    start_date timestamp without time zone,
    categories character varying(255)[] DEFAULT '{}'::character varying[],
    draft boolean DEFAULT false,
    time_zone character varying(255) DEFAULT 'UTC'::character varying,
    end_date_time timestamp without time zone,
    canceled boolean
);


ALTER TABLE public.sessions OWNER TO peterzd;

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_id_seq OWNER TO peterzd;

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE sessions_id_seq OWNED BY sessions.id;


--
-- Name: sessions_users; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE sessions_users (
    id integer NOT NULL,
    user_id integer,
    session_id integer
);


ALTER TABLE public.sessions_users OWNER TO peterzd;

--
-- Name: sessions_users_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE sessions_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_users_id_seq OWNER TO peterzd;

--
-- Name: sessions_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE sessions_users_id_seq OWNED BY sessions_users.id;


--
-- Name: static_pages; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE static_pages (
    id integer NOT NULL,
    title character varying(255),
    content text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    image_updated_at timestamp without time zone
);


ALTER TABLE public.static_pages OWNER TO peterzd;

--
-- Name: static_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE static_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.static_pages_id_seq OWNER TO peterzd;

--
-- Name: static_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE static_pages_id_seq OWNED BY static_pages.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    subscriber_id integer,
    subscribed_session_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.subscriptions OWNER TO peterzd;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.subscriptions_id_seq OWNER TO peterzd;

--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    rolable_id integer,
    rolable_type character varying(255),
    type character varying(255),
    name character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    provider character varying(255),
    uid character varying(255),
    invitation_token character varying(255),
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_id integer,
    invited_by_type character varying(255),
    time_zone character varying(255) DEFAULT 'UTC'::character varying
);


ALTER TABLE public.users OWNER TO peterzd;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: peterzd
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO peterzd;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: peterzd
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY chapters ALTER COLUMN id SET DEFAULT nextval('chapters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY ckeditor_assets ALTER COLUMN id SET DEFAULT nextval('ckeditor_assets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY contact_messages ALTER COLUMN id SET DEFAULT nextval('contact_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY courses_users ALTER COLUMN id SET DEFAULT nextval('courses_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY email_messages ALTER COLUMN id SET DEFAULT nextval('email_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY followings ALTER COLUMN id SET DEFAULT nextval('followings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY languages ALTER COLUMN id SET DEFAULT nextval('languages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY propose_topics ALTER COLUMN id SET DEFAULT nextval('propose_topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY relationships ALTER COLUMN id SET DEFAULT nextval('relationships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY resources ALTER COLUMN id SET DEFAULT nextval('resources_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY sessions ALTER COLUMN id SET DEFAULT nextval('sessions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY sessions_users ALTER COLUMN id SET DEFAULT nextval('sessions_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY static_pages ALTER COLUMN id SET DEFAULT nextval('static_pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: peterzd
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: active_admin_comments; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY active_admin_comments (id, namespace, body, resource_id, resource_type, author_id, author_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('active_admin_comments_id_seq', 1, false);


--
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY admin_users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at) FROM stdin;
1	admin@example.com	$2a$10$X3P.ZLr5oljXDHU5mamoOOmpvrOftnr6yl3J/zTts4b/F/pr4b79q	\N	\N	\N	26	2013-10-08 04:29:01.5719	2013-10-08 04:28:48.816401	218.108.222.146	218.108.222.146	2013-09-19 02:03:00.276814	2013-10-08 04:29:01.573106
2	sameer@originatechina.com	$2a$10$EGtyHYEH8SEOyxwlC8vctOfgPWAvC5VB3ABj0b5bBhxttpOFy25bS	\N	\N	2013-10-09 09:08:43.388353	1	2013-10-09 09:08:43.395519	2013-10-09 09:08:43.395519	128.97.245.115	128.97.245.115	2013-09-19 03:05:40.925235	2013-10-09 09:08:43.397368
4	alexduina@gmail.com	$2a$10$YXF3grkLqI3jFv69EL0mveR0qse/r6HIOZckCC4yssuw19U/WVoEa	\N	\N	2013-10-09 09:14:41.936281	10	2013-10-18 08:16:10.660353	2013-10-15 13:46:04.421018	46.165.196.12	217.170.192.141	2013-09-19 03:17:08.358713	2013-10-18 08:16:10.664773
3	nruble@gmail.com	$2a$10$dbbO/LBKjymYa9g36MYwS.UXKobun8rRxOGC0/pQqgaDRsEFBkFNy	\N	\N	2013-10-19 02:33:05.188454	5	2013-10-21 06:02:21.892528	2013-10-19 02:33:05.193894	46.105.114.105	46.165.196.12	2013-09-19 03:13:12.352452	2013-10-21 06:02:21.894324
\.


--
-- Name: admin_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('admin_users_id_seq', 4, true);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY categories (id, name, created_at, updated_at) FROM stdin;
1	macro	2013-11-05 10:06:30.131635	2013-11-05 10:06:30.131635
2	business	2013-11-05 10:06:30.141533	2013-11-05 10:06:30.141533
3	entrepreneurship	2013-11-05 10:06:30.144133	2013-11-05 10:06:30.144133
4	tech	2013-11-05 10:06:30.146368	2013-11-05 10:06:30.146368
5	culture	2013-11-05 10:06:30.148545	2013-11-05 10:06:30.148545
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('categories_id_seq', 5, true);


--
-- Data for Name: chapters; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY chapters (id, description, course_id, "order", created_at, updated_at, title) FROM stdin;
\.


--
-- Name: chapters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('chapters_id_seq', 1, false);


--
-- Data for Name: ckeditor_assets; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY ckeditor_assets (id, data_file_name, data_content_type, data_file_size, assetable_id, assetable_type, type, width, height, created_at, updated_at) FROM stdin;
\.


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('ckeditor_assets_id_seq', 1, false);


--
-- Data for Name: contact_messages; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY contact_messages (id, name, email, message, created_at, updated_at) FROM stdin;
\.


--
-- Name: contact_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('contact_messages_id_seq', 1, false);


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY courses (id, description, created_at, updated_at, categories, title, cover_file_name, cover_content_type, cover_file_size, cover_updated_at) FROM stdin;
\.


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('courses_id_seq', 1, false);


--
-- Data for Name: courses_users; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY courses_users (id, course_id, expert_id) FROM stdin;
\.


--
-- Name: courses_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('courses_users_id_seq', 1, false);


--
-- Data for Name: email_messages; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY email_messages (id, subject, "to", message, copy_me, from_name, from_address, reply_to, created_at, updated_at, user_id, invited_type, invite_token) FROM stdin;
1	Invitation to be a member on Prodygia	jevan@originatechina.com	<p>I&rsquo;m using a new site to read and display quality content on China and thought I&rsquo;d share with you.</p>\r\n\r\n<p>It&rsquo;s called Prodygia. What&rsquo;s different with their model is that they start with experts, like you and me, and give us a toolkit to promote our knowledge on China and get paid. You can record on-demand video sessions and sell them to your network or run live sessions online. It&rsquo;s quite unique and innovative in the market. They are carving out a niche for expertise on business, entrepreneurship, technology and culture as they relate to China.</p>\r\n\r\n<p>I encourage you to learn more about the platform and see how you can capitalize on it to build your online presence.</p>\r\n\r\n<p>Click below to sign up and enter your profile. It&rsquo;s a first step. You can actually save time by signing up from your LinkedIn or Facebook accounts. Feel free to email specific questions to the Prodygia team on<a href="mailto:experts@prodygia.com"> experts@prodygia.com. </a></p>\r\n\r\n<p>Sincerely,</p>\r\n\r\n<p>Peter Zhao</p>\r\n	f	Nicolas	no-reply@prodygia.com	no-reply@prodygia.com	2013-11-26 10:09:28.850547	2013-11-26 10:09:29.746039	19	Member	f267225c3f55c071dd750b73eb614a56d5bf20415c522124ac4690db10365302
2	TEST - Invitation to be a member on Prodygia	alessandro.duina@jljgroup.com	<p>I&rsquo;m using a new site to read and display quality content on China and thought I&rsquo;d share with you.</p>\r\n\r\n<p>It&rsquo;s called Prodygia. What&rsquo;s different with their model is that they start with experts, like you and me, and give us a toolkit to promote our knowledge on China and get paid. You can record on-demand video sessions and sell them to your network or run live sessions online. It&rsquo;s quite unique and innovative in the market. They are carving out a niche for expertise on business, entrepreneurship, technology and culture as they relate to China.</p>\r\n\r\n<p>I encourage you to learn more about the platform and see how you can capitalize on it to build your online presence.</p>\r\n\r\n<p>Click below to sign up and enter your profile. It&rsquo;s a first step. You can actually save time by signing up from your LinkedIn or Facebook accounts. Feel free to email specific questions to the Prodygia team on<a href="mailto:experts@prodygia.com"> experts@prodygia.com. </a></p>\r\n\r\n<p>Sincerely,</p>\r\n\r\n<p>Alessandro Duina</p>\r\n	t	Nicolas	no-reply@prodygia.com	no-reply@prodygia.com	2013-11-27 01:39:22.052487	2013-11-27 01:39:22.070849	15	Member	2996e81a9e70cce820ea9e7ff84c277955717b26e9fb6fb56480f1789389f5f9
\.


--
-- Name: email_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('email_messages_id_seq', 2, true);


--
-- Data for Name: followings; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY followings (id, the_followed, follower, created_at, updated_at) FROM stdin;
\.


--
-- Name: followings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('followings_id_seq', 1, false);


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY languages (id, long_version, short_version, created_at, updated_at) FROM stdin;
\.


--
-- Name: languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('languages_id_seq', 1, false);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY orders (id, user_id, session_id, payment_id, state, amount, description, created_at, updated_at) FROM stdin;
1	11	15	PAY-7X021488XL160061KKJFDKGQ	\N	\N	\N	2013-10-01 02:36:08.26281	2013-10-01 02:36:10.605194
2	11	15	PAY-3U223784HE353963NKJFDKGY	\N	\N	\N	2013-10-01 02:36:10.845224	2013-10-01 02:36:11.550813
3	12	15	PAY-68M46806JN654811SKJFDMUI	\N	\N	\N	2013-10-01 02:41:21.144701	2013-10-01 02:41:21.777845
4	12	15	PAY-7CN03128W3259991LKJFDMUQ	\N	\N	\N	2013-10-01 02:41:22.015769	2013-10-01 02:41:22.68562
5	13	15	PAY-63D26830FY075100TKJFDS5Y	\N	\N	\N	2013-10-01 02:54:46.881514	2013-10-01 02:54:47.666724
6	13	15	PAY-1J087851L6745411RKJFDS6A	\N	\N	\N	2013-10-01 02:54:47.914685	2013-10-01 02:54:48.549449
7	14	13	\N	\N	\N	\N	2013-10-01 03:10:40.04823	2013-10-01 03:10:40.04823
8	14	13	\N	\N	\N	\N	2013-10-01 03:10:41.966972	2013-10-01 03:10:41.966972
9	14	13	\N	\N	\N	\N	2013-10-01 03:10:52.152079	2013-10-01 03:10:52.152079
10	14	13	\N	\N	\N	\N	2013-10-01 03:10:52.920399	2013-10-01 03:10:52.920399
11	13	9	PAY-1AK162939V3265807KJFJHIQ	\N	\N	\N	2013-10-01 09:19:29.153311	2013-10-01 09:19:30.833238
12	13	9	PAY-7JY80071XK685281BKJFJHIY	\N	\N	\N	2013-10-01 09:19:31.118234	2013-10-01 09:19:31.880399
13	11	15	PAY-57J849710P8379335KJJXOKA	\N	\N	\N	2013-10-08 03:08:23.099064	2013-10-08 03:08:25.098644
14	11	15	PAY-28716689CL599873CKJJXOKQ	\N	\N	\N	2013-10-08 03:08:25.69839	2013-10-08 03:08:26.338416
15	11	15	PAY-8TG97967DU4000131KJJXP4Q	\N	\N	\N	2013-10-08 03:11:44.758852	2013-10-08 03:11:46.451793
16	11	15	PAY-3D951771RL0893223KJJXP4Y	\N	\N	\N	2013-10-08 03:11:46.749819	2013-10-08 03:11:47.412311
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('orders_id_seq', 16, true);


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY profiles (id, title, company, location, expertise, favorite_quote, career, education, web_site, article_reports, additional, testimonials, user_id, created_at, updated_at) FROM stdin;
1	\N	\N	Hangzhou, China	cooking	\N	\N	\N	\N	\N	\N	\N	3	2013-09-10 03:17:51.054085	2013-09-10 03:17:51.054085
2	Founder	Prodygia	Shanghai, China	Doing Business in China	"Whether you think you can or you think you can't-- you're right."\r\n- Henry Ford	Prodygia, Co-Founder (current) \r\n HROne, Board Member (current) \r\n	Kellogg Business School, Northwestern University, MBA \r\n Politecnico di Milano, Management Engineering Degree \r\n	www.jljgroup.com \r\n www.hroneonline.com \r\n	Published many industry and strategy reports about the Chinese market. 	Interests and hobbies include internet technologies, chess, long-distance running, scuba diving, cooking, NLP, and meditation.	"Thank you for your precious contribution to the project; we highly appreciate your professionalism." \r\n\r\n\t\t\t\t\t\t\tFerdinando Gueli, Deputy Trade Commissioner, Italian Trade Commission, Shanghai, China	1	2013-09-10 03:17:51.047194	2013-09-10 07:23:12.289068
3												8	2013-09-10 07:21:48.080589	2013-09-10 07:44:04.310844
4			Hangzhou, China	writing								2	2013-09-10 03:17:51.050978	2013-09-19 02:17:43.720044
5			Beijing, China									4	2013-09-10 06:40:59.994178	2013-09-19 02:18:03.415023
6	Co-Founder	Prodygia	Shanghai, China	<p>Doing Business in China</p>\r\n	"Whether you think you can or you think you can't-- you're right."\r\n- Henry Ford	Prodygia, Co-Founder (current) \r\n HROne, Board Member (current) \r\n	Kellogg Business School, Northwestern University, MBA \r\n Politecnico di Milano, Management Engineering Degree \r\n	<p>www.jljgroup.com www.hroneonline.com</p>\r\n	Published many industry and strategy reports about the Chinese market. 	<p>Interests and hobbies include internet technologies, chess, long-distance running, scuba diving, cooking, NLP, and meditation.</p>\r\n	<p>&quot;Thank you for your precious contribution to the project; we highly appreciate your professionalism.&quot; Ferdinando Gueli, Deputy Trade Commissioner, Italian Trade Commission, Shanghai, China</p>\r\n	9	2013-09-10 03:17:51.024821	2013-09-21 02:54:56.877215
7			Shanghai, China									7	2013-09-10 07:21:26.011824	2013-09-19 02:13:45.95958
8			Beijing, China									6	2013-09-10 07:20:33.834081	2013-09-19 02:16:07.194578
9			Shanghai, China									5	2013-09-10 06:54:51.673677	2013-09-19 02:16:30.074261
23	Instructor & Coach	Wu Wei Association	Brescia, Italy		\N	\N	\N		\N			\N	2013-09-23 18:10:24.641851	2013-09-23 18:10:24.641851
24	Instructor & Coach	Wu Wei Association	Brescia, Italy		\N	\N	\N		\N			\N	2013-09-23 18:11:54.839097	2013-09-23 18:11:54.839097
25	Instructor & Coach	Wu Wei Association	Brescia, Italy		\N	\N	\N		\N			\N	2013-09-23 18:15:06.247266	2013-09-23 18:15:06.247266
26					\N	\N	\N		\N			\N	2013-09-24 00:27:54.082868	2013-09-24 00:27:54.082868
27			Brescia, Italy	Traditional Chinese Medicine	\N	\N	\N		\N			10	2013-09-26 17:25:37.205604	2013-09-26 17:43:04.136676
28	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	21	2013-11-05 10:39:03.013674	2013-11-05 10:39:03.013674
29	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	22	2013-11-06 06:32:24.436977	2013-11-06 06:32:24.436977
30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	27	2013-12-12 03:01:32.462907	2013-12-12 03:01:32.462907
\.


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('profiles_id_seq', 30, true);


--
-- Data for Name: propose_topics; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY propose_topics (id, "Name", "Location", "Email", "Topic", created_at, updated_at) FROM stdin;
\.


--
-- Name: propose_topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('propose_topics_id_seq', 1, false);


--
-- Data for Name: relationships; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY relationships (id, follower_id, followed_id, type, created_at, updated_at) FROM stdin;
2	21	7	\N	2013-12-12 03:05:08.808584	2013-12-12 03:05:08.808584
4	21	6	\N	2013-12-12 03:10:47.879103	2013-12-12 03:10:47.879103
9	26	10	\N	2013-12-17 05:00:45.608777	2013-12-17 05:00:45.608777
\.


--
-- Name: relationships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('relationships_id_seq', 10, true);


--
-- Data for Name: resources; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY resources (id, expert_id, attached_file_file_path, direct_upload_url, attached_file_file_name, attached_file_content_type, attached_file_file_size, attached_file_updated_at, created_at, updated_at, section_id, video_definition) FROM stdin;
\.


--
-- Name: resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('resources_id_seq', 1, false);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY schema_migrations (version) FROM stdin;
20130718031659
20130718072405
20130724061705
20130724100629
20130725054737
20130725060626
20130725062330
20130725072808
20130725084300
20130725085738
20130815053230
20130830070738
20130830071031
20130830073859
20130830091129
20130830093830
20130902074726
20130902080458
20130903100347
20130906123850
20130910044701
20130910100504
20130916081047
20130916081051
20130917060301
20130917083320
20130917175718
20130917175719
20130917091251
20130918095257
20130919022712
20130918035719
20130918065211
20130918070000
20130919085526
20130921053544
20130923131526
20130924064608
20130925072618
20130927064653
20131011034357
20131011040538
20131009092445
20131016032406
20131022030013
20131022063608
20131028075225
20131028121802
20131029040243
20131101090026
20131105073314
20131119135732
20131121072348
20131121112542
20131122083227
20131122090417
20131125062046
20131127080747
20131126033807
20131126034659
20131126053755
20131202080030
20131203074749
20131203075007
20131203075057
20131203075142
20131203075800
20131204041317
20131204090449
20131205094609
20131209090417
\.


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY sections (id, description, chapter_id, "order", created_at, updated_at, title) FROM stdin;
\.


--
-- Name: sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('sections_id_seq', 1, false);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY sessions (id, title, expert_id, description, status, created_at, updated_at, content_type, video_url, cover_file_name, cover_content_type, cover_file_size, cover_updated_at, video_file_name, video_content_type, video_file_size, video_updated_at, location, price, language, always_show, start_date, categories, draft, time_zone, end_date_time, canceled) FROM stdin;
8	Principles of Business - East meets West	4	<p>In this session John will give us an overview of the do&#39;s and don&#39;ts of hiring and retaining Chinese local staff in China. Lessons that John learned the hard way, while building his Pizza chain and creating a company culture that became one of their Key Successful Factors. Enroll in this session and listen to what John as to say. More details on this session to come soon!</p>\r\n		2013-09-10 07:03:35.391457	2013-11-05 10:15:38.784183	VideoSession	\N	John_video_pic.png	image/png	387580	2013-09-11 02:59:49.454928	PrinciplesOfBusinessJohnOLoghlen.mp4	video/mp4	8406108	2013-09-10 07:03:35.373062		0.0	\N	f	\N	{entrepreneurship}	f	\N	\N	\N
5	The New Paradigm for Entrepreneurs: the Lean Start-Up	7	<p>Until not long ago, start-ups were conceptually considered the same as &ldquo;real&rdquo;, mature companies, just like their smaller and younger version; they were supposed to have a multi-year business plan and execute based on that pan: conduct market research, build the product, launch it and go to market. However, it is now a proven fact that &ldquo;no business plan can stand the test of the first customers&hellip;&rdquo;: the Lean Startup Approach flips the traditional approach upside down and its lessons are very relevant not only to all entrepreneurs (in the internet &amp; technology space especially) but also for established companies as well (for example, when launching a new product or when introducing a new service). This approach started in the US and it is now expanding also in China.</p>\r\n\r\n<h3>What will be covered?</h3>\r\n\r\n<ul>\r\n\t<li>The basics of the &ldquo;Lean Startup Approach&rdquo; and why it is important for all entrepreneurs</li>\r\n\t<li>Selected case studies &amp; examples</li>\r\n\t<li>Processes and practical tools</li>\r\n</ul>\r\n\r\n<h3>What I will get out of it?</h3>\r\n\r\n<p>A good understanding of the principles behind this approach and how you can apply to your start up from tomorrow.</p>\r\n\r\n<h3>Who is this for?</h3>\r\n\r\n<p>The session is open to all and particularly suitable for entrepreneurs and start-up founders as well as managers working in large companies involved in innovation and new product launch.</p>\r\n		2013-09-10 05:23:44.560746	2013-11-05 10:13:43.444839	LiveSession	\N	compass.jpg	image/jpeg	425050	2013-09-10 15:19:16.245084	videoplayback.mp4	video/mp4	17172033	2013-09-10 05:23:44.555286	Shanghai	0.0	\N	f	\N	{entrepreneurship}	f	\N	\N	\N
9	Developing Your China Roadmap	9	<p>Whether your company is considering entering the Chinese market or you are an entrepreneur ready to start a business from scratch in China, you have critical questions that you need to find good answers to.</p>\r\n\r\n<p>My experience has taught me that each project in China is different and unique; each industry sector has its own characteristics, opportunities and challenges. I have also learned that doing business in China is complex and should not be over-simplified. The learning curves are many and steep, and there is no substitute for direct experience.</p>\r\n\r\n<p>However, I have wondered how much more effective and efficient I could have been when I first started if I was given a &ldquo;compass&rdquo; to help me navigate the process; a thought-process to ask the right questions to the right people, avoid typical mistakes, and move forward in the right direction from the very start.</p>\r\n\r\n<p>With my 10+ years of hands-on experience helping international clients enter, navigate and grow their operations in China, I have built such compass. I now call it the &ldquo;China Roadmap&rdquo;: a set of practical guidelines, tips, and insights covering key aspects of doing business in China. Things you should know, regardless of the specific sector or project.</p>\r\n\r\n<p>Understanding this China Roadmap from the start will save you time, money and effort that could otherwise be wasted and I will be pleased to share it with you in this upcoming session.</p>\r\n\r\n<h3><strong>What will be covered?</strong></h3>\r\n\r\n<p>This session will cover the essentials of the China Roadmap, while follow up sessions will deep dive into specific topics.</p>\r\n\r\n<p>The following 10 topics will be explored:</p>\r\n\r\n<ol>\r\n\t<li>The big picture about China: top trends and top characteristics of the Chinese system</li>\r\n\t<li>Key cultural differences between China and the West that will affect your business</li>\r\n\t<li>Top 3 mistakes international companies make when approaching the Chinese market</li>\r\n\t<li>5 strategic factors to consider BEFORE making a decision to enter</li>\r\n\t<li>Why it is a must to use service providers, in which areas, and how to select them</li>\r\n\t<li>How and when to conduct proper market research</li>\r\n\t<li>How to think through legal setup options</li>\r\n\t<li>Human capital as key success factor &ndash; recruitment, retention, compliance</li>\r\n\t<li>The (relative) importance of learning Chinese</li>\r\n\t<li>Putting it all together: developing your own Roadmap &amp; China strategy</li>\r\n</ol>\r\n\r\n<p>A few days before the session I will make my presentation available together with relevant resources that I selected and found useful. To cover the broad set of topics above, the session itself will focus on practical highlights and insights and will also be driven by your questions and comments.</p>\r\n\r\n<h3><strong>What I will get out of it?</strong></h3>\r\n\r\n<p>You will have an opportunity to gain familiarity with the most important aspects of doing business in China, and you will be much clear as to what are the questions you need to focus and what to be aware of as you move forward with your China project.</p>\r\n\r\n<p>You will have access to select and targeted resources for details and reference, you will benefit from practical tips and insights that took me years to accumulate. This will just be a start, but you will have an idea of the building blocks of your Roadmap to China.</p>\r\n\r\n<p>You will also have a preview of follow up sessions, where we&rsquo;ll deep dive into individual topics.</p>\r\n\r\n<p>You will be invited to a private forum discussion where you will be able to continue the interaction with me as well as with other members attending the session.</p>\r\n\r\n<h3><strong>Who is this for?</strong></h3>\r\n\r\n<ul>\r\n\t<li>\r\n\t<p>SMEs and individual entrepreneurs who are considering entering the Chinese market</p>\r\n\t</li>\r\n\t<li>\r\n\t<p>Those who have already invested in China and want to both refine their understanding and increase their effectiveness</p>\r\n\t</li>\r\n\t<li>\r\n\t<p>These insights are common to all entrepreneurs and companies (both B2C, B2B) starting up in China.</p>\r\n\t</li>\r\n</ul>\r\n		2013-09-10 08:04:23.535782	2013-11-05 10:16:07.111909	VideoSession	\N	china_roadmap_session.jpg	image/jpeg	60647	2013-09-10 08:08:37.833995	ChinaRoadmapA.mp4	video/mp4	13410938	2013-09-10 14:35:30.91016		0.0	\N	f	\N	{business}	f	\N	\N	\N
10	Announcement: Introducing a New Expert! 	2	<p><span style="font-size:16px">Meet Alessandro Duina, one of the latest experts to join the Prodygia platform. Alessandro founded his own consulting company to help SMEs from Europe and the US to enter the Chinese market. He knows the ins and outs of legal&nbsp;registration, partnerships,&nbsp;recruiting, tax and accounting. &nbsp;</span></p>\r\n		2013-09-10 14:51:25.537386	2013-11-05 10:16:28.143762	Announcement	\N	Pic_of_AD_intro_video.png	image/png	1053152	2013-09-10 15:16:29.692343	AD_Intro_v3.mp4	video/mp4	16875715	2013-09-10 15:16:29.687791		0.0	\N	f	\N	{business}	f	\N	\N	\N
11	7 Reasons Why You Should Be on LinkedIn as Part of Your China Job-Hunting Strategy  	5	<p><span style="font-size:16px">What? You&rsquo;re not on LinkedIn yet? What are you waiting for? These seven reasons outline why you should be on the social networking site.</span></p>\r\n\r\n<p><span style="font-size:18px"><strong>a) Because That&rsquo;s Where The People Are</strong></span></p>\r\n\r\n<p><span style="font-size:16px">LinkedIn is the number one social network for professionals &mdash; and, arguably, the most important website for jobseekers &mdash; with more than 150 million members worldwide. Not only are people you know already on the site, but so are people you should get to know &mdash; recruiters, hiring managers, and your future co-workers.</span></p>\r\n\r\n<p><strong><span style="font-size:18px">b)&nbsp;To &ldquo;Dig Your Well Before You&rsquo;re Thirsty&rdquo; </span></strong></p>\r\n\r\n<p><span style="font-size:16px">In his book of the same name, author Harvey Mackay advocates building your network before you need it &mdash; and joining LinkedIn now gives you time to build your network of connections.</span></p>\r\n\r\n<p><strong><span style="font-size:18px">c)&nbsp;To Strengthen Your Offline Network</span></strong></p>\r\n\r\n<p><span style="font-size:16px">LinkedIn helps you keep track of people you know &ldquo;in real life&rdquo; &mdash; what they are doing, where they work now, and who they know.</span></p>\r\n\r\n<p><span style="font-size:18px"><strong>d)&nbsp;To Reconnect With Former Co-Workers</strong></span></p>\r\n\r\n<p><span style="font-size:16px">Sometimes it&rsquo;s hard to stay in touch with the people you used to work with &mdash; making it difficult to find them when you need them (say, to use as a reference in your job search). LinkedIn allows you to search contacts by employer, so anyone who listed that company in their profile will be found in the search.</span></p>\r\n\r\n<p><strong><span style="font-size:18px">e) Because You Can Establish Yourself as an Expert</span></strong></p>\r\n\r\n<p><span style="font-size:16px">One of the ways to be seen as a thought leader in your industry is to increase your visibility. One way to do this is to actively participate in Groups related to your job, and also to respond to questions on LinkedIn&rsquo;s &ldquo;Answers&rdquo; forums. Anytime you post in Groups or answer questions, these updates will be available in your profile, so people looking for you can see that you are actively engaged in this online community.</span></p>\r\n\r\n<p><strong><span style="font-size:18px">f) To Be Found as a Passive Candidate</span></strong></p>\r\n\r\n<p><span style="font-size:16px">Having a robust LinkedIn profile &mdash; filled with your accomplishments and strong keywords &mdash; will lead prospective employers to you, even if you are not actively looking for a job. Recruiters especially are always searching LinkedIn to find candidates to match their search assignments.</span></p>\r\n\r\n<p><strong><span style="font-size:18px">g) Because Your Presence on LinkedIn Can Help You Be Found Elsewhere Online</span></strong></p>\r\n\r\n<p><span style="font-size:16px">It&rsquo;s common practice for hiring managers and recruiters to &ldquo;Google&rdquo; job candidates, and your LinkedIn profile will likely appear high up in their Google search results. A strong LinkedIn profile can enhance your candidacy, especially if you have a solid network of contacts, at least a few Recommendations, and you&rsquo;ve supplemented the basic profile information with things like lists of your certifications, languages you speak, SlideShare presentations, honors and awards, and/or your professional portfolio.</span></p>\r\n\r\n<p>&nbsp;</p>\r\n		2013-09-10 15:25:02.896815	2013-11-05 10:16:50.675503	ArticleSession	\N	social_media_session_filip.jpg	image/jpeg	102788	2013-09-10 15:25:02.893356	\N	\N	\N	\N		0.0	\N	f	\N	{business}	f	\N	\N	\N
13	Demystifying Chinese Social Media	6	<p><span style="font-size:16px">The numbers are staggering: over 590 million internet users in China, of which 460 millions go online via their mobile phones, making cyber life a 24/7 reality. And even if the economy is slowing down, the number of Internet and social media users is still growing at breakneck speed.</span></p>\r\n\r\n<p><span style="font-size:16px">The players in this digital media eco-system are not the ones we know in the West. Instead, they are a host of local players who are innovating fast, introducing new products and capturing new markets.</span></p>\r\n\r\n<p><span style="font-size:16px">The challenge for international businesses is how to use this medium to understand emerging Chinese consumers and connect with them. Easier said than done.</span></p>\r\n\r\n<p><span style="font-size:16px">This series of sessions will give you a basic appreciation for this eco-system&rsquo;s history, cultural and social importance, players, trends, and help you think through strategies for becoming involved.</span></p>\r\n\r\n<h3><strong><span style="font-size:16px">What will be covered?</span></strong></h3>\r\n\r\n<ul>\r\n\t<li><span style="font-size:16px">A mapping of key Chinese social media platforms and ICT players</span></li>\r\n\t<li><span style="font-size:16px">Trends in innovation and users&rsquo; experience</span></li>\r\n\t<li><span style="font-size:16px">Grid to decode major events and news developing in social media</span></li>\r\n\t<li><span style="font-size:16px">Recommendations for sound social media strategy in China</span></li>\r\n\t<li><span style="font-size:16px">Recommended offline and online reading</span></li>\r\n</ul>\r\n\r\n<h3><strong><span style="font-size:18px">What will I get out of it?</span></strong></h3>\r\n\r\n<p><span style="font-size:16px">This is a &lsquo;social media in China 101&rsquo; crash course to give you essential orientation to navigate your strategy in the Chinese social media space. You&rsquo;ll receive select references and readings we picked for you to read in advance, and the session will be dedicated to distilling those learnings via live, interactive exchanges.</span></p>\r\n\r\n<p><span style="font-size:16px">By the end, you&rsquo;ll be able to speak knowledgeably about core elements of Chinese social media.</span></p>\r\n\r\n<h3><strong><span style="font-size:18px">Who is this for?</span></strong></h3>\r\n\r\n<p><span style="font-size:16px">International managers and directors who want to learn more about the social media world in China, whether out of personal interest or in order to achieve a professional goal.</span></p>\r\n\r\n<p><span style="font-size:16px"><strong>Vivian Wu</strong> will co-lead this session with Filip Noubel.</span></p>\r\n\r\n<p><span style="font-size:16px">Vivian Wu is a media expert with more than 12 years of experience in traditional and social media in China. Currently running a Beijing-based consulting company advising foreign companies and international organizations entering the Chinese media market, she provides digital media solutions and maintains an innovation lab to develop tools such as mobile phone APPs.</span></p>\r\n\r\n<p><span style="font-size:16px">After studying English at People&rsquo;s University and international media studies at Peking University, she launched a translation company, worked at Siemens and then switched to media organizations including CCTV, Beijing TV and finally the English-language South China Morning Post as a Beijing-based reporter covering business and media industry news from 2003 to 2009. She has won several awards for her news coverage.</span></p>\r\n\r\n<p><span style="font-size:16px">Since 2009 she has provided independent consultancy to a number of Chinese and international organizations while continuing a research career that took her to UC Berkeley University (2010), Oxford (2011) and Waseda University (2013). She is a frequent speaker at international events including the UN, SciencesPo, the EU Chamber of Commerce and advisor to leading Chinese media outlets such as Tencent, Netease. In 2013 she co-edited a reference book on media law for Chinese judges as a result of leading several Chinese delegations of media and law experts to Europe, the US and Japan.</span></p>\r\n\r\n<p><span style="font-size:16px">Wu is based in Beijing and now co-writing a book on the impact of social media in China. She also serves as a special advisor to a private experimental school in Beijing as part of her new research in critical thinking and reform of the Chinese educational system.</span></p>\r\n\r\n<p>&nbsp;</p>\r\n		2013-09-11 14:43:39.21739	2013-11-05 10:17:25.424492	LiveSession	\N	demystifyingsocialmedia.jpg	image/jpeg	60140	2013-09-11 14:43:39.215953	\N	\N	\N	\N	Beijing, China	0.0	\N	f	\N	{tech}	f	\N	\N	\N
7	Transitioning Your Career To China	5	<p>Finding your next job or making a career transition can be difficult enough, but if you&rsquo;d like to explore your opportunities to work in China there are even more factors to take into consideration.</p>\r\n\r\n<p>Sending CVs to recruiters and waiting for the phone to ring won&rsquo;t get you very far. What you need is a clear strategy, planning and execution to lead you toward your goal.</p>\r\n\r\n<p>This session is about understanding whether working in China market your skills and expertise in the increasingly competitive and evolving 21st century.</p>\r\n\r\n<h3>What will be covered?</h3>\r\n\r\n<p>We will cover the following concepts/frameworks:</p>\r\n\r\n<ul>\r\n\t<li>Start from the basic: clarifying you long term- goals, where you want to be</li>\r\n\t<li>The importance of designing the brand of &hellip;You!</li>\r\n\t<li>How the pieces fit together &ndash; planning for success, CV writing, networking, interviewing</li>\r\n</ul>\r\n\r\n<h3>What I will get out of it?</h3>\r\n\r\n<p>At the end of this series of 3 sessions, you will learn how to form clear goals and how to develop a clear plan for action that works.</p>\r\n\r\n<h3>Who is this for?</h3>\r\n\r\n<p>Anybody who is experiencing a plateau in her/his career and needs the suggestions and visions of the Career Doctor.</p>\r\n		2013-09-10 06:41:17.7964	2013-11-05 10:14:40.105054	LiveSession	\N	Peter_career_session_resized.jpg	image/jpeg	44171	2013-09-10 07:59:24.678952	\N	\N	\N	\N		0.0	\N	f	\N	{business}	f	\N	\N	\N
14	Competing in China’s E-commerce Market Requires a Startup Mentality	7	<p>Xin Wang of Brandeis University International Business School and Z. Justin Ren of Boston University School of Management wrote an interesting article about How to Compete in China&rsquo;s E-Commerce Market for MIT Sloan Management Review. They analyze why companies like eBay, Groupon, and Google have struggled in China.</p>\r\n\r\n<p>They offer advice relevant to both entrepreneurs and large companies: understand your customers, make decisions quickly, and pay attention to your competition. As The Startup Owner&rsquo;s Manual and The Lean Startup point out, the entrepreneur&rsquo;s mission is to understand their customers&rsquo; needs, test hypotheses by gathering customer feedback, and iterate quickly based on their findings. When doing this, you&rsquo;ll have to discover how to solve your customers&rsquo; problems better than your competitors do. And since you are testing and iterating, you&rsquo;ll have no choice but to create a culture of quick decision making.</p>\r\n\r\n<p>As Blank and Dorf point out, &ldquo;a startup is a faith-based initiative&rdquo;. It&rsquo;s important for large companies entering China, or other new markets, to remember they are also &ldquo;faith-based initiatives&rdquo; &mdash; even though they are market leaders at home, their approach is unproven in the new market. They need to think like a startup.</p>\r\n\r\n<p>When entering a new market, make sure you understand the competitive climate and your target customers&rsquo; needs. Then, alter your offering to carve out your own piece of the market. Otherwise you may end up another example of large company hubris leading to failure in a new market.</p>\r\n		2013-09-12 02:27:43.778936	2013-11-05 10:17:42.872192	ArticleSession	\N	shutterstock_90046438.jpg	image/jpeg	57088	2013-09-12 02:27:43.775763	\N	\N	\N	\N		0.0	\N	f	\N	{entrepreneurship}	f	\N	\N	\N
15	Re-Balancing Body-Mind Energy	10	<p><strong>THIS SESSION WILL BE RUN IN ITALIAN. &nbsp;LA&nbsp;SESSIONE SI TERRA&#39; IN LINGUA ITALIANA PER UTENTI ITALIANI.</strong></p>\r\n\r\n<p>The difficulties of managing our everyday professional or personal lives can sometimes cause&nbsp;psycho-physical stress and lead to deteriotating health. There exist preventive measures we should be aware of and learn about in order to boost the resilience of our bodies and minds. &nbsp;&nbsp;</p>\r\n\r\n<p>In this session you will pick up special techniques used in traditional Chinese medicine to reinforce physical and mental energy levels. I&#39;ve refined these techniques over 20 years of in-depth study and practice with Chinese masters. Here, I&#39;ve distilled the core insights and exercises so that you get tips you can apply to your life right away and start feeling visible improvements.&nbsp;</p>\r\n\r\n<h3>What will be covered?&nbsp;</h3>\r\n\r\n<p>The focus will be on the heart and kidney, two&nbsp;organs which are connected to water and fire (representing &#39;structure&#39; and &#39;function&#39;, respectively)&nbsp;and&nbsp;essential actors in maintaining&nbsp;a healthy body.</p>\r\n\r\n<h3>What will I get out of it?&nbsp;</h3>\r\n\r\n<ul>\r\n\t<li>Theoretical knowledge of the importance&nbsp;of the&nbsp;kidney&nbsp;and heart within the body</li>\r\n\t<li>Practical exercises&nbsp;that can be used to naturally boost your energy levels&nbsp;</li>\r\n</ul>\r\n\r\n<h3>Who is this for?</h3>\r\n\r\n<p>This session is for suitable for beginners in traditional Chinese medicine who wants to address&nbsp;physical or mental stress. &nbsp;</p>\r\n\r\n<h3>Additional details&nbsp;</h3>\r\n\r\n<p>La sessione si terra&#39; in ITALIANO ed e&#39; offerta al prezzo promozionale di Euro 15 (il prezzo normale in futuro sara&#39; di Euro 29).</p>\r\n\r\n<p>Il&nbsp;massimo numero di partecipanti e&#39; di 6 persone, per rendere la sessione piu&#39;&nbsp;dinamica&nbsp;e interattiva.&nbsp;</p>\r\n\r\n<p>L&#39;iscrizione alla sessione virtuale dara&#39; &nbsp;anche l&#39;accesso ad un FORUM privato esclusivamente dedicateo ai soli partecipanti alla sessione e che permettera&#39; di continuare&nbsp;l&#39;interazione con Gabriele (e gli altri pertecipanti) anche dopo la sessione stessa.</p>\r\n\r\n<p>Per qualsiasi domanda relativa alla sessione online, come verra&#39; svolta etc. non esitate a contattare Prodygia support presso support@Prodygia.com (in italiano o inglese).</p>\r\n\r\n<p><strong>VI ATTENDO ONLINE, ARRIVEDERCI A PRESTO!</strong></p>\r\n	what is status?	2013-09-26 17:35:27.984869	2013-11-05 10:17:58.090401	LiveSession	\N	gabriele_balance_session.jpg	image/jpeg	63624	2013-10-09 09:16:02.204634	Breve_Esempio_di_Session_Virtuale_di_Gabriele_Filippini.mp4	video/mp4	27547680	2013-10-02 01:24:53.502973	Brescia, Italy	19.5	\N	t	2013-10-16 14:00:00	{culture}	f	\N	\N	\N
12	Entrepreneurship In China: Illusion vs. Reality	4	<p><span style="font-size:16px">The Chinese market both awes and frustrates the business world. It&rsquo;s typical for international companies and entrepreneurs to enter China with dreams of selling to 1.3 billion consumers and generating huge revenue growth from consumer sales which are projected to reach 10 USD trillion by 2020. Some are pouring hundreds of millions in to set up offices, hire, develop relationships, design and distribute products. Yet more often than not, businesses are losing money their first few years. What they discover is a challenging, increasingly competitive landscape moving at blistering pace, and where it&rsquo;s getting harder to turn a profit.</span></p>\r\n\r\n<p><span style="font-size:16px">Let me share my experience with you and shorten your learning curve. There are many opportunities for international players who are sensitive to the local culture and can navigate the market. In my case, I carefully planned and built my company, Gung Ho, from the ground up. It required strategic sense combined with tactical decisions.</span></p>\r\n\r\n<h3><strong><span style="font-size:18px">What will be covered?</span></strong></h3>\r\n\r\n<ul>\r\n\t<li><span style="font-size:16px">Most promising opportunities for international players</span></li>\r\n\t<li><span style="font-size:16px">Most formidable risks to consider</span></li>\r\n\t<li><span style="font-size:16px">Do&rsquo;s and don&rsquo;ts of starting your own business</span></li>\r\n\t<li><span style="font-size:16px">Understanding Chinese consumers</span></li>\r\n\t<li><span style="font-size:16px">Building the team and partnering with Chinese</span></li>\r\n</ul>\r\n\r\n<h3><span style="font-size:18px"><strong>What will I get out of it?</strong></span></h3>\r\n\r\n<ul>\r\n\t<li><span style="font-size:16px">Thought process in deciding &lsquo;go-no go&rsquo;</span></li>\r\n\t<li><span style="font-size:16px">Examples of real success stories and failures</span></li>\r\n\t<li><span style="font-size:16px">Perspective and advice based on experience</span></li>\r\n\t<li><span style="font-size:16px">Appreciation for the risk and challenges involved; also rewards and timeframes</span></li>\r\n</ul>\r\n\r\n<h3><strong><span style="font-size:18px">Who is this for?</span></strong></h3>\r\n\r\n<ul>\r\n\t<li><span style="font-size:16px">Entrepreneurs and SMEs from Europe and the US looking to enter the Chinese market but unsure where to start.</span></li>\r\n\t<li><span style="font-size:16px">International entrepreneurs in China who&rsquo;ve launched their own business and could use guidance or best practice sharing</span></li>\r\n</ul>\r\n		2013-09-11 14:35:35.364299	2013-11-05 10:17:07.953623	LiveSession	\N	entrepreneurshipInChina.jpg	image/jpeg	898804	2013-09-11 14:35:35.360526	\N	\N	\N	\N		0.0	\N	f	\N	{entrepreneurship}	f	\N	\N	\N
\.


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('sessions_id_seq', 15, true);


--
-- Data for Name: sessions_users; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY sessions_users (id, user_id, session_id) FROM stdin;
1	13	15
2	13	9
3	11	13
4	14	13
5	14	13
6	14	5
7	11	13
8	11	13
9	11	12
10	15	9
11	17	13
\.


--
-- Name: sessions_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('sessions_users_id_seq', 11, true);


--
-- Data for Name: static_pages; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY static_pages (id, title, content, created_at, updated_at, image_file_name, image_content_type, image_file_size, image_updated_at) FROM stdin;
4	for members	<p>type content here plz</p>\r\n	2013-09-19 05:19:23.647268	2013-09-19 05:19:23.647268	\N	\N	\N	\N
7	conditions	<p>type content here plz</p>\r\n	2013-09-19 05:20:11.837512	2013-09-19 05:20:11.837512	\N	\N	\N	\N
1	About Us	<h2><strong><span style="font-size:18px">Vision</span></strong></h2>\r\n\r\n<p><span style="font-size:16px">China&#39;s opening to the world is one of&nbsp;the biggest stories of the early 21st century.</span></p>\r\n\r\n<p><span style="font-size:16px">This makes it imperative for the West to learn more about how the &quot;new China&quot; operates in terms of business, innovation, culture and many other areas. Lack of access, distances, costs, and time constraints are all barriers many of us have experienced when trying to learn and achieve a better understanding. Sometimes it&#39;s even difficult to know where to start!</span></p>\r\n\r\n<p><span style="font-size:16px">At Prodygia, we figured there must be a better way to connect China with the rest of the world, and we decided to do something about it.</span></p>\r\n\r\n<p><span style="font-size:16px">Our mission is to build an online, multimedia platform where the West &quot;meets&quot; China via quality content and live interactions with select experts.</span></p>\r\n\r\n<p><span style="font-size:16px"><em>Log into China</em>: get to the topics that are relevant to you and learn from real experts.</span></p>\r\n\r\n<h2><strong><span style="font-size:18px">Today</span></strong></h2>\r\n\r\n<p><span style="font-size:16px">Our journey has just begun and this site is the first step toward making the vision come true.</span></p>\r\n\r\n<p><span style="font-size:16px">We&#39;re currently working with select experts to bring their content on the site. Plus expect more features to be integrated as we move along</span></p>\r\n\r\n<p><span style="font-size:16px">Connecting with you, the early users, and capturing your feedback are key to the success of the platform. If you would like to join us in this journey, we would very much like to hear from you. Take a few seconds to sign up at the top right of the screen and keep you posted on latest developments.</span></p>\r\n\r\n<h3><strong><span style="font-size:18px">The Team</span></strong></h3>\r\n\r\n<p><span style="font-size:16px">Prodygia was started by two friends who met in Shanghai a decade ago. As foreigners&nbsp; with no local contacts or language skills, they quickly realized how much they didn&#39;t know - and also what a wonderful opportunity lay ahead of them to learn and grow. It meant starting from scratch, though, and the learning curves were steep. Quite a humbling experience!</span></p>\r\n\r\n<p><span style="font-size:16px">The team, now complete with technical expertise, represents 50 years of&nbsp;strategic and operational experience gained from a variety of roles at The Boston Consulting Group (BCG); the World Economic Forum; Standard Chartered Bank; a boutique one-stop service company for China market entry and growth; a boutique web development company for building agile, scalable, high-performance online platforms.</span></p>\r\n\r\n<p><span style="font-size:16px">They are alumni of Stanford University, Kellogg Business School, INSEAD, Tsinghua, and the UCLA Anderson School of Management.</span></p>\r\n	2013-09-19 05:17:04.68138	2013-09-20 11:51:27.824654	about_us.jpg	image/jpeg	43465	2013-09-19 05:17:04.678616
5	Privacy	<p><span style="font-size:16px">Any information collected via this site is kept strictly confidential and used only within the scope of Prodygia, i.e. to keep you updated and follow up with you on topics you have expressed interest for.</span></p>\r\n\r\n<p><span style="font-size:16px">Like you, we don&#39;t like to be spammed. And therefore we will never spam you.</span></p>\r\n	2013-09-19 05:19:43.091595	2013-09-20 12:04:24.495366	\N	\N	\N	\N
2	FAQ	<h2>Is the site still in &ldquo;demo&rdquo; mode?</h2>\r\n\r\n<p>Yes! The current site is just to give you a feel for what we are building.</p>\r\n\r\n<p>Behind the scene we are working very hard to develop key functionality, build our community of select experts and relevant content.</p>\r\n\r\n<p>Come back in a few weeks, there is much more to come!</p>\r\n	2013-09-19 05:17:39.828318	2013-09-19 12:47:54.975276	faq.jpg	image/jpeg	36348	2013-09-19 05:17:39.827181
6	Terms	<p><span style="font-size:16px">We will make sure to talk to our friendly lawyers and fill up this page with the important things you need to know shortly. All in the Prodygia spirit of looking after you as well as us.</span></p>\r\n\r\n<p><span style="font-size:16px">Until then, just enjoy the site (and tell us what you think).</span></p>\r\n	2013-09-19 05:19:54.558099	2013-09-20 12:04:51.074694	\N	\N	\N	\N
3	For Experts	<p>Are you a China expert in one of our key subject categories &ndash; macro trends, business, entrepreneurship, tech, or culture?</p>\r\n\r\n<p><span style="font-size:13px">Wondering how to build or strengthen your online presence, complement your existing marketing channels and raise your visibility?</span></p>\r\n\r\n<p><span style="font-size:13px">Keen to reach a global community of members and develop additional revenue streams?</span></p>\r\n\r\n<p><span style="font-size:13px">Prodygia allows you to integrate your current business model with a set of tools that will reinforce your online marketing presences and help you realize your potential whether you are a business, a professional, or a an independent instructor or trainer.</span></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><strong>Why to join us as a China Expert:</strong></p>\r\n\r\n<ul>\r\n\t<li>Build&nbsp; or reinforce your online presence and online marketing activities, <u>complementing</u> existing channels and networks</li>\r\n\t<li>Strengthen your brand awareness</li>\r\n\t<li>Improve your lead generation</li>\r\n\t<li>Reach a global community of members</li>\r\n\t<li>Develop complementary revenue streams via an online tool kit that let you publish your content, lead virtual session with a targeted audiences, as group or private consultations</li>\r\n\t<li>Take advantage of our video conferencing system and integrated payment solutions</li>\r\n\t<li>Be part of a new concept and contribute to shaping it</li>\r\n\t<li>Take advantage of the free membership for experts during the initial launch phase</li>\r\n</ul>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<p><span style="font-size:13px">If you decide to join or have any questions, send us an email at </span><a href="mailto:support@prodygia.com" style="font-size: 13px; line-height: 1.6em;">support@prodygia.com</a><span style="font-size:13px">&nbsp;&nbsp;</span></p>\r\n\r\n<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>\r\n\r\n<p>&nbsp;</p>\r\n	2013-09-19 05:19:10.425073	2013-09-26 17:20:03.933245	\N	\N	\N	\N
\.


--
-- Name: static_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('static_pages_id_seq', 7, true);


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY subscriptions (id, subscriber_id, subscribed_session_id, created_at, updated_at) FROM stdin;
1	27	14	2013-12-12 02:59:48.416225	2013-12-12 02:59:48.416225
2	21	14	2013-12-12 03:06:50.00474	2013-12-12 03:06:50.00474
\.


--
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('subscriptions_id_seq', 2, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: peterzd
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, rolable_id, rolable_type, type, name, first_name, last_name, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at, provider, uid, invitation_token, invitation_created_at, invitation_sent_at, invitation_accepted_at, invitation_limit, invited_by_id, invited_by_type, time_zone) FROM stdin;
1	nick@prodygia.com	$2a$10$4WimEJzt2TmDv72MPgyyKe09ocT9Na/SAUQDedgynoZwTRcq4aXiS	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:26:40.318591	2013-09-22 09:26:40.318591	\N	\N	Expert	\N	Nicolas	Ruble	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	jevan@prodygia.com	$2a$10$kC8H/qmXCXn42Q7m5lDX2.D7O4Zb4XGCEpBECTdj7vuOvYClRRGvS	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:30:03.973787	2013-09-22 09:30:03.973787	\N	\N	Expert	\N	jevan	wu	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	peter@prodygia.com	$2a$10$KbAyDYTovE0REN5TJCiyoe8ZRiSMEZ8itML0oianj72.wC2jxW1p.	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:36:03.290308	2013-09-22 09:36:03.290308	\N	\N	Expert	\N	Peter	Hill	peterhill.png	image/png	36804	2013-09-22 09:36:03.125144	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
6	filip@prodygia.com	$2a$10$rHbyMi6zCOsjLLpaKqFWneg76k2tDGkoFXtlljArNIO69Cn7szYhS	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:36:46.278084	2013-09-22 09:36:46.278084	\N	\N	Expert	\N	Filip	Noubel	filipnouble.png	image/png	33227	2013-09-22 09:36:46.124609	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	sameer@prodygia.com	$2a$10$IU3mmV2rJgad64bLf84yye7zSDT92p6KMFgXTYgeU7B5d3/erRjhW	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:37:34.901798	2013-09-22 09:37:34.901798	\N	\N	Expert	\N	Sameer	Karim	sameerkarim.png	image/png	260797	2013-09-22 09:37:34.600325	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	prodygia@prodygia.com	$2a$10$yw8nnxPIWlChJZ4hwenrA.y7Ti2tVHqEtyblV28LkDH17U1pONXRu	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:27:59.852244	2013-09-22 09:42:20.160344	\N	\N	Expert	\N	Prodygia Staff		prodygiaexpert.png.jpg	image/jpeg	4120	2013-09-22 09:42:20.039859	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	john@prodygia.com	$2a$10$EnEP4sdPVzx6TYIdBW16K.1vi7Jsi.TtDalXvw5IeOrsbuiW9CaOK	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:35:17.352903	2013-09-22 13:40:26.508	\N	\N	Expert	\N	John	O'Loghlen	johnoloughlin.png	image/png	41203	2013-09-22 13:40:26.3621	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	someone@prodygia.com	$2a$10$coMAvnJjf3PP9Wo26bfnXu7vcFIBz4u13EZ0b6yBHm8hMhVcLE07.	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:38:46.309116	2013-09-23 04:32:56.840275	\N	\N	Expert	\N	Someone else		prodygiaexpert.png.jpg	image/jpeg	4120	2013-09-23 04:32:56.44546	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
9	alessandro@prodygia.com	$2a$10$/H/a5GdQigR51SKFYmisJ.xiAtYIVwBZrOB.R/QcvdJwYyrSgqVTi	\N	\N	\N	0	\N	\N	\N	\N	2013-09-22 09:41:48.003687	2013-09-23 20:18:20.387712	\N	\N	Expert	\N	Alessandro	Duina	AD_pic2.jpg	image/jpeg	37062	2013-09-23 20:18:20.220316	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
10	wuweituina@gmail.com		\N	\N	\N	0	\N	\N	\N	\N	2013-09-26 17:25:37.17836	2013-09-26 17:43:20.614389	\N	\N	Expert	\N	Gabriele	Filippini	Gabriele_pic.png	image/png	290483	2013-09-26 17:43:20.365067	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	sameerkarim1@gmail.com	$2a$10$QBEy6g25TYfViHPVHuMVyOK2lhSAMOwMLFVPn66Qj7kdpw4mz8CL.	\N	\N	\N	1	2013-12-12 03:03:27.445003	2013-12-12 03:03:27.445003	128.97.244.84	128.97.244.84	2013-12-12 03:03:27.437589	2013-12-12 03:03:27.45527	\N	\N	Member	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	UTC
25	alessandro.duina@jljgroup.com		\N	\N	\N	0	\N	\N	\N	\N	2013-11-27 01:39:22.06541	2013-11-27 01:54:20.633854	\N	\N	Member	\N	\N	\N	\N	\N	\N	\N	\N	\N	2996e81a9e70cce820ea9e7ff84c277955717b26e9fb6fb56480f1789389f5f9	2013-11-27 01:39:22.064121	\N	\N	\N	15	User	UTC
21	zdsunshine0640@gmail.com	$2a$10$sDvuIWepwl2puxJFB1MU0.A4eqyEmWs4yRBlgzb9EhwZyye3tlcVm	\N	\N	\N	4	2013-12-12 03:04:39.697903	2013-12-12 02:59:01.380635	218.108.221.115	218.108.221.115	2013-11-05 10:38:29.698067	2013-12-12 03:04:39.699607	\N	\N	Expert	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2013-11-05 10:38:29.696216	\N	2013-11-05 10:39:12.824228	\N	20	User	UTC
20	admin@example.com	$2a$10$IFBkk0rtXTTYFn4sJsSQM.wdCYUysRW1puLP52jaY7ajg1iJVTEk6	\N	\N	\N	6	2013-12-17 03:35:36.486241	2013-12-16 11:04:38.959636	128.97.245.188	81.95.121.102	2013-11-05 10:37:59.942705	2013-12-17 03:35:36.487974	\N	\N	AdminUser	admin@example.com	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	UTC
16	ruble.richard@gmail.com	$2a$10$euXMG2J/6oF8aG8YRpgVh.3zPOYPmuM8gBevieaoKwbMxHrFz.e12	\N	\N	\N	1	2013-10-10 14:07:57.786257	2013-10-10 14:07:57.786257	89.91.240.64	89.91.240.64	2013-10-10 14:07:57.777123	2013-10-10 14:07:57.789365	\N	\N	Member	\N	Richard	Ruble	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
28	zjut.fmr@gmail.com	$2a$10$GLRbT8JPBucGzGmcdt6kyeizi4RqURImM7Go8hOJU1vKqYCIwT29C	\N	\N	\N	1	2013-11-27 02:51:22.312913	2013-11-27 02:51:22.312913	74.62.34.238	74.62.34.238	2013-11-27 02:51:22.302739	2013-11-27 02:51:22.32435	\N	\N	Member	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	UTC
19	zdsunshine0640@126.com	$2a$10$v8mrfn4fWI8PmYG6v4Bby.wpdMJ1biK0A0Mw3rAd8rb3Y5qwopx26	GxwU2nszeGffzaEGQngt	\N	2013-11-26 10:08:53.978309	4	2013-11-28 03:53:50.831993	2013-11-26 10:08:53.993296	218.108.220.52	218.108.221.139	2013-11-05 10:31:43.210892	2013-11-28 03:53:50.834708	\N	\N	Member	\N	peter	zhao	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Beijing
15	alexduina@gmail.com	$2a$10$Qwtul9rciS00jfuBYP6UC.7mVqGcpYU/tFrVUncwzWk8cuMkgrdEO	082571d7d9b58fd53a0894520513cff0abf8768e3dee519e40b16db06410b105	2013-11-27 01:19:33.236609	\N	6	2013-11-29 05:39:24.664186	2013-11-27 01:22:58.126711	46.165.196.12	46.165.196.12	2013-10-02 00:33:26.506824	2013-11-29 05:39:24.665755	\N	\N	Member	\N	Alessandro	Duina	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	nruble@gmail.com	$2a$10$VPGGYucbvJsfztMW6m9lHOh/YQFBzvUgRb9x0QaAaqTw83VrCKBMK	\N	\N	\N	4	2013-11-28 01:40:38.688022	2013-11-27 02:53:18.723792	204.152.207.170	96.44.130.234	2013-11-26 07:45:58.781919	2013-11-28 01:40:38.689193	\N	\N	Member	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	UTC
26	sameer.karim@originate.com	$2a$10$sfMbFPT/pvtvFB1LviPZ2unahHJJYCS6JAY.s0XCdgXdWhyXZcknK	96746913914048b64b9ab6f0a5df0c9db2a487679c36a128a32a767575dae942	2013-11-27 02:39:15.313568	\N	2	2013-12-17 05:00:26.006625	2013-11-27 02:35:13.398153	128.97.245.188	128.97.244.185	2013-11-27 02:35:13.391479	2013-12-17 05:00:26.010656	\N	\N	Member	\N	Sameer	Karim	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	UTC
29	zdsunshine0640@gmail.com	$2a$10$QDmjvveMG5ZBr5dhWF8MeOD/qrssoYEn.Q.wswLLLP0VpCizQslVK	\N	\N	\N	1	2013-11-28 02:27:46.372833	2013-11-28 02:27:46.372833	74.62.34.238	74.62.34.238	2013-11-28 02:27:46.364951	2013-11-28 02:27:46.384131	\N	\N	Member	Zhao  Peter	\N	\N	\N	\N	\N	\N	facebook	100002452383492	\N	\N	\N	\N	\N	\N	\N	UTC
27	sameerkarim1@gmail.com	$2a$10$RV9/ax8Apq.MU474qnn.VuB4pcaCWnlb5/J01ctiwOHGDN6Y9StQi	eXTF-SPTj1b8UX8S3fxx	\N	\N	11	2013-12-12 03:09:08.882257	2013-12-12 03:08:58.713601	128.97.244.84	128.97.244.84	2013-11-27 02:38:04.831126	2013-12-12 03:09:08.883662	\N	\N	Member	Sameer Karim	\N	\N	\N	\N	\N	\N	facebook	1058202078	\N	\N	\N	\N	\N	\N	\N	UTC
31	jevanwu@gmail.com	$2a$10$J.02fvHA/inNGcmofnMJmOfmrdVVOelqO.FjZNaWLIWul7dmeo3sW	\N	\N	\N	2	2013-12-13 10:33:39.74797	2013-12-13 10:33:21.380742	124.90.57.142	124.90.57.142	2013-12-13 10:33:21.352678	2013-12-13 10:33:39.749944	\N	\N	Member	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	UTC
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: peterzd
--

SELECT pg_catalog.setval('users_id_seq', 31, true);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: chapters_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY chapters
    ADD CONSTRAINT chapters_pkey PRIMARY KEY (id);


--
-- Name: ckeditor_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY ckeditor_assets
    ADD CONSTRAINT ckeditor_assets_pkey PRIMARY KEY (id);


--
-- Name: contact_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY contact_messages
    ADD CONSTRAINT contact_messages_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: courses_users_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY courses_users
    ADD CONSTRAINT courses_users_pkey PRIMARY KEY (id);


--
-- Name: email_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY email_messages
    ADD CONSTRAINT email_messages_pkey PRIMARY KEY (id);


--
-- Name: expert_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT expert_profiles_pkey PRIMARY KEY (id);


--
-- Name: followings_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY followings
    ADD CONSTRAINT followings_pkey PRIMARY KEY (id);


--
-- Name: languages_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: propose_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY propose_topics
    ADD CONSTRAINT propose_topics_pkey PRIMARY KEY (id);


--
-- Name: relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_pkey PRIMARY KEY (id);


--
-- Name: resources_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY resources
    ADD CONSTRAINT resources_pkey PRIMARY KEY (id);


--
-- Name: sections_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sessions_users_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY sessions_users
    ADD CONSTRAINT sessions_users_pkey PRIMARY KEY (id);


--
-- Name: static_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY static_pages
    ADD CONSTRAINT static_pages_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: peterzd; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_ckeditor_assetable; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX idx_ckeditor_assetable ON ckeditor_assets USING btree (assetable_type, assetable_id);


--
-- Name: idx_ckeditor_assetable_type; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX idx_ckeditor_assetable_type ON ckeditor_assets USING btree (assetable_type, type, assetable_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_chapters_on_course_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_chapters_on_course_id ON chapters USING btree (course_id);


--
-- Name: index_courses_on_categories; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_courses_on_categories ON courses USING gin (categories);


--
-- Name: index_courses_users_on_course_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_courses_users_on_course_id ON courses_users USING btree (course_id);


--
-- Name: index_courses_users_on_expert_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_courses_users_on_expert_id ON courses_users USING btree (expert_id);


--
-- Name: index_email_messages_on_user_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_email_messages_on_user_id ON email_messages USING btree (user_id);


--
-- Name: index_orders_on_session_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_orders_on_session_id ON orders USING btree (session_id);


--
-- Name: index_orders_on_user_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_orders_on_user_id ON orders USING btree (user_id);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--
-- Name: index_relationships_on_followed_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_relationships_on_followed_id ON relationships USING btree (followed_id);


--
-- Name: index_relationships_on_follower_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_relationships_on_follower_id ON relationships USING btree (follower_id);


--
-- Name: index_resources_on_section_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_resources_on_section_id ON resources USING btree (section_id);


--
-- Name: index_sections_on_chapter_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_sections_on_chapter_id ON sections USING btree (chapter_id);


--
-- Name: index_sessions_on_categories; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_sessions_on_categories ON sessions USING gin (categories);


--
-- Name: index_sessions_on_expert_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_sessions_on_expert_id ON sessions USING btree (expert_id);


--
-- Name: index_subscriptions_on_subscribed_session_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_subscriptions_on_subscribed_session_id ON subscriptions USING btree (subscribed_session_id);


--
-- Name: index_subscriptions_on_subscriber_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_subscriptions_on_subscriber_id ON subscriptions USING btree (subscriber_id);


--
-- Name: index_users_on_email_and_provider; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email_and_provider ON users USING btree (email, provider);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON users USING btree (invitation_token);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE INDEX index_users_on_invited_by_id ON users USING btree (invited_by_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: peterzd; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

