-- INITIALIZE EMOJI DATABASE

create database if not exists emoji CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

create user if not exists emojiuser@'%' IDENTIFIED BY 'DcS5Gb7Gs2W#';
grant all privileges on emoji.* to emojiuser@'%';
flush privileges;

create table if not exists emoji.emojis (id INTEGER NOT NULL PRIMARY KEY, emoji varchar(5) NOT NULL, description varchar(100));

insert into emoji.emojis values(1,"🙂","Slightly smiling face");
insert into emoji.emojis values(2,"🥳","Partying face");
insert into emoji.emojis values(3,"😍","Smiling face with heart eyes");
insert into emoji.emojis values(4,"😘","Face blowing kiss");
insert into emoji.emojis values(5,"🤫","Shushing face");
insert into emoji.emojis values(6,"🥶","Cold face");
insert into emoji.emojis values(7,"😳","Flushed face");
insert into emoji.emojis values(8,"😢","Crying face");
insert into emoji.emojis values(9,"💀","Skull");
insert into emoji.emojis values(10,"☠","Skull and cross-bone");
insert into emoji.emojis values(11,"😾","Pouting cat");
insert into emoji.emojis values(12,"💗","Growing heart");
insert into emoji.emojis values(13,"💙","Blue heart");
insert into emoji.emojis values(14,"🥑","Avocado");
insert into emoji.emojis values(15,"🥩","Cut of meat");
insert into emoji.emojis values(16,"🍭","Lollipop");
insert into emoji.emojis values(17,"🍸","Cocktail glass");
insert into emoji.emojis values(18,"🧋","Bubble tea");
insert into emoji.emojis values(19,"🎲","Game die");
insert into emoji.emojis values(20,"♠","Spade suit");

-- INITIALIZE VOTES DATABASE

create database if not exists votes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

create user if not exists voteuser@'%' IDENTIFIED BY 'DcS5Gb7Gs2W#';
grant all privileges on votes.* to voteuser@'%';
flush privileges;

create table if not exists votes.votes (id INTEGER NOT NULL PRIMARY KEY auto_increment, emoji_id INTEGER NOT NULL, voting_date TIMESTAMP);
