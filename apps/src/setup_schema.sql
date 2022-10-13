--
-- PostgreSQL database dump
--

-- Dumped from database version 11.10
-- Dumped by pg_dump version 11.11

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

create database eksackdemo ;
\c eksackdemo;

create user dbuser1 password 'eksackdemo' ;
CREATE SCHEMA dbschema;
grant create on database eksackdemo to dbuser1;
grant all privileges on schema dbschema to dbuser1;
grant all privileges on all tables in schema dbschema to dbuser1;
grant connect on database eksackdemo to dbuser1;
ALTER SCHEMA dbschema OWNER TO dbuser1;

--
-- Name: add_user(text, text, text, text); Type: PROCEDURE; Schema: dbschema; Owner: dbuser1
--

CREATE PROCEDURE dbschema.add_user(fname text, lname text, email text, password text)
    LANGUAGE plpgsql
    AS $$
begin
	    insert into Users(fname, lname, email, password)
	    values(fname, lname, email, password);
	    commit;
end;$$;


ALTER PROCEDURE dbschema.add_user(fname text, lname text, email text, password text) OWNER TO dbuser1;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: apparels; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.apparels (
	    id integer NOT NULL,
	    name text,
	    description text,
	    img_url text,
	    category text,
	    inventory integer,
	    price double precision
);


ALTER TABLE dbschema.apparels OWNER TO dbuser1;

--
-- Name: bicycles; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.bicycles (
	    id integer NOT NULL,
	    name text,
	    description text,
	    img_url text,
	    category text,
	    inventory integer,
	    price double precision
);


ALTER TABLE dbschema.bicycles OWNER TO dbuser1;

--
-- Name: fashion; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.fashion (
	    id integer NOT NULL,
	    name text,
	    description text,
	    img_url text,
	    category text,
	    inventory integer,
	    price double precision
);


ALTER TABLE dbschema.fashion OWNER TO dbuser1;

--
-- Name: jewelry; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.jewelry (
	    id integer NOT NULL,
	    name text,
	    description text,
	    img_url text,
	    category text,
	    inventory integer,
	    price double precision
);


ALTER TABLE dbschema.jewelry OWNER TO dbuser1;

--
-- Name: kart; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.kart (
	    userid integer NOT NULL,
	    productid integer NOT NULL,
	    qty integer
);


ALTER TABLE dbschema.kart OWNER TO dbuser1;

--
-- Name: order_details; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.order_details (
	    order_id integer NOT NULL,
	    item_id integer NOT NULL,
	    qty integer,
	    unit_price numeric
);


ALTER TABLE dbschema.order_details OWNER TO dbuser1;

--
-- Name: orders; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.orders (
	    order_id integer NOT NULL,
	    email text,
	    order_date date,
	    order_total numeric
);


ALTER TABLE dbschema.orders OWNER TO dbuser1;

--
-- Name: reviews; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.reviews (
	    item_id integer NOT NULL,
	    category text NOT NULL,
	    username text NOT NULL,
	    review text,
	    rating integer
);


ALTER TABLE dbschema.reviews OWNER TO dbuser1;

--
-- Name: users; Type: TABLE; Schema: dbschema; Owner: dbuser1
--

CREATE TABLE dbschema.users (
	    id integer NOT NULL,
	    fname text,
	    lname text,
	    email text,
	    password text
);

CREATE TABLE dbschema.SessionStore(
	    key varchar(100) NOT NULL,
	    value jsonb,
	    constraint sessionstore_pk primary key(key)
);

ALTER TABLE dbschema.users OWNER TO dbuser1;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: dbschema; Owner: dbuser1
--

CREATE SEQUENCE dbschema.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE dbschema.users_id_seq OWNER TO dbuser1;

CREATE SEQUENCE dbschema.order_seq
    AS integer
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE dbschema.order_seq OWNER TO dbuser1;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: dbschema; Owner: dbuser1
--

ALTER SEQUENCE dbschema.users_id_seq OWNED BY dbschema.users.id;


--
-- Name: users id; Type: DEFAULT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.users ALTER COLUMN id SET DEFAULT nextval('dbschema.users_id_seq'::regclass);



--
-- Data for Name: order_details; Type: TABLE DATA; Schema: dbschema; Owner: dbuser1
--

COPY dbschema.order_details (order_id, item_id, qty, unit_price) FROM stdin;
1	7000081	1	67.95
1	5000010	1	38.95
1	5000009	1	37.95
1	9000001	1	91.95
2	2	1	199.95
3	2	1	199.95
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: dbschema; Owner: dbuser1
--

COPY dbschema.orders (order_id, email, order_date, order_total) FROM stdin;
1	test@test.com	2021-06-08	200
2	test@test.com	2021-06-08	300
3	test@test.com	2021-06-08	200
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: dbschema; Owner: dbuser1
--

COPY dbschema.reviews (item_id, category, username, review, rating) FROM stdin;
2	fashion	test7	awesome product 7	4
2	fashion	test8	awesome product 8	3
2	fashion	test9	awesome product 9	4
2	fashion	test10	awesome product 10	4
2	fashion	test11	awesome product 11	4
2	fashion	test12	awesome product 12	3
2	fashion	test13	awesome product 13	5
2	fashion	test14	awesome product 14	5
2	fashion	test15	awesome product 15	5
2	fashion	test16	awesome product 16	4
2	fashion	test17	awesome product 17	5
2	fashion	test18	awesome product 18	3
2	fashion	test19	awesome product 19	5
2	fashion	test20	awesome product 20	4
2	fashion	test21	awesome product 21	3
3	fashion	test1	awesome product 1	4
3	fashion	test2	awesome product 2	2
3	fashion	test3	awesome product 3	3
3	fashion	test4	awesome product 4	5
3	fashion	test5	awesome product 5	2
3	fashion	test6	awesome product 6	5
3	fashion	test7	awesome product 7	3
3	fashion	test8	awesome product 8	2
3	fashion	test9	awesome product 9	5
3	fashion	test10	awesome product 10	3
3	fashion	test11	awesome product 11	4
3	fashion	test12	awesome product 12	2
3	fashion	test13	awesome product 13	5
3	fashion	test14	awesome product 14	5
3	fashion	test15	awesome product 15	4
3	fashion	test16	awesome product 16	2
3	fashion	test17	awesome product 17	3
3	fashion	test18	awesome product 18	4
3	fashion	test19	awesome product 19	4
3	fashion	test20	awesome product 20	5
3	fashion	test21	awesome product 21	2
3	fashion	test22	awesome product 22	5
3	fashion	test23	awesome product 23	5
3	fashion	test24	awesome product 24	5
3	fashion	test25	awesome product 25	4
3	fashion	test26	awesome product 26	3
3	fashion	test27	awesome product 27	4
3	fashion	test28	awesome product 28	5
3	fashion	test29	awesome product 29	2
3	fashion	test30	awesome product 30	5
3	fashion	test31	awesome product 31	2
3	fashion	test32	awesome product 32	5
3	fashion	test33	awesome product 33	2
3	fashion	test34	awesome product 34	4
3	fashion	test35	awesome product 35	5
3	fashion	test36	awesome product 36	3
3	fashion	test37	awesome product 37	3
3	fashion	test38	awesome product 38	2
3	fashion	test39	awesome product 39	3
6	fashion	test1	awesome product 1	2
6	fashion	test2	awesome product 2	3
6	fashion	test3	awesome product 3	2
6	fashion	test4	awesome product 4	2
6	fashion	test5	awesome product 5	3
6	fashion	test6	awesome product 6	2
6	fashion	test7	awesome product 7	4
6	fashion	test8	awesome product 8	3
6	fashion	test9	awesome product 9	3
6	fashion	test10	awesome product 10	3
6	fashion	test11	awesome product 11	2
6	fashion	test12	awesome product 12	3
6	fashion	test13	awesome product 13	3
6	fashion	test14	awesome product 14	2
6	fashion	test15	awesome product 15	2
6	fashion	test16	awesome product 16	2
6	fashion	test17	awesome product 17	5
6	fashion	test18	awesome product 18	4
6	fashion	test19	awesome product 19	5
6	fashion	test20	awesome product 20	4
6	fashion	test21	awesome product 21	5
6	fashion	test22	awesome product 22	4
6	fashion	test23	awesome product 23	5
6	fashion	test24	awesome product 24	4
6	fashion	test25	awesome product 25	5
6	fashion	test26	awesome product 26	3
6	fashion	test27	awesome product 27	3
6	fashion	test28	awesome product 28	2
6	fashion	test29	awesome product 29	4
6	fashion	test30	awesome product 30	3
6	fashion	test31	awesome product 31	4
6	fashion	test32	awesome product 32	5
6	fashion	test33	awesome product 33	5
6	fashion	test34	awesome product 34	4
6	fashion	test35	awesome product 35	2
6	fashion	test36	awesome product 36	3
6	fashion	test37	awesome product 37	4
6	fashion	test38	awesome product 38	5
6	fashion	test39	awesome product 39	5
6	fashion	test40	awesome product 40	2
6	fashion	test41	awesome product 41	2
6	fashion	test42	awesome product 42	5
6	fashion	test43	awesome product 43	4
6	fashion	test44	awesome product 44	4
6	fashion	test45	awesome product 45	2
6	fashion	test46	awesome product 46	5
6	fashion	test47	awesome product 47	5
40	fashion	test48	awesome product 48	5
40	fashion	test1	awesome product 1	3
40	fashion	test2	awesome product 2	4
40	fashion	test3	awesome product 3	4
40	fashion	test4	awesome product 4	3
40	fashion	test5	awesome product 5	3
40	fashion	test6	awesome product 6	3
41	fashion	test7	awesome product 7	5
41	fashion	test8	awesome product 8	2
41	fashion	test9	awesome product 9	4
41	fashion	test10	awesome product 10	3
5	fashion	test11	awesome product 11	2
5	fashion	test12	awesome product 12	3
5	fashion	test13	awesome product 13	5
5	fashion	test14	awesome product 14	5
5	fashion	test15	awesome product 15	3
5	fashion	test16	awesome product 16	4
5	fashion	test17	awesome product 17	3
5	fashion	test18	awesome product 18	3
5	fashion	test19	awesome product 19	2
5	fashion	test20	awesome product 20	2
5	fashion	test21	awesome product 21	2
5	fashion	test22	awesome product 22	5
5	fashion	test23	awesome product 23	2
5	fashion	test24	awesome product 24	3
5	fashion	test25	awesome product 25	5
5	fashion	test26	awesome product 26	5
5	fashion	test27	awesome product 27	2
5	fashion	test28	awesome product 28	5
5	fashion	test29	awesome product 29	4
5	fashion	test30	awesome product 30	5
5	fashion	test31	awesome product 31	4
5	fashion	test32	awesome product 32	2
5	fashion	test33	awesome product 33	4
5	fashion	test34	awesome product 34	2
5	fashion	test35	awesome product 35	3
5	fashion	test36	awesome product 36	5
5	fashion	test37	awesome product 37	3
5	fashion	test38	awesome product 38	3
5	fashion	test39	awesome product 39	5
5	fashion	test40	awesome product 40	2
5	fashion	test41	awesome product 41	4
5	fashion	test42	awesome product 42	2
5	fashion	test43	awesome product 43	4
5	fashion	test44	awesome product 44	3
5	fashion	test45	awesome product 45	2
5	fashion	test46	awesome product 46	5
5	fashion	test47	awesome product 47	2
5	fashion	test48	awesome product 48	3
5	fashion	test49	awesome product 49	2
5	fashion	test50	awesome product 50	2
5	fashion	test51	awesome product 51	4
5	fashion	test52	awesome product 52	3
5	fashion	test53	awesome product 53	2
5	fashion	test54	awesome product 54	5
5	fashion	test55	awesome product 55	5
5	fashion	test56	awesome product 56	5
5	fashion	test57	awesome product 57	4
5	fashion	test58	awesome product 58	5
6	fashion	test59	awesome product 59	4
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: dbschema; Owner: dbuser1
--

COPY dbschema.users (id, fname, lname, email, password) FROM stdin;
1	krishna	sarabu	test@test.com	welcome
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: dbschema; Owner: dbuser1
--

SELECT pg_catalog.setval('dbschema.users_id_seq', 6, true);


--
-- Name: apparels apparels_pkey; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.apparels
    ADD CONSTRAINT apparels_pkey PRIMARY KEY (id);


--
-- Name: bicycles bicycles_pkey; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.bicycles
    ADD CONSTRAINT bicycles_pkey PRIMARY KEY (id);


--
-- Name: fashion fashion_pkey; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.fashion
    ADD CONSTRAINT fashion_pkey PRIMARY KEY (id);


--
-- Name: jewelry jewelry_pkey; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.jewelry
    ADD CONSTRAINT jewelry_pkey PRIMARY KEY (id);


--
-- Name: kart kart_pk; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.kart
    ADD CONSTRAINT kart_pk PRIMARY KEY (userid, productid);


--
-- Name: order_details order_details_pk; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.order_details
    ADD CONSTRAINT order_details_pk PRIMARY KEY (order_id, item_id);


--
-- Name: orders orders_pk; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.orders
    ADD CONSTRAINT orders_pk PRIMARY KEY (order_id);


--
-- Name: reviews reviews_pk; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.reviews
    ADD CONSTRAINT reviews_pk PRIMARY KEY (item_id, category, username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: dbschema; Owner: dbuser1
--

ALTER TABLE ONLY dbschema.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


alter user dbuser1 set search_path="dbschema", "public";
--
-- PostgreSQL database dump complete
--

grant all privileges on all tables in schema dbschema to dbuser1;


COPY dbschema.apparels (id, name, description, img_url, category, inventory, price) FROM stdin;
5000010	Guaranteed	<p><p><em>This is a demonstration store. You can purchase products like this from <a href=http://unitedbyblue.com/ target=_blank>United By Blue</a>.</em></p>\n<ul>\n<li><span style=line-height: 1.4;>100% organic cotton, stone washed slub knit 6 oz jersey fabric</span></li>\n<li><span style=line-height: 1.4;>Made in California</span></li>\n</ul>\n<span style=line-height: 1.4;></span>\n<ul class=tabs-content></ul></p>	https://cdn.shopify.com/s/files/1/0803/6591/products/guaranteed_navy.jpeg?v=1426786281	Shirts	78	42.9500000000000028
5000000	The Scout Skincare Kit	<p><p><em>This is a demonstration store. You can purchase products like this from <a href=http://unitedbyblue.com/ target=_blank>United By Blue</a>.</em></p><meta charset=utf-8>\n<p><span>A collection of the best Ursa Major has to offer! The Scout kit contains travel sizes of their best selling skin care items including: </span></p>\n<ul>\n<li><span style=line-height: 1.4;>Face Wash (2 fl oz)</span></li>\n<li><span style=line-height: 1.4;>Shave Cream (2 fl oz)</span></li>\n<li><span style=line-height: 1.4;>Face Balm (0.5 fl oz)</span></li>\n<li><span style=line-height: 1.4;>5 tonic-infused bamboo Face Wipes</span></li>\n</ul>\n<p><span>All wrapped together in a great, reusable tin.</span><span class=aam> </span></p></p>	https://cdn.shopify.com/s/files/1/0803/6591/products/skin-care_c18143d5-6378-46aa-b0d7-526aee3bc776.jpg?v=1426708827		0	13.9499999999999993
5000001	Ayres Chambray	<p><p><em>This is a demonstration store. You can purchase products like this from <a href=http://unitedbyblue.com/ target=_blank>United By Blue</a>.</em></p>\n<p>Comfortable and practical, our chambray button down is perfect for travel or days spent on the go. The Ayres Chambray has a rich, washed out indigo color suitable to throw on for any event. Made with sustainable soft chambray featuring two chest pockets with sturdy and scratch resistant corozo buttons.</p>\n<ul class=tabs-content>\n<li><span style=line-height: 1.4;>100% Organic Cotton Chambray, 4.9 oz Fabric.</span></li>\n<li><span style=line-height: 1.4;>Natural Corozo Buttons.</span></li>\n</ul></p>	https://cdn.shopify.com/s/files/1/0803/6591/products/chambray_5f232530-4331-492a-872c-81c225d6bafd.jpg?v=1426630717	Shirts	64	198.949999999999989
5000002	Lodge	<p><p><em>This is a demonstration store. You can purchase products like this from <a href=http://unitedbyblue.com/ target=_blank>United By Blue</a>.</em></p>\n<p>The lodge, after a day of white slopes, is a place of revelry, blazing fires and high spirits.</p>\n<ul>\n<li><span style=line-height: 1.4;>100% organic cotton, stone washed slub knit 6 oz jersey fabric</span></li>\n</ul></p>	https://cdn.shopify.com/s/files/1/0803/6591/products/lodge_women_white2_df6cafb7-1756-4991-8f1c-e074ecf4a5f2.jpeg?v=1426786254	Shirts	41	68.9500000000000028
5000012	5 Panel Camp Cap	<p><p><em>This is a demonstration store. You can purchase products like this from <a href=http://unitedbyblue.com/ target=_blank>United By Blue</a>.</em></p>\n<p><span style=line-height: 1.4;>A classic 5 panel hat with our United By Blue logo on the front and an adjustable strap to keep fit and secure. Made with recycled polyester and organic cotton mix.</span></p>\n<ul>\n<li><span style=line-height: 1.5;>Made in New Jersey</span></li>\n<li><span style=line-height: 1.5;>7oz Eco-Twill fabric: 35% organic cotton, 65% recycled PET (plastic water and soda bottles) </span></li>\n<li><span style=line-height: 1.5;>Embossed leather patch</span></li>\n</ul>\n<ul class=tabs></ul>\n<p> </p>\n<ul class=tabs-content></ul></p>	https://cdn.shopify.com/s/files/1/0803/6591/products/5-panel-hat_4ee20a27-8d5a-490e-a2fc-1f9c3beb7bf5.jpg?v=1426709889	Accessories	48	111.950000000000003
\.


--
-- Data for Name: bicycles; Type: TABLE DATA; Schema: dbschema; Owner: dbuser1
--

COPY dbschema.bicycles (id, name, description, img_url, category, inventory, price) FROM stdin;
7000081	Micro Juliet	<p><p><em>This is a demonstration store. You can purchase products like this from <a href=https://www.purefixcycles.com target=_blank>Pure Fix Cycles</a></em></p><p class=lead>Our Juliet is more midnight than morning sun.  Built to break hearts, this black-on-black bike can handle anything.</p></p>	https://cdn.shopify.com/s/files/1/0923/8062/products/JULIET_2014_SEAMLESS_SIDE_WEB.jpeg?v=1442434400	Black, Kids Fixie, Micro, Micro Series	7	162.949999999999989
7000183	Alfa	<p><p><em>This is a demonstration store. You can purchase products like this from <a href=https://www.purefixcycles.com target=_blank>Pure Fix Cycles</a></em></p><p>Sunshine, blue skies, a gentle breeze – you can spend all year waiting for perfect bike weather or you can grab an Alfa and make your own. Whatever the forecast, Alfa makes every day a beautiful day for a ride.</p></p>	https://cdn.shopify.com/s/files/1/0923/8062/products/ALFA_SIDE_WEB.jpeg?v=1442512858	Bicycle, Bicycles, Bike, Blue, Fixed Gear, Fixie, Pure Fix Cycles, White, WTB	32	199.949999999999989
7000180	Crane Bell	<p><p></p></p>	https://cdn.shopify.com/s/files/1/0923/8062/products/crane-copper-bell-WEB.jpeg?v=1438625053	Accessories, Bells, Goods	94	76.9500000000000028
7000181	Interlock Integrated Bike Lock	<p><p><em>This is a demonstration store. You can purchase products like this from <a href=https://www.purefixcycles.com target=_blank>Pure Fix Cycles</a></em></p><p>Annoyed by carrying your bike lock? The rattling, clanging, or ugly mounting hardware? The InterLock is a lock that hides inside of your bike! All you need to do is replace the seatpost with this one - that comes with a permanently attached bike lock!</p>\n<ul>\n<li>25.4mm seatpost</li>\n<li>﻿Cables are 90cm total length, or 35.4 inches if you’re imperially inclined.</li>\n<li>Product weight: 620 Grams including lock and seatpost.</li>\n<li>Seatpost is 3D Forged, 6061 Aluminium.</li>\n</ul></p>	https://cdn.shopify.com/s/files/1/0923/8062/products/Interlock_Black_3RD_WEB.jpeg?v=1438625046	Accessories, Locks, Saddles and Seatposts, Seatposts and Clamps	74	17.9499999999999993
\.


--
-- Data for Name: fashion; Type: TABLE DATA; Schema: dbschema; Owner: dbuser1
--

COPY dbschema.fashion (id, name, description, img_url, category, inventory, price) FROM stdin;
2	Bracelet 41 in Silver	<p><meta charset=utf-8>\n<p><span>Rustic links adorn a unisex bracelet. 1-100 jewelry gives an organic feel while maintaining an understated elegance. Varying chain-links. Hook-and-eye closure. Color Silver. 100% Sterling Silver. Made in U.S.A. </span><span><em>From Hook to Eye </em><em>Length </em></span><em>7 &amp; 1/2, Size Large. </em><em><em>Hook to Eye </em></em><em>Length 6, Size Small. </em></p>\n<p><a href=http://babyandco.us/collections/1-100><em>Shop our collection of 1-100. </em></a></p></p>	https://cdn.shopify.com/s/files/1/0923/8036/products/product_bracelet_1-100_bracelet41_01.jpeg?v=1437081366	1-100, Accessories, arrivals, AW15, Bracelets, gift guide, jewelry, Man, mothermoon, signature, silver, spring2, visible, Woman	74	42.9500000000000028
3	Bracelet 3 in Silver	<p><meta charset=utf-8>\n<p><span>Rustic and lovely, 1-100 jewelry gives an organic feel while maintaining an understated elegance. Pummeled then polished, the 3 bracelet is a masterful addition. Color Silver. 100% Sterling Silver. Made in U.S.A. </span><em>Length 7, 1 &amp; 1/2 Wide. </em></p></p>	https://cdn.shopify.com/s/files/1/0923/8036/products/product_bracelet_1-100_bracelet3_01.jpeg?v=1441401623	1-100, Accessories, Bracelets, cooloff, gift guide, jewelry, last, Man, S14, silver, visible, Woman	99	90.9500000000000028
5	Bracelet 84 in Silver	<p><meta charset=utf-8>\n<p><span>Curved and lovely, 1-100 jewelry gives an organic touch to understated elegance. This cuff is intentionally designed to be lacking mechanical precision assures individuality to the wearer. Color Silver. 100% Sterling Silver. Made in U.S.A. <em>Length </em></span><span><em><em>6 &amp; 1/2, </em></em></span><em>2 &amp; 1/2 Wide. </em></p></p>	https://cdn.shopify.com/s/files/1/0923/8036/products/2015-04-20_Accessories_20_12072_21332.jpeg?v=1437081343	1-100, Accessories, Bracelets, cooloff, Cuff, gift guide, last, putty, S14, Silver, visible, Woman	51	154.949999999999989
6	Ring 56 in Silver	<p><meta charset=utf-8>\n<p><span>Rustic yet lovely, 1-100 jewelry gives an organic feel while maintaining an understated elegance. Beautifully layered ring is smooth to touch, yet varying in texture. Color Silver. 100% Sterling Silver. Made in U.S.A. <em>Size Small 6, Size Large 11. </em></span></p></p>	https://cdn.shopify.com/s/files/1/0923/8036/products/2015-04-20_Accessories_23_12075_21344.jpeg?v=1437081338	1-100, Accessories, Man, Rings, S14, visible, Woman	2	199.949999999999989
41	Azur Bracelet in Blue Azurite	<p><meta charset=utf-8>\n<p> Elasticated, beaded bracelet by 5 Octobre. Gold details.</p></p>	https://cdn.shopify.com/s/files/1/0923/8036/products/2015-05-08_Laydown_Look2_14120_21584.jpeg?v=1437080798	Accessories, bounty, Bracelets, copy, jewelry, S14, SALE, shot 5/8, Woman	65	173.949999999999989
40	Bi-Goutte Earrings	<p><meta charset=utf-8>\n<p>Quintessential elegance with delicate details. With the ease of the fish hook earring, the Bi-Goutte offers a handsome everyday piece. 5 Octobre. Color Green. Made in France. </p>\n<p><a href=http://babyandco.us/collections/5-octobre><em>Shop our collection of 5 Octobre. </em></a></p></p>	https://cdn.shopify.com/s/files/1/0923/8036/products/2015-05-01_Accessories_05_14103_21517.jpeg?v=1437080810	accessories, arrivals, AW15, bounty, earrings, jewelry, mothermoon, signature, sping6, spring6, woman	17	11.9499999999999993
\.


--
-- Data for Name: jewelry; Type: TABLE DATA; Schema: dbschema; Owner: dbuser1
--

COPY dbschema.jewelry (id, name, description, img_url, category, inventory, price) FROM stdin;
9000000	14k Wire Bloom Earrings	<p><div class=product-description rte itemprop=description>Sed in metus nec dui consequat vestibulum. In varius pretium nunc, sed bibendum mauris lacinia non. Praesent vel neque ut ligula porttitor vestibulum ac eu erat. Pellentesque quis turpis odio. Etiam auctor laoreet ligula, vel aliquam urna ornare sed. Praesent laoreet diam vitae lectus molestie pulvinar.</div>\n<div class=product-description rte itemprop=description>\n<ul>\n<li><span>Nullam blandit</span></li>\n<li><span>Vestibulum euismod</span></li>\n<li><span>Nullam venenatis </span></li>\n<li><span>Aenean a magna eros</span></li>\n</ul>\n</div></p>	https://cdn.shopify.com/s/files/1/0597/2185/products/18k-rose-gold-wire-bloom-earrings_afcace12-edfb-4c82-aba0-11462409947f.jpg?v=1406749652	Rose Gold	0	157.949999999999989
9000001	14k Solid Bloom Earrings	<p><div class=product-description rte itemprop=description>Sed in metus nec dui consequat vestibulum. In varius pretium nunc, sed bibendum mauris lacinia non. Praesent vel neque ut ligula porttitor vestibulum ac eu erat. Pellentesque quis turpis odio. Etiam auctor laoreet ligula, vel aliquam urna ornare sed. Praesent laoreet diam vitae lectus molestie pulvinar.</div>\n<div class=product-description rte itemprop=description>\n<ul>\n<li><span>Nullam blandit</span></li>\n<li><span>Vestibulum euismod</span></li>\n<li><span>Nullam venenatis </span></li>\n<li><span>Aenean a magna eros</span></li>\n</ul>\n</div></p>	https://cdn.shopify.com/s/files/1/0597/2185/products/18k-rose-gold-solid-bloom-earrings_35415c7b-3053-4247-a017-f60f03ade244.jpg?v=1406749643	Rose Gold	38	197.949999999999989
9000002	14k Intertwined Earrings	<p><div class=product-description rte itemprop=description>Sed in metus nec dui consequat vestibulum. In varius pretium nunc, sed bibendum mauris lacinia non. Praesent vel neque ut ligula porttitor vestibulum ac eu erat. Pellentesque quis turpis odio. Etiam auctor laoreet ligula, vel aliquam urna ornare sed. Praesent laoreet diam vitae lectus molestie pulvinar.</div>\n<div class=product-description rte itemprop=description>\n<ul>\n<li><span>Nullam blandit</span></li>\n<li><span>Vestibulum euismod</span></li>\n<li><span>Nullam venenatis </span></li>\n<li><span>Aenean a magna eros</span></li>\n</ul>\n</div></p>	https://cdn.shopify.com/s/files/1/0597/2185/products/18k-rose-gold-intertwined-earrings_2bcb98e2-ac48-44c8-bf3a-1fddc37e936a.jpg?v=1406749634	Rose Gold	52	106.950000000000003
9000003	14k Interlinked Earrings	<p><div class=product-description rte itemprop=description>Sed in metus nec dui consequat vestibulum. In varius pretium nunc, sed bibendum mauris lacinia non. Praesent vel neque ut ligula porttitor vestibulum ac eu erat. Pellentesque quis turpis odio. Etiam auctor laoreet ligula, vel aliquam urna ornare sed. Praesent laoreet diam vitae lectus molestie pulvinar.</div>\n<div class=product-description rte itemprop=description>\n<ul>\n<li><span>Nullam blandit</span></li>\n<li><span>Vestibulum euismod</span></li>\n<li><span>Nullam venenatis </span></li>\n<li><span>Aenean a magna eros</span></li>\n</ul>\n</div></p>	https://cdn.shopify.com/s/files/1/0597/2185/products/18k-white-interlinked-earrings_f954bffe-d751-48bd-903f-18b5c74e16cd.jpg?v=1406749625	White Gold	30	81.9500000000000028
9000004	14k Dangling Pendant Earrings	<p><div class=product-description rte itemprop=description>Sed in metus nec dui consequat vestibulum. In varius pretium nunc, sed bibendum mauris lacinia non. Praesent vel neque ut ligula porttitor vestibulum ac eu erat. Pellentesque quis turpis odio. Etiam auctor laoreet ligula, vel aliquam urna ornare sed. Praesent laoreet diam vitae lectus molestie pulvinar.</div>\n<div class=product-description rte itemprop=description>\n<ul>\n<li><span>Nullam blandit</span></li>\n<li><span>Vestibulum euismod</span></li>\n<li><span>Nullam venenatis </span></li>\n<li><span>Aenean a magna eros</span></li>\n</ul>\n</div></p>	https://cdn.shopify.com/s/files/1/0597/2185/products/18k-white-gold-dangling-pendant-earrings_17e71027-81d8-4a49-a455-2e5c205963ee.jpg?v=1406749608	White Gold	56	57.9500000000000028
9000005	14k Dangling Pendant Earrings	<p><div class=product-description rte itemprop=description>Sed in metus nec dui consequat vestibulum. In varius pretium nunc, sed bibendum mauris lacinia non. Praesent vel neque ut ligula porttitor vestibulum ac eu erat. Pellentesque quis turpis odio. Etiam auctor laoreet ligula, vel aliquam urna ornare sed. Praesent laoreet diam vitae lectus molestie pulvinar.</div>\n<div class=product-description rte itemprop=description>\n<ul>\n<li><span style=line-height: 1.5;>Nullam blandit</span></li>\n<li><span style=line-height: 1.5;>Vestibulum euismod</span></li>\n<li><span style=line-height: 1.5;>Nullam venenatis </span></li>\n<li><span style=line-height: 1.5;>Aenean a magna eros</span></li>\n</ul>\n</div></p>	https://cdn.shopify.com/s/files/1/0597/2185/products/18k-rose-gold-infinite-link-earrings_d3d4fd54-7016-4f3c-b3be-66aeb5c24d5f.jpg?v=1406749599	Rose Gold	58	47.9500000000000028
\.


--
-- Data for Name: kart; Type: TABLE DATA; Schema: dbschema; Owner: dbuser1
--

COPY dbschema.kart (userid, productid, qty) FROM stdin;
4	6	\N
4	8	\N
\.


