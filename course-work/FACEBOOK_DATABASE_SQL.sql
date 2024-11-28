CREATE DATABASE FACEBOOK_DATABASE

USE FACEBOOK_DATABASE
-----------------------TABLES AND TABLE CHANGES-----------------------------------
CREATE TABLE USERS(
	USER_ID INT IDENTITY(1,1) PRIMARY KEY,
	NAME VARCHAR(100) NOT NULL,
	PASSWORD VARCHAR(100) NOT NULL,
	EMAIL VARCHAR(100) UNIQUE NOT NULL,
	DATEOFBIRTH DATE,
	FRIENDS_COUNTER INT DEFAULT 0,
)

CREATE TABLE FRIENDSHIP(
	USER1_ID INT,
	USER2_ID INT,
	FRIENDS_SINCE DATE,

	PRIMARY KEY(USER1_ID,USER2_ID),
	FOREIGN KEY (USER1_ID) REFERENCES USERS(USER_ID),
	FOREIGN KEY (USER2_ID) REFERENCES USERS(USER_ID),
)

CREATE TABLE MESSAGE(
	MESSAGE_ID INT IDENTITY(1,1) PRIMARY KEY,
	CONTENT VARCHAR(500),
	TIMESTAMP DATETIME DEFAULT GETDATE(),
	SENDER_ID INT,
	RECEIVER_ID INT,

	FOREIGN KEY (SENDER_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE,
	FOREIGN KEY (RECEIVER_ID) REFERENCES USERS(USER_ID),
)

CREATE TABLE PAGE(
	PAGE_ID INT IDENTITY(1,1) PRIMARY KEY,
	NAME VARCHAR(100) NOT NULL,
	DESCRIPTION VARCHAR(1000),
	ADMIN_ID INT,

	FOREIGN KEY (ADMIN_ID) REFERENCES USERS(USER_ID),
)

CREATE TABLE POST(
	POST_ID INT IDENTITY(1,1) PRIMARY KEY,
	CONTENT VARCHAR(2500) NOT NULL,
	TIMESTAMP DATETIME DEFAULT GETDATE(),
	CREATOR_ID INT,
	REACTIONS_COUNTER INT DEFAULT 0,
	COMMENTS_COUNTER INT DEFAULT 0,

	FOREIGN KEY (CREATOR_ID) REFERENCES USERS(USER_ID) ON DELETE CASCADE
)

CREATE TABLE GROUPS(
	GROUP_ID INT IDENTITY(1,1) PRIMARY KEY,
	NAME VARCHAR(100) NOT NULL,
	DESCRIPTION VARCHAR(1000),
	ADMIN_ID INT,
	
	FOREIGN KEY (ADMIN_ID) REFERENCES USERS(USER_ID),
)

CREATE TABLE COMMENTS(
	COMMENT_ID INT IDENTITY(1,1) PRIMARY KEY,
	CONTENT VARCHAR(500) NOT NULL,
	DATEOFCOMMENT DATETIME DEFAULT GETDATE(),
	COMMENTED_POST_ID INT,
	COMMENTATOR_ID INT,

	FOREIGN KEY (COMMENTED_POST_ID) REFERENCES POST(POST_ID) ,
	FOREIGN KEY (COMMENTATOR_ID) REFERENCES USERS(USER_ID) ,
) 

CREATE TABLE REACTION_TYPE(
	REACTION_TYPE_ID INT IDENTITY(1,1) PRIMARY KEY,
	NAME VARCHAR(50) NOT NULL,
)
SELECT * FROM COMMENTS
CREATE TABLE REACTION(
	REACTION_ID INT IDENTITY(1,1),
	REACTION_POST_ID INT,
	R_COMMENT_ID INT,
	R_USER_ID INT,
	REACTION_TYPE_ID INT,
	TIMESTAMP DATETIME DEFAULT GETDATE(),

	PRIMARY KEY(REACTION_ID),

	FOREIGN KEY(REACTION_POST_ID) REFERENCES POST(POST_ID) ,
	FOREIGN KEY(R_USER_ID ) REFERENCES USERS(USER_ID) ,
	FOREIGN KEY(REACTION_TYPE_ID) REFERENCES REACTION_TYPE(REACTION_TYPE_ID) ,
	FOREIGN KEY(R_COMMENT_ID) REFERENCES COMMENTS(COMMENT_ID) ,
)
CREATE TABLE PAGE_FOLLOWERS
(
	F_PAGE_ID INT,
	FOLLOWER_ID INT,
	ROLE_TYPE VARCHAR(50) DEFAULT 'FOLLOWER',

	PRIMARY KEY (F_PAGE_ID,FOLLOWER_ID),
	FOREIGN KEY (F_PAGE_ID) REFERENCES PAGE(PAGE_ID),
	FOREIGN KEY (FOLLOWER_ID) REFERENCES USERS(USER_ID),
)

CREATE TABLE GROUP_MEMBERS
(
	M_GROUP_ID INT,
	MEMBER_ID INT,
	ROLE_TYPE VARCHAR(50) DEFAULT 'MEMBER',

	PRIMARY KEY(M_GROUP_ID,MEMBER_ID),
	FOREIGN KEY	(M_GROUP_ID) REFERENCES GROUPS(GROUP_ID),
	FOREIGN KEY (MEMBER_ID) REFERENCES USERS(USER_ID)
)
----------------------ALTER TABLES------------------------
ALTER TABLE FRIENDSHIP
ADD USER_ID_MIN AS (CASE WHEN USER1_ID < USER2_ID THEN USER1_ID ELSE USER2_ID END) PERSISTED,
    USER_ID_MAX AS (CASE WHEN USER1_ID> USER2_ID THEN USER1_ID ELSE USER2_ID END) PERSISTED;

ALTER TABLE FRIENDSHIP
ADD CONSTRAINT unique_friendship UNIQUE (USER_ID_MIN, USER_ID_MAX);

ALTER TABLE FRIENDSHIP
ADD  REQUEST_STATUS VARCHAR(50) DEFAULT 'Pending',
	REQUESTED_BY INT;

ALTER TABLE FRIENDSHIP
ADD FOREIGN KEY (REQUESTED_BY) REFERENCES USERS(USER_ID);

UPDATE Friendship
SET REQUESTED_BY = CASE 
    WHEN USER1_ID < USER2_ID THEN USER1_ID
    ELSE USER2_ID
END;

ALTER TABLE PAGE
ADD FOLLOWERS_COUNTER INT DEFAULT 0

ALTER TABLE GROUPS
ADD MEMBERS_COUNTER INT DEFAULT 0
---------------------ALTER TABLES-------------------------
-----------------------TABLES AND TABLE CHANGES-----------------------------------

---------------------TRIGERS-----------------------------------------------
CREATE TRIGGER trg_UpdateFriendCount_Insert
ON FRIENDSHIP
AFTER INSERT
AS
BEGIN
    -- Update FRIENDS_COUNTER for each user involved in the inserted friendships
    UPDATE USERS
    SET FRIENDS_COUNTER = (
        SELECT COUNT(*)
        FROM FRIENDSHIP
        WHERE USER1_ID = USERS.USER_ID OR USER2_ID = USERS.USER_ID
    )
    WHERE USER_ID IN (
        SELECT USER1_ID FROM inserted
        UNION 
        SELECT USER2_ID FROM inserted
    );
END;

CREATE TRIGGER trg_UpdateFriendCount_Delete
ON FRIENDSHIP
AFTER DELETE
AS
BEGIN
    -- Decrease FRIENDS_COUNTER for each user involved in the deleted friendships
    UPDATE USERS
    SET FRIENDS_COUNTER = (
        SELECT COUNT(*)
        FROM FRIENDSHIP
        WHERE USER1_ID = USERS.USER_ID OR USER2_ID = USERS.USER_ID
    )
    WHERE USER_ID IN (
        SELECT USER1_ID FROM deleted
        UNION 
        SELECT USER2_ID FROM deleted
    );
END;


CREATE TRIGGER trg_UpdateReactionsCounter_Insert
ON REACTION
AFTER INSERT
AS
BEGIN
    -- Update REACTIONS_COUNTER for each post involved in the inserted reactions
    UPDATE POST
    SET REACTIONS_COUNTER = (
        SELECT COUNT(*)
        FROM REACTION
        WHERE REACTION_POST_ID = POST.POST_ID
    )
    WHERE POST_ID IN (SELECT REACTION_POST_ID FROM inserted);
END;

CREATE TRIGGER trg_UpdateReactionsCounter_Delete
ON REACTION
AFTER DELETE
AS
BEGIN
    -- Update REACTIONS_COUNTER for each post involved in the deleted reactions
    UPDATE POST
    SET REACTIONS_COUNTER = (
        SELECT COUNT(*)
        FROM REACTION
        WHERE REACTION_POST_ID = POST.POST_ID
    )
    WHERE POST_ID IN (SELECT REACTION_POST_ID FROM deleted);
END;

CREATE TRIGGER trg_UpdatePageFollowersCounter_Insert
ON PAGE_FOLLOWERS
AFTER INSERT
AS
BEGIN
    -- Update REACTIONS_COUNTER for each post involved in the inserted reactions
    UPDATE PAGE
    SET FOLLOWERS_COUNTER = (
        SELECT COUNT(*)
        FROM PAGE_FOLLOWERS
        WHERE F_PAGE_ID = PAGE.PAGE_ID
    )
    WHERE PAGE_ID IN (SELECT F_PAGE_ID FROM inserted);
END;

CREATE TRIGGER trg_UpdatePageFollowersCounter_Delete
ON PAGE_FOLLOWERS
AFTER DELETE
AS
BEGIN
    UPDATE PAGE
    SET FOLLOWERS_COUNTER = (
        SELECT COUNT(*)
        FROM PAGE_FOLLOWERS
        WHERE F_PAGE_ID = PAGE.PAGE_ID
    )
    WHERE PAGE_ID IN (SELECT F_PAGE_ID FROM deleted);
END;

---------------------TRIGERS-----------------------------------------------
---------------------DATA LOADING------------------------------------------
INSERT INTO USERS (NAME, PASSWORD, EMAIL, DATEOFBIRTH)
VALUES 
    ('Иван Георгиев', 'парола123', 'ivan.georgiev@example.com', '1990-02-15'),
    ('Мария Петрова', 'securePass456', 'maria.petrova@example.com', '1985-09-22'),
    ('Александър Николов', 'alexaPwd789', 'alexandar.nikolov@example.com', '1992-11-10'),
    ('Елена Димитрова', 'elenaSecret321', 'elena.dimitrova@example.com', '1988-05-03'),
    ('Георги Иванов', 'georgiPass654', 'georgi.ivanov@example.com', '1995-07-18'),
    ('Стефка Христова', 'stefkaPwd123', 'stefka.hristova@example.com', '1993-01-25');

INSERT INTO FRIENDSHIP(USER1_ID,USER2_ID,FRIENDS_SINCE)
VALUES 
	('1','6',GETDATE()),
	('2','6',GETDATE()),
	('3','6',GETDATE()),
	('4','5',GETDATE()),
	('4','1',GETDATE())
 
 INSERT INTO FRIENDSHIP(USER1_ID,USER2_ID,FRIENDS_SINCE)
VALUES 
	('4','6',GETDATE()),
	('2','5',GETDATE()),
	('3','5',GETDATE()),
	('2','1',GETDATE())

INSERT INTO REACTION_TYPE(NAME)
VALUES
	('Like'),
	('Love'),
	('Care'),
	('Haha'),
	('Wow'),
	('Sad'),
	('Angry')

SELECT * FROM REACTION_TYPE

INSERT INTO POST (CONTENT, TIMESTAMP, CREATOR_ID)
VALUES
    ('Днешният ден е прекрасен! Няма нищо по-хубаво от слънцето.', GETDATE(), 1),
    ('Току-що приключих новата си книга. Препоръчвам я!', GETDATE(), 2),
    ('Спомени от детството - незабравими моменти!', GETDATE(), 3),
    ('Какво ще кажете за този нов ресторант в града?', GETDATE(), 4),
    ('Честит рожден ден на най-добрия приятел!', GETDATE(), 5),
    ('Планираме пътуване до морето! Кой е готов за приключения?', GETDATE(), 6);

INSERT INTO REACTION (REACTION_POST_ID, R_COMMENT_ID, R_USER_ID, REACTION_TYPE_ID)
VALUES
    (1, NULL, 2, 1),  -- Мария Петрова (User ID 2) likes Иван Георгиев's post (Post ID 1)
    (1, NULL, 3, 2),  -- Александър Николов (User ID 3) loves Иван Георгиев's post (Post ID 1)
    (2, NULL, 1, 3),  -- Иван Георгиев (User ID 1) cares for Мария Петрова's post (Post ID 2)
    (2, NULL, 4, 4),  -- Елена Димитрова (User ID 4) finds Мария Петрова's post (Post ID 2) funny
    (3, NULL, 5, 5),  -- Георги Иванов (User ID 5) is wowed by Александър Николов's post (Post ID 3)
    (4, NULL, 6, 6),  -- Стефка Христова (User ID 6) feels sad about Елена Димитрова's post (Post ID 4)
    (5, NULL, 3, 7),  -- Александър Николов (User ID 3) is angry about Георги Иванов's birthday post (Post ID 5)
    (6, NULL, 1, 1),  -- Иван Георгиев (User ID 1) likes Стефка Христова's travel post (Post ID 6)
    (1, NULL, 4, 2),  -- Елена Димитрова (User ID 4) loves Иван Георгиев's post (Post ID 1)
    (3, NULL, 2, 4);  -- Мария Петрова (User ID 2) finds Александър Николов's post (Post ID 3) funny

INSERT INTO PAGE (NAME, DESCRIPTION, ADMIN_ID) VALUES 
('Travel Enthusiasts', 'A community for sharing travel experiences, tips, and destinations.', 1),
('Healthy Recipes', 'Explore delicious and nutritious recipes for a healthier lifestyle.', 2),
('Tech Innovations', 'Stay updated on the latest technology trends and innovations.', 3),
('Book Lovers Club', 'Join fellow readers to discuss and recommend your favorite books.', 4),
('Fitness Motivation', 'A place for fitness enthusiasts to inspire and motivate each other.', 5),
('Art & Creativity', 'Share your artwork and discover new creative techniques and ideas.', 6);

INSERT INTO PAGE_FOLLOWERS
VALUES 
	(1,5),
	(1,6),
	(2,3),
	(1,3)

	
SELECT U1.NAME AS USER_NAME, 
	   U2.NAME AS FRIEND_WITH
FROM FRIENDSHIP F 
	JOIN USERS U1 ON F.USER1_ID = U1.USER_ID
	JOIN USERS U2 ON F.USER2_ID = U2.USER_ID

SELECT * FROM PAGE
SELECT * FROM USERS

---------------------PROCEDURES--------------------------------------------------------------------------
CREATE PROCEDURE dbo.AddUser
	@Name VARCHAR(50),
	@Password VARCHAR(50),
	@Email VARCHAR(50),
	@DateOfBirth DATE
AS
BEGIN 
	INSERT INTO USERS(NAME,PASSWORD,EMAIL,DATEOFBIRTH)
	VALUES(@Name,@Password,@Email,@DateOfBirth);

	Print 'User added succesfully';
END;

CREATE PROCEDURE MAKE_FOLLOWER_ADMIN
	@PAGE_ID INT,
	@FOLLOWER_ID INT
AS
BEGIN
	UPDATE PAGE_FOLLOWERS
	SET ROLE_TYPE = 'ADMIN'
	WHERE F_PAGE_ID = @PAGE_ID AND FOLLOWER_ID = @FOLLOWER_ID
END;


CREATE PROCEDURE MAKE_MEMBER_ADMIN
	@GROUP_ID INT,
	@MEMBER_ID INT
AS
BEGIN
	UPDATE GROUP_MEMBERS
	SET ROLE_TYPE = 'ADMIN'
	WHERE M_GROUP_ID = @GROUP_ID AND MEMBER_ID = @MEMBER_ID
END;


CREATE PROCEDURE GetPostReactionsSummary
    @PostId INT
AS
BEGIN
    SELECT 
        P.POST_ID,
        P.CONTENT AS PostContent,
        P.TIMESTAMP AS PostTimestamp,
        P.CREATOR_ID AS PostCreatorId,
        P.REACTIONS_COUNTER AS TotalReactions,
        P.COMMENTS_COUNTER AS TotalComments,
        
        -- Брой на реакциите за всеки тип с помощта на CASE
        SUM(CASE WHEN R.REACTION_TYPE_ID = 1 THEN 1 ELSE 0 END) AS LikeCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 2 THEN 1 ELSE 0 END) AS LoveCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 3 THEN 1 ELSE 0 END) AS CareCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 4 THEN 1 ELSE 0 END) AS HahaCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 5 THEN 1 ELSE 0 END) AS WowCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 6 THEN 1 ELSE 0 END) AS SadCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 7 THEN 1 ELSE 0 END) AS AngryCount
    FROM 
        POST P
    LEFT JOIN 
        REACTION R ON P.POST_ID = R.REACTION_POST_ID
    WHERE 
        P.POST_ID = @PostId
    GROUP BY 
        P.POST_ID, P.CONTENT, P.TIMESTAMP, P.CREATOR_ID, P.REACTIONS_COUNTER, P.COMMENTS_COUNTER;
END;

CREATE PROCEDURE GetCommentReactionsSummary
    @CommentId INT
AS
BEGIN
    SELECT 
        C.COMMENT_ID,
        C.CONTENT AS CommentContent,
        C.DATEOFCOMMENT AS CommentTimestamp,
        C.COMMENTED_POST_ID AS RelatedPostId,
        C.COMMENTATOR_ID AS CommentatorId,
        C.REACTIONS_COUNTER AS TotalReactions,

        -- Брой на реакциите за всеки тип с помощта на CASE
        SUM(CASE WHEN R.REACTION_TYPE_ID = 1 THEN 1 ELSE 0 END) AS LikeCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 2 THEN 1 ELSE 0 END) AS LoveCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 3 THEN 1 ELSE 0 END) AS CareCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 4 THEN 1 ELSE 0 END) AS HahaCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 5 THEN 1 ELSE 0 END) AS WowCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 6 THEN 1 ELSE 0 END) AS SadCount,
        SUM(CASE WHEN R.REACTION_TYPE_ID = 7 THEN 1 ELSE 0 END) AS AngryCount
    FROM 
        COMMENTS C
    LEFT JOIN 
        REACTION R ON C.COMMENT_ID = R.R_COMMENT_ID
    WHERE 
        C.COMMENT_ID = @CommentId
    GROUP BY 
        C.COMMENT_ID, C.CONTENT, C.DATEOFCOMMENT, C.COMMENTED_POST_ID, C.COMMENTATOR_ID, C.REACTIONS_COUNTER;
END;

---------------------PROCEDURES--------------------------------------------------------------------------
---------------------FUNCTIONS--------------------------------------------------------------------------
CREATE FUNCTION dbo.GetUsersFriends()
RETURNS TABLE
AS
RETURN(
	SELECT U1.NAME AS USER_NAME, 
	   U2.NAME AS FRIEND_WITH
FROM FRIENDSHIP F 
	JOIN USERS U1 ON F.USER1_ID = U1.USER_ID
	JOIN USERS U2 ON F.USER2_ID = U2.USER_ID
)
CREATE FUNCTION GetPageFollowersInfo()
RETURNS TABLE
AS
RETURN(
	SELECT PF.F_PAGE_ID, P.NAME AS PAGE_TITLE, PF.FOLLOWER_ID, U.NAME AS USERNAME
	FROM PAGE_FOLLOWERS PF 
	JOIN PAGE P ON PF.F_PAGE_ID = P.PAGE_ID
	JOIN USERS U ON PF.FOLLOWER_ID = U.USER_ID
)

---------------------FUNCTIONS--------------------------------------------------------------------------
SELECT * FROM POST WHERE POST_ID = 1
SELECT * FROM REACTION
SELECT * FROM COMMENTS
SELECT * FROM REACTION_TYPE
SELECT * FROM dbo.GetUsersFriends()
EXEC GetPostReactionsSummary @PostId = 2;
EXEC GetCommentReactionsSummary @CommentId = 12;
EXEC dbo.AddUser @Name = 'Иван Георгиев' , @Password = 'e46naidobroto',@Email = 'e46lover@gmail.com',@DateOfBirth = '1996-02-12';
SELECT * FROM GetPageFollowersInfo()
EXEC MAKE_FOLLOWER_ADMIN @PAGE_ID=1,@FOLLOWER_ID = 5;
SELECT * FROM PAGE_FOLLOWERS
SELECT * FROM GROUP_MEMBERS
EXEC MAKE_MEMBER_ADMIN @GROUP_ID = 1, @MEMBER_ID = 12

UPDATE Friendship
SET REQUEST_STATUS = 'Accepted', FRIENDS_SINCE = CURRENT_TIMESTAMP
WHERE USER1_ID = 11 AND USER2_ID = 13 AND REQUEST_STATUS = 'Pending';
SELECT * FROM FRIENDSHIP
SELECT * FROM PAGE