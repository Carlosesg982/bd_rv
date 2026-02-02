USE bd_rv; 

DROP PROCEDURE IF EXISTS sp_vehicles_list;
DELIMITER //
CREATE PROCEDURE sp_vehicles_list(
)
BEGIN
    SELECT v.id, 
        v.Plate, 
        b.title AS brand_name, 
        m.title AS model_name, 
        v.created_at, 
        v.updated_at
    FROM vehicles v
    INNER JOIN brand b ON v.id_brand = b.id
    INNER JOIN model m ON v.id_model = m.id
    WHERE is_active = 1
    ORDER BY v.created_at ASC;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_brand_list;
DELIMITER //
CREATE PROCEDURE sp_brand_list()
BEGIN
    SELECT id, title
    FROM brand
    ORDER BY title ASC;
    
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_model_list;
DELIMITER //
CREATE PROCEDURE sp_model_list()
BEGIN
    SELECT id, title
    FROM model
    ORDER BY title ASC;
    
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_vehicle_add;
DELIMITER //
CREATE PROCEDURE sp_vehicle_add(
    IN p_id_brand INT,
    IN p_id_model INT,
    IN p_plate VARCHAR(20)
)
BEGIN
    INSERT INTO vehicles (id_brand, id_model, Plate)
    VALUES (p_id_brand, p_id_model, p_plate);

    SELECT 
        v.id, 
        v.Plate, 
        b.title AS brand_name, 
        m.title AS model_name, 
        v.created_at
    FROM vehicles v
    INNER JOIN brand b ON v.id_brand = b.id
    INNER JOIN model m ON v.id_model = m.id
    WHERE v.id = LAST_INSERT_ID();
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_vehicle_delete;
DELIMITER //
CREATE PROCEDURE sp_vehicle_delete(
    IN p_id_vehicle INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vehicles WHERE id = p_id_vehicle) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'El vehículo no existe';
    ELSE
        UPDATE vehicles 
        SET is_active = 0,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_id_vehicle;
        
        SELECT p_id_vehicle AS id;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_vehicle_update;
DELIMITER //
CREATE PROCEDURE sp_vehicle_update(
    IN p_id INT,
    IN p_id_brand INT,
    IN p_id_model INT,
    IN p_plate VARCHAR(20)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM vehicles WHERE id = p_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vehículo no encontrado';
    ELSE
        UPDATE vehicles 
        SET id_brand = p_id_brand, 
            id_model = p_id_model, 
            Plate = p_plate,
            updated_at = CURRENT_TIMESTAMP
        WHERE id = p_id;

        SELECT v.id, v.Plate, b.title AS brand_name, m.title AS model_name, v.updated_at
        FROM vehicles v
        INNER JOIN brand b ON v.id_brand = b.id
        INNER JOIN model m ON v.id_model = m.id
        WHERE v.id = p_id;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_register_movement_add;
DELIMITER //
CREATE PROCEDURE sp_register_movement_add(
    IN p_id_vehicles INT,
    IN p_movements enum('in','out'),
    IN p_motorcyclist VARCHAR(100),
    IN p_mileage BIGINT
)
BEGIN
    INSERT INTO register_movement (id_Vehicles, movements, motorcyclist, mileage)
    VALUES (p_id_vehicles, p_movements, p_motorcyclist, p_mileage);

    SELECT 
        id, id_Vehicles, movements, motorcyclist, mileage, created_at
    FROM register_movement 
    WHERE id = LAST_INSERT_ID();
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_register_movement_list;
DELIMITER //
CREATE PROCEDURE sp_register_movement_list(
		IN p_motorcyclist VARCHAR(100),
        IN p_id_vehicles INT,
        IN p_created_at TIMESTAMP
)
BEGIN
    SELECT 
        rm.id,
        v.Plate, 
        b.title AS brand_name, 
        m.title AS model_name, 
        rm.movements,
        rm.motorcyclist,
        rm.created_at,
        rm.mileage,
        v.id AS vehicle_id
    FROM register_movement rm
    INNER JOIN vehicles v ON rm.id_Vehicles = v.id
    INNER JOIN brand b ON v.id_brand = b.id
    INNER JOIN model m ON v.id_model = m.id
    WHERE (p_motorcyclist IS NULL OR p_motorcyclist = '' OR rm.motorcyclist LIKE CONCAT('%', p_motorcyclist, '%'))
    AND (p_id_vehicles IS NULL OR p_id_vehicles = 0 OR rm.id_Vehicles = p_id_vehicles)
    AND (p_created_at IS NULL OR  DATE(rm.created_at) = p_created_at)
    ORDER BY rm.created_at DESC;   
END //
DELIMITER ;

