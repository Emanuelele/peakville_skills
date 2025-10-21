CREATE TABLE players (
    identifier VARCHAR(50) PRIMARY KEY,
    level INT NOT NULL DEFAULT 1,
    XP INT NOT NULL DEFAULT 0,
    tokens INT NOT NULL DEFAULT 0,
    currentTrees JSON,
    quests JSON,
    skills JSON,
    INDEX idx_level (level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE trees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE skills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image VARCHAR(255),
    basePrice INT NOT NULL DEFAULT 1,
    parentTree INT NOT NULL,
    previousSkills JSON,
    nextSkills JSON,
    FOREIGN KEY (parentTree) REFERENCES trees(id) ON DELETE CASCADE,
    INDEX idx_parent_tree (parentTree)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE quests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    XP INT NOT NULL DEFAULT 1,
    type VARCHAR(50) NOT NULL DEFAULT 'GENERAL',
    steps INT NOT NULL DEFAULT 1,
    skills JSON,
    FOREIGN KEY (skill) REFERENCES skills(id) ON DELETE SET NULL,
    INDEX idx_type (type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;