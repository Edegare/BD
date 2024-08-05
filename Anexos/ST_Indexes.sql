--
-- Unidade Curricular de Bases de Dados.
-- Agência de Detetives "Secret Story"
--
-- INDICES
-- Criação, alteração e remoção de índices.
--
-- Grupo 2, 2024
--
-- 

-- Indicação da Base de Dados de Trabalho.
USE Agencia;

--
-- Criacao de um índice sobre o atributo "data_denuncia" da tabela "Denuncia"
CREATE INDEX idxDataDenuncia
	ON Denuncia (data_denuncia);

--
-- Criacao de um índice único sobre o atributo "email" da tabela "Cliente"
-- Unicidade Garantida e melhor desempenho em consultas (Pior nas inserções, atualizações, etc)
CREATE UNIQUE INDEX idxEMail 
	ON Cliente (email);
    
-- Drop do indice
DROP INDEX idxEMail ON Cliente;

--
-- Consultas de seleção do email serão mais rápidas porque o índice já contém todos os emails.
-- Facilita assim a busca pelos emails dos clientes, e consequentemente ajudará caso seja necessário enviar um email a todos os clientes.
SELECT email FROM Cliente;

-- Consultas com filtros por um certo email serão mais rápidas porque o índice permite a busca rápida pelo email especifico.
-- Facilita assim a busca por um certo cliente através do seu email. Por exemplo, caso o cliente tenha enviado uma mensagem à direção e a direção queira saber quem está por detrás do mail
SELECT * FROM Cliente WHERE email = 'jo@gmail.com';

-- Consultas de ordenação por email serão mais eficientes porque o índice já organiza os emails por ordem.
-- Facilita assim a busca por certos emails ordenados alfabeticamente
SELECT * FROM Cliente ORDER BY email;

-- Visualizacao de todos os índices criados sobre as tabelas da base de dados "Agencia".
-- Utilização de uma vista do sistema - INFORMATION_SCHEMA.STATISTICS
SELECT DISTINCT TABLE_NAME, INDEX_NAME
	FROM INFORMATION_SCHEMA.STATISTICS
	WHERE TABLE_SCHEMA = 'Agencia';