--postgres user by default connects to postgres db
ALTER USER postgres WITH PASSWORD 'postgres';
--default schema is public
drop schema public cascade;
create schema public;

CREATE TABLE matches (
  match_id bigint PRIMARY KEY,
  match_seq_num bigint,
  radiant_win boolean,
  start_time integer,
  duration integer,
  tower_status_radiant integer,
  tower_status_dire integer,
  barracks_status_radiant integer,
  barracks_status_dire integer,
  cluster integer,
  first_blood_time integer,
  lobby_type integer,
  human_players integer,
  leagueid integer,
  positive_votes integer,
  negative_votes integer,
  game_mode integer,
  engine integer,
  picks_bans json[],
  --radiant_team_name varchar(255),
  --dire_team_name varchar(255),
  --radiant_captain integer,
  --dire_captain integer,
  --radiant_logo integer
  --dire_logo integer,
  --radiant_team_complete integer,
  --dire_team_complete integer,
  --radiant_team_id integer,
  --dire_team_id integer,
  --from skill api
  skill integer,
  --parsed data below
  parse_status integer,
  url varchar(255),
  chat json[],
  objectives json[],
  radiant_gold_adv integer[],
  radiant_xp_adv integer[],
  teamfights json[],
  version integer
  );

CREATE TABLE players (
  account_id bigint PRIMARY KEY,
  steamid bigint,
  avatar varchar(255),
  personaname varchar(255),
  last_login timestamp with time zone,
  full_history_time timestamp with time zone,
  cheese integer,
  fh_unavailable boolean
  /*
    "avatarfull" : "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/88/883f2697f5b2dc4affda2d47eedc1cbec8cfb657_full.jpg",
    "avatarmedium" : "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/88/883f2697f5b2dc4affda2d47eedc1cbec8cfb657_medium.jpg",
    "communityvisibilitystate" : 3,
    "lastlogoff" : 1426020853,
    "loccityid" : 44807,
    "loccountrycode" : "TR",
    "locstatecode" : "16",
    "personastate" : 0,
    "personastateflags" : 0,
    "primaryclanid" : "103582791433775490",
    "profilestate" : 1,
    "profileurl" : "http://steamcommunity.com/profiles/76561198060610657/",
    "realname" : "Alper",
    "timecreated" : 1332289262,
  */
);

CREATE TABLE player_matches (
  PRIMARY KEY(match_id, player_slot),
      match_id bigint REFERENCES matches(match_id) ON DELETE CASCADE,
      account_id bigint,
      player_slot integer,
      hero_id integer,
      item_0 integer,
      item_1 integer,
      item_2 integer,
      item_3 integer,
      item_4 integer,
      item_5 integer,
      kills integer,
      deaths integer,
      assists integer,
      leaver_status integer,
      gold integer,
      last_hits integer,
      denies integer,
      gold_per_min integer,
      xp_per_min integer,
      gold_spent integer,
      hero_damage integer,
      tower_damage integer,
      hero_healing integer,
      level integer,
      ability_upgrades json[],
      additional_units json[],
      --parsed fields below
      stuns real,
      max_hero_hit json,
      times integer[],
      gold_t integer[],
      lh_t integer[],
      xp_t integer[],
      obs_log json[],
      sen_log json[],
      purchase_log json[],
      kills_log json[],
      buyback_log json[],
      lane_pos json,
      obs json,
      sen json,
      actions json,
      pings json,
      purchase json,
      gold_reasons json,
      xp_reasons json,
      killed json,
      item_uses json,
      ability_uses json,
      hero_hits json,
      damage json,
      damage_taken json,
      damage_inflictor json,
      runes json,
      killed_by json,
      modifier_applied json,
      kill_streaks json,
      multi_kills json,
      healing json
      --disabled due to incompatibility
      --kill_streaks_log json[][], --an array of kill streak values
      --multi_kill_id_vals integer[] --an array of multi kill values (the length of each multi kill)
);

CREATE TABLE player_ratings (
  PRIMARY KEY(account_id, match_id),
  account_id bigint REFERENCES players(account_id) ON DELETE CASCADE,
  match_id bigint,
  solo_competitive_rank integer,
  competitive_rank integer, 
  time timestamp with time zone
);

CREATE INDEX on player_matches(account_id);
CREATE INDEX on matches(version);
CREATE INDEX on players(full_history_time);
CREATE INDEX on players(last_login);
CREATE INDEX on players(cheese);
CREATE INDEX on player_ratings(account_id, time);