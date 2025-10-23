CREATE TABLE players (
    identifier VARCHAR(50) PRIMARY KEY,
    level INT NOT NULL DEFAULT 1,
    XP INT NOT NULL DEFAULT 0,
    tokens INT NOT NULL DEFAULT 0,
    currentTrees JSON,
    quests JSON,
    skills JSON,
    maxActiveQuests INT NOT NULL DEFAULT 3,
    activeQuests JSON
);

CREATE TABLE trees (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price INT NOT NULL DEFAULT 1
);

CREATE TABLE skills (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    price INT NOT NULL DEFAULT 1,
    parentTree INT NOT NULL,
    previousSkills JSON,
    nextSkills JSON
);

CREATE TABLE quests (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    XP INT NOT NULL DEFAULT 1,
    steps INT NOT NULL DEFAULT 1,
    skillsReference JSON,
    requiredQuests JSON,
    actionConfig JSON,
    hidden BOOLEAN NOT NULL DEFAULT FALSE
);