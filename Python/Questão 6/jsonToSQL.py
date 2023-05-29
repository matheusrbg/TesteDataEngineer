import pandas as pd
from pandas import json_normalize
import json
import pyodbc as db
import sys

path = sys.argv[1]
mypasswordFile = sys.argv[2]

with open(mypasswordFile, 'r') as f:
    pwd = f.read()

# Importando Json  
with open(path) as f:
    content = json.load(f)
    df = json_normalize(content['procedimentos'])
    
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

# Assumindo tabela já criada

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