-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:4306
-- Generation Time: Nov 15, 2024 at 03:38 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `airline_management_system`
--
CREATE DATABASE IF NOT EXISTS `airline_management_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `airline_management_system`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `AddNewFlight`$$
CREATE DEFINER=`` PROCEDURE `AddNewFlight` (IN `flightcode` VARCHAR(6), IN `source` VARCHAR(30), IN `destination` VARCHAR(30), IN `takeoff` VARCHAR(30), IN `noofseat` BIGINT)   BEGIN
    -- Insert the new flight into the manageflight table
    INSERT INTO manageflight (flightcode, source, destination, takeoff, noofseat)
    VALUES (flightcode, source, destination, takeoff, noofseat);

    -- Return a success message
    SELECT 'Flight added successfully!' AS message;
END$$

DROP PROCEDURE IF EXISTS `CalculateTotalRevenue`$$
CREATE DEFINER=`` PROCEDURE `CalculateTotalRevenue` (IN `flightCode` VARCHAR(6))   BEGIN
    DECLARE totalRevenue DECIMAL(10,2);

    -- Calculate the total revenue by summing up the amount from the ticket_booking table
    SELECT SUM(CAST(amount AS DECIMAL(10,2))) INTO totalRevenue
    FROM ticket_booking
    WHERE flightcode = flightCode;

    -- Return the total revenue
    IF totalRevenue IS NOT NULL THEN
        SELECT CONCAT('Total Revenue for Flight ', flightCode, ' is: ', totalRevenue) AS message;
    ELSE
        SELECT 'No bookings found for this flight.' AS message;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `GetAllPassengersForFlight`$$
CREATE DEFINER=`` PROCEDURE `GetAllPassengersForFlight` (IN `flightCode` VARCHAR(6))   BEGIN
    -- Retrieve the passenger details for the given flight code
    SELECT p.name, p.gender, p.nationality, p.passportnumber
    FROM ticket_booking t
    JOIN managepassenger p ON t.passportnumber = p.passportnumber
    WHERE t.flightcode = flightCode;
END$$

DROP PROCEDURE IF EXISTS `RetrieveFlightInfoBetweenCities`$$
CREATE DEFINER=`` PROCEDURE `RetrieveFlightInfoBetweenCities` (IN `source_city` VARCHAR(30), IN `destination_city` VARCHAR(30))   BEGIN
    -- Retrieve flight information between the specified source and destination
    SELECT flightcode, source, destination, takeoff, noofseat
    FROM manageflight
    WHERE source = source_city AND destination = destination_city;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user',
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`username`, `password`, `role`) VALUES
('admin', 'admin123', 'admin'),
('passengerUser', 'passengerPass', 'user'),
('Shwetha', 'Shwetha123', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `manageflight`
--

DROP TABLE IF EXISTS `manageflight`;
CREATE TABLE IF NOT EXISTS `manageflight` (
  `flightcode` varchar(6) NOT NULL,
  `source` varchar(30) NOT NULL,
  `destination` varchar(30) NOT NULL,
  `takeoff` varchar(30) NOT NULL,
  `noofseat` bigint(30) NOT NULL,
  PRIMARY KEY (`flightcode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `manageflight`
--

INSERT INTO `manageflight` (`flightcode`, `source`, `destination`, `takeoff`, `noofseat`) VALUES
('f1-10', 'Mumbai', 'Hyderabad', '08/11/2022', 99),
('f1-101', 'Chennai', 'Bhopal', '09/22/2000', 501),
('f1-200', 'Singapore', 'Bengaluru', '08/22/2005', 499),
('F1-202', 'Bengaluru', 'Chennai', '12/09/2024', 99),
('F1-500', 'Delhi', 'Kolkata', '09/12/2024', 200),
('f1-900', 'CHintamani', 'Bengaluru', '09/27/2000', 49);

--
-- Triggers `manageflight`
--
DROP TRIGGER IF EXISTS `prevent_duplicate_flight_code`;
DELIMITER $$
CREATE TRIGGER `prevent_duplicate_flight_code` BEFORE INSERT ON `manageflight` FOR EACH ROW BEGIN
    -- Check if the flight code already exists
    IF EXISTS (SELECT 1 FROM manageflight WHERE flightcode = NEW.flightcode) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Flight code already exists!';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `managepassenger`
--

DROP TABLE IF EXISTS `managepassenger`;
CREATE TABLE IF NOT EXISTS `managepassenger` (
  `name` varchar(20) NOT NULL,
  `gender` enum('male','female','other') NOT NULL,
  `nationality` varchar(20) NOT NULL,
  `passportnumber` varchar(20) NOT NULL,
  `phone` varchar(20) NOT NULL,
  PRIMARY KEY (`passportnumber`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `managepassenger`
--

INSERT INTO `managepassenger` (`name`, `gender`, `nationality`, `passportnumber`, `phone`) VALUES
('Shwetha', 'female', 'Indian', '111111111', '909090900'),
('Hiro Tanaka', '', 'Japanese', 'R11223344', '+81-80-1234-5678'),
('Maria Garcia', '', 'Spanish', 'T55667788', '+34-612-345678'),
('Priya Desai', '', 'Indian', 'W33445566', '+91-98765-43210'),
('Laila Ahmed', '', 'Egyptian', 'X55443322', '+20-102-3456789'),
('Michael Brown', '', 'British', 'Y66778899', '+44-7700-900111'),
('Chen Wei', '', 'Chinese', 'Z99887766', '+86-138-00138000');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_booking`
--

DROP TABLE IF EXISTS `ticket_booking`;
CREATE TABLE IF NOT EXISTS `ticket_booking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `flightcode` varchar(20) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `passportnumber` varchar(20) NOT NULL,
  `amount` varchar(20) NOT NULL,
  `nationality` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `passportnumber` (`passportnumber`,`flightcode`),
  KEY `fk_flight` (`flightcode`)
) ENGINE=InnoDB AUTO_INCREMENT=421 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ticket_booking`
--

INSERT INTO `ticket_booking` (`id`, `name`, `flightcode`, `gender`, `passportnumber`, `amount`, `nationality`) VALUES
(1, 'm', 'f1-10', 'Male', 'Y66778899', '2000', 'In'),
(27, 'MAA', 'f1-101', 'Female', '111111111', '1000', 'Indian'),
(90, 'Shwetha', 'f1-10', 'Female', '111111111', '2000', 'Indian'),
(200, 'Meeeee', 'f1-200', 'Male', 'Y66778899', '1000', 'Indian'),
(220, 'Surya', 'f1-202', 'Male', 'Y66778899', '5000', 'Indian'),
(221, 'Krishna', 'f1-900', 'Male', 'Y66778899', '5000', 'Indian'),
(420, 'P', 'f1-10', 'Male', 'Z99887766', '2000', 'Ind');

--
-- Triggers `ticket_booking`
--
DROP TRIGGER IF EXISTS `after_ticket_insert`;
DELIMITER $$
CREATE TRIGGER `after_ticket_insert` AFTER INSERT ON `ticket_booking` FOR EACH ROW BEGIN
    UPDATE manageflight
    SET noofseat = noofseat - 1
    WHERE flightcode = NEW.flightcode;
END
$$
DELIMITER ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ticket_booking`
--
ALTER TABLE `ticket_booking`
  ADD CONSTRAINT `fk_flight` FOREIGN KEY (`flightcode`) REFERENCES `manageflight` (`flightcode`),
  ADD CONSTRAINT `fk_passport` FOREIGN KEY (`passportnumber`) REFERENCES `managepassenger` (`passportnumber`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
