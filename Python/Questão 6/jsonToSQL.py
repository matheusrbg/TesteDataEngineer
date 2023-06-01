import pandas as pd
from pandas import json_normalize
import json
import pyodbc as db
import sys
import requests 

path = sys.argv[1]
mypasswordFile = sys.argv[2]
rollback = bool(sys.argv[3])
stop = int(sys.argv[4])

with open(mypasswordFile, 'r') as f:
    pwd = f.read()

# Acessando a API a partir da biblioteca requests
# req = requests.get('https://api.myapi.com/procedimentos', auth=('user', 'pass'))
# content = req.json()

# Simula o Json importado  
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

# Criando Tabela
try:
    cursor.execute('''
            CREATE TABLE stg_prontuario.procedimentos (
                procedimento_id int primary key auto_increment comment "Id do procedimento",
                name_procedimento varchar(50),
                id_paciente int not null,
                id_medico int not null,
                id_hosp int not null,
                FOREIGN KEY (id_paciente) REFERENCES paciente(id)
                )
                ''')
    conn.commit()
except:
    print("Tabela já existe")


# Inserindo dataframe na tabela
for proc in df.itertuples():
    try:
         cursor.execute('''
                INSERT INTO stg_prontuario.procedimentos (name_procedimento, id_paciente, id_medico, id_hosp)
                VALUES (?,?,?,?)
                ''', 
                proc.name_procedimento,
                proc.id_paciente,
                proc.id_medico,
                proc.id_hosp
                )
    except:
        # Se nós preferirmos com rollback, os comandos anteriores serão apagados
        if(rollback):
            print("ROLLBACK...")
            conn.rollback()
            break
        # Caso contrário, a linha só será pulada
        
        # Se quisermos parar depois de um erro 
        if(stop == 1):
            break
conn.commit()

conn.close()