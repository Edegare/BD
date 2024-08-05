--
-- Unidade Curricular de Bases de Dados.
-- Agência de Detetives "Secret Story"
--
-- CRIAÇÃO
-- Criação da base de dados e respetivas tabelas
--
-- Grupo 2, 2024
--
-- 

-- Criação da base de dados
CREATE SCHEMA IF NOT EXISTS Agencia DEFAULT CHARACTER SET utf8 ;
USE Agencia;
-- DROP DATABASE Agencia;

-- Centro
CREATE TABLE IF NOT EXISTS Centro (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nome_direcao VARCHAR(10) NOT NULL,
  concelho VARCHAR(20) NOT NULL,
  rua VARCHAR(50) NOT NULL,
  cod_postal CHAR(8) NOT NULL,
  tele CHAR(13) NOT NULL
);
-- DROP TABLE Centro;

-- Agente
CREATE TABLE IF NOT EXISTS Agente (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	cargo VARCHAR(15) NOT NULL,
	data_nasc DATE NOT NULL,
	email VARCHAR(50) NOT NULL,
	pass VARCHAR(15) NOT NULL,
	concelho VARCHAR(20) NOT NULL,
	cod_postal CHAR(8) NOT NULL,
	rua VARCHAR(50) NOT NULL,
	centro_id INT NOT NULL,
	tele CHAR(13) NOT NULL,
	FOREIGN KEY (centro_id) REFERENCES Centro(id)
);
-- DROP TABLE Agente;

-- Cliente
CREATE TABLE IF NOT EXISTS Cliente (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	email VARCHAR(50) NOT NULL,
	pass VARCHAR(15) NOT NULL,
	concelho VARCHAR(20) NOT NULL,
	cod_postal CHAR(8) NOT NULL,
	rua VARCHAR(50) NOT NULL
);
-- DROP TABLE Cliente;


-- Denuncia
CREATE TABLE IF NOT EXISTS Denuncia (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	estado_atual VARCHAR(15) NOT NULL DEFAULT "Não registada",
	concelho VARCHAR(20) NOT NULL,
	cod_postal CHAR(8) NOT NULL,
	rua VARCHAR(50) NOT NULL,
	data_denuncia DATE NOT NULL DEFAULT (CURRENT_DATE()),
	descricao VARCHAR(150) NOT NULL,
	cliente_id INT NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES Cliente(id)
);
-- DROP TABLE Denuncia;


-- Tipo de caso
CREATE TABLE IF NOT EXISTS Tipo_de_caso (
	numero INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	nome VARCHAR(30) UNIQUE NOT NULL
);
-- DROP TABLE Tipo_de_caso;

-- Caso
CREATE TABLE IF NOT EXISTS Caso (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	data_registo DATE NOT NULL DEFAULT (CURRENT_DATE()),
	data_final DATE,
	estado_atual VARCHAR(15) NOT NULL DEFAULT "Em progresso",
	relatorio VARCHAR(300) NOT NULL DEFAULT "Sem informações sobre o caso.",
	denuncia_id INT UNIQUE NOT NULL,
	FOREIGN KEY (denuncia_id) REFERENCES Denuncia(id)
);
-- DROP TABLE Caso;

-- Suspeito
CREATE TABLE IF NOT EXISTS Suspeito (
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	descricao VARCHAR(150) NOT NULL
);
-- DROP TABLE Suspeito;

-- Evidencia
CREATE TABLE IF NOT EXISTS Evidencia (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  descricao VARCHAR(150) NOT NULL,
  data_recolha DATE NOT NULL DEFAULT (CURRENT_DATE()),
  caso_id INT NOT NULL,
  FOREIGN KEY (caso_id) REFERENCES Caso(id)
);
-- DROP TABLE Evidencia;

-- Tele dos clientes
CREATE TABLE IF NOT EXISTS Tele_cliente (
  tele_cliente CHAR(13) NOT NULL PRIMARY KEY,
  cliente_id INT NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES Cliente(id)
);
-- DROP TABLE Tele_cliente;

-- Agente responsavel Caso
CREATE TABLE IF NOT EXISTS Agente_responsavel_caso (
  agente_id INT NOT NULL,
  caso_id INT NOT NULL,
  PRIMARY KEY (agente_id, caso_id),
  FOREIGN KEY (agente_id) REFERENCES Agente(id),
  FOREIGN KEY (caso_id) REFERENCES Caso(id)
);
-- DROP TABLE Agente_responsavel_caso;

-- Caso apresenta suspeito
CREATE TABLE IF NOT EXISTS Caso_apresenta_suspeito (
  caso_id INT NOT NULL,
  suspeito_id INT NOT NULL,
  PRIMARY KEY (caso_id, suspeito_id),
  FOREIGN KEY (caso_id) REFERENCES Caso(id),
  FOREIGN KEY (suspeito_id) REFERENCES Suspeito(id)
);
-- DROP TABLE Caso_apresenta_suspeito;


-- Caso pertence tipo
CREATE TABLE IF NOT EXISTS Caso_pertence_tipo (
  caso_id INT NOT NULL,
  tipo_numero INT NOT NULL,
  PRIMARY KEY (caso_id, tipo_numero),
  FOREIGN KEY (caso_id) REFERENCES Caso(id),
  FOREIGN KEY (tipo_numero) REFERENCES Tipo_de_caso(numero)
);
-- DROP TABLE Caso_pertence_tipo;