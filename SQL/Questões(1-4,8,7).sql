-- Active: 1685318355790@@127.0.0.1@3306@eds

--Primeira questão
CREATE TABLE stg_prontuario.paciente(  
    id int NOT NULL AUTO_INCREMENT COMMENT 'Identificador único sequencial',
    hosp VARCHAR(1) COMMENT 'Hospital do paciente',
    nome VARCHAR(30) COMMENT "Nome do paciente",
    dt_nascimento DATE COMMENT "Data de nascimento do paciente",
    cpf int COMMENT "CPF do paciente",
    nome_mae VARCHAR(30) COMMENT "Nome da mãe do paciente",
    dt_atualizacao TIMESTAMP COMMENT "Data e hora de atualização do registro",
    PRIMARY KEY(id,hosp)
) COMMENT 'Criação da tabela paciente';

--Segunda questão
INSERT INTO stg_prontuario.paciente
SELECT p.id,'a',p.nome,p.dt_nascimento,p.cpf,p.nome_mae,p.dt_atualizacao FROM stg_hospital_a.paciente p;

INSERT INTO stg_prontuario.paciente
SELECT p.id,'b',p.nome,p.dt_nascimento,p.cpf,p.nome_mae,p.dt_atualizacao FROM stg_hospital_b.paciente p;

INSERT INTO stg_prontuario.paciente
SELECT p.id,'c',p.nome,p.dt_nascimento,p.cpf,p.nome_mae,p.dt_atualizacao FROM stg_hospital_c.paciente p;

--Terceira questão
SELECT nome, cpf, COUNT(*)
FROM stg_prontuario.paciente
GROUP BY nome,cpf
HAVING COUNT(*) > 1;

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
    id int NOT NULL COMMENT 'Identificador do atendimento',
    hosp VARCHAR(1) COMMENT 'Hospital do atendimento',
    id_pac int COMMENT "Identificador do paciente",
    id_med int COMMENT "Identificador do médico",
    tipo VARCHAR(1) COMMENT 'Tipo de atendimento',
    dt_atendimento TIMESTAMP COMMENT "Data e hora de atendimento",
    PRIMARY KEY(id,hosp,id_pac,id_med)
) COMMENT 'Criação da tabela atendimentos';

CREATE TABLE stg_prontuario.diagnosticos(  
    id_diag int NOT NULL COMMENT 'Identificador do diagnostico',
    id_atend int NOT NULL COMMENT 'Identificador do atendimento',
    hosp VARCHAR(1) COMMENT 'Hospital do atendimento',
    id_pac int COMMENT "Identificador do paciente",
    id_med int COMMENT "Identificador do médico",
    diagnostico VARCHAR(50) COMMENT "Diagnostico",
    descricao VARCHAR(255) COMMENT "Descrição do diagnostico",
    Foreign Key (id_atend,hosp,id_pac,id_med) REFERENCES atendimentos(id,hosp,id_pac,id_med),
    PRIMARY KEY(id_diag,id_atend,hosp,id_pac,id_med)
) COMMENT 'Criação da tabela diagnosticos';

--Oitava questão
SELECT AVG(atendimentos)
FROM(
    SELECT COUNT(*) as atendimentos
    FROM stg_prontuario.atendimentos a
    WHERE tipo = "U"
    GROUP BY date(dt_atendimento)
    ) as atendimentosUrgenciaPorDia;

