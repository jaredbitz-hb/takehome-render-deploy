--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: reservations; Type: TABLE; Schema: public; Owner: jared
--

CREATE TABLE public.reservations (
    reservation_id integer NOT NULL,
    "time" timestamp without time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.reservations OWNER TO jared;

--
-- Name: reservations_reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: jared
--

CREATE SEQUENCE public.reservations_reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.reservations_reservation_id_seq OWNER TO jared;

--
-- Name: reservations_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jared
--

ALTER SEQUENCE public.reservations_reservation_id_seq OWNED BY public.reservations.reservation_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: jared
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE public.users OWNER TO jared;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: jared
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO jared;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jared
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: reservations reservation_id; Type: DEFAULT; Schema: public; Owner: jared
--

ALTER TABLE ONLY public.reservations ALTER COLUMN reservation_id SET DEFAULT nextval('public.reservations_reservation_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: jared
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: jared
--

COPY public.reservations (reservation_id, "time", user_id) FROM stdin;
1	2023-10-24 10:30:00	1
2	2023-12-25 10:30:00	1
3	2023-12-25 11:00:00	2
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: jared
--

COPY public.users (user_id, email) FROM stdin;
1	Sincere@april.biz
2	Shanna@melissa.tv
3	Nathan@yesenia.net
4	Julianne.OConner@kory.org
5	Lucio_Hettinger@annie.ca
6	Karley_Dach@jasper.info
7	Telly.Hoeger@billy.biz
8	Sherwood@rosamond.me
9	Chaim_McDermott@dana.io
10	Rey.Padberg@karina.biz
\.


--
-- Name: reservations_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jared
--

SELECT pg_catalog.setval('public.reservations_reservation_id_seq', 3, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jared
--

SELECT pg_catalog.setval('public.users_user_id_seq', 10, true);


--
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: jared
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (reservation_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: jared
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: reservations reservations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: jared
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

