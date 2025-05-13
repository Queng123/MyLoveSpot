CREATE DATABASE IF NOT EXISTS my_love_spot;
USE my_love_spot;

CREATE TABLE User (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE RefreshToken (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES User(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE RefreshToken
ADD CONSTRAINT one_token_per_user UNIQUE (user_id);

CREATE TABLE Spots (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    address VARCHAR(255) UNIQUE NOT NULL,
    creator_id INTEGER REFERENCES User(id) ON DELETE CASCADE,

    longitude DECIMAL(9,6),
    latitude DECIMAL(9,6),
    logo TEXT,
    rating DECIMAL(3,2),
    color VARCHAR(50),
    image TEXT,
    link TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
    name VARCHAR(50) NOT NULL UNIQUE,
    color VARCHAR(50) NOT NULL
);

INSERT INTO Tag (name, color) VALUES
('Romantic', 'red'),
('Scenic View', 'skyblue'),
('Sunset Spot', 'orange'),
('Candlelight Dinner', 'gold'),
('Secluded', 'midnightblue'),
('Luxury', 'purple'),
('Nature', 'green'),
('Rooftop', 'silver'),
('Cozy', 'pink'),
('Beachside', 'turquoise');

CREATE TABLE SpotTags (
    spot_id INTEGER REFERENCES Spots(id) ON DELETE CASCADE,
    tag_id INTEGER REFERENCES Tag(id) ON DELETE CASCADE,
    PRIMARY KEY (spot_id, tag_id)
);

-- Add sample user
INSERT INTO User (name, email, password) 
VALUES ('Nkorde', 'nkorde@example.com', '$2a$10$L5JXV8kJ5Z5D8eEj4t/YiOVYF9HCg6xjQJPnK1IHkZ/FPYjQdJ/Ae');

-- Get the user_id for reference
SET @user_id = LAST_INSERT_ID();

-- Add 3 Spots in San Francisco
INSERT INTO Spots (name, description, address, creator_id, longitude, latitude, logo, rating, color, image, link)
VALUES 
    ('Sutro Heights Park', 
     'An elevated park with panoramic views of the Pacific Ocean and the Marin Headlands. Perfect for sunset watching and romantic strolls.',
     '846 Point Lobos Ave, San Francisco, CA 94121', 
     @user_id, 
     -122.510675, 
     37.778488, 
     'pin', 
     0.0, 
     '#FF0000', 
     'https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Sutro_Heights_Park.jpg/1280px-Sutro_Heights_Park.jpg', 
     'https://sfrecpark.org/764/Sutro-Heights'
    ),
    
    ('Rooftop at Charmaine\'s', 
     'Upscale rooftop bar with cozy fire pits, craft cocktails, and city views. Perfect for a sophisticated date night.',
     '45 McAllister St, San Francisco, CA 94102', 
     @user_id, 
     -122.412924, 
     37.781118, 
     'pin', 
     0.0, 
     '#FF0000', 
     'https://static.properhotel.com/properhotel/media/images/proper-hotel-sf-charmaines-rooftop-bar-evening-drink.jpg', 
     'https://properhotel.com/san-francisco/food-drink/charmaines/'
    ),
    
    ('Baker Beach', 
     'A beautiful beach with stunning views of the Golden Gate Bridge. Come at sunset for a truly magical experience.',
     'Baker Beach, San Francisco, CA 94129', 
     @user_id, 
     -122.483888, 
     37.793389, 
     'pin', 
     0.0, 
     '#FF0000', 
     'https://www.nps.gov/common/uploads/grid_builder/prsf/crop16_9/D5EF70B2-1DD8-B71B-0BC5D121EF3D3381.jpg', 
     'https://www.nps.gov/prsf/planyourvisit/baker-beach.htm'
    );

-- Set spot IDs for reference
SELECT @sutro_heights_id := id FROM Spots WHERE name = 'Sutro Heights Park';
SELECT @charmaines_id := id FROM Spots WHERE name = 'Rooftop at Charmaine\'s';
SELECT @baker_beach_id := id FROM Spots WHERE name = 'Baker Beach';

-- Link spots to their tags
-- Sutro Heights Park
INSERT INTO SpotTags (spot_id, tag_id)
SELECT @sutro_heights_id, id FROM Tag WHERE name IN ('Romantic', 'Scenic View', 'Sunset Spot', 'Nature');

-- Rooftop at Charmaine's
INSERT INTO SpotTags (spot_id, tag_id)
SELECT @charmaines_id, id FROM Tag WHERE name IN ('Romantic', 'Luxury', 'Rooftop', 'Cozy');

-- Baker Beach
INSERT INTO SpotTags (spot_id, tag_id)
SELECT @baker_beach_id, id FROM Tag WHERE name IN ('Romantic', 'Scenic View', 'Sunset Spot', 'Beachside');
