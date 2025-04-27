use project_medical_data_history ;
select * from admissions;
select * from doctors;
select * from patients;
select * from province_names;

-- 1. Show first name, last name, and gender of patients who's gender is 'M'
select first_name ,last_name,gender from patients 
where gender = 'M' limit 10;

-- 2. Show first name and last name of patients who does not have allergies.
select first_name , last_name , allergies from patients where allergies is null limit 10;

-- 3. Show first name of patients that start with the letter 'C'
select first_name from patients where first_name like 'c%' limit 10;

-- 4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name , last_name , weight from patients where weight between 100 and 120 order by weight limit 10  ;

-- 5. Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'
update patients set allergies = case 
when allergies is null then  ' NKA'
else null
end ;

-- 6. Show first name and last name concatenated into one column to show their full name.
select first_name , last_name, concat(first_name,' ',last_name) as full_name  from patients limit 10 ;

-- 7. Show first name, last name, and the full province name of each patient.
select p.first_name, p.last_name, pr.province_name from patients as p
join 
province_names as pr on pr.province_id = p.province_id order by province_name limit 10;

-- 8. Show how many patients have a birth_date with 2010 as the birth year.
select   year(birth_date) as birth_year , count(*) as no_patients from patients 
where year(birth_date)  = '2010' group by birth_year; 

-- 9. Show the first_name, last_name, and height of the patient with the greatest height.
select first_name , last_name , max(height) as  height from patients 
group by first_name ,last_name order by height desc limit 10; 

-- 10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000.
select * from patients where patient_id in ( 1,45,534,879,1000);

-- 11. Show the total number of admissions.
select * from admissions;
select count(*) as total_admissions from admissions;

-- 12. Show all the columns from admissions where the patient was admitted and discharged on the same day.
select * from admissions where admission_date = discharge_date limit 10;

-- 13. Show the total number of admissions for patient_id 579.
select count(*) as total_admissions,patient_id  from admissions where patient_id  = 579;

-- 14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct(p.city) ,p.province_id from patients as p
join 
admissions as a on a.patient_id = p.patient_id 
where province_id = 'NS' ;

-- 15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name , last_name,birth_date,height,weight from patients  
where height > 160 and weight > 70 limit 10;

-- 16. Show unique birth years from patients and order them by ascending.
select distinct(year(birth_date)) as birth_year from patients
 order by year(birth_date) asc limit 10;
 
 -- 17. Show unique first names from the patients table which only occurs once in the list.
 select first_name from patients 
 group by first_name
 having count(first_name) = 1 limit 10 ;
 
 -- 18. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id , first_name from patients 
where first_name like 's%s'
and length(first_name) >= 6 limit 10;

-- 19. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.   Primary diagnosis is stored in the admissions table.
select p.patient_id,p.first_name,p.last_name,a.diagnosis from patients as p 
join 
admissions as a on a.patient_id = p.patient_id  
where diagnosis = 'Dementia'; 

-- 20. Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
select  first_name from patients 
order by lenght(first_name), first_name limit 10;

-- 21. Show the total amount of male patients and the total amount of female patients in the patients table. 
-- Display the two results in the same row.
select 
sum(case when gender = "M" then 1 else 0 end) as male_patients ,
sum(case when gender = "F" then 1 else 0 end) as female_patients 
from patients; 

-- 23. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id , diagnosis from admissions 