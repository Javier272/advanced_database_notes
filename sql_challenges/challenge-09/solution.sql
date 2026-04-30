-- excercise 1
SELECT object_type, COUNT(*) AS cnt
FROM user_objects
GROUP BY object_type
ORDER BY object_type;

-- excercise 2
SELECT DBMS_METADATA.GET_DDL('TABLE', 'TASKS') FROM DUAL;

--excercise 3
CREATE TABLE "JAVIER"."TASKS"

--excercise 4
FOREIGN KEY (user_id) REFERENCES users(id)
FOREIGN KEY (team_id) REFERENCES teams(id)

SELECT constraint_name, table_name
FROM user_constraints
WHERE constraint_type = 'R';


--excecise 5
SELECT referenced_name, referencing_name, referencing_type
FROM user_dependencies
ORDER BY referenced_name;


--excecise 6
SELECT object_type, COUNT(*) FROM user_objects GROUP BY object_type;
SELECT table_name FROM user_tables;

SELECT DBMS_METADATA.GET_DDL('TABLE', table_name) FROM user_tables;
SELECT DBMS_METADATA.GET_DDL('TRIGGER', trigger_name) FROM user_triggers;
SELECT DBMS_METADATA.GET_DDL('INDEX', index_name) FROM user_indexes;
SELECT DBMS_METADATA.GET_DDL('CONSTRAINT', constraint_name) FROM user_constraints;

SELECT COUNT(*) FROM user_tables;
SELECT COUNT(*) FROM user_triggers;


--Discussion questions
--Q1: What are the limitations of DBMS_METADATA vs expdp?
--DBMS_METADATA

--Q2: If you have circular dependencies (A depends on B, B depends on A),
-- No tiene ciclos reales

--Q3: Your company is migrating from one Oracle database to another.
--Sacar DDL limpio EMIT_SCHEMA=false
--Revisar FKs tasks depende de users y teams
--Ejecutar en orden correcto
--Crear triggers al final
--Validar conteos

