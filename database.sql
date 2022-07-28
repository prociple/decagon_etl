-- ############################################################
-- 
-- Author: Andrew Ezeamama
-- Date: 27th July 2022
-- Comment: My Decagon - Data Engineer Test'
-- 
-- ############################################################

-- Create Database: decagon
CREATE DATABASE decagon
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

GRANT ALL ON DATABASE decagon TO postgres;

GRANT TEMPORARY, CONNECT ON DATABASE decagon TO PUBLIC;



-- Create Table: public.continents
CREATE TABLE IF NOT EXISTS public.continents
(
    code character(2) COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT continents_pkey PRIMARY KEY (code)
);


-- Create Table: public.languages
CREATE TABLE IF NOT EXISTS public.languages
(
    code character(2) COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    native text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT languages_pkey PRIMARY KEY (code)
);



-- Create Table: public.countries
CREATE TABLE IF NOT EXISTS public.countries
(
    code character(2) COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    native text COLLATE pg_catalog."default" NOT NULL,
    phone text COLLATE pg_catalog."default" NOT NULL,
    continent character(2) COLLATE pg_catalog."default" NOT NULL,
    capital text COLLATE pg_catalog."default" NOT NULL,
    currency text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT countries_pkey PRIMARY KEY (code),
    CONSTRAINT fk_continents FOREIGN KEY (continent)
        REFERENCES public.continents (code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);


-- Table: public.countries_languages
CREATE TABLE IF NOT EXISTS public.countries_languages
(
    country character(2) COLLATE pg_catalog."default" NOT NULL,
    language character(2) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT fk_country FOREIGN KEY (country)
        REFERENCES public.countries (code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT fk_language FOREIGN KEY (language)
        REFERENCES public.languages (code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
