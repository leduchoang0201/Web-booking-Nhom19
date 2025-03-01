-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 15, 2025 at 01:17 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `booking`
--

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `booking_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `status` enum('pending','confirmed','cancelled') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`booking_id`, `user_id`, `room_id`, `check_in`, `check_out`, `status`, `created_at`) VALUES
(0, 24, 15, '2025-01-16', '2025-01-20', 'cancelled', '2025-01-13 15:15:44'),
(16, 19, 3, '2025-01-15', '2025-01-17', 'cancelled', '2025-01-13 18:47:00'),
(17, 19, 4, '2025-01-17', '2025-01-18', 'cancelled', '2025-01-13 22:44:14'),
(20, 19, 6, '2025-01-15', '2025-01-16', 'cancelled', '2025-01-13 23:35:22'),
(21, 36, 3, '2025-01-15', '2025-01-16', 'cancelled', '2025-01-14 06:53:23'),
(22, 19, 7, '2025-01-16', '2025-01-18', 'confirmed', '2025-01-15 10:23:25');

--
-- Triggers `bookings`
--
DELIMITER $$
CREATE TRIGGER `after_booking_update` AFTER UPDATE ON `bookings` FOR EACH ROW BEGIN
    -- Kiểm tra nếu trạng thái mới là 'cancelled'
    IF NEW.status = 'cancelled' THEN
        -- Cập nhật trạng thái của phòng trong bảng rooms về 1 (khả dụng)
        UPDATE rooms
        SET status = 1
        WHERE room_id = NEW.room_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `payment_method` enum('credit_card','paypal','cash') NOT NULL,
  `status` enum('pending','completed','failed') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `room_name` varchar(100) NOT NULL,
  `room_type` varchar(50) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `capacity` int(11) NOT NULL,
  `status` int(4) DEFAULT 1,
  `image` varchar(255) DEFAULT NULL,
  `location` varchar(100) NOT NULL DEFAULT 'Unknown'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_name`, `room_type`, `price`, `capacity`, `status`, `image`, `location`) VALUES
(1, 'Phòng Standard (STD)', 'STD', 2000000.00, 4, 0, 'phong2.jpg', 'Phú Quốc'),
(2, 'Phòng Superior (SUP)', 'VIP', 3000000.00, 2, 0, 'phong3.jpg', 'Nha Trang'),
(3, 'Phòng Deluxe (DLX)', 'VIP', 5000000.00, 2, 1, 'phong1.jpg', 'Nha Trang'),
(4, 'Phòng Suite (SUT)', 'VIP', 8000000.00, 2, 1, 'phong17.jpg', 'Nha Trang'),
(5, 'Phòng Junior Suite', 'VIP', 7000000.00, 3, 1, 'phong4.jpg', 'Nam Hội'),
(6, 'Phòng Executive Suite', 'Vip', 9000000.00, 3, 1, 'phong1.jpg', 'Nha Trang'),
(7, 'Phòng Connecting Room', 'Standard', 4000000.00, 2, 0, 'phong5.jpg', 'Phú Quốc'),
(8, 'Phòng Single Room', 'Standard', 1000000.00, 2, 1, 'phong6.jpg', 'Nha Trang '),
(9, 'Phòng Twin Room', 'Deluxe', 2000000.00, 3, 1, 'phong7.jpg', 'Nam Hội'),
(10, 'Phòng Double Room', 'Deluxe', 2500000.00, 3, 1, 'phong8.jpg', 'Hạ Long'),
(11, 'Phòng Triple Room', 'Suite', 3000000.00, 4, 1, 'phong9.jpg', 'Hải Phòng'),
(12, 'Phòng Quad Room', 'Suite', 3500000.00, 4, 1, 'phong10.jpg', 'Hạ Long'),
(13, 'Phòng Family Room', 'Penthouse', 6000000.00, 6, 1, 'phong11.jpg', 'Phú Quốc'),
(14, 'Phòng President Suite', 'Penthouse', 9000000.00, 6, 1, 'phong12.jpg', 'Phú Quốc'),
(15, 'Phòng Royal Suite', 'Luxury', 8500000.00, 5, 1, 'phong13.jpg', 'Hạ Long'),
(16, 'Phòng Queen Room', 'Luxury', 3000000.00, 5, 1, 'phong14.jpg', 'Phú Quốc'),
(17, 'Phòng King Room', 'Presidential', 5000000.00, 8, 1, 'phong15.jpg', 'Phú Quốc');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `role` int(11) DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `name`, `email`, `password`, `created_at`, `role`) VALUES
(1, 'Nguyen Van A', 'user1@gmail.com', 'hashed_password_1', '2025-01-07 10:30:17', 2),
(2, 'Tran Thi B', 'user2@gmail.com', 'hashed_password_2', '2025-01-07 10:30:17', 2),
(3, 'Le Van C', 'user3@gmail.com', 'hashed_password_3', '2025-01-07 10:30:17', 2),
(4, 'Pham Thi D', 'user4@gmail.com', '$2a$10$F0dtQllg./TWrh.bpndZC..SQ4uZz4uOERhqDkxZXpqUqN8Hs9mtq', '2025-01-07 10:30:17', 2),
(5, 'Hoang Van E', 'user5@gmail.com', '$2a$10$WR1wLPvHkm/NsIF4YsiEfuf5mh3LqojD2.S/4xYYImSwxiKSvE9mm', '2025-01-07 10:30:17', 2),
(6, 'Bui Thi F', 'user6@gmail.com', '$2a$10$fhmZ3Ilc3GrN/84j5Zrm4uYWJyncsPJlmEMHBuQCptqzvC16HUqEu', '2025-01-07 10:30:17', 2),
(14, 'AA', 'bc', '$2a$10$3SVfHMta05Cgt6ChqQtIyOuXgLSCDA/pOYHPIwU6VqnF2K7rBdE9G', '2025-01-08 07:43:53', 2),
(16, 'Admin', 'admin@gmail.com', '$2a$10$5RipT4NbKo.Amnz80X0V9.bsg8IFI1i/N0nZ8zgAAop7tTMJsvdRe', '2025-01-08 07:50:56', 1),
(18, 'LE duc hoang', 'a@gmail.com', '$2a$10$yPnRyXXzON2fhca5VlPnCOxgxDTDmChJpgqx5Libh1KCPisGl4arq', '2025-01-08 08:32:00', 2),
(19, 'asd', 'asd@gmail.com', '$2a$10$NBsZKpfjs6Tfjf97gl1pM.t.FJzO4LmrHG9E35/qIfnh4k3/HCxH6', '2025-01-08 09:13:29', 2),
(24, 'Hoang', '222@gmail.com', '$2a$10$UuwHJ.YJTtMPJNpqwyqHHucjpqPtfFxG3Okp9FEc20jXBGQTf9AfK', '2025-01-08 10:56:49', 2),
(36, 'Hoang', '22130086@st.hcmuaf.edu.vn', '$2a$10$O.PIQtDtrUMhllnATMSWb.hfpa3gHuY1X6GpttR6qiRjCRyHhgJee', '2025-01-14 04:24:32', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `booking_id` (`booking_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `booking_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`booking_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
