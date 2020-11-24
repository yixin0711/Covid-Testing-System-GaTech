/*
CS4400: Introduction to Database Systems
Fall 2020
Phase III Template

Team 59
Xin Yi (xyi38)
Runze Yang (ryang318)
Qingyuan Deng (qdeng39)


Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/


-- ID: 2a
-- Author: lvossler3
-- Name: register_student
DROP PROCEDURE IF EXISTS register_student;
DELIMITER //
CREATE PROCEDURE register_student(
		IN i_username VARCHAR(40),
        IN i_email VARCHAR(40),
        IN i_fname VARCHAR(40),
        IN i_lname VARCHAR(40),
        IN i_location VARCHAR(40),
        IN i_housing_type VARCHAR(20),
        IN i_password VARCHAR(40)
)
BEGIN
-- Type solution below
INSERT INTO USER (username, user_password, email, fname, lname) 
VALUES (i_username, MD5(i_password), i_email, i_fname, i_lname);
INSERT INTO STUDENT (student_username, housing_type, location) 
VALUES (i_username, i_housing_type, i_location);
-- End of solution
END //
DELIMITER ;
-- CALL register_student('lvossler3', 'laurenvossler@gatech.edu', 'Lauren', 'Vossler', 'East', 'Off-campus Apartment',  'iLoVE4400$');

-- ID: 2b
-- Author: lvossler3
-- Name: register_employee
DROP PROCEDURE IF EXISTS register_employee;
DELIMITER //
CREATE PROCEDURE register_employee(
		IN i_username VARCHAR(40),
        IN i_email VARCHAR(40),
        IN i_fname VARCHAR(40),
        IN i_lname VARCHAR(40),
        IN i_phone VARCHAR(10),
        IN i_labtech BOOLEAN,
        IN i_sitetester BOOLEAN,
        IN i_password VARCHAR(40)
)
BEGIN
-- Type solution below
	insert into USER(username, user_password, email, fname, lname) 
	values(i_username,MD5(i_password),i_email,i_fname,i_lname);
    
	insert into EMPLOYEE(emp_username,phone_num)
    values(i_username,i_phone);
    
    if i_labtech is True then
    insert into LABTECH(labtech_username) values(i_username);
    end if;
    if i_sitetester is True then 
    insert into SITETESTER(sitetester_username) values(i_username);
    end if;

-- End of solution
END //
DELIMITER ;
-- CALL register_employee('sstentz3', 'sstentz3@gatech.edu', 'Samuel', 'Stentz', '9703312824', True, True, 'l@urEni$myLIFE2');

-- ID: 4a
-- Author: Aviva Smith
-- Name: student_view_results
DROP PROCEDURE IF EXISTS `student_view_results`;
DELIMITER //
CREATE PROCEDURE `student_view_results`(
    IN i_student_username VARCHAR(50),
	IN i_test_status VARCHAR(50),
	IN i_start_date DATE,
    IN i_end_date DATE
)
BEGIN
	DROP TABLE IF EXISTS student_view_results_result;
    CREATE TABLE student_view_results_result(
        test_id VARCHAR(7),
        timeslot_date date,
        date_processed date,
        pool_status VARCHAR(40),
        test_status VARCHAR(40)
    );
    INSERT INTO student_view_results_result

    -- Type solution below
	SELECT t.test_id, t.appt_date, p.process_date, p.pool_status , t.test_status
	FROM Appointment a
	LEFT JOIN Test t
	ON t.appt_date = a.appt_date
	AND t.appt_time = a.appt_time
	AND t.appt_site = a.site_name
	LEFT JOIN Pool p
	ON t.pool_id = p.pool_id
	WHERE i_student_username = a.username
	AND (i_test_status = t.test_status OR i_test_status IS NULL)
	AND (i_start_date <= t.appt_date OR i_start_date IS NULL)
	AND (i_end_date >= t.appt_date OR i_end_date IS NULL);
    
    if (select count(*) from student_view_results_result)=0
    then insert into student_view_results_result values(NULL,NULL,NULL,NULL,NULL);end if;
    
    
    -- End of solution
END //
DELIMITER ;

CALL student_view_results('dkim99', 'negative', '2020-08-01', '2020-09-30');


-- ID: 5a
-- Author: asmith457
-- Name: explore_results
DROP PROCEDURE IF EXISTS explore_results;
DELIMITER $$
CREATE PROCEDURE explore_results (
    IN i_test_id VARCHAR(7))
BEGIN
    DROP TABLE IF EXISTS explore_results_result;
    CREATE TABLE explore_results_result(
        test_id VARCHAR(7),
        test_date date,
        timeslot time,
        testing_location VARCHAR(40),
        date_processed date,
        pooled_result VARCHAR(40),
        individual_result VARCHAR(40),
        processed_by VARCHAR(80)
    );
    INSERT INTO explore_results_result

    -- Type solution below
	select test_id,appt_date,appt_time,appt_site,process_date,pool_status,test_status,concat(fname,' ',lname)
	from test T,pool P, user U
	where T.pool_id=P.pool_id and
	P.processed_by=U.username
	and test_id=i_test_id;
    -- End of solution
END$$
DELIMITER ;

-- CALL  explore_results('100017');


-- ID: 6a
-- Author: asmith457
-- Name: aggregate_results
DROP PROCEDURE IF EXISTS aggregate_results;
DELIMITER $$
CREATE PROCEDURE aggregate_results(
    IN i_location VARCHAR(50),
    IN i_housing VARCHAR(50),
    IN i_testing_site VARCHAR(50),
    IN i_start_date DATE,
    IN i_end_date DATE)
BEGIN
    DROP TABLE IF EXISTS aggregate_results_result;
    CREATE TABLE aggregate_results_result(
        test_status VARCHAR(40),
        num_of_test INT,
        percentage DECIMAL(6,2)
    );
	
    INSERT INTO aggregate_results_result

    -- Type solution below
    select test_status,
			count(*),
            count(*)
			from test t
	left join appointment a
			ON t.appt_date = a.appt_date
			AND t.appt_time = a.appt_time
			AND t.appt_site = a.site_name
	left join student
			on username=student_username
	left join pool p
			on t.pool_id=p.pool_id
	where (i_location=location OR i_location IS NULL)
			AND (i_housing=housing_type OR i_housing IS NULL )
			AND (i_testing_site = t.appt_site OR i_testing_site IS NULL)
			AND (CASE WHEN i_end_date IS NOT NULL
				THEN (p.process_date <= i_end_date) 
				ELSE (p.process_date IS NULL OR p.process_date >= i_start_date OR i_start_date IS NULL) END)
		group by test_status;
	
    select sum(num_of_test) from aggregate_results_result into @sum;
    update aggregate_results_result
    set percentage=num_of_test*100/@sum;

    
	if 'pending' not in (select test_status from aggregate_results_result)
    then insert into aggregate_results_result values('pending',0,0);end if;
    if 'negative' not in (select test_status from aggregate_results_result)
    then insert into aggregate_results_result values('negative',0,0);end if;
    if 'positive' not in (select test_status from aggregate_results_result)
    then insert into aggregate_results_result values('positive',0,0);end if;

    -- End of solution
END$$
DELIMITER ;
-- call aggregate_results(NULL,NULL,'Bobby Dodd Stadium',NULL,NULL);


-- ID: 7a
-- Author: lvossler3
-- Name: test_sign_up_filter
DROP PROCEDURE IF EXISTS test_sign_up_filter;
DELIMITER //
CREATE PROCEDURE test_sign_up_filter(
    IN i_username VARCHAR(40),
    IN i_testing_site VARCHAR(40),
    IN i_start_date date,
    IN i_end_date date,
    IN i_start_time time,
    IN i_end_time time)
BEGIN
    DROP TABLE IF EXISTS test_sign_up_filter_result;
    CREATE TABLE test_sign_up_filter_result(
        appt_date date,
        appt_time time,
        street VARCHAR (40),
        site_name VARCHAR(40));
    INSERT INTO test_sign_up_filter_result

    -- Type solution below
	select distinct appt_date,appt_time,s.street,s.site_name from appointment a
	left join site s on a.site_name=s.site_name
	where (i_testing_site=a.site_name or i_testing_site is NULL)
	and (i_start_date<=a.appt_date OR i_start_date is NULL)
	and (i_end_date>=a.appt_date OR i_end_date is NULL)
	and (i_start_time<=a.appt_time OR i_start_time is NULL)
	and (i_end_time>=a.appt_time OR i_end_time is NULL)
	and username is NULL
	and s.location in
	(select location from student
	where student_username=i_username);
    -- End of solution

    END //
    DELIMITER ;
-- CALL test_sign_up_filter('gburdell1', 'North Avenue (Centenial Room)', NULL, '2020-10-06', NULL, NULL);
-- CALL test_sign_up_filter('gburdell1', NULL, NULL, NULL, NULL, NULL);
-- CALL test_sign_up_filter('mgeller3', NULL, NULL, NULL, NULL, NULL);


-- ID: 7b
-- Author: lvossler3
-- Name: test_sign_up
DROP PROCEDURE IF EXISTS test_sign_up;
DELIMITER //
CREATE PROCEDURE test_sign_up(
		IN i_username VARCHAR(40),
        IN i_site_name VARCHAR(40),
        IN i_appt_date date,
        IN i_appt_time time,
        IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below
	if 'pending' not in
	(select test_status from student st
	left join appointment a
	on student_username=username
	left join test t
	ON t.appt_date = a.appt_date
	AND t.appt_time = a.appt_time
	AND t.appt_site = a.site_name
	where student_username=i_username)
	then
	select username from appointment
	where site_name=i_site_name
	and appt_date=i_appt_date
	and appt_time=i_appt_time into @ava;
    
    if @ava is NULL
	then
	update appointment
	set username=i_username
	where site_name=i_site_name
	and appt_date=i_appt_date
	and appt_time=i_appt_time;
	end if;
	if @ava is NULL
	then
	insert test(test_id,test_status,pool_id,appt_site,appt_date,appt_time)
	values(i_test_id,'pending',NULL,i_site_name,i_appt_date,i_appt_time);
	end if;
		
    end if;

-- End of solution
END //
DELIMITER ;



-- Number: 8a
-- Author: lvossler3
-- Name: tests_processed
DROP PROCEDURE IF EXISTS tests_processed;
DELIMITER //
CREATE PROCEDURE tests_processed(
    IN i_start_date date,
    IN i_end_date date,
    IN i_test_status VARCHAR(10),
    IN i_lab_tech_username VARCHAR(40))
BEGIN
    DROP TABLE IF EXISTS tests_processed_result;
    CREATE TABLE tests_processed_result(
        test_id VARCHAR(7),
        pool_id VARCHAR(10),
        test_date date,
        process_date date,
        test_status VARCHAR(10) );
    INSERT INTO tests_processed_result
    -- Type solution below
	select test_id,t.pool_id,appt_date,process_date,test_status from test t
	left join pool p
	on t.pool_id=p.pool_id
	where processed_by=i_lab_tech_username
	and (appt_date>=i_start_date or i_start_date is NULL)
	and (appt_date<=i_end_date or i_end_date is NULL)
	and (test_status=i_test_status or i_test_status is NULL);

    -- End of solution
    END //
    DELIMITER ;

-- ID: 9a
-- Author: ahatcher8@
-- Name: view_pools
DROP PROCEDURE IF EXISTS view_pools;
DELIMITER //
CREATE PROCEDURE view_pools(
    IN i_begin_process_date DATE,
    IN i_end_process_date DATE,
    IN i_pool_status VARCHAR(20),
    IN i_processed_by VARCHAR(40)
)
BEGIN
    DROP TABLE IF EXISTS view_pools_result;
    CREATE TABLE view_pools_result(
        pool_id VARCHAR(10),
        test_ids VARCHAR(100),
        date_processed DATE,
        processed_by VARCHAR(40),
        pool_status VARCHAR(20));

    INSERT INTO view_pools_result
-- Type solution below

	SELECT a.pool_id, b.test_ids, a.process_date AS date_processed, a.processed_by, a.pool_status
	FROM pool a
	LEFT JOIN 
	(SELECT pool_id, GROUP_CONCAT(test_id) AS test_ids
	FROM test
	GROUP BY pool_id) b
	ON a.pool_id = b.pool_id
	WHERE pool_status = CASE WHEN i_pool_status IS NULL THEN pool_status
							ELSE i_pool_status END
	AND
    (
    (i_processed_by IS NOT NULL AND processed_by = i_processed_by AND pool_status != 'pending')
    OR
    (i_processed_by IS NULL)
    )
	AND
    (
	(i_begin_process_date IS NOT NULL AND i_end_process_date IS NOT NULL AND process_date >= i_begin_process_date AND process_date <= i_end_process_date AND pool_status != 'pending') 
	OR 
	(i_begin_process_date IS NULL AND i_end_process_date IS NOT NULL AND process_date <= i_end_process_date AND pool_status != 'pending')
	OR
	(i_begin_process_date IS NOT NULL AND i_end_process_date IS NULL AND (process_date >= i_begin_process_date OR process_date IS NULL))
	OR
	(i_begin_process_date IS NULL AND i_end_process_date IS NULL)
    );
    
-- End of solution
END //
DELIMITER ;

-- ID: 10a
-- Author: ahatcher8@
-- Name: create_pool
DROP PROCEDURE IF EXISTS create_pool;
DELIMITER //
CREATE PROCEDURE create_pool(
	IN i_pool_id VARCHAR(10),
    IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below

    IF
       i_test_id IN (SELECT test_id FROM test)
    THEN
		SELECT pool_id
		INTO @curr_pool_id
		FROM test
		WHERE test_id = i_test_id;
        IF 
			@curr_pool_id IS NULL
        THEN
			INSERT INTO pool (pool_id, pool_status, process_date, processed_by) VALUES (i_pool_id, 'pending', NULL, NULL);
			UPDATE test
			SET pool_id = i_pool_id
			WHERE test_id = i_test_id;
		END IF;
    END IF;

-- End of solution
END //
DELIMITER ;

-- ID: 10b
-- Author: ahatcher8@
-- Name: assign_test_to_pool
DROP PROCEDURE IF EXISTS assign_test_to_pool;
DELIMITER //
CREATE PROCEDURE assign_test_to_pool(
    IN i_pool_id VARCHAR(10),
    IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below

    IF
       i_test_id IN (SELECT test_id FROM test) AND i_pool_id IN (SELECT pool_id FROM pool)
    THEN
		SELECT pool_id
		INTO @curr_pool_id
		FROM test
		WHERE test_id = i_test_id;
        
        SELECT COUNT(*)
        INTO @curr_pool_num
        FROM test
        WHERE pool_id = i_pool_id;
        
        IF  
			@curr_pool_id IS NULL AND @curr_pool_num <= 6
        THEN
			UPDATE test
			SET pool_id = i_pool_id
			WHERE test_id = i_test_id;
		END IF;
    END IF;

-- End of solution
END //
DELIMITER ;

-- ID: 11a
-- Author: ahatcher8@
-- Name: process_pool
DROP PROCEDURE IF EXISTS process_pool;
DELIMITER //
CREATE PROCEDURE process_pool(
    IN i_pool_id VARCHAR(10),
    IN i_pool_status VARCHAR(20),
    IN i_process_date DATE,
    IN i_processed_by VARCHAR(40)
)
BEGIN
-- Type solution below

    SELECT pool_status
    INTO @curr_status
    FROM POOL
    WHERE pool_id = i_pool_id;

    IF
        ((@curr_status = 'pending') AND (i_pool_status = 'positive' OR i_pool_status = 'negative'))
    THEN
        UPDATE POOL
        SET pool_status = i_pool_status, process_date = i_process_date, processed_by = i_processed_by
        WHERE pool_id = i_pool_id;
    END IF;

-- End of solution
END //
DELIMITER ;

-- ID: 11b
-- Author: ahatcher8@
-- Name: process_test
DROP PROCEDURE IF EXISTS process_test;
DELIMITER //
CREATE PROCEDURE process_test(
    IN i_test_id VARCHAR(7),
    IN i_test_status VARCHAR(20)
)
BEGIN
-- Type solution below

    IF
       i_test_id IN (SELECT test_id FROM test)
    THEN
        SELECT test_status, pool_id
		INTO @curr_test_status, @curr_pool_id
		FROM test
		WHERE test_id = i_test_id;
        
		SELECT pool_status
		INTO @curr_pool_status
		FROM POOL
		WHERE pool_id = @curr_pool_id;
        
        IF 
			 @curr_test_status = 'pending' AND @curr_pool_status = 'positive' AND i_test_status IN ('negative','positive','pending')
        THEN
			UPDATE test
			SET test_status = i_test_status
			WHERE test_id = i_test_id;
		ELSE 
			IF @curr_test_status  = 'pending' AND @curr_pool_status = 'negative' AND i_test_status = 'negative'
			THEN
				UPDATE test
				SET test_status = i_test_status
				WHERE test_id = i_test_id;
			END IF;
        END IF;
        
    END IF;

-- End of solution
END //
DELIMITER ;

-- ID: 12a
-- Author: dvaidyanathan6
-- Name: create_appointment

DROP PROCEDURE IF EXISTS create_appointment;
DELIMITER //
CREATE PROCEDURE create_appointment(
	IN i_site_name VARCHAR(40),
    IN i_date DATE,
    IN i_time TIME
)
BEGIN
-- Type solution below

	SELECT EXISTS (SELECT * FROM appointment WHERE site_name = i_site_name AND appt_date = i_date AND appt_time = i_time)
	INTO @curr_exist;
	
    IF 
		@curr_exist = 0
	THEN
		SELECT COUNT(*) * 10
        INTO @limit_appt_num
        FROM working_at
        WHERE site = i_site_name;
        
		SELECT COUNT(*)
        INTO @curr_appt_num
        FROM appointment
        WHERE site_name = i_site_name AND appt_date = i_date;
        
        IF 
			@curr_appt_num < @limit_appt_num
		THEN
			INSERT INTO appointment (username, site_name, appt_date, appt_time) VALUES (NULL, i_site_name, i_date, i_time);
        END IF;
            
    END IF;
    
-- End of solution
END //
DELIMITER ;

-- ID: 13a
-- Author: dvaidyanathan6@
-- Name: view_appointments
DROP PROCEDURE IF EXISTS view_appointments;
DELIMITER //
CREATE PROCEDURE view_appointments(
    IN i_site_name VARCHAR(40),
    IN i_begin_appt_date DATE,
    IN i_end_appt_date DATE,
    IN i_begin_appt_time TIME,
    IN i_end_appt_time TIME,
    IN F INT  -- 0 for "booked only", 1 for "available only", NULL for "all"
)
BEGIN
    DROP TABLE IF EXISTS view_appointments_result;
    CREATE TABLE view_appointments_result(

        appt_date DATE,
        appt_time TIME,
        site_name VARCHAR(40),
        location VARCHAR(40),
        username VARCHAR(40));

    INSERT INTO view_appointments_result
-- Type solution below 

	SELECT a.appt_date, a.appt_time, a.site_name, b.location, a.username
	FROM 
	(SELECT appt_date, appt_time, site_name, username
	FROM appointment
	WHERE 
	((i_begin_appt_time IS NOT NULL AND i_end_appt_time IS NOT NULL AND i_begin_appt_time <= i_end_appt_time AND appt_time >= i_begin_appt_time AND appt_time <= i_end_appt_time)
    OR
    (i_begin_appt_time IS NOT NULL AND i_end_appt_time IS NULL AND appt_time >= i_begin_appt_time)
	OR
    (i_begin_appt_time IS NULL AND i_end_appt_time IS NOT NULL AND appt_time <= i_end_appt_time)
	OR
    (i_begin_appt_time IS NULL AND i_end_appt_time IS NULL))
    AND
    ((i_site_name IS NULL)
    OR
    (i_site_name IS NOT NULL AND site_name = i_site_name))
    AND 
    ((username IS NOT NULL AND F = 0) 
    OR (username IS NULL AND F = 1) 
    OR (F IS NULL))
    AND
    ((i_begin_appt_date IS NOT NULL AND i_end_appt_date IS NOT NULL AND i_begin_appt_date <= i_end_appt_date AND appt_date >= i_begin_appt_date AND appt_date <= i_end_appt_date)
    OR
    (i_begin_appt_date IS NOT NULL AND i_end_appt_date IS NULL AND appt_date >= i_begin_appt_date)
    OR
    (i_begin_appt_date IS NULL AND i_end_appt_date IS NOT NULL AND appt_date <= i_end_appt_date)
    OR
	(i_begin_appt_date IS NULL AND i_end_appt_date IS NULL))
    ) a
	LEFT JOIN site b
	ON a.site_name = b.site_name;

-- End of solution
END //
DELIMITER ;


-- ID: 14a
-- Author: kachtani3@
-- Name: view_testers
DROP PROCEDURE IF EXISTS view_testers;
DELIMITER //
CREATE PROCEDURE view_testers()
BEGIN
    DROP TABLE IF EXISTS view_testers_result;
    CREATE TABLE view_testers_result(

        username VARCHAR(40),
        name VARCHAR(80),
        phone_number VARCHAR(10),
        assigned_sites VARCHAR(255));

    INSERT INTO view_testers_result
-- Type solution below

    SELECT x.username, x.name, x.phone_number, y.assigned_sites
	FROM 
	(SELECT c.username, c.phone_number, CONCAT(d.fname, ' ', d.lname) AS name
	FROM
	(SELECT a.sitetester_username AS username, b.phone_num as phone_number
	FROM sitetester a
	LEFT JOIN employee b
	ON a.sitetester_username = b.emp_username) c
	LEFT JOIN user d
	ON c.username = d.username) x
	LEFT JOIN 
	(SELECT username, GROUP_CONCAT(site) AS assigned_sites
	FROM working_at
	GROUP BY username) y
	ON x.username = y.username;

-- End of solution
END //
DELIMITER ;

-- ID: 15a
-- Author: kachtani3@
-- Name: create_testing_site
DROP PROCEDURE IF EXISTS create_testing_site;
DELIMITER //
CREATE PROCEDURE create_testing_site(
	IN i_site_name VARCHAR(40),
    IN i_street varchar(40),
    IN i_city varchar(40),
    IN i_state char(2),
    IN i_zip char(5),
    IN i_location varchar(40),
    IN i_first_tester_username varchar(40)
)
BEGIN
-- Type solution below
INSERT INTO SITE (site_name, street, city, state, zip, location) VALUES (i_site_name, i_street, i_city, i_state, i_zip, i_location);
INSERT INTO WORKING_AT (username, site) VALUES (i_first_tester_username, i_site_name);
-- End of solution
END //
DELIMITER ;

-- ID: 16a
-- Author: kachtani3@
-- Name: pool_metadata
DROP PROCEDURE IF EXISTS pool_metadata;
DELIMITER //
CREATE PROCEDURE pool_metadata(
    IN i_pool_id VARCHAR(10))
BEGIN
    DROP TABLE IF EXISTS pool_metadata_result;
    CREATE TABLE pool_metadata_result(
        pool_id VARCHAR(10),
        date_processed DATE,
        pooled_result VARCHAR(20),
        processed_by VARCHAR(100));

    INSERT INTO pool_metadata_result
-- Type solution below
    SELECT p.pool_id, p.process_date, p.pool_status, LOWER(CONCAT(u.fname, u.lname))
    FROM POOL as p LEFT JOIN USER as u ON p.processed_by = u.username
    WHERE (pool_id = i_pool_id);

-- End of solution
END //
DELIMITER ;

-- ID: 16b
-- Author: kachtani3@
-- Name: tests_in_pool
DROP PROCEDURE IF EXISTS tests_in_pool;
DELIMITER //
CREATE PROCEDURE tests_in_pool(
    IN i_pool_id VARCHAR(10))
BEGIN
    DROP TABLE IF EXISTS tests_in_pool_result;
    CREATE TABLE tests_in_pool_result(
        test_id varchar(7),
        date_tested DATE,
        testing_site VARCHAR(40),
        test_result VARCHAR(20));

    INSERT INTO tests_in_pool_result
-- Type solution below
	SELECT test_id, appt_date, appt_site, test_status from TEST
    where (pool_id = i_pool_id);

-- End of solution
END //
DELIMITER ;

-- ID: 17a
-- Author: kachtani3@
-- Name: tester_assigned_sites
DROP PROCEDURE IF EXISTS tester_assigned_sites;
DELIMITER //
CREATE PROCEDURE tester_assigned_sites(
    IN i_tester_username VARCHAR(40))
BEGIN
    DROP TABLE IF EXISTS tester_assigned_sites_result;
    CREATE TABLE tester_assigned_sites_result(
        site_name VARCHAR(40));

    INSERT INTO tester_assigned_sites_result
-- Type solution below
	SELECT site from WORKING_AT
    WHERE (username = i_tester_username);

-- End of solution
END //
DELIMITER ;

-- ID: 17b
-- Author: kachtani3@
-- Name: assign_tester
DROP PROCEDURE IF EXISTS assign_tester;
DELIMITER //
CREATE PROCEDURE assign_tester(
	IN i_tester_username VARCHAR(40),
    IN i_site_name VARCHAR(40)
)
BEGIN
-- Type solution below
	IF EXISTS (SELECT * FROM SITETESTER WHERE sitetester_username = i_tester_username) THEN
    IF EXISTS (SELECT site_name FROM SITE WHERE site_name = i_site_name) THEN
	INSERT INTO WORKING_AT (username, site) VALUES (i_tester_username, i_site_name);
    END IF;
	END IF;
-- End of solution
END //
DELIMITER ;


-- ID: 17c
-- Author: kachtani3@
-- Name: unassign_tester
DROP PROCEDURE IF EXISTS unassign_tester;
DELIMITER //
CREATE PROCEDURE unassign_tester(
	IN i_tester_username VARCHAR(40),
    IN i_site_name VARCHAR(40)
)
BEGIN
-- Type solution below
IF (SELECT COUNT(*) FROM WORKING_AT WHERE site = i_site_name) > 1 THEN
DELETE FROM WORKING_AT
WHERE (username = i_tester_username AND site = i_site_name);
END IF;
-- End of solution
END //
DELIMITER ;


-- ID: 18a
-- Author: lvossler3
-- Name: daily_results
DROP PROCEDURE IF EXISTS daily_results;
DELIMITER //
CREATE PROCEDURE daily_results()
BEGIN
	DROP TABLE IF EXISTS daily_results_result;
    CREATE TABLE daily_results_result(
		process_date date,
        num_tests int,
        pos_tests int,
        pos_percent DECIMAL(6,2));
	INSERT INTO daily_results_result
    -- Type solution below

    SELECT p.process_date, 
	   count(*) AS total,
       count(CASE WHEN test_status = 'positive' THEN 1 END) AS pos_count, 
	   (count(CASE WHEN test_status = 'positive' THEN 1 END)/count(*)) * 100 AS percentage
	FROM TEST AS t 
	LEFT JOIN POOL AS p 
	ON t.pool_id = p.pool_id
	GROUP BY p.process_date
	HAVING p.process_date IS NOT NULL;
    
    -- End of solution
    END //
    DELIMITER ;