CREATE DATABASE IF NOT EXISTS my_love_spot;
USE my_love_spot;

CREATE TABLE User (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE Spots (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    address VARCHAR(255),
    creator_id INTEGER REFERENCES User(id) ON DELETE CASCADE,
    longitude DECIMAL(9,6),
    latitude DECIMAL(9,6),
    logo TEXT,
    rating DECIMAL(3,2),
    color VARCHAR(50),
    image TEXT,
    link TEXT
);

CREATE TABLE Favorites (
    user_id INTEGER REFERENCES User(id) ON DELETE CASCADE,
    spot_id INTEGER REFERENCES Spots(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, spot_id)
);

CREATE TABLE Rating (
    user_id INTEGER REFERENCES User(id) ON DELETE CASCADE,
    spot_id INTEGER REFERENCES Spots(id) ON DELETE CASCADE,
    note INTEGER CHECK (note >= 0 AND note <= 5),
    PRIMARY KEY (user_id, spot_id)
);

CREATE TABLE Tag (
    id SERIAL PRIMARY KEY,
    spot_id INTEGER REFERENCES Spots(id) ON DELETE CASCADE,
    tag_name VARCHAR(50) NOT NULL
);
