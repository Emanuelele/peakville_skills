CREATE TABLE players (
    identifier VARCHAR(50) PRIMARY KEY,
    level INT NOT NULL DEFAULT 1,
    XP INT NOT NULL DEFAULT 0,
    tokens INT NOT NULL DEFAULT 0,
    currentTrees JSON,
    quests JSON,
    skills JSON,
);

CREATE TABLE trees (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE skills (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    basePrice INT NOT NULL DEFAULT 1,
    parentTree INT NOT NULL,
    previousSkills JSON,
    nextSkills JSON,
);

CREATE TABLE quests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    XP INT NOT NULL DEFAULT 1,
    steps INT NOT NULL DEFAULT 1,
    skillsReference JSON,
    requiredQuests JSON,
    hidden BOOLEAN NOT NULL DEFAULT FALSE,
);