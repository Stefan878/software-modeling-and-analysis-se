

INSERT INTO USERS (NAME, PASSWORD, EMAIL, DATEOFBIRTH) 
VALUES
('Ivan Petrov', 'password123', 'ivan.petrov@example.com', '1985-06-14'),
('Maria Ivanova', 'maria2023!', 'maria.ivanova@example.com', '1992-12-05'),
('Georgi Dimitrov', 'geo_secure98', 'georgi.dimitrov@example.com', '1988-04-17'),
('Elena Mihaylova', 'elena_pw2022', 'elena.mihaylova@example.com', '1995-09-21'),
('Nikolay Georgiev', 'nikolay_pw87', 'nikolay.georgiev@example.com', '1987-03-30'),
('Stoyan Stoyanov', 'stoyan_123', 'stoyan.stoyanov@example.com', '1990-07-10'),
('Petya Petrova', 'petya_pw!12', 'petya.petrova@example.com', '1994-11-23'),
('Desislava Nikolova', 'desi_pass99', 'desislava.nikolova@example.com', '1989-08-04'),
('Dimitar Popov', 'dimitar_pw34', 'dimitar.popov@example.com', '1993-02-12'),
('Radoslava Hristova', 'radoslava_pw22', 'radoslava.hristova@example.com', '1991-05-29'),
('Vasil Vasilev', 'vasil2023pw', 'vasil.vasilev@example.com', '1986-01-15'),
('Aleksandar Todorov', 'aleks12345', 'aleksandar.todorov@example.com', '1984-10-03'),
('Katerina Ilieva', 'katerina_pw99', 'katerina.ilieva@example.com', '1996-03-27'),
('Lyubomir Borisov', 'lyubomir_pw88', 'lyubomir.borisov@example.com', '1990-12-19');

SELECT * FROM USERS

INSERT INTO FRIENDSHIP (USER1_ID, USER2_ID)
VALUES
(1, 5),
(1, 8),
(2, 3),
(2, 4),
(3, 10),
(3, 15),
(4, 7),
(4, 12),
(5, 9),
(5, 14),
(6, 11),
(6, 13),
(7, 18),
(7, 17),
(8, 16),
(8, 19),
(9, 14),
(9, 20),
(10, 15),
(10, 21),
(11, 13),
(11, 17),
(12, 16),
(12, 20),
(13, 18),
(14, 21),
(15, 19),
(16, 17),
(17, 21),
(18, 20),
(19, 21);

SELECT * FROM FRIENDSHIP

INSERT INTO MESSAGE (CONTENT, TIMESTAMP, SENDER_ID, RECEIVER_ID) VALUES
('Hey! How have you been?', '2023-10-01 15:34:22', 1, 5),
('Are we still on for the meeting tomorrow?', '2023-10-02 09:10:45', 3, 4),
('Happy birthday! Hope you have an amazing day!', '2023-11-01 08:45:12', 2, 8),
('Did you check the latest updates?', '2023-09-15 14:20:05', 6, 10),
('Let me know when you’re free to chat.', '2023-11-02 11:25:00', 7, 3),
('Congratulations on your promotion!', '2023-06-20 12:00:45', 9, 12),
('Can you send me the files by today?', '2023-08-25 17:05:30', 11, 15),
('I’ll be arriving late. Please inform the others.', '2023-10-30 13:45:50', 14, 13),
('Let’s catch up over coffee sometime soon!', '2023-09-29 16:50:11', 18, 16),
('Thanks for your help earlier!', '2023-07-14 10:05:15', 19, 21);


INSERT INTO POST (CONTENT, TIMESTAMP, CREATOR_ID) VALUES
('Just had an amazing weekend with friends! Feeling refreshed for the week ahead.', '2023-09-15 10:30:22', 1),
('Does anyone have good book recommendations? I’m looking to read something new.', '2023-10-04 18:22:12', 3),
('Excited to announce that I’ve started a new job! Wish me luck on this new journey.', '2023-08-21 09:15:35', 5),
('Can’t believe it’s already November! This year flew by so quickly.', '2023-11-01 08:10:55', 8),
('Sharing some travel photos from my last trip! Such beautiful scenery.', '2023-10-15 19:45:10', 10),
('Feeling grateful today for all the wonderful people in my life.', '2023-09-30 14:30:00', 13),
('Just completed my first marathon! What an experience!', '2023-07-25 07:15:22', 14),
('Hosting a dinner party this weekend! Any recipe ideas?', '2023-10-20 16:05:45', 18),
('A big thank you to everyone who helped me with my recent project!', '2023-09-10 12:00:00', 16),
('Finally got to see my favorite band live! It was incredible!', '2023-08-30 21:20:30', 21);

INSERT INTO GROUPS (NAME, DESCRIPTION, ADMIN_ID) VALUES
('Travel Enthusiasts', 'A group for people who love exploring new destinations, sharing travel tips, and planning adventures.', 1),
('Book Club', 'Monthly book discussions, recommendations, and book exchange opportunities.', 3),
('Fitness Friends', 'Join us to discuss fitness routines, share progress, and motivate each other.', 5),
('Tech Talk', 'A community for tech enthusiasts to discuss the latest in technology, gadgets, and programming.', 8),
('Food Lovers', 'For all who love to cook, eat, and talk about delicious food.', 10),
('Photography Hub', 'A space to share your photos, get feedback, and learn more about photography.', 13);

INSERT INTO COMMENTS (CONTENT, DATEOFCOMMENT, COMMENTED_POST_ID, COMMENTATOR_ID) VALUES
('Слънцето наистина е невероятно днес! Съгласен съм!', '2023-10-20 09:15:32', 1, 2),
('Звучи страхотно, ще я добавя в списъка си за четене!', '2023-10-21 11:45:10', 2, 3),
('Наистина незабравими моменти! Тези спомени ни правят това, което сме.', '2023-09-05 14:22:45', 3, 4),
('Бях в този ресторант! Много приятно място и страхотна храна.', '2023-10-22 18:30:20', 4, 5),
('Честит рожден ден и от мен! Да бъде щастлив!', '2023-08-15 10:05:00', 5, 6),
('Морето е любимото ми място! Надявам се да имате страхотно пътуване!', '2023-07-02 16:40:12', 6, 7),
('That sounds like a fantastic weekend!', '2023-09-16 09:20:18', 7, 8),
('Have you tried "The Night Circus"? It’s an amazing read!', '2023-10-05 13:55:25', 8, 9),
('Good luck with the new job! You’ll do great!', '2023-08-21 10:10:15', 9, 10),
('I know, right? This year just disappeared in a flash.', '2023-11-01 09:05:45', 10, 11);

SELECT * FROM PAGE

INSERT INTO PAGE_FOLLOWERS (F_PAGE_ID, FOLLOWER_ID) VALUES
(1, 1),
(1, 3),
(1, 5),
(1, 7),
(1, 9),
(2, 2),
(2, 4),
(2, 6),
(2, 8),
(2, 10),
(2, 12),
(3, 3),
(3, 6),
(3, 9),
(3, 13),
(3, 15),
(4, 1),
(4, 4),
(4, 7),
(4, 10),
(4, 14),
(5, 5),
(5, 8),
(5, 11),
(5, 13),
(5, 16),
(5, 18),
(6, 2),
(6, 4),
(6, 9),
(6, 11),
(6, 15),
(6, 17),
(6, 20);

SELECT * FROM GROUPS

INSERT INTO GROUP_MEMBERS (M_GROUP_ID, MEMBER_ID) VALUES
(1, 1),
(1, 5),
(1, 7),
(1, 10),
(1, 12),
(2, 2),
(2, 3),
(2, 8),
(2, 11),
(2, 14),
(3, 5),
(3, 6),
(3, 9),
(3, 13),
(3, 18),
(4, 3),
(4, 4),
(4, 12),
(4, 15),
(5, 6),
(5, 9),
(5, 14),
(5, 16),
(5, 19),
(6, 7),
(6, 8),
(6, 10),
(6, 17),
(6, 20);


-- Реакции на постове
INSERT INTO REACTION (REACTION_POST_ID, R_USER_ID, REACTION_TYPE_ID) VALUES
(1, 2, 1),
(1, 3, 2),
(1, 4, 5),
(2, 1, 3),
(2, 5, 4),
(3, 2, 1),
(3, 6, 6),
(4, 7, 2),
(5, 8, 3),
(6, 9, 4),
(7, 10, 5),
(8, 11, 2),
(9, 12, 3),
(10, 13, 4),
(11, 14, 6),
(12, 15, 1),
(13, 16, 7),
(14, 17, 3),
(15, 18, 2),
(16, 19, 5);

-- Реакции на коментари
INSERT INTO REACTION (R_COMMENT_ID, R_USER_ID, REACTION_TYPE_ID) VALUES
(12, 1, 1),
(13, 2, 2),
(14, 3, 3),
(15, 4, 4),
(16, 5, 5),
(17, 6, 6),
(18, 7, 2),
(19, 8, 3),
(20, 9, 4),
(21, 10, 5),
(22, 11, 2),
(23, 12, 1),
(24, 13, 3),
(25, 14, 4),
(26, 15, 2),
(27, 16, 5),
(28, 17, 3),
(29, 18, 1),
(30, 19, 4),
(31, 20, 2),
(32, 21, 5);

DELETE FROM GROUP_MEMBERS
DELETE FROM PAGE_FOLLOWERS
DELETE FROM FRIENDSHIP
