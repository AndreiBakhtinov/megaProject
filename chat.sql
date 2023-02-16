create database if not exists chat;
use chat;

create table if not exists users
(
    user_id integer primary key auto_increment,
    fullname varchar(256) not null,
    country varchar(64),
    is_blocked BOOL default false,
    created_at datetime default current_timestamp
);
create table chats(
    chat_id int primary key auto_increment,
    topic nvarchar(256) not null,
    created_at datetime default current_timestamp,
    user1_id INTEGER,
    user2_id INTEGER,
    FOREIGN KEY (user1_id) REFERENCES users(user_id),
    FOREIGN KEY (user2_id) REFERENCES users(user_id)
);

create table if not exists messages(
    message_id integer primary key auto_increment,
    chat_id integer,
    author_id integer,
    recipient_id integer,
    text text not null,
    created_at datetime default current_timestamp,
    is_removed BOOL default false,
    FOREIGN KEY (author_id) REFERENCES users(user_id),
    FOREIGN KEY (recipient_id) REFERENCES users(user_id),
    FOREIGN KEY (chat_id) REFERENCES chats(chat_id)
);

create table if not exists reactions(
    reaction_id integer primary key auto_increment,
    user_id integer,
    message_id integer,
    value integer not null check(value between 1 and 5),
    created_at datetime default current_timestamp,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (message_id) REFERENCES messages(message_id)
);

SELECT chats.chat_id, messages.text, messages.created_at, chats.topic
FROM chats
JOIN messages on chats.chat_id=messages.chat_id
WHERE messages.created_at = (
    SELECT MAX(created_at) FROM messages m
    WHERE chats.chat_id=m.chat_id
)
ORDER BY messages.created_at DESC;