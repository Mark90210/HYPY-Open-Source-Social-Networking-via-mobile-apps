--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
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
-- Name: alerts; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE alerts (
    id integer NOT NULL,
    user_id integer,
    type character varying,
    title character varying,
    messge text,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    expires_at timestamp without time zone,
    sent_at timestamp without time zone,
    delivered_at timestamp without time zone
);


ALTER TABLE alerts OWNER TO rossb;

--
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: rossb
--

CREATE SEQUENCE alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE alerts_id_seq OWNER TO rossb;

--
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rossb
--

ALTER SEQUENCE alerts_id_seq OWNED BY alerts.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    user_id integer,
    photo_id integer,
    text text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE comments OWNER TO rossb;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: rossb
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_id_seq OWNER TO rossb;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rossb
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: galleries; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE galleries (
    id integer NOT NULL,
    user_id integer,
    owner_type character varying,
    description text,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    location point,
    hero_image character varying
);


ALTER TABLE galleries OWNER TO rossb;

--
-- Name: galleries_id_seq; Type: SEQUENCE; Schema: public; Owner: rossb
--

CREATE SEQUENCE galleries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE galleries_id_seq OWNER TO rossb;

--
-- Name: galleries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rossb
--

ALTER SEQUENCE galleries_id_seq OWNED BY galleries.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE invitations (
    id integer NOT NULL,
    inviter_id integer,
    invitee_id integer,
    gallery_id integer,
    file_url character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE invitations OWNER TO rossb;

--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: rossb
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE invitations_id_seq OWNER TO rossb;

--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rossb
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    user_id integer,
    gallery_id integer,
    file_url character varying,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE photos OWNER TO rossb;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: rossb
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE photos_id_seq OWNER TO rossb;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rossb
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO rossb;

--
-- Name: sponsor_users; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE sponsor_users (
    id integer NOT NULL,
    sponsor_id integer,
    user_id integer,
    access_level integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE sponsor_users OWNER TO rossb;

--
-- Name: sponsor_users_id_seq; Type: SEQUENCE; Schema: public; Owner: rossb
--

CREATE SEQUENCE sponsor_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sponsor_users_id_seq OWNER TO rossb;

--
-- Name: sponsor_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rossb
--

ALTER SEQUENCE sponsor_users_id_seq OWNED BY sponsor_users.id;


--
-- Name: sponsors; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE sponsors (
    id integer NOT NULL,
    name character varying,
    bio text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE sponsors OWNER TO rossb;

--
-- Name: sponsors_id_seq; Type: SEQUENCE; Schema: public; Owner: rossb
--

CREATE SEQUENCE sponsors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sponsors_id_seq OWNER TO rossb;

--
-- Name: sponsors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rossb
--

ALTER SEQUENCE sponsors_id_seq OWNED BY sponsors.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: rossb; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    first_name character varying,
    last_name character varying,
    bio text,
    email character varying,
    phone character varying,
    password_hash character varying,
    salt character varying,
    device_identifier character varying,
    token character varying,
    is_admin boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    profile_image character varying,
    verification_code character varying
);


ALTER TABLE users OWNER TO rossb;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: rossb
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO rossb;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rossb
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY alerts ALTER COLUMN id SET DEFAULT nextval('alerts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY galleries ALTER COLUMN id SET DEFAULT nextval('galleries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY sponsor_users ALTER COLUMN id SET DEFAULT nextval('sponsor_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY sponsors ALTER COLUMN id SET DEFAULT nextval('sponsors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY alerts (id, user_id, type, title, messge, data, created_at, updated_at, expires_at, sent_at, delivered_at) FROM stdin;
\.


--
-- Name: alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rossb
--

SELECT pg_catalog.setval('alerts_id_seq', 1, false);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY comments (id, user_id, photo_id, text, created_at, updated_at) FROM stdin;
13	81	83	Go Cuse!	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
14	82	83	You better rush the court at the end of the game	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
15	83	83	I will!	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
16	84	84	how did you score those seats?	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
17	83	84	I know a guy who knows a guy	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
18	84	84	if you wanna meet up after I’m 300 feet behind you.	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
19	83	85	That’s garbage, he should get thrown out	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
20	82	85	Looks like he broke Tejada’s leg	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
21	81	85	there goes our World Series hopes...	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
22	85	85	not too late.	2016-04-12 22:48:18.8289	2016-04-12 22:48:18.8289
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rossb
--

SELECT pg_catalog.setval('comments_id_seq', 22, true);


--
-- Data for Name: galleries; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY galleries (id, user_id, owner_type, description, name, created_at, updated_at, location, hero_image) FROM stdin;
15	81	\N	UCLA takes on Pac-12 rival Oregon at home in Pauley Pavilion.	UCLA v. Oregon Basketball Game	2016-04-12 22:48:02.042864	2016-04-12 22:48:02.042864	\N	https://s3.amazonaws.com/perspective.development/gallery_ucla_oregon.jpg
16	84	\N	The New York Mets face their NL East Rivals in Philadelphia.	New York Mets vs. Philadelphia Phillies Baseball Game	2016-04-12 22:48:02.042864	2016-04-12 22:48:02.042864	\N	https://s3.amazonaws.com/perspective.development/gallery_mets_phillies.jpg
\.


--
-- Name: galleries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rossb
--

SELECT pg_catalog.setval('galleries_id_seq', 16, true);


--
-- Data for Name: invitations; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY invitations (id, inviter_id, invitee_id, gallery_id, file_url, description, created_at, updated_at) FROM stdin;
\.


--
-- Name: invitations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rossb
--

SELECT pg_catalog.setval('invitations_id_seq', 1, false);


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY photos (id, user_id, gallery_id, file_url, description, created_at, updated_at) FROM stdin;
83	83	15	https://s3.amazonaws.com/perspective.development/photo_1.jpg.	Blinding like the sun. All orange up here.	2016-04-12 22:48:07.771514	2016-04-12 22:48:07.771514
84	83	15	https://s3.amazonaws.com/perspective.development/photo_2.jpg	Posterizing dunk from Syracuse	2016-04-12 22:48:07.771514	2016-04-12 22:48:07.771514
85	84	16	https://s3.amazonaws.com/perspective.development/photo_3.jpg	Crazy slide from Chase Utley into second! That can’t be allowed.	2016-04-12 22:48:07.771514	2016-04-12 22:48:07.771514
\.


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rossb
--

SELECT pg_catalog.setval('photos_id_seq', 85, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY schema_migrations (version) FROM stdin;
1
2
3
4
5
6
7
8
9
10
11
12
\.


--
-- Data for Name: sponsor_users; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY sponsor_users (id, sponsor_id, user_id, access_level, created_at, updated_at) FROM stdin;
\.


--
-- Name: sponsor_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rossb
--

SELECT pg_catalog.setval('sponsor_users_id_seq', 1, false);


--
-- Data for Name: sponsors; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY sponsors (id, name, bio, created_at, updated_at) FROM stdin;
\.


--
-- Name: sponsors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rossb
--

SELECT pg_catalog.setval('sponsors_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: rossb
--

COPY users (id, first_name, last_name, bio, email, phone, password_hash, salt, device_identifier, token, is_admin, created_at, updated_at, profile_image, verification_code) FROM stdin;
81	Mike	Voge	\N	\N	\N	\N	\N	\N	\N	\N	2016-04-12 22:46:27.8931	2016-04-12 22:46:27.8931	https://s3.amazonaws.com/perspective.development/user_mike_voge.jpg	\N
82	Gerhardt	Voge	\N	\N	\N	\N	\N	\N	\N	\N	2016-04-12 22:46:27.8931	2016-04-12 22:46:27.8931	https://s3.amazonaws.com/perspective.development/user_gerhardt_voge.jpg	\N
83	Chris	Roper	\N	\N	\N	\N	\N	\N	\N	\N	2016-04-12 22:46:27.8931	2016-04-12 22:46:27.8931	https://s3.amazonaws.com/perspective.development/user_chris_roper.jpg	\N
84	James	Moeller	\N	\N	\N	\N	\N	\N	\N	\N	2016-04-12 22:46:27.8931	2016-04-12 22:46:27.8931	https://s3.amazonaws.com/perspective.development/user_james_moeller.jpg	\N
85	Paul	Voge	\N	\N	\N	\N	\N	\N	\N	\N	2016-04-12 22:46:27.8931	2016-04-12 22:46:27.8931	https://s3.amazonaws.com/perspective.development/user_paul_voge.jpg	\N
86	USciences	Athletics	\N	\N	\N	\N	\N	\N	\N	\N	2016-04-12 22:46:27.8931	2016-04-12 22:46:27.8931	https://s3.amazonaws.com/perspective.development/user_usciences_athletics.jpg	\N
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: rossb
--

SELECT pg_catalog.setval('users_id_seq', 86, true);


--
-- Name: alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: rossb; Tablespace: 
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: rossb; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: galleries_pkey; Type: CONSTRAINT; Schema: public; Owner: rossb; Tablespace: 
--

ALTER TABLE ONLY galleries
    ADD CONSTRAINT galleries_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: rossb; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: rossb; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: sponsor_users_pkey; Type: CONSTRAINT; Schema: public; Owner: rossb; Tablespace: 
--

ALTER TABLE ONLY sponsor_users
    ADD CONSTRAINT sponsor_users_pkey PRIMARY KEY (id);


--
-- Name: sponsors_pkey; Type: CONSTRAINT; Schema: public; Owner: rossb; Tablespace: 
--

ALTER TABLE ONLY sponsors
    ADD CONSTRAINT sponsors_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: rossb; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: rossb; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_00204dc74b; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT fk_rails_00204dc74b FOREIGN KEY (invitee_id) REFERENCES users(id);


--
-- Name: fk_rails_0021cae2bd; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY sponsor_users
    ADD CONSTRAINT fk_rails_0021cae2bd FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_03de2dc08c; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_rails_03de2dc08c FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_05f824a025; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY galleries
    ADD CONSTRAINT fk_rails_05f824a025 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_2e5d9f85e5; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT fk_rails_2e5d9f85e5 FOREIGN KEY (gallery_id) REFERENCES galleries(id);


--
-- Name: fk_rails_7480156672; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT fk_rails_7480156672 FOREIGN KEY (inviter_id) REFERENCES users(id);


--
-- Name: fk_rails_77b369c32e; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY sponsor_users
    ADD CONSTRAINT fk_rails_77b369c32e FOREIGN KEY (sponsor_id) REFERENCES sponsors(id);


--
-- Name: fk_rails_8e6de2dbfc; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_rails_8e6de2dbfc FOREIGN KEY (photo_id) REFERENCES photos(id);


--
-- Name: fk_rails_9dac759bbc; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT fk_rails_9dac759bbc FOREIGN KEY (gallery_id) REFERENCES galleries(id);


--
-- Name: fk_rails_c79d76afc0; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT fk_rails_c79d76afc0 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_d4053234e7; Type: FK CONSTRAINT; Schema: public; Owner: rossb
--

ALTER TABLE ONLY alerts
    ADD CONSTRAINT fk_rails_d4053234e7 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: rossb
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM rossb;
GRANT ALL ON SCHEMA public TO rossb;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

