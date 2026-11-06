-- Clínica SaúdeDigital (CSD)
-- Script de criação do banco de dados e das 7 tabelas.
-- Compatível com MySQL 8.x / MySQL Workbench.

CREATE DATABASE IF NOT EXISTS csd
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE csd;

-- 1. Pacientes
CREATE TABLE IF NOT EXISTS paciente (
    id_paciente INT NOT NULL AUTO_INCREMENT,
    nome_paciente VARCHAR(100) NOT NULL,
    cpf_paciente CHAR(11) NOT NULL,
    data_nascimento DATE NOT NULL,
    telefone_paciente VARCHAR(20) NULL,
    email_paciente VARCHAR(100) NULL,
    PRIMARY KEY (id_paciente),
    UNIQUE KEY uk_paciente_cpf (cpf_paciente)
) ENGINE=InnoDB;

-- 2. Médicos
CREATE TABLE IF NOT EXISTS medico (
    crm VARCHAR(20) NOT NULL,
    nome_medico VARCHAR(100) NOT NULL,
    telefone_medico VARCHAR(20) NULL,
    email_medico VARCHAR(100) NULL,
    PRIMARY KEY (crm)
) ENGINE=InnoDB;

-- 3. Especialidades
CREATE TABLE IF NOT EXISTS especialidade (
    id_especialidade INT NOT NULL AUTO_INCREMENT,
    nome_especialidade VARCHAR(100) NOT NULL,
    descricao_especialidade TEXT NULL,
    PRIMARY KEY (id_especialidade),
    UNIQUE KEY uk_especialidade_nome (nome_especialidade)
) ENGINE=InnoDB;

-- 4. Agendamentos
CREATE TABLE IF NOT EXISTS agendamento (
    id_agendamento INT NOT NULL AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    crm VARCHAR(20) NOT NULL,
    data_agendamento DATETIME NOT NULL,
    data_hora_agendada DATETIME NOT NULL,
    status_agendamento VARCHAR(20) NOT NULL DEFAULT 'Agendada',
    PRIMARY KEY (id_agendamento),
    KEY idx_agendamento_paciente (id_paciente),
    KEY idx_agendamento_medico (crm),
    CONSTRAINT fk_agendamento_paciente
        FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente),
    CONSTRAINT fk_agendamento_medico
        FOREIGN KEY (crm) REFERENCES medico (crm)
) ENGINE=InnoDB;

-- 5. Prontuários: cada paciente possui um prontuário único.
CREATE TABLE IF NOT EXISTS prontuario (
    id_prontuario INT NOT NULL AUTO_INCREMENT,
    id_paciente INT NOT NULL,
    descricao_clinica TEXT NULL,
    data_registro DATETIME NULL DEFAULT NULL,
    PRIMARY KEY (id_prontuario),
    UNIQUE KEY uk_prontuario_paciente (id_paciente),
    CONSTRAINT fk_prontuario_paciente
        FOREIGN KEY (id_paciente) REFERENCES paciente (id_paciente)
) ENGINE=InnoDB;

-- 6. Relação N:N entre médicos e especialidades.
CREATE TABLE IF NOT EXISTS medico_especialidade (
    crm VARCHAR(20) NOT NULL,
    id_especialidade INT NOT NULL,
    PRIMARY KEY (crm, id_especialidade),
    KEY idx_medico_especialidade_especialidade (id_especialidade),
    CONSTRAINT fk_medico_especialidade_medico
        FOREIGN KEY (crm) REFERENCES medico (crm),
    CONSTRAINT fk_medico_especialidade_especialidade
        FOREIGN KEY (id_especialidade) REFERENCES especialidade (id_especialidade)
) ENGINE=InnoDB;

-- 7. Consultas: cada agendamento pode gerar no máximo uma consulta.
-- Um prontuário pode estar relacionado a várias consultas.
CREATE TABLE IF NOT EXISTS consulta (
    id_consulta INT NOT NULL AUTO_INCREMENT,
    id_agendamento INT NOT NULL,
    id_prontuario INT NOT NULL,
    data_hora_realizada DATETIME NULL DEFAULT NULL,
    status_consulta VARCHAR(20) NOT NULL DEFAULT 'Agendada',
    PRIMARY KEY (id_consulta),
    UNIQUE KEY uk_consulta_agendamento (id_agendamento),
    KEY idx_consulta_prontuario (id_prontuario),
    CONSTRAINT fk_consulta_agendamento
        FOREIGN KEY (id_agendamento) REFERENCES agendamento (id_agendamento),
    CONSTRAINT fk_consulta_prontuario
        FOREIGN KEY (id_prontuario) REFERENCES prontuario (id_prontuario)
) ENGINE=InnoDB;
