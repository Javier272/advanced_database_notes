-- trigger insert
CREATE OR REPLACE TRIGGER trg_insert
BEFORE INSERT ON PET_CARE_LOG
FOR EACH ROW
BEGIN
    :NEW.LAST_UPDATE_DATETIME := SYSDATE;
    :NEW.CREATED_BY_USER := USER;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR('Error de inserción');
END;

-- trigger update
CREATE OR REPLACE TRIGGER trg_update
BEFORE UPDATE ON PET_CARE_LOG
FOR EACH ROW
BEGIN
    IF USER != :OLD.CREATED_BY_USER THEN
        RAISE_APPLICATION_ERROR('Error solo el usuario que creó este registro puede modificar');
    END IF;

    :NEW.LAST_UPDATE_DATETIME := SYSDATE;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20002 THEN RAISE;
        ELSE RAISE_APPLICATION_ERROR('Error en actualización');
        END IF;
END;


-- trigger delete
CREATE OR REPLACE TRIGGER trg_delete
BEFORE DELETE ON PET_CARE_LOG
FOR EACH ROW
BEGIN
    IF USER != 'JOEMANAGER' THEN
        RAISE_APPLICATION_ERROR('Error solo el usuario JOEMANAGER puede eliminar');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20004 THEN RAISE;
        ELSE RAISE_APPLICATION_ERROR('Error al eleminar');
        END IF;
END;
