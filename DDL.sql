CREATE DATABASE IF NOT EXISTS bd_rv;

USE bd_rv;

CREATE TABLE brand (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(40) NOT NULL
);

CREATE TABLE model (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(40) NOT NULL
);

CREATE TABLE Vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_brand INT NOT NULL,
    id_model INT NOT NULL,
    Plate VARCHAR(40) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN NOT NULL, 
    INDEX idx_brand (id_brand),
    INDEX idx_model (id_model),
    FOREIGN KEY (id_brand) REFERENCES brand(id),
    FOREIGN KEY (id_model) REFERENCES model(id)
);

CREATE TABLE register_movement (
	id INT AUTO_INCREMENT PRIMARY KEY,
    id_Vehicles INT NOT NULL,
    movements ENUM('in', 'out'),
    motorcyclist VARCHAR(100) NOT NULL,
    mileage BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (id_Vehicles) REFERENCES Vehicles(id)
);