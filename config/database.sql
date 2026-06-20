-- Supereme Legal Platform Database
CREATE DATABASE IF NOT EXISTS supereme_legal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE supereme_legal;

-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150),
    phone VARCHAR(20),
    city VARCHAR(100),
    profession VARCHAR(100),
    is_admin TINYINT(1) DEFAULT 0,
    is_verified TINYINT(1) DEFAULT 0,
    verification_token VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- Law Books Table
CREATE TABLE law_books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    title_urdu VARCHAR(255),
    author VARCHAR(150),
    description TEXT,
    description_urdu TEXT,
    category VARCHAR(100),
    google_search_query VARCHAR(255),
    pdf_url VARCHAR(500),
    cover_image VARCHAR(255),
    downloads INT DEFAULT 0,
    rating DECIMAL(3,2),
    views INT DEFAULT 0,
    is_active TINYINT(1) DEFAULT 1,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id),
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- Urdu Law Dictionary Table
CREATE TABLE urdu_dictionary (
    id INT PRIMARY KEY AUTO_INCREMENT,
    legal_term VARCHAR(255) NOT NULL UNIQUE,
    english_definition TEXT,
    urdu_definition TEXT,
    urdu_meaning VARCHAR(500),
    contextual_meaning TEXT,
    explanation TEXT,
    usage_example TEXT,
    usage_example_urdu TEXT,
    category VARCHAR(100),
    related_terms VARCHAR(500),
    google_search_query VARCHAR(255),
    views INT DEFAULT 0,
    is_verified TINYINT(1) DEFAULT 0,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id),
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- Law Cases Table
CREATE TABLE law_cases (
    id INT PRIMARY KEY AUTO_INCREMENT,
    case_number VARCHAR(100) NOT NULL,
    case_title VARCHAR(255) NOT NULL,
    case_title_urdu VARCHAR(255),
    court VARCHAR(150),
    year INT,
    parties_involved TEXT,
    case_summary TEXT,
    case_summary_urdu TEXT,
    legal_points TEXT,
    pdf_url VARCHAR(500),
    google_search_query VARCHAR(255),
    citation VARCHAR(150),
    category VARCHAR(100),
    downloads INT DEFAULT 0,
    views INT DEFAULT 0,
    is_active TINYINT(1) DEFAULT 1,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id),
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- Judgments Table
CREATE TABLE judgments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    judgment_title VARCHAR(255) NOT NULL,
    judgment_title_urdu VARCHAR(255),
    judge_name VARCHAR(150),
    court VARCHAR(150),
    judgment_date DATE,
    case_number VARCHAR(100),
    judgment_text TEXT,
    judgment_text_urdu TEXT,
    key_rulings TEXT,
    legal_implications TEXT,
    pdf_url VARCHAR(500),
    google_search_query VARCHAR(255),
    category VARCHAR(100),
    downloads INT DEFAULT 0,
    views INT DEFAULT 0,
    is_active TINYINT(1) DEFAULT 1,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id),
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- User Suggestions Table
CREATE TABLE suggestions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    suggestion_type VARCHAR(50),
    title VARCHAR(255),
    message TEXT,
    category VARCHAR(100),
    status ENUM('pending', 'reviewed', 'implemented', 'rejected') DEFAULT 'pending',
    admin_notes TEXT,
    reviewed_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(id),
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- Search History Table
CREATE TABLE search_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    search_query VARCHAR(255),
    category VARCHAR(50),
    results_found INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- Bookmarks Table
CREATE TABLE bookmarks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    item_id INT,
    item_type ENUM('book', 'case', 'judgment', 'dictionary') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- Ratings Table
CREATE TABLE ratings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    item_id INT,
    item_type ENUM('book', 'case', 'judgment') NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CHARSET=utf8mb4
) ENGINE=InnoDB;

-- Create Indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_dictionary_term ON urdu_dictionary(legal_term);
CREATE INDEX idx_books_category ON law_books(category);
CREATE INDEX idx_cases_court ON law_cases(court);
CREATE INDEX idx_cases_year ON law_cases(year);
CREATE INDEX idx_judgments_date ON judgments(judgment_date);
CREATE INDEX idx_suggestions_user ON suggestions(user_id);
CREATE INDEX idx_suggestions_status ON suggestions(status);

-- Insert Sample Admin User (password: admin@123)
INSERT INTO users (username, email, password_hash, full_name, is_admin, is_verified) 
VALUES ('admin', 'admin@supereme.com', '$2y$10$abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOP', 'Admin User', 1, 1);
