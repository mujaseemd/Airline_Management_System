-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 20, 2024 at 05:36 AM
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

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddNewFlight` (IN `flightcode` VARCHAR(6), IN `source` VARCHAR(30), IN `destination` VARCHAR(30), IN `takeoff` VARCHAR(30), IN `noofseat` BIGINT)   BEGIN
    -- Insert the new flight into the manageflight table
    INSERT INTO manageflight (flightcode, source, destination, takeoff, noofseat)
    VALUES (flightcode, source, destination, takeoff, noofseat);

    -- Return a success message
    SELECT 'Flight added successfully!' AS message;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `CalculateTotalRevenue` (IN `flightCode` VARCHAR(6))   BEGIN
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetAllPassengersForFlight` (IN `flightCode` VARCHAR(6))   BEGIN
    -- Retrieve the passenger details for the given flight code
    SELECT p.name, p.gender, p.nationality, p.passportnumber
    FROM ticket_booking t
    JOIN managepassenger p ON t.passportnumber = p.passportnumber
    WHERE t.flightcode = flightCode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `RetrieveFlightInfoBetweenCities` (IN `source_city` VARCHAR(30), IN `destination_city` VARCHAR(30))   BEGIN
    SELECT flightcode, source, destination, takeoff, noofseat
    FROM manageflight
    WHERE source = source_city AND destination = destination_city;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

CREATE TABLE `login` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','user') DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login`
--

INSERT INTO `login` (`username`, `password`, `role`) VALUES
('admin', 'admin123', 'admin'),
('passengerUser', 'passengerPass', 'user');

-- --------------------------------------------------------

--
-- Table structure for table `manageflight`
--

CREATE TABLE `manageflight` (
  `flightcode` varchar(6) NOT NULL,
  `source` varchar(30) NOT NULL,
  `destination` varchar(30) NOT NULL,
  `takeoff` varchar(30) NOT NULL,
  `noofseat` bigint(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `manageflight`
--

INSERT INTO `manageflight` (`flightcode`, `source`, `destination`, `takeoff`, `noofseat`) VALUES
('f1-099', 'c', 'd', '09/22/2000', 10),
('f1-10', 'des', 'Dubai', '08/11/2022', 100),
('f1-101', 'cc', 'dd', '09/22/2000', 501),
('f1-200', 'Singapore', 'Bengaluru', '08/22/2005', 500),
('f1-500', 'CHennai', 'kochi', '08/08/2025', 100),
('f1-900', 'CHintamani', 'Bengaluru', '09/27/2000', 50),
('f2-100', 'cc', 'dd', '09/09/2024', 100),
('f2-150', 'src', 'dest', '02/09/2024', 50);

--
-- Triggers `manageflight`
--
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

CREATE TABLE `managepassenger` (
  `name` varchar(20) NOT NULL,
  `gender` enum('male','female','other') NOT NULL,
  `nationality` varchar(20) NOT NULL,
  `passportnumber` varchar(20) NOT NULL,
  `phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `managepassenger`
--

INSERT INTO `managepassenger` (`name`, `gender`, `nationality`, `passportnumber`, `phone`) VALUES
('Shwetha', 'female', 'Indian', '111111111', '909090900'),
('Hiro Tanaka', 'female', 'Japanese', 'R11223344', '+81-80-1234-5678'),
('Maria Garcia', 'female', 'Spanish', 'T55667788', '+34-612-345678'),
('Priya Desai', 'female', 'Indian', 'W33445566', '+91-98765-43210'),
('Laila Ahmed', 'female', 'Egyptian', 'X55443322', '+20-102-3456789'),
('Mujaseem', 'female', 'Indian', 'Y11998811', '7676767676'),
('Michael Brown', 'male', 'British', 'Y66778899', '+44-7700-900111'),
('Chen Wei', 'male', 'Chinese', 'Z99887766', '+86-138-00138000');

-- --------------------------------------------------------

--
-- Table structure for table `ticket_booking`
--

CREATE TABLE `ticket_booking` (
  `id` varchar(20) NOT NULL,
  `name` varchar(20) NOT NULL,
  `flightcode` varchar(20) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `passportnumber` varchar(20) NOT NULL,
  `amount` varchar(20) NOT NULL,
  `nationality` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ticket_booking`
--

INSERT INTO `ticket_booking` (`id`, `name`, `flightcode`, `gender`, `passportnumber`, `amount`, `nationality`) VALUES
('21', 'MAA', 'f1-101', 'Female', 'R11223344', '1000', 'Indian'),
('90', 'Shwetha', 'f1-10', 'Female', '111111111', '2000', 'Indian');

--
-- Triggers `ticket_booking`
--
DELIMITER $$
CREATE TRIGGER `after_ticket_insert` AFTER INSERT ON `ticket_booking` FOR EACH ROW BEGIN
    UPDATE manageflight
    SET noofseat = noofseat - 1
    WHERE flightcode = NEW.flightcode;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `login`
--
ALTER TABLE `login`
  ADD PRIMARY KEY (`username`);

--
-- Indexes for table `manageflight`
--
ALTER TABLE `manageflight`
  ADD PRIMARY KEY (`flightcode`);

--
-- Indexes for table `managepassenger`
--
ALTER TABLE `managepassenger`
  ADD PRIMARY KEY (`passportnumber`);

--
-- Indexes for table `ticket_booking`
--
ALTER TABLE `ticket_booking`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `passportnumber` (`passportnumber`,`flightcode`),
  ADD KEY `fk_flight` (`flightcode`);

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
