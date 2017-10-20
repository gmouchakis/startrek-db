--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

ALTER TABLE IF EXISTS ONLY public.medium_volume DROP CONSTRAINT IF EXISTS medium_volume_media_set_fkey;
ALTER TABLE IF EXISTS ONLY public.medium_volume_episode DROP CONSTRAINT IF EXISTS medium_volume_episode_volume_fkey;
ALTER TABLE IF EXISTS ONLY public.medium_volume_episode DROP CONSTRAINT IF EXISTS medium_volume_episode_episode_fkey;
ALTER TABLE IF EXISTS ONLY public.media_set DROP CONSTRAINT IF EXISTS media_set_type_fkey;
ALTER TABLE IF EXISTS ONLY public.media_set DROP CONSTRAINT IF EXISTS media_set_series_fkey;
ALTER TABLE IF EXISTS ONLY public.episode DROP CONSTRAINT IF EXISTS episode_series_fkey;
DROP TRIGGER IF EXISTS insert_dis_episode_trig ON public.dis;
ALTER TABLE IF EXISTS ONLY public.medium_volume_episode DROP CONSTRAINT IF EXISTS unique_vol_ep;
ALTER TABLE IF EXISTS ONLY public.medium_type DROP CONSTRAINT IF EXISTS type_unique;
ALTER TABLE IF EXISTS ONLY public.series DROP CONSTRAINT IF EXISTS series_pkey;
ALTER TABLE IF EXISTS ONLY public.movie DROP CONSTRAINT IF EXISTS movies_pkey;
ALTER TABLE IF EXISTS ONLY public.medium_volume DROP CONSTRAINT IF EXISTS medium_volume_pkey;
ALTER TABLE IF EXISTS ONLY public.medium_volume_episode DROP CONSTRAINT IF EXISTS medium_volume_episode_pkey;
ALTER TABLE IF EXISTS ONLY public.medium_type DROP CONSTRAINT IF EXISTS medium_pkey;
ALTER TABLE IF EXISTS ONLY public.media_set DROP CONSTRAINT IF EXISTS media_set_pkey;
ALTER TABLE IF EXISTS ONLY public.episode DROP CONSTRAINT IF EXISTS episode_pkey;
DROP VIEW IF EXISTS public.voy;
DROP VIEW IF EXISTS public.tos_hddvd;
DROP VIEW IF EXISTS public.tos_dvdr;
DROP VIEW IF EXISTS public.tos_bluray;
DROP VIEW IF EXISTS public.tos;
DROP VIEW IF EXISTS public.tng_dvd;
DROP VIEW IF EXISTS public.tng_bluray;
DROP VIEW IF EXISTS public.tng;
DROP VIEW IF EXISTS public.tas;
DROP TABLE IF EXISTS public.series;
DROP TABLE IF EXISTS public.movie;
DROP TABLE IF EXISTS public.medium_volume_episode;
DROP TABLE IF EXISTS public.medium_volume;
DROP TABLE IF EXISTS public.medium_type;
DROP TABLE IF EXISTS public.media_set;
DROP VIEW IF EXISTS public.ent;
DROP VIEW IF EXISTS public.ds9;
DROP VIEW IF EXISTS public.dis;
DROP VIEW IF EXISTS public.cont;
DROP TABLE IF EXISTS public.episode;
DROP FUNCTION IF EXISTS public.valid_date(month smallint, day smallint);
DROP FUNCTION IF EXISTS public.insert_dis_episode();
DROP SCHEMA IF EXISTS public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET search_path = public, pg_catalog;

--
-- Name: insert_dis_episode(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION insert_dis_episode() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO episode
              (series, title, airdate, season, episode_number,
               production_code, stardate, date_year, date_month, date_day)
         VALUES
           ('475cc2a6-c8d5-4f65-abaa-58a01c5bfeae',
            new.title, new.airdate, new.season, new.episode_number,
            new.production_code, new.stardate,
            new.date_year, new.date_month, new.date_day);
  RETURN new;
END;
$$;


--
-- Name: valid_date(smallint, smallint); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION valid_date(month smallint, day smallint) RETURNS boolean
    LANGUAGE sql
    AS $$
SELECT ((month = 1 OR month = 3 OR month = 5 OR month = 7 OR month = 8 OR month = 10 OR month = 12)
         AND (day >= 1 AND day <= 31))
       OR
       ((month = 2) AND (day >= 1 AND day <= 29))
       OR
       ((month = 4 OR month = 6 OR month = 9 OR month = 11) AND (day >= 1 AND day <= 30));
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: episode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE episode (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    series uuid NOT NULL,
    title text NOT NULL,
    airdate date,
    remastered_airdate date,
    season smallint,
    episode_number smallint,
    production_code text,
    stardate numeric,
    date_year smallint,
    date_month smallint,
    date_day smallint,
    vignette boolean,
    CONSTRAINT valid_day CHECK (valid_date(date_month, date_day)),
    CONSTRAINT valid_month CHECK (((date_month >= 1) AND (date_month <= 12)))
);


--
-- Name: cont; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cont AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.episode_number,
    episode.stardate,
    episode.vignette
   FROM episode
  WHERE (episode.series = '51994c36-6748-4297-a179-efc44599cd21'::uuid)
  ORDER BY episode.airdate;


--
-- Name: dis; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW dis AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.season,
    episode.episode_number,
    episode.production_code,
    episode.stardate,
    (((((episode.date_year || '-'::text) || episode.date_month) || '-'::text) || episode.date_day))::date AS date,
    episode.date_year,
    episode.date_month,
    episode.date_day
   FROM episode
  WHERE (episode.series = '475cc2a6-c8d5-4f65-abaa-58a01c5bfeae'::uuid)
  ORDER BY episode.airdate;


--
-- Name: ds9; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW ds9 AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.season,
    episode.episode_number,
    episode.production_code,
    episode.stardate
   FROM episode
  WHERE (episode.series = '711a7a2e-2fad-4a85-b07e-14077db05150'::uuid)
  ORDER BY episode.airdate;


--
-- Name: ent; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW ent AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.season,
    episode.episode_number,
    episode.production_code,
    episode.stardate,
    (((((episode.date_year || '-'::text) || episode.date_month) || '-'::text) || episode.date_day))::date AS date
   FROM episode
  WHERE (episode.series = 'e3656426-3669-442f-95ba-5daa5838270f'::uuid)
  ORDER BY episode.airdate;


--
-- Name: media_set; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media_set (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    series uuid NOT NULL,
    type uuid NOT NULL,
    season smallint
);


--
-- Name: medium_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE medium_type (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text NOT NULL
);


--
-- Name: medium_volume; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE medium_volume (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    media_set uuid NOT NULL,
    sequence smallint NOT NULL
);


--
-- Name: medium_volume_episode; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE medium_volume_episode (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    volume uuid NOT NULL,
    episode uuid NOT NULL
);


--
-- Name: movie; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE movie (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    release_date date NOT NULL,
    stardate numeric
);


--
-- Name: series; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE series (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    aired daterange
);


--
-- Name: tas; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tas AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.season,
    episode.episode_number,
    episode.production_code,
    episode.stardate
   FROM episode
  WHERE (episode.series = 'e3ca03f7-c94d-4847-8cb1-9f19ba99bd43'::uuid)
  ORDER BY episode.airdate;


--
-- Name: tng; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tng AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.season,
    episode.episode_number,
    episode.production_code,
    episode.stardate
   FROM episode
  WHERE (episode.series = '07858cb3-060a-421a-9c44-6028fb13b9de'::uuid)
  ORDER BY episode.airdate;


--
-- Name: tng_bluray; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tng_bluray AS
 SELECT ep.id,
    ep.title,
    ms.season,
    mv.sequence AS disc
   FROM episode ep,
    media_set ms,
    medium_type mt,
    medium_volume mv,
    medium_volume_episode mve,
    series s
  WHERE ((ep.id = mve.episode) AND (ms.id = mv.media_set) AND (ms.type = mt.id) AND (mve.volume = mv.id) AND (s.id = ep.series) AND (s.title = 'Star Trek: The Next Generation'::text) AND (mt.type = 'Blu-ray'::text))
  ORDER BY ep.airdate;


--
-- Name: VIEW tng_bluray; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW tng_bluray IS 'The TNG Blu-ray set released from 2012 to 2015, containing remastered versions of all episodes in 1080p and 7.1 surround sound.';


--
-- Name: tng_dvd; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tng_dvd AS
 SELECT ep.id,
    ep.title,
    ms.season,
    mv.sequence AS disc
   FROM episode ep,
    media_set ms,
    medium_type mt,
    medium_volume mv,
    medium_volume_episode mve,
    series s
  WHERE ((ep.id = mve.episode) AND (ms.id = mv.media_set) AND (ms.type = mt.id) AND (mve.volume = mv.id) AND (s.id = ep.series) AND (s.title = 'Star Trek: The Next Generation'::text) AND (mt.type = 'DVD'::text))
  ORDER BY ep.airdate;


--
-- Name: VIEW tng_dvd; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW tng_dvd IS 'The TNG DVD set first released in 2002, containing the episodes in their original broadcast visual quality, but the addition of 5.1 surround sound.';


--
-- Name: tos; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tos AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.remastered_airdate,
    episode.season,
    episode.episode_number,
    episode.production_code,
    episode.stardate
   FROM episode
  WHERE (episode.series = 'badb4eb9-d493-464f-94b8-21334d2157e1'::uuid)
  ORDER BY episode.airdate;


--
-- Name: tos_bluray; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tos_bluray AS
 SELECT ep.id,
    ep.title,
    ms.season,
    mv.sequence AS disc
   FROM episode ep,
    media_set ms,
    medium_type mt,
    medium_volume mv,
    medium_volume_episode mve,
    series s
  WHERE ((ep.id = mve.episode) AND (ms.id = mv.media_set) AND (ms.type = mt.id) AND (mve.volume = mv.id) AND (s.id = ep.series) AND (s.title = 'Star Trek: The Original Series'::text) AND (mt.type = 'Blu-ray'::text))
  ORDER BY ep.airdate, ep.production_code;


--
-- Name: VIEW tos_bluray; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW tos_bluray IS 'The TOS Blu-ray set released in 2009, containing the remastered versions of all the episodes in 1080p and 7.1 surround sound.';


--
-- Name: tos_dvdr; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tos_dvdr AS
 SELECT ep.id,
    ep.title,
    ms.season,
    mv.sequence AS disc
   FROM episode ep,
    media_set ms,
    medium_type mt,
    medium_volume mv,
    medium_volume_episode mve,
    series s
  WHERE ((ep.id = mve.episode) AND (ms.id = mv.media_set) AND (ms.type = mt.id) AND (mve.volume = mv.id) AND (s.id = ep.series) AND (s.title = 'Star Trek: The Original Series'::text) AND (mt.type = 'DVD-R'::text))
  ORDER BY ep.airdate;


--
-- Name: VIEW tos_dvdr; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW tos_dvdr IS 'The TOS DVD set released in 2008 and 2009, containing the remastered episodes in 480i and 5.1 surround sound, with only the enhanced effects.';


--
-- Name: tos_hddvd; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW tos_hddvd AS
 SELECT ep.id,
    ep.title,
    ms.season,
    mv.sequence AS disc
   FROM episode ep,
    media_set ms,
    medium_type mt,
    medium_volume mv,
    medium_volume_episode mve,
    series s
  WHERE ((ep.id = mve.episode) AND (ms.id = mv.media_set) AND (ms.type = mt.id) AND (mve.volume = mv.id) AND (s.id = ep.series) AND (s.title = 'Star Trek: The Original Series'::text) AND (mt.type = 'HD DVD'::text))
  ORDER BY ep.airdate;


--
-- Name: VIEW tos_hddvd; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW tos_hddvd IS 'TOS Season 1 released on HD DVD in 2007, shortly before the format''s cancellation and Blu-ray winning the HD format war.  Contains all Season 1 episodes in remastered 1080p and 5.1 surround sound, as well as DVD versions of the same episodes in 480i.  Unlike the Blu-ray release, these discs contain only the enhanced effects.';


--
-- Name: voy; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW voy AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.season,
    episode.episode_number,
    episode.production_code,
    episode.stardate
   FROM episode
  WHERE (episode.series = 'b71e1b59-1560-4d80-8f71-2d924a8edb9a'::uuid)
  ORDER BY episode.airdate;


--
-- Name: episode episode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY episode
    ADD CONSTRAINT episode_pkey PRIMARY KEY (id);


--
-- Name: media_set media_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_set
    ADD CONSTRAINT media_set_pkey PRIMARY KEY (id);


--
-- Name: medium_type medium_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_type
    ADD CONSTRAINT medium_pkey PRIMARY KEY (id);


--
-- Name: medium_volume_episode medium_volume_episode_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume_episode
    ADD CONSTRAINT medium_volume_episode_pkey PRIMARY KEY (id);


--
-- Name: medium_volume medium_volume_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume
    ADD CONSTRAINT medium_volume_pkey PRIMARY KEY (id);


--
-- Name: movie movies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY movie
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: series series_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: medium_type type_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_type
    ADD CONSTRAINT type_unique UNIQUE (type);


--
-- Name: medium_volume_episode unique_vol_ep; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume_episode
    ADD CONSTRAINT unique_vol_ep UNIQUE (volume, episode);


--
-- Name: dis insert_dis_episode_trig; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER insert_dis_episode_trig INSTEAD OF INSERT ON dis FOR EACH ROW EXECUTE PROCEDURE insert_dis_episode();


--
-- Name: episode episode_series_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY episode
    ADD CONSTRAINT episode_series_fkey FOREIGN KEY (series) REFERENCES series(id);


--
-- Name: media_set media_set_series_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_set
    ADD CONSTRAINT media_set_series_fkey FOREIGN KEY (series) REFERENCES series(id);


--
-- Name: media_set media_set_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_set
    ADD CONSTRAINT media_set_type_fkey FOREIGN KEY (type) REFERENCES medium_type(id);


--
-- Name: medium_volume_episode medium_volume_episode_episode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume_episode
    ADD CONSTRAINT medium_volume_episode_episode_fkey FOREIGN KEY (episode) REFERENCES episode(id);


--
-- Name: medium_volume_episode medium_volume_episode_volume_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume_episode
    ADD CONSTRAINT medium_volume_episode_volume_fkey FOREIGN KEY (volume) REFERENCES medium_volume(id);


--
-- Name: medium_volume medium_volume_media_set_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume
    ADD CONSTRAINT medium_volume_media_set_fkey FOREIGN KEY (media_set) REFERENCES media_set(id);


--
-- PostgreSQL database dump complete
--

