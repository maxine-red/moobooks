BEGIN;
  DROP SCHEMA IF EXISTS mastodon CASCADE;
  DROP SCHEMA IF EXISTS twitter CASCADE;
  CREATE SCHEMA mastodon;
  CREATE SCHEMA twitter;
  DROP TABLE IF EXISTS plushies;
  CREATE TABLE plushies (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
  );
  CREATE TABLE twitter.apps (
    id SERIAL PRIMARY KEY,
    name TEXT,
    consumer_key TEXT NOT NULL UNIQUE,
    consumer_secret TEXT NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
  );
  CREATE TABLE twitter.accounts (
    id BIGINT PRIMARY KEY,
    plush_id INTEGER REFERENCES plushies(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
    app_id INTEGER REFERENCES twitter.apps(id)
    ON UPDATE CASCADE ON DELETE SET NULL,
    screen_name TEXT NOT NULL,
    display_name TEXT,
    avatar TEXT,
    banner TEXT,
    biography TEXT,
    location TEXT,
    homepage TEXT,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
  );
  CREATE TABLE twitter.statuses (
    id BIGINT PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES twitter.accounts(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_mention BOOLEAN NOT NULL DEFAULT FALSE,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
  );
END;
