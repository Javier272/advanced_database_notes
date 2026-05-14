-- excercise 1
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship
from datetime import datetime

class Comment(Base):
    __tablename__ = 'comments'

    id = Column(Integer, primary_key=True)
    task_id = Column(Integer, ForeignKey('tasks.id'), nullable=False)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    content = Column(Text, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    task = relationship("Task", back_populates="comments")
    author = relationship("User", back_populates="comments")

-- Qué relaciones debería tener? 
--Debe tener una relación "Many-to-One" hacia Task y hacia User

--¿Debería Task tener una relación comments?
--Sí, un back_populates en la clase Task permitiría acceder a todos los comentarios de una tare

--¿Qué pasa si se borra una tarea?
--Si se borra la tarea, los comentarios se borran automáticamente


--exercise 2

--upgrade(): Contiene las instrucciones para aplicar los cambios

--downgrade(): Sirve para deshacer esos cambios

--¿Qué pasa si haces downgrade?: Se eliminaría la tabla comments y se pierden los datos almacenados


--exercise 3

new_team = Team(name="DevOps", description="Infrastructure and CI/CD")
session.add(new_team)
session.flush() # Para obtener el ID del team antes del commit


diana = User(username="diana_ops", email="diana@example.com", team_id=new_team.id)
session.add(diana)


tasks = [
    Task(title="Setup Jenkins", status="open", assigned_to=diana.id),
    Task(title="Dockerize App", status="open", assigned_to=diana.id),
    Task(title="Clean Logs", status="open", assigned_to=diana.id)
]
session.add_all(tasks)
session.commit()

count = session.query(Task).count()
print(f"Total tasks: {count}")


tasks[0].status = 'closed'


session.delete(tasks[2])
session.commit()


--exercise 4
--¿Qué pasa con la columna? Desaparec de la tabla en la base de datos

--¿Qué pasa con los datos? Se pierden permanentemente


--exercise 5
--¿Por qué ORM? Permite escribir código Python más limpio y evita errores de sintaxis SQL

--¿Por qué migraciones?Permiten que todo el equipo tenga la misma estructura de tablas y mantienen un historial de cambios.

--¿Cuándo hacer rollback?: Cuando se despliega un cambio que rompe la aplicación

--add() vs commit(): add() coloca el objeto en la cola y commit() envía los cambios a la base de datos.

--¿Por qué relaciones?: Porque permiten navegar por los datos de forma mas facil