--Q1
SELECT *
FROM lecturers 
WHERE address LIKE '%Hai Ba Trung%'
ORDER BY fullname DESC;

--Q2
SELECT 
	lecturers.fullname, 
	lecturers.address, 
	lecturers.dob
FROM
	participation  
	LEFT JOIN lecturers
		ON participation.lid = lecturers.lid
	LEFT JOIN projects 
		ON participation.pid = projects.pid
WHERE projects.title = 'Grid Computing';

--Q3
SELECT 
	lecturers.fullname, 
	lecturers.address, 
	lecturers.dob
FROM
	participation  
	LEFT JOIN lecturers
		ON participation.lid = lecturers.lid
	LEFT JOIN projects 
		ON participation.pid = projects.pid
WHERE 
	projects.title = 'Grid Computing'
	OR projects.title = 'Automatic English-Vietnamese Translation';

--Q4
SELECT lecturers.fullname
FROM 
	participation  
	LEFT JOIN lecturers
		ON participation.lid = lecturers.lid
GROUP BY 1
HAVING COUNT(*) >= 2

--Q5
SELECT lecturers.fullname
FROM 
	participation  
	LEFT JOIN lecturers
		ON participation.lid = lecturers.lid
GROUP BY 1
HAVING COUNT(*) >= ALL(
	SELECT COUNT(*) 
	FROM participation
	GROUP BY participation.lid);
	
SELECT MIN(cost)
FROM projects;

--Q6
SELECT *
FROM projects 
WHERE cost <= ALL(SELECT cost FROM projects);

--Q7
SELECT 
	lecturers.fullname, 
	lecturers.address, 
	lecturers.dob,
	projects.title
FROM
	participation  
	LEFT JOIN lecturers
		ON participation.lid = lecturers.lid
	LEFT JOIN projects 
		ON participation.pid = projects.pid
WHERE lecturers.address LIKE '%Tay Ho%';

--Q8
SELECT 
	lecturers.fullname, 
	lecturers.address, 
	lecturers.dob
FROM
	participation  
	LEFT JOIN lecturers
		ON participation.lid = lecturers.lid
	LEFT JOIN projects 
		ON participation.pid = projects.pid
WHERE 
	projects.title = 'Text Classification'
	AND lecturers.dob < '01/01/1980';
	
--Q9
SELECT 
	lecturers.lid, 
	lecturers.fullname, 
	SUM(participation.duration)
FROM
	participation  
	LEFT JOIN lecturers
		ON participation.lid = lecturers.lid
GROUP BY 1;

--Q10
INSERT INTO lecturers(lid,fullname, address, dob)
VALUES ('GV06','Ngo Tuan Phong', 'Dong Da, Hanoi', '08/09/1986');

--Q11
UPDATE lecturers 
SET address = 'Tay Ho, Hanoi'
WHERE fullname = 'Vu Tuyet Trinh';

--Q12
DELETE FROM participation 
WHERE LID = 'GV02'

DELETE FROM lecturers 
WHERE LID = 'GV02'