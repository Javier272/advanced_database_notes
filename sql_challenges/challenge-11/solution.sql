CREATE OR REPLACE TRIGGER trg_ticket_assignment_log
    AFTER INSERT OR UPDATE OF assigned_to ON tickets
    FOR EACH ROW
BEGIN
    IF INSERTING AND :NEW.assigned_to IS NOT NULL THEN
        -- Asignación inicial al crear el ticket
        INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by, valid_from)
        VALUES (:NEW.ticket_id, :NEW.assigned_to, NULL, :NEW.created_at);
        
    ELSIF UPDATING AND :NEW.assigned_to IS NOT NULL THEN
        -- cierra asignacion anterior
        UPDATE ticket_assignments
           SET valid_to = CURRENT_TIMESTAMP
         WHERE ticket_id = :OLD.ticket_id
           AND valid_to IS NULL;
           
        -- abre asignacion
        INSERT INTO ticket_assignments (ticket_id, assigned_to, assigned_by, valid_from)
        VALUES (:NEW.ticket_id, :NEW.assigned_to, NULL, CURRENT_TIMESTAMP);
    END IF;
END;
/



INSERT INTO tickets (title, status, priority, assigned_to, created_at) 
VALUES ('Error de Login', 'open', 'critical', 1, TIMESTAMP '2026-06-01 09:00:00');

INSERT INTO tickets (title, status, priority, assigned_to, created_at) 
VALUES ('Actualiza pago', 'open', 'medium', 2, TIMESTAMP '2026-06-02 10:30:00');

INSERT INTO tickets (title, status, priority, assigned_to, created_at, resolved_at) 
VALUES ('Cambia contraseña', 'resolved', 'low', 3, TIMESTAMP '2026-06-03 11:00:00', TIMESTAMP '2026-06-03 14:00:00');

INSERT INTO tickets (title, status, priority, assigned_to, created_at) 
VALUES ('No carga el dashboard', 'open', 'high', 1, TIMESTAMP '2026-06-04 15:00:00');

INSERT INTO tickets (title, status, priority, assigned_to, created_at) 
VALUES ('Exportar reporte a CSV', 'open', 'low', 2, TIMESTAMP '2026-06-05 16:20:00');
COMMIT;

UPDATE tickets
   SET assigned_to = 3, 
       status = 'in_progress'
 WHERE ticket_id = 2;
COMMIT;

CREATE TABLE dim_agent (
    agent_key NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    agent_id NUMBER NOT NULL, -- ID del sistema OLTP
    agent_name VARCHAR2(100) NOT NULL,
    team VARCHAR2(50) NOT NULL
);

CREATE TABLE fact_ticket_daily (
    fact_key NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date_key NUMBER NOT NULL, -- Formato YYYYMMDD
    agent_key NUMBER NOT NULL REFERENCES dim_agent(agent_key),
    status VARCHAR2(50) NOT NULL,
    priority VARCHAR2(50) NOT NULL,
    tickets_created NUMBER DEFAULT 0,
    tickets_resolved NUMBER DEFAULT 0
);


INSERT INTO dim_agent (agent_id, agent_name, team) VALUES (1, 'Ana Torres', 'Soporte N1');
INSERT INTO dim_agent (agent_id, agent_name, team) VALUES (2, 'Pedro Gomez', 'Soporte N2');
INSERT INTO dim_agent (agent_id, agent_name, team) VALUES (3, 'Juan Lopez', 'Ingeniería');
COMMIT;


SELECT 
    f.date_key,
    a.agent_name,
    f.status,
    f.priority,
    SUM(f.tickets_created) AS total_creados,
    SUM(f.tickets_resolved) AS total_resueltos
FROM fact_ticket_daily f
JOIN dim_agent a ON f.agent_key = a.agent_key
GROUP BY 
    f.date_key, 
    a.agent_name, 
    f.status, 
    f.priority
ORDER BY 
    f.date_key, 
    a.agent_name;