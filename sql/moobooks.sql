BEGIN;
  DROP SCHEMA IF EXISTS mastodon CASCADE;
  DROP SCHEMA IF EXISTS twitter CASCADE;
  CREATE SCHEMA mastodon;
  CREATE SCHEMA twitter;
  DROP TABLE IF EXISTS database_version;
  CREATE TABLE database_version (
    id SERIAL PRIMARY KEY,
    major SMALLINT NOT NULL,
    minor SMALLINT NOT NULL,
    patch SMALLINT NOT NULL
  );
  INSERT INTO database_version (major, minor, patch) VALUES (0,1,0);
  DROP TABLE IF EXISTS plushies;
  CREATE TABLE plushies (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    engine TEXT NOT NULL DEFAULT 'rng',
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    can_favorite BOOLEAN NOT NULL DEFAULT FALSE,
    can_reblog BOOLEAN NOT NULL DEFAULT FALSE,
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
    description TEXT,
    location TEXT,
    website TEXT,
    access_token TEXT,
    access_token_secret TEXT,
    created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    updated_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP(0)
  );
  CREATE TABLE twitter.plush_owners (
    account_id BIGINT NOT NULL REFERENCES twitter.accounts(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    plush_id INTEGER NOT NULL REFERENCES plushies(id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (account_id, plush_id)
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
