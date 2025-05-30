create database Hotel;

use Hotel;

CREATE TABLE Hotel (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    location_name NVARCHAR(100) NOT NULL
);
CREATE TABLE Room (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    price INT NOT NULL,
    description NVARCHAR(500),
    guests INT NOT NULL,
    image VARCHAR(500) NOT NULL,
    hotel_id INT,
    FOREIGN KEY (hotel_id) REFERENCES Hotel(hotel_id)
);