DROP DATABASE blog;

--CREATE DB
CREATE DATABASE blog;

--CONNECT TO DB
\c blog

--CREATE OBJECTS
CREATE TABLE usuarios(
    id SERIAL NOT NULL PRIMARY KEY,
    email VARCHAR(100)
);

CREATE TABLE posts(
    id SERIAL NOT NULL PRIMARY KEY,
    usuario_id INT,
    titulo VARCHAR(100),
    fecha DATE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

CREATE TABLE comentarios(
    id SERIAL NOT NULL PRIMARY KEY,
    usuario_id INT,
    post_id INT,
    texto VARCHAR(200),
    fecha DATE,
    FOREIGN KEY (post_id) REFERENCES posts(id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

\copy usuarios FROM 'user.csv' csv header;
\copy posts FROM 'post.csv' csv header;
\copy comentarios FROM 'comments.csv' csv header;

-- SELECT email, id and title from user 5
SELECT u.id, u.email, p.id, p.titulo FROM usuarios AS u
INNER JOIN posts AS p
ON u.id = p.usuario_id
WHERE u.id = 5;

-- SELECT all != usuario06@hotmail.com
SELECT u.id, u.email, c.usuario_id, c.texto FROM usuarios AS u
INNER JOIN comentarios AS c
ON u.id = c.usuario_id
WHERE u.email != 'usuario06@hotmail.com';

-- SELECT empty users
SELECT u.id, u.email, p.usuario_id FROM usuarios AS u
LEFT JOIN posts AS p
ON u.id = p.usuario_id
WHERE p.usuario_id is NULL;

-- SELECT all posts and comments
SELECT p.*, c.* FROM posts AS p
FULL OUTER JOIN comentarios AS c
ON p.id = c.post_id ORDER BY p.id ASC;

-- SELECT users where post in june
SELECT u.*, p.fecha FROM usuarios AS u
INNER JOIN posts AS p
ON u.id = p.usuario_id
WHERE EXTRACT(MONTH FROM p.fecha) = 06; 