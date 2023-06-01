-- Active: 1685318355790@@127.0.0.1@3306@eds

-- Criei o schema de todos os hospitais
CREATE SCHEMA stg_hospital_a;

-- Criei o schema do prontuario
CREATE SCHEMA stg_prontuario;

-- Criei essa mesma table em todos os hospitais 
CREATE TABLE stg_hospital_a.paciente(  
    id int NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Identificador único sequencial',
    nome VARCHAR(30) COMMENT "Nome do paciente",
    dt_nascimento DATE COMMENT "Data de nascimento do paciente",
    cpf int COMMENT "CPF do paciente",
    nome_mae VARCHAR(30) COMMENT "Nome da mãe do paciente",
    dt_atualizacao TIMESTAMP COMMENT "Data e hora de atualização do registro",
) COMMENT 'Criação da tabela paciente';


-- Populando os schemas
INSERT INTO stg_hospital_a.paciente (nome,dt_nascimento,cpf,nome_mae, dt_atualizacao) VALUES('Joao Gomes','1999-11-23',1364668,'Joana Gomes',"2021-04-03 11:56:23");

INSERT INTO stg_hospital_b.paciente (nome,dt_nascimento,cpf,nome_mae, dt_atualizacao) VALUES('Jose Santos','1995-05-12',1234134,'Maria da Silva',"2021-04-05 09:59:34");

INSERT INTO stg_hospital_c.paciente (nome,dt_nascimento,cpf,nome_mae, dt_atualizacao) VALUES('Maria Joyse Rodrigues','2005-06-30',1241123,'Zeni Rodrigues',"2022-04-03 11:35:14");

INSERT INTO stg_prontuario.atendimentos (id_hosp,id_pac,id_med,tipo,dt_atendimento) VALUES(1,2,3,'A',"2022-04-06 11:35:14");
INSERT INTO stg_prontuario.atendimentos (id_hosp,id_pac,id_med,tipo,dt_atendimento) VALUES(1,2,3,'U',"2022-04-01 11:35:14");
