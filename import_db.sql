PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);


DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    user_id INTEGER NOT NULL,
    body TEXT NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    likes BOOLEAN NOT NULL,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    users (fname,lname)
VALUES
    ('Noam', 'Zimet'),
    ('Kaushal', 'Kumbagowdana');

INSERT INTO
    questions (title,body,user_id)
VALUES
    ('ORM', 'How do we do this project?', (SELECT id FROM users WHERE users.fname = 'Noam')),
    ('Sky', 'Why is the sky blue', (SELECT id FROM users WHERE users.fname = 'Kaushal'));

INSERT INTO
    replies (question_id, parent_id, user_id, body)
VALUES
    ((SELECT id FROM questions WHERE questions.title = 'Sky'),
        NULL,
        (SELECT id FROM users WHERE users.fname = 'Kaushal'),
        'Sky is actually green'
    ),
    ((SELECT id FROM questions WHERE questions.title = 'Sky'),
        (SELECT id FROM replies WHERE replies.body = 'Sky is actually green'),
        (SELECT id FROM users WHERE users.fname = 'Noam'),
        'WHATTTT!'
    );
