CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(100) NOT NULL
);

-- BCrypt hash for plaintext password: password123
INSERT INTO users (username, password_hash)
VALUES ('demo', '$2a$10$8w4Q0gD6r3fZf7vM8x6lPuz0h9Qa5xE0xR6QKfM8XzqFnlV4xYf9u')
ON CONFLICT (username) DO NOTHING;
