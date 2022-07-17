create database Twitter_Clone;

Use Twitter_clone

/* create tables on which the social_media clone would be based on */
/* twitter handle */

CREATE TABLE users(
	id INT AUTO_INCREMENT UNIQUE PRIMARY KEY,
	username VARCHAR(255) NOT NULL,
	created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE posts(
	id INT AUTO_INCREMENT PRIMARY KEY,
	post_text VARCHAR(355) NOT NULL,
	user_id INT NOT NULL,
	created_dat TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id)
);


CREATE TABLE comments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	comment_text VARCHAR(255) NOT NULL,
	user_id INT NOT NULL,
    post_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(post_id) REFERENCES posts(id)
    
);


CREATE TABLE likes(
	user_id INT NOT NULL,
    post_id INT NOT NULL,
	created_at TIMESTAMP DEFAULT NOW(),
	FOREIGN KEY(user_id) REFERENCES users(id),
    foreign key(post_id) REFERENCES posts(id),
	PRIMARY KEY(user_id,post_id)
);



CREATE TABLE retweets(
	user_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY(user_id) REFERENCES users(id),
    foreign key(post_id) REFERENCES posts(id),
	PRIMARY KEY(user_id,post_id)

)

/* insert into values into these tables */
Insert into Users (username) Values ('Adewale'), ('John Irabor'), ('Davido Adeleke'), ('Opeyemi Nafiu'), ('Jackson Adeleke'), ('Mummy Grandson'), ('Toni Adeyinka'), ('Achodo Ephraim'), ('Ugochukwu Adeniran'), ('Wizkid Ayo'), ('Kevin Hart'), ('Emmanuel Adeleke');

/* check table */
select *
from likes

Insert into Posts (post_text, user_id) Values ('Osun election is a success', 5), ('Spatialnode is an amazing startup', 4), ('Come for my comedy show', 11), ('Releasing MIL today', 10), ('Craving rice and parfait', 1), ('Happy birthday', 3), ('Peter obi gats win this election o', 5), ('Lewandowski is a done deal', 10), ('Tupac is still alive', 7), ('Adeleke!!!', 1);
select*
from Posts

/* Insert into table comments */
Insert into Comments (comment_text, user_id, post_id) Values ('Wizkid man', 6, 4)

Insert into Comments (comment_text, user_id, post_id) Values ('Davido is better, ABT to the rescue', 7, 4)

Insert into Comments (comment_text, user_id, post_id) Values ('Omo Tem outdid herself on essence', 8, 4), ('Ifb', 9,4)
select*
from comments


Insert into retweets(user_id, post_id) Values (1, 4), (2,4), (3,4), (4,4), (5,4), (1,5), (2,5), (4,5), (1,1), (2,1), (3,1),(4,1), (7,1)

select*
from likes

/*Insert into likes table */
Insert into likes(user_id, post_id) Values (1, 4), (2,4), (3,4), (4,4), (5,4), (1,5), (2,5), (4,5), (1,1), (2,1), (3,1),(4,1), (7,1)

/* exploring the tables */
SELECT * FROM users
ORDER BY created_at
LIMIT 7

SELECT date_format(created_at,'%W') AS 'day of the week', COUNT(*) AS 'total registration'
FROM users
GROUP BY 1
ORDER BY 2 DESC;


/* find inactive users by post activity */
SELECT username
FROM users
LEFT JOIN posts ON users.id = posts.user_id
WHERE posts.id IS NULL;

/*find date where posts are made more */ 
Select date_format(created_at,'%W') AS 'day of the week', post_text
from users
join posts on users.id = posts.user_id



/* rank posts with more likes */
select post_text, count(post_text) as number_of_likes
from posts
join likes on posts.post_id = likes.post_id 
group by number_of_likes
order by number_of_likes desc;

/* rank users with the most activity per post */
select users.username, user_id, count(post_text) as number_of_posts
from users
join posts on users.id = posts.user_id
group by username
order by number_of_posts desc

/* rank by number of posts and engagements on their posts */




/* most likes per single post */
SELECT posts.id as post_id, post_text, COUNT(*) AS Total_Likes, users.id
FROM likes
JOIN posts ON posts.id = likes.post_id
JOIN users ON users.id = likes.user_id
GROUP BY posts.id
ORDER BY Total_Likes desc
Limit 3;

/* most retweets per single post */
Select posts.id, post_text, count(*) as total_retweets
from retweets
JOIN posts ON posts.id = retweets.post_id
JOIN users ON users.id = retweets.user_id
GROUP BY posts.id
order by total_retweets desc
limit 1;

/* rank users with the most retweets, postings */

select posts.user_id, post_text, posts.id, count(*) as number_of_likes
from likes
join posts on posts.id = likes.post_id 
join users on users.id = likes.user_id
group by posts.id
order by number_of_likes desc


SELECT users.username, COUNT(posts.post_text) as posts_number
FROM users
JOIN posts ON users.id = posts.user_id
GROUP BY users.id
ORDER BY 2 DESC;

SELECT ROUND((SELECT COUNT(*)FROM posts)/(SELECT COUNT(*) FROM users),2) as average_posts_user

SELECT SUM(user_posts.total_posts_per_user)
FROM (SELECT users.username,COUNT(posts.post_text) AS total_posts_per_user
		FROM users
		JOIN posts ON users.id = posts.user_id
		GROUP BY users.id) AS user_posts;

/* post per user */
SELECT users.username, users.id, COUNT(posts.post_text) AS total_posts_per_user
FROM users
JOIN posts ON users.id = posts.user_id
GROUP BY users.id

/* users who have commented and their comments */ 
SELECT username, comment_text
FROM users
JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS not NULL;


SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NULL;

SELECT COUNT(*) FROM
(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NULL) AS total_number_of_users_without_comments;
    

