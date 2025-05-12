-- StudentGPA View 

DROP VIEW IF EXISTS StudentGPA;
GO


CREATE VIEW [StudentGPA] AS
SELECT
    S.[StudentID],
    S.[StudentFName],
    S.[StudentLName],
    S.[VIPID],
	StudentClassification,
    COALESCE(AVG(G.[QualityPoints]), 0) AS [GPA],
    COALESCE(SI.[AttemptedHours], 0) AS [AttemptedHours],
    (SM.[MajorName]) AS [MajorName],
	SUM(COALESCE(CC.[MinCreditHours], 0)) AS [EarnedCredits]
FROM
    [Students] S
LEFT JOIN
    [EnrolledCourses] EC ON S.[StudentID] = EC.[StudentID]
LEFT JOIN
    [Grades] G ON EC.[StudentGrade] = G.[LetterGrade]
LEFT JOIN
    [StudentInfo] SI ON S.[InfoID] = SI.[InfoID]
LEFT JOIN
    [ClassificationInfo] CI ON S.[ClassificationID] = CI.[ClassificationID]
LEFT JOIN
    [StudentMajor] SM ON S.[MajorID] = SM.[MajorID]
LEFT JOIN
    [CourseOffering] CO ON EC.[CourseOfferingID] = CO.[CourseOfferingID]
LEFT JOIN
    [CourseCatalog] CC ON CO.[CourseID] = CC.[CourseID]
GROUP BY
    S.[StudentID],
    S.[StudentFName],
    S.[StudentLName],
    S.[VIPID],
    SI.[AttemptedHours],
    CI.[StudentClassification],
    SM.[MajorName]
GO

	--select * 
	--from StudentGPA
	


-- Instructor Average Score View 
-- CTE Expression that retreives the average instructor evaluation scores over the prior 3 semesters 

DROP VIEW IF EXISTS InstructorSummary;
GO
CREATE VIEW InstructorSummary AS
WITH InstructorSummary AS (
  SELECT
    Instructors.InstructorID,
    InstructorFName,
    InstructorLName,
    COUNT(DISTINCT CourseOffering.CourseOfferingID) AS NumCoursesTaught,
    COUNT(DISTINCT CourseEvaluationsOnlineResponse.EnrollmentID) AS NumStudentsEvaluatedOnline,
    AVG(CourseEvaluationsOnlineResponse.R1) AS Q1Online,
    AVG(CourseEvaluationsOnlineResponse.R2) AS Q2Online,
    AVG(CourseEvaluationsOnlineResponse.R3) AS Q3Online,
    AVG(CourseEvaluationsOnlineResponse.R4) AS Q4Online,
	AVG(CourseEvaluationsOnlineResponse.R5) AS Q5Online,
	AVG(CourseEvaluationsOnlineResponse.R6) AS Q6Online,
    AVG(CourseEvaluationsOnlineResponse.R7) AS Q7Online,
    AVG(CourseEvaluationsOnlineResponse.R8) AS Q8Online,
	AVG(CourseEvaluationsOnlineResponse.R9) AS Q9Online,
	AVG(CourseEvaluationsOnlineResponse.R10) AS Q10Online,
    AVG(CourseEvaluationsOnlineResponse.R11) AS Q11Online,
    AVG(CourseEvaluationsOnlineResponse.R12) AS Q12Online,
	AVG(CourseEvaluationsOnlineResponse.R13) AS Q13Online,
    AVG(CourseEvaluationsOnlineResponse.R14) AS Q14Online,
    AVG(CourseEvaluationsOnlineResponse.R15) AS Q15Online,
	AVG(CourseEvaluationsOnlineResponse.R16) AS Q16Online,
	AVG(CourseEvaluationsOnlineResponse.R17) AS Q17Online,
    AVG(CourseEvaluationsOnlineResponse.R18) AS Q18Online,
    AVG(CourseEvaluationsOnlineResponse.R19) AS Q19Online,
	AVG(CourseEvaluationsOnlineResponse.R20) AS Q20Online,


    COUNT(DISTINCT CourseEvaluationsInPersonResponse.EnrollmentID) AS NumStudentsEvaluatedInPerson,
    AVG(CourseEvaluationsInPersonResponse.R1) AS Q1InPerson,
    AVG(CourseEvaluationsInPersonResponse.R2) AS Q2InPerson,
    AVG(CourseEvaluationsInPersonResponse.R3) AS Q3InPerson,
    AVG(CourseEvaluationsInPersonResponse.R4) AS Q4InPerson,
	AVG(CourseEvaluationsInPersonResponse.R5) AS Q5InPerson,
	AVG(CourseEvaluationsInPersonResponse.R6) AS Q6InPerson,
	AVG(CourseEvaluationsInPersonResponse.R7) AS Q7InPerson,
	AVG(CourseEvaluationsInPersonResponse.R8) AS Q8InPerson,
	AVG(CourseEvaluationsInPersonResponse.R9) AS Q9InPerson,
	AVG(CourseEvaluationsInPersonResponse.R10) AS Q10InPerson,
    AVG(CourseEvaluationsInPersonResponse.R11) AS Q11InPerson,
	AVG(CourseEvaluationsInPersonResponse.R12) AS Q12InPerson,
	AVG(CourseEvaluationsInPersonResponse.R13) AS Q13InPerson,
	AVG(CourseEvaluationsInPersonResponse.R14) AS Q14InPerson,
	AVG(CourseEvaluationsInPersonResponse.R15) AS Q15InPerson,
    AVG(CourseEvaluationsInPersonResponse.R16) AS Q16InPerson
			   
  FROM
    Instructors
    INNER JOIN CourseOffering ON Instructors.InstructorID = CourseOffering.InstructorID
    LEFT JOIN EnrolledCourses ON CourseOffering.CourseOfferingID = EnrolledCourses.CourseOfferingID
    LEFT JOIN CourseEvaluationsOnlineResponse ON EnrolledCourses.EnrollmentID = CourseEvaluationsOnlineResponse.EnrollmentID
    LEFT JOIN CourseEvaluationsInPersonResponse ON EnrolledCourses.EnrollmentID = CourseEvaluationsInPersonResponse.EnrollmentID
    LEFT JOIN AcademicTerm ON CourseOffering.TermID = AcademicTerm.TermID
  WHERE
    AcademicTerm.Semester IN ('Spring', 'Summer', 'Fall')
    AND AcademicTerm.Year >= YEAR(GETDATE()) - 3   -- filters to the prior 3 semesters based on the current date 
  GROUP BY
    Instructors.InstructorID, Instructors.InstructorFName, Instructors.InstructorLName
)

SELECT
  InstructorID,
  InstructorFName,
  InstructorLName,
  NumCoursesTaught,
  NumStudentsEvaluatedOnline,
  Q1Online,
  Q2Online,
  Q3Online,
  Q4Online,
  Q5Online,
  Q6Online,
  Q7Online,
  Q8Online,
  Q9Online,
  Q10Online,
  Q11Online,
  Q12Online,
  Q13Online,
  Q14Online,
  Q15Online,
  Q16Online,
  Q17Online,
  Q18Online,
  Q19Online,
  Q20Online,

  NumStudentsEvaluatedInPerson,
  Q1InPerson,
  Q2InPerson,
  Q3InPerson,
  Q4InPerson,
  Q5InPerson,
  Q6InPerson,
  Q7InPerson,
  Q8InPerson,
  Q9InPerson,
  Q10InPerson,
  Q11InPerson,
  Q12InPerson,
  Q13InPerson,
  Q14InPerson,
  Q15InPerson,
  Q16InPerson

FROM
  InstructorSummary;
GO
 --select * 
 --from [dbo].[InstructorSummary]
 
 
 
 
 

 
 
 
 
 -- Prerequisite Lookup Query
-- Instructions: For the courseID you want to find the Prerequisites for, simply put in the
-- ID in the WHERE clause and use the CourseCatalog to find the course name for the prerequisite.
-- Prerequisite Lookup Query
-- Instructions: For the courseID you want to find the Prerequisites for, simply put in the
-- ID in the WHERE clause and use the CourseCatalog to find the course name for the prerequisite.
SELECT DISTINCT
    PrerequisiteInfo.PrereqFor AS TargetCourseID,
    CourseCatalogTarget.CourseTitle AS TargetCourseTitle,   -- PrereqIS
    CourseCatalogTarget.CourseNumber AS TargetCourseNumber,
    PrerequisiteInfo.PrerequisiteID,
    CourseCatalogPrereq.CourseTitle AS PrerequisiteCourseTitle,  --PrereqFor
    CourseCatalogPrereq.CourseNumber AS PrerequisiteCourseNumber 
FROM
    PrerequisiteInfo
INNER JOIN
    CourseCatalog AS CourseCatalogPrereq ON PrerequisiteInfo.PrereqIs = CourseCatalogPrereq.CourseID
INNER JOIN
    CourseCatalog AS CourseCatalogTarget ON PrerequisiteInfo.PrereqFor = CourseCatalogTarget.CourseID

-- Want to search for a specific course? 
-- WHERE PrerequisiteInfo.PrereqFor = 'TargetCourseID' 
-- Or also search the course by its name. 
-- WHERE CourseCatalogTarget.CourseTitle = 'Object-Oriented Programming I' 

ORDER BY PrerequisiteInfo.PrereqFor ASC;
 



-- Professor Courses Taught Query 
-- Query that shows all the courses taught by a specific professsor at USCB. 
-- Simply put in the first and last name for an Instructor on the where clause on line 24. 
-- NOTE: Some instructors have Middle initaials in the Instructors Table. 
SELECT
    AcademicTerm.Semester,
    AcademicTerm.Year,
    SubjectDetails.SubjectName AS Subject,
    CourseCatalog.CourseNumber,
    CourseCatalog.CourseTitle,
    Location.BuildingLocation + ' ' + Location.RoomNumber AS Location,
    Instructors.InstructorFName + ' ' + Instructors.InstructorLName AS Instructor
FROM
    CourseOffering
JOIN
    CourseCatalog ON CourseOffering.CourseID = CourseCatalog.CourseID
JOIN
    Instructors ON CourseOffering.InstructorID = Instructors.InstructorID
JOIN
    AcademicTerm ON CourseOffering.TermID = AcademicTerm.TermID
JOIN
    SubjectDetails ON CourseCatalog.SubjectID = SubjectDetails.SubjectID
JOIN
    Location ON CourseOffering.LocationID = Location.LocationID
WHERE
    Instructors.InstructorFName + ' ' + Instructors.InstructorLName = 'Ronald Erdei'
ORDER BY
    AcademicTerm.Year DESC,
    CASE
        WHEN AcademicTerm.Semester = 'Fall' THEN 1
        WHEN AcademicTerm.Semester = 'Summer' THEN 2
        WHEN AcademicTerm.Semester = 'Spring' THEN 3
        ELSE 4
    END DESC;

-- To look up all instructors at USCB 
--select * 
--from Instructors 



-- Student Courses Query 
-- Show all courses for a specific student, organized by semester
SELECT
    AcademicTerm.Semester,
    AcademicTerm.Year,
    SubjectDetails.SubjectName AS Subject,
    CourseCatalog.CourseNumber,
    CourseCatalog.CourseTitle,
    Instructors.InstructorFName + ' ' + Instructors.InstructorLName AS Instructor,
    CASE
        WHEN EnrolledCourses.StudentGrade IS NULL THEN 'In Progress'
        ELSE EnrolledCourses.StudentGrade
    END AS Grade
FROM
    Students
JOIN
    EnrolledCourses ON Students.StudentID = EnrolledCourses.StudentID
JOIN
    CourseOffering ON EnrolledCourses.CourseOfferingID = CourseOffering.CourseOfferingID
JOIN
    CourseCatalog ON CourseOffering.CourseID = CourseCatalog.CourseID
JOIN
    Instructors ON CourseOffering.InstructorID = Instructors.InstructorID
JOIN
    AcademicTerm ON CourseOffering.TermID = AcademicTerm.TermID
JOIN
    SubjectDetails ON CourseCatalog.SubjectID = SubjectDetails.SubjectID
WHERE
    Students.StudentID = '1065'
ORDER BY
    AcademicTerm.Year,
    CASE
        WHEN AcademicTerm.Semester = 'Spring' THEN 1
        WHEN AcademicTerm.Semester = 'Summer' THEN 2
        WHEN AcademicTerm.Semester = 'Fall' THEN 3
        ELSE 4
    END;



