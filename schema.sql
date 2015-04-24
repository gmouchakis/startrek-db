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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: episode; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE episode (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    series uuid,
    title text NOT NULL,
    airdate date,
    remastered_airdate date,
    season smallint,
    episode_number smallint,
    production_code text,
    stardate numeric,
    date date,
    vignette boolean
);


--
-- Name: series; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE series (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    aired daterange
);


--
-- Name: cont; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW cont AS
 SELECT episode.id,
    episode.title,
    episode.airdate,
    episode.season,
    episode.episode_number,
    episode.production_code,
    episode.stardate
   FROM episode
  WHERE (episode.series = ( SELECT series.id
           FROM series
          WHERE (series.title = 'Star Trek Continues'::text)))
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
  WHERE (episode.series = ( SELECT series.id
           FROM series
          WHERE (series.title = 'Star Trek: Deep Space Nine'::text)))
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
    episode.date
   FROM episode
  WHERE (episode.series = ( SELECT series.id
           FROM series
          WHERE (series.title = 'Star Trek: Enterprise'::text)))
  ORDER BY episode.airdate;


--
-- Name: media_set; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE media_set (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    series uuid,
    type uuid,
    season smallint
);


--
-- Name: medium_type; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medium_type (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text NOT NULL
);


--
-- Name: medium_volume; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medium_volume (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    media_set uuid,
    sequence smallint NOT NULL
);


--
-- Name: medium_volume_episode; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medium_volume_episode (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    volume uuid,
    episode uuid
);


--
-- Name: movie; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE movie (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    release_date date NOT NULL,
    stardate numeric
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
  WHERE (episode.series = ( SELECT series.id
           FROM series
          WHERE (series.title = 'Star Trek: The Animated Series'::text)))
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
  WHERE (episode.series = ( SELECT series.id
           FROM series
          WHERE (series.title = 'Star Trek: The Next Generation'::text)))
  ORDER BY episode.airdate;


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
  WHERE (((((((ep.id = mve.episode) AND (ms.id = mv.media_set)) AND (ms.type = mt.id)) AND (mve.volume = mv.id)) AND (s.id = ep.series)) AND (s.title = 'Star Trek: The Next Generation'::text)) AND (mt.type = 'DVD'::text))
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
  WHERE (episode.series = ( SELECT series.id
           FROM series
          WHERE (series.title = 'Star Trek: The Original Series'::text)))
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
  WHERE (((((((ep.id = mve.episode) AND (ms.id = mv.media_set)) AND (ms.type = mt.id)) AND (mve.volume = mv.id)) AND (s.id = ep.series)) AND (s.title = 'Star Trek: The Original Series'::text)) AND (mt.type = 'Blu-ray'::text))
  ORDER BY ep.airdate, ep.production_code;


--
-- Name: VIEW tos_bluray; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW tos_bluray IS 'The TOS Blu-ray set released in 2009, containing the remastered versions of all the episodes in 1080p and 7.1 surround sound.';


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
  WHERE (episode.series = ( SELECT series.id
           FROM series
          WHERE (series.title = 'Star Trek: Voyager'::text)))
  ORDER BY episode.airdate;


--
-- Name: episode_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY episode
    ADD CONSTRAINT episode_pkey PRIMARY KEY (id);


--
-- Name: media_set_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY media_set
    ADD CONSTRAINT media_set_pkey PRIMARY KEY (id);


--
-- Name: medium_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medium_type
    ADD CONSTRAINT medium_pkey PRIMARY KEY (id);


--
-- Name: medium_volume_episode_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medium_volume_episode
    ADD CONSTRAINT medium_volume_episode_pkey PRIMARY KEY (id);


--
-- Name: medium_volume_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medium_volume
    ADD CONSTRAINT medium_volume_pkey PRIMARY KEY (id);


--
-- Name: movies_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY movie
    ADD CONSTRAINT movies_pkey PRIMARY KEY (id);


--
-- Name: series_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);


--
-- Name: type_unique; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medium_type
    ADD CONSTRAINT type_unique UNIQUE (type);


--
-- Name: unique_vol_ep; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medium_volume_episode
    ADD CONSTRAINT unique_vol_ep UNIQUE (volume, episode);


--
-- Name: episode_series_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY episode
    ADD CONSTRAINT episode_series_fkey FOREIGN KEY (series) REFERENCES series(id);


--
-- Name: media_set_series_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_set
    ADD CONSTRAINT media_set_series_fkey FOREIGN KEY (series) REFERENCES series(id);


--
-- Name: media_set_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media_set
    ADD CONSTRAINT media_set_type_fkey FOREIGN KEY (type) REFERENCES medium_type(id);


--
-- Name: medium_volume_episode_episode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume_episode
    ADD CONSTRAINT medium_volume_episode_episode_fkey FOREIGN KEY (episode) REFERENCES episode(id);


--
-- Name: medium_volume_episode_volume_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume_episode
    ADD CONSTRAINT medium_volume_episode_volume_fkey FOREIGN KEY (volume) REFERENCES medium_volume(id);


--
-- Name: medium_volume_media_set_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_volume
    ADD CONSTRAINT medium_volume_media_set_fkey FOREIGN KEY (media_set) REFERENCES media_set(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
