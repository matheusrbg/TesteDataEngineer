import pandas as pd
import pyodbc as db
import sys

path = sys.argv[1]
mypasswordFile = sys.argv[2]

with open(mypasswordFile, 'r') as f:
    pwd = f.read()

# Importando CSV   
df = pd.read_csv(path,header=0)

# Conectando ao Server SQL
conn = db.connect(
    'DRIVER=MySQL ODBC 8.0 ANSI Driver;'
    'SERVER=localhost;'
    'DATABASE=eds;'
    'UID=root;'
    'PWD='+pwd+';'
    'charset=utf8mb4;'
    )
cursor = conn.cursor()

# Creando Tabela
cursor.execute('''
		CREATE TABLE stg_prontuario.procedimentos (
			procedimento_id int primary key auto_increment comment "Id do procedimento",
			name_procedimento varchar(50),
            id_paciente int,
            id_medico int,
            hosp varchar(1),
            FOREIGN KEY (id_paciente,hosp) REFERENCES paciente(id,hosp)
			)
               ''')

# Inserindo dataframe na tabela
for proc in df.itertuples():
    cursor.execute('''
                INSERT INTO stg_prontuario.procedimentos (procedimento_id, name_procedimento, id_paciente, id_medico, hosp)
                VALUES (?,?,?,?,?)
                ''',
                proc.procedimento_id, 
                proc.name_procedimento,
                proc.id_paciente,
                proc.id_medico,
                proc.hosp
                )
conn.commit()