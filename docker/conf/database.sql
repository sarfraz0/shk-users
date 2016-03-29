CREATE ROLE poor WITH LOGIN ENCRYPTED PASSWORD 'rich';
CREATE DATABASE budget OWNER poor ENCODING 'UNICODE';

-- after init_db

INSERT INTO statuses (name) VALUES ('active');
INSERT INTO statuses (name) VALUES ('blacklisted');
INSERT INTO statuses (name) VALUES ('pending');
INSERT INTO statuses (name) VALUES ('deleted');

INSERT INTO roles (name) VALUES ('admin');
INSERT INTO roles (name) VALUES ('manager');
INSERT INTO roles (name) VALUES ('user');
INSERT INTO roles (name) VALUES ('guest');

INSERT INTO users VALUES (
    DEFAULT,
    'admin',
    '$6$rounds=100000$VOcHnEfMoJ0ahe16$liVstaZK5MaVXrGYLN.yMl/8/CG0Hk4A3vMuPzecmFnbqNW2d61QT.205FTj8.VmocMi5jxbe9lqETzGyrTPi.',
    'admin@variablentreprise.com',
    (SELECT cid FROM statuses WHERE name LIKE 'active')
); -- password is admin

INSERT INTO users VALUES (
    DEFAULT,
    'guest',
    '$6$rounds=100000$K5zvPWHQkcejk5Km$5DAc8gy3vDu/WAna871CZ/Bqmd1TYPzN1oa4C9g0zXq0MfWdTj0fZ7iDhltishUyT0km03nAK46nKuGFhWdsS0',
    'guest@variablentreprise.com',
    (SELECT cid FROM statuses WHERE name LIKE 'active')
); -- password is guest

INSERT INTO roles_users VALUES (
    (SELECT cid FROM roles WHERE name LIKE 'admin'),
    (SELECT cid FROM users WHERE pseudo LIKE 'admin')
);

INSERT INTO roles_users VALUES (
    (SELECT cid FROM roles WHERE name LIKE 'user'),
    (SELECT cid FROM users WHERE pseudo LIKE 'guest')
);

