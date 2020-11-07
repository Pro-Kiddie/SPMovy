CREATE DATABASE  IF NOT EXISTS `assignment` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `assignment`;
-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: assignment
-- ------------------------------------------------------
-- Server version	5.7.21-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `booking` (
  `bookingID` int(11) NOT NULL AUTO_INCREMENT,
  `userID` varchar(50) NOT NULL,
  `scheduleID` int(11) NOT NULL,
  `noTickets` int(11) NOT NULL,
  `seatNo` varchar(45) DEFAULT NULL,
  `status` set('hold','paid') DEFAULT NULL,
  PRIMARY KEY (`bookingID`),
  KEY `user_idx` (`userID`),
  KEY `schedule_idx` (`scheduleID`),
  CONSTRAINT `schedule` FOREIGN KEY (`scheduleID`) REFERENCES `schedule` (`scheduleID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user` FOREIGN KEY (`userID`) REFERENCES `user` (`userID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `booking`
--

LOCK TABLES `booking` WRITE;
/*!40000 ALTER TABLE `booking` DISABLE KEYS */;
INSERT INTO `booking` VALUES (16,'test',8,3,'F9,F10,F11','paid'),(18,'test',8,2,'D6,D7','paid'),(19,'test',11,1,'G15','paid'),(23,'test',11,2,'E10,E11','paid'),(24,'test',13,5,'F11,F12,F13,F14,F15','paid'),(25,'test',14,2,'E10,E11','paid'),(31,'test',12,2,'E11,E12','paid'),(32,'test',11,3,'F13,F14,F15','paid'),(33,'test',2,5,'F12,F13,F14,F15,F16','paid'),(36,'test',8,2,'H14,H15','paid'),(39,'AnaMarie',8,3,'I9,I10,I11','paid'),(49,'test',8,2,'G7,G8','paid'),(50,'test',8,2,'C6,C7','paid'),(51,'test',8,2,'E20,F1','paid'),(77,'test',17,2,'D12,E14','paid'),(79,'test',14,2,'H10,H11','paid'),(81,'AnaMarie',22,2,'F13,F14','paid');
/*!40000 ALTER TABLE `booking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cinema`
--

DROP TABLE IF EXISTS `cinema`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cinema` (
  `cinemaID` int(11) NOT NULL AUTO_INCREMENT,
  `cinemaName` varchar(45) NOT NULL,
  PRIMARY KEY (`cinemaID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cinema`
--

LOCK TABLES `cinema` WRITE;
/*!40000 ALTER TABLE `cinema` DISABLE KEYS */;
INSERT INTO `cinema` VALUES (1,'Dover'),(2,'Causeway Point'),(3,'Orchard ION');
/*!40000 ALTER TABLE `cinema` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre`
--

DROP TABLE IF EXISTS `genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genre` (
  `genreID` int(11) NOT NULL AUTO_INCREMENT,
  `genreName` varchar(45) NOT NULL,
  `description` varchar(5000) NOT NULL,
  PRIMARY KEY (`genreID`),
  UNIQUE KEY `genreName_UNIQUE` (`genreName`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre`
--

LOCK TABLES `genre` WRITE;
/*!40000 ALTER TABLE `genre` DISABLE KEYS */;
INSERT INTO `genre` VALUES (3,'Horror','Horror Films are unsettling films designed to frighten and panic, cause dread and alarm, and to invoke our hidden worst fears, often in a terrifying, shocking finale, while captivating and entertaining us at the same time in a cathartic experience. Horror films effectively center on the dark side of life, the forbidden, and strange and alarming events. They deal with our most primal nature and its fears: our nightmares, our vulnerability, our alienation, our revulsions, our terror of the unknown, our fear of death and dismemberment, loss of identity, or fear of sexuality.'),(4,'Thriller','Thrillers movies are defined by the moods they elicit, giving viewers heightened feelings of suspense, excitement, surprise, anticipation and anxiety.'),(5,'Romance','Romance movies are love stories focus on passion, emotion, and the affectionate romantic involvement of the main characters and the journey that their genuinely romantic love takes them through dating, courtship or marriage.'),(6,'Comedy','Comedy is a genre of film in which the main emphasis is on humor. These films are designed to make the audience laugh through amusement.'),(9,'Sci-Fiction','Star wars');
/*!40000 ALTER TABLE `genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `genre_movie`
--

DROP TABLE IF EXISTS `genre_movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genre_movie` (
  `genreID` int(11) NOT NULL,
  `movieID` int(11) NOT NULL,
  PRIMARY KEY (`genreID`,`movieID`),
  KEY `movieID_idx` (`movieID`),
  CONSTRAINT `Link_Genre_Movie_1` FOREIGN KEY (`genreID`) REFERENCES `genre` (`genreID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Link_Genre_Movie_2` FOREIGN KEY (`movieID`) REFERENCES `movie` (`movieID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `genre_movie`
--

LOCK TABLES `genre_movie` WRITE;
/*!40000 ALTER TABLE `genre_movie` DISABLE KEYS */;
INSERT INTO `genre_movie` VALUES (3,6),(6,6),(3,7),(5,7),(4,8),(9,8),(5,9),(6,9),(6,11);
/*!40000 ALTER TABLE `genre_movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movie`
--

DROP TABLE IF EXISTS `movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `movie` (
  `movieID` int(5) NOT NULL AUTO_INCREMENT,
  `movieTitle` varchar(45) NOT NULL,
  `actorList` varchar(500) NOT NULL,
  `releaseDate` date NOT NULL,
  `synopsis` varchar(5000) NOT NULL,
  `duration` int(11) NOT NULL,
  `status` set('showing','coming','over') NOT NULL,
  PRIMARY KEY (`movieID`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movie`
--

LOCK TABLES `movie` WRITE;
/*!40000 ALTER TABLE `movie` DISABLE KEYS */;
INSERT INTO `movie` VALUES (5,'Truth Or Dare','Lucy Hale, Tyler Posey, Violett Beane, Nolan Gerard Funk, Hayden Szeto, Sophia Taylor Ali','2018-05-10','Lucy Hale (Pretty Little Liars) and Tyler Posey (Teen Wolf) lead the cast of Blumhouses Truth or Dare, a supernatural thriller from Blumhouse Productions (Happy Death Day, Get Out, Split). A harmless game of Truth or Dare among friends turns deadly when someone or something begins to punish those who tell a lie or refuse the dare. ',120,'showing'),(6,'Deadpool 2','Ryan Reynolds, Josh Brolin, Zazie Beetz, Brianna Hildebrand','2018-05-17','After surviving a near fatal bovine attack, a disfigured cafeteria chef (Wade Wilson) struggles to fulfill his dream of becoming Mayberry\'s hottest bartender while also learning to cope with his lost sense of taste. Searching to regain his spice for life, as well as a flux capacitor, Wade must battle ninjas, the yakuza, and a pack of sexually aggressive canines, as he journeys around the world to discover the importance of family, friendship, and flavor - finding a new taste for adventure and earning the coveted coffee mug title of World\'s Best Lover. ',120,'showing'),(7,'Sakura Guardian In The North','Sayuri Yoshinaga, Masato Sakai, Ryoko Shinohara','2018-05-10','Spring of 1945, cherry blossoms flower in southern Sakhalin, a symbol of hope for Tetsu Ezure and her family. But with the Soviet Union\'s invasion the following August they flee to Abashiri, Hokkaido, to a life of harsh cold and hunger through which they struggle to survive. 1971, younger son Shujiro, now grown, has returned to Japan where he meets his mother for the first time in fifteen years.',126,'coming'),(8,'I Kill Giants','Imogen Poots, Madison Wolfe, Sydney Wade, Zoe Saldana','2018-05-10','Barbara Thorson (Madison Wolfe) is a teenage girl who escapes the realities of school and a troubled family life by retreating into her magical world of fighting evil giants. With the help of her new friend Sophia (Sydney Wade) and her school counselor (Zoe Saldana), Barbara learns to face her fears and battle the giants that threaten her world.',101,'showing'),(9,'Dude\'s Manual','Zhong Chuxi, Chun Xia, Dong Zijian','2018-05-23','He Xiaoyang, who is single for four years, is mistaken as head girl Guan Xin\'s love interest by accident. To get rid of He Xiaoyang, Guan Xin decides to help him pursue the most beautiful girl in campus Li Shushu. With Guan Xin\'s help, He Xiaoyang learns the most efficient way to pursue a girl. But he can\'t figure out whether there is really a way to face his true love.',101,'over'),(11,'Ah Boys to Man 5','Anlin, Ana, Samuel','2018-05-22','Yay',120,'coming');
/*!40000 ALTER TABLE `movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `review` (
  `reviewID` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `rating` decimal(3,1) NOT NULL,
  `comments` varchar(5000) NOT NULL,
  `movieID` int(11) NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reviewID`,`movieID`),
  KEY `Link_Movie_Review_idx` (`movieID`),
  CONSTRAINT `Link_Movie_Review` FOREIGN KEY (`movieID`) REFERENCES `movie` (`movieID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (11,'Anlin',0.0,'First to comment.',5,'2018-05-18 02:58:33'),(12,'Miranda Ker',7.0,'Anlin is the most awesome programmer ever!',5,'2018-05-18 17:21:20'),(13,'Mr.Low',3.5,'hi',6,'2018-05-25 16:07:33'),(16,'Anlin',5.0,'&lt;script&gt;alert(\'XSS\')&lt;/script&gt;',6,'2018-07-16 14:22:33'),(22,'Attacker',6.5,'&lt;form&gt;password: &lt;input type=&quot;text&quot; name=&quot;passwd&quot;/&gt;&lt;/form&gt; will ',6,'2018-08-05 12:08:35');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedule` (
  `scheduleID` int(11) NOT NULL AUTO_INCREMENT,
  `movieID` int(5) NOT NULL,
  `cinemaID` int(11) NOT NULL,
  `date` date NOT NULL,
  `timeslot` time NOT NULL,
  `price` decimal(4,2) NOT NULL,
  `tickets` int(11) DEFAULT '50',
  PRIMARY KEY (`scheduleID`,`movieID`,`cinemaID`,`date`,`timeslot`),
  KEY `scheduleOfMovie_idx` (`movieID`),
  KEY `cinemaSchedule_idx` (`cinemaID`),
  CONSTRAINT `cinemaSchedule` FOREIGN KEY (`cinemaID`) REFERENCES `cinema` (`cinemaID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `scheduleOfMovie` FOREIGN KEY (`movieID`) REFERENCES `movie` (`movieID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` VALUES (2,6,2,'2018-07-11','11:30:00',12.80,43),(8,6,1,'2018-07-11','15:30:00',7.50,30),(9,6,3,'2018-07-15','10:00:00',13.00,0),(11,5,3,'2018-07-19','10:30:00',8.50,42),(12,6,1,'2018-07-11','14:10:00',13.00,48),(13,6,1,'2018-07-11','18:00:00',7.50,41),(14,6,1,'2018-07-21','10:40:00',13.00,46),(15,6,1,'2018-07-21','11:10:00',13.00,0),(16,5,2,'2018-08-03','10:20:00',8.30,48),(17,5,2,'2018-08-03','11:40:00',8.30,46),(18,5,2,'2018-08-03','16:10:00',13.30,48),(19,8,1,'2018-08-23','10:30:00',8.30,50),(20,8,1,'2018-08-23','13:20:00',8.30,50),(21,8,2,'2018-07-11','10:20:00',13.00,50),(22,8,2,'2018-07-11','12:40:00',13.00,48),(23,8,3,'2018-07-10','10:30:00',9.80,50),(24,8,3,'2018-07-10','15:00:00',9.80,50);
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `userID` varchar(50) NOT NULL,
  `password` char(166) NOT NULL,
  `role` varchar(45) NOT NULL,
  `fName` varchar(45) NOT NULL,
  `lName` varchar(45) NOT NULL,
  `email` varchar(150) NOT NULL,
  `contact` char(11) NOT NULL,
  `cc` char(19) NOT NULL,
  PRIMARY KEY (`userID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('admin','1000:7693975c00dd378811183feba4fa2faa:13fae27271556a8f52fb36baefbe9d43e51b889bd989befb77b6b82f251fbf772e75e268090cae2ebc2300f896a7ad1d516d968107fa8c0a1251e00a6deb323b','admin','Anlin','Yang','anlin.17@ichat.sp.edu.sg','90786276','4657 9387 0294 8275'),('AnaMarie','1000:5259e6728641c1bb930342db2642cf1a:0023eb524422388515b8264346502a57a20b03edfd6e7bd1776e5131c53b99dc71761d51610efc1f4aee6b6d3764774a2ba7fea2f59bd1dd3eb8ce4d590eceb7','member','Ana','Marie Del Rio De Vera','ana.17@ichat.sp.edu.sg','94872958','5938 3920 6938 3059'),('test','1000:cc74708b8267f148dd0082bbb28bb1d7:d26ea78009f4efc1018097b20bce2ee83e57ffda8140caf4f72502b947473c7f40f6860515dd6838514d6c938c2373322cfc64b0a604705558455b95d9dfd007','member','Alvin','Low','test@example.com','69409380','4000 5000 6000 7000');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'assignment'
--
/*!50003 DROP PROCEDURE IF EXISTS `addBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addBooking`(in scheduleID0 int, in userID0 varchar(50), in noTickets0 int, out id int, out balance int)
BEGIN
    insert into booking (userID, scheduleID, noTickets, status)
    values (userID0, scheduleID0, noTickets0, 'hold');
    
    update schedule set tickets=tickets-noTickets0 where scheduleID=scheduleID0;
    
    SELECT LAST_INSERT_ID() into id;
    SELECT tickets into balance from schedule where scheduleID=scheduleID0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addGenre` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addGenre`(in genreName0 varchar(45), in description0 varchar(5000))
BEGIN
	insert into genre (genreName,description)
    values (genreName0,description0);
    
    select LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `addMovie` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addMovie`(IN movieTitle0 varchar(45), IN actorList0 varchar(500), IN releaseDate0 date, IN synopsis0 varchar(5000), IN duration0 int, IN status0 varchar(10))
BEGIN

	insert into movie
    (movieTitle,actorList,releaseDate,synopsis,duration,status)
    values
    (movieTitle0,actorList0,releaseDate0,synopsis0,duration0,status0);
    
	select LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteBooking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBooking`(in bookingID0 int, in scheduleID0 int, in noTickets int)
BEGIN
	delete from booking where bookingID=bookingID0;
    update schedule set tickets=tickets+noTickets where scheduleID=scheduleID0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `displayMoviesInGenre` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `displayMoviesInGenre`(in s_genreName varchar(45))
BEGIN
	declare gID int default null;
	select genreID into gID from genre where LOWER(genreName) like LOWER(CONCAT('%',s_genreName,'%'));
	if gID is not null then
		select * from genre_movie gm, movie m where gm.genreID = gID and gm.movieID = m.movieID order by releaseDate DESC;
	end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `new_procedure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_procedure`(in moviename Int, in catIDs int )
BEGIN
insert into hall (Threater_ThreaterId, HallNo)
Values
(threaterId, HallNo);
SET @hallif = LAST_INSERT_ID();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-08-05 12:17:33
