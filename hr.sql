데이터 결합 (hr계정, 실습 join8~13)

join8
erd 다이어그램을 참고하여 countries, regions테이블을 이용하여
지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
(지역은 유럽만 한정)

SELECT regions.region_id, regions.region_name, countries.country_name
FROM countries, regions
WHERE regions.region_id = countries.region_id
    AND regions.region_name = 'Europe';
    
join9
erd 다이어그램을 참고하여 countries, regions, locations 테이블을
이용하여 지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같은 결과가
나오도록 쿼리를 작성해보세요
(지역은 유럽만 한정)

SELECT regions.region_id, regions.region_name, countries.country_name, locations.city
FROM countries, regions, locations
WHERE regions.region_id = countries.region_id
    AND countries. country_id = locations.country_id
    AND regions.region_name = 'Europe';
    
join10
 erd 다이어그램을 참고하여 countries, regions, locations, departments
테이블을 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에
있는 부서를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요
(지역은 유럽만 한정)

SELECT regions.region_id, regions.region_name,
        countries.country_name, locations.city,
        departments.department_name
FROM countries, regions, locations,departments
WHERE regions.region_id = countries.region_id
    AND countries. country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND regions.region_name = 'Europe';

join11
erd 다이어그램을 참고하여 countries, regions, locations, departments,
employees 테이블을 이용하여 지역별 소속 국가, 국가에 소속된 도시 이름
및 도시에 있는 부서, 부서에 소속된 직원 정보를 다음과 같은 결과가
나오도록 쿼리를 작성해보세요
(지역은 유럽만 한정)
select *
from employees

SELECT regions.region_id, regions.region_name,
        countries.country_name, locations.city,
        departments.department_name,
        CONCAT(first_name, last_name) name
FROM countries, regions, locations,departments, employees
WHERE regions.region_id = countries.region_id
    AND countries. country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND employees.department_id = departments.department_id
    AND regions.region_name = 'Europe';
    
join12
erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의
담당업무 명칭을 포함하여 다음과 같은 결과가 나오도록 쿼리를
작성해보세요


SELECT employees.employee_id,
        CONCAT(first_name, last_name) name,
        jobs.job_id, jobs.job_title
FROM employees, jobs
WHERE employees.job_id = jobs.job_id;

select *
from employees
select *
from jobs

join13
erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여 직원의
담당업무 명칭, 직원의 매니저 정보 포함하여 다음과 같은 결과가 나오도록
쿼리를 작성해보세요
--SELECT employees.manager_id mgr_id,
--        CONCAT(first_name, last_name) mgr_name,
--        employees.employee_id,
--        CONCAT(first_name, last_name) name,
--        jobs.job_id, jobs.job_title
--FROM employees, jobs
--WHERE employees.job_id = jobs.job_id;

