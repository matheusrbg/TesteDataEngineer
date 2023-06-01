-- Active: 1685318355790@@127.0.0.1@3306@eds

--Primeira questão
CREATE TABLE stg_prontuario.paciente(  
    id int NOT NULL AUTO_INCREMENT COMMENT 'Identificador único sequencial',
    id_hosp int NOT NULL COMMENT 'Hospital do paciente',
    nome VARCHAR(30) COMMENT "Nome do paciente",
    dt_nascimento DATE COMMENT "Data de nascimento do paciente",
    cpf int COMMENT "CPF do paciente",
    nome_mae VARCHAR(30) COMMENT "Nome da mãe do paciente",
    dt_atualizacao TIMESTAMP COMMENT "Data e hora de atualização do registro",
    --Foreign Key (id_hosp) REFERENCES hospitais(id),
    PRIMARY KEY(id)
) COMMENT 'Criação da tabela paciente';

--Segunda questão
INSERT INTO stg_prontuario.paciente (id_hosp,nome,dt_nascimento,cpf,nome_mae,dt_atualizacao)
SELECT 0,p.nome,p.dt_nascimento,p.cpf,p.nome_mae,p.dt_atualizacao FROM stg_hospital_a.paciente p;

INSERT INTO stg_prontuario.paciente (id_hosp,nome,dt_nascimento,cpf,nome_mae,dt_atualizacao)
SELECT 1,p.nome,p.dt_nascimento,p.cpf,p.nome_mae,p.dt_atualizacao FROM stg_hospital_b.paciente p;

INSERT INTO stg_prontuario.paciente (id_hosp,nome,dt_nascimento,cpf,nome_mae,dt_atualizacao)
SELECT 2,p.nome,p.dt_nascimento,p.cpf,p.nome_mae,p.dt_atualizacao FROM stg_hospital_c.paciente p;

--Terceira questão

-- Retornando os cpfs e a quantidade de duplicados
SELECT cpf, COUNT(*)
FROM stg_prontuario.paciente
GROUP BY cpf
HAVING COUNT(*) > 1;

-- Retornando todos os dados dos pacientes duplicados
SELECT * 
FROM stg_prontuario.paciente 
WHERE
    cpf IN (
        SELECT cpf
        FROM stg_prontuario.paciente
        GROUP BY cpf
        HAVING COUNT(*) > 1
    );

--Quarta questão
SELECT * 
FROM stg_prontuario.paciente 
WHERE
    (cpf, dt_atualizacao) IN ( 
        SELECT cpf, MAX(dt_atualizacao)
        FROM stg_prontuario.paciente
        GROUP BY cpf
        HAVING COUNT(cpf) > 1
    );

--Sétima questão
CREATE TABLE stg_prontuario.atendimentos(  
    id int NOT NULL AUTO_INCREMENT COMMENT 'Identificador do atendimento',
    id_hosp int NOT NULL COMMENT 'Identificador do Hospital',
    id_pac int NOT NULL COMMENT 'Identificador do paciente',
    id_med int NOT NULL COMMENT 'Identificador do médico',
    tipo VARCHAR(1) COMMENT 'Tipo de atendimento',
    dt_atendimento TIMESTAMP COMMENT 'Data e hora de atendimento',
    Foreign Key (id_pac) REFERENCES paciente(id),
    --Foreign Key (id_med) REFERENCES medico(id),
    --Foreign Key (id_hosp) REFERENCES hospitais(id),
    PRIMARY KEY(id)
) COMMENT 'Criação da tabela atendimentos';

CREATE TABLE stg_prontuario.diagnosticos(  
    id int NOT NULL AUTO_INCREMENT COMMENT 'Identificador do diagnostico',
    descricao VARCHAR(255) COMMENT 'Descrição do diagnostico',
    PRIMARY KEY(id)
) COMMENT 'Criação da tabela diagnosticos';

CREATE TABLE stg_prontuario.diagnosticos_de_atendimentos(  
    id_diag int NOT NULL COMMENT 'Identificador do diagnostico',
    id_atend int NOT NULL COMMENT 'Identificador do atendimento',
    comentario VARCHAR(255) COMMENT 'Comentário do médico',
    Foreign Key (id_atend) REFERENCES atendimentos(id),
    Foreign Key (id_diag) REFERENCES diagnosticos(id),
    PRIMARY KEY(id_diag,id_atend)
) COMMENT 'Criação da tabela diagnosticos de atendimentos';

--Oitava questão
SELECT AVG(atendimentos)
FROM(
    SELECT COUNT(*) as atendimentos
    FROM stg_prontuario.atendimentos a
    WHERE tipo = "U"
    GROUP BY date(dt_atendimento)
    ) as atendimentosUrgenciaPorDia;

