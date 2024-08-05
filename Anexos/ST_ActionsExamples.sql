--
-- Unidade Curricular de Bases de Dados.
-- Agência de Detetives "Secret Story"
--
-- AÇÕES SIMPLES
-- Inserts, deletes, selects, updates de exemplo
--
-- Grupo 2, 2024
--
-- 

-- Indicação da Base de Dados de Trabalho.
USE Agencia;

-- -----------------------------------------
-- CLIENTE
-- Procedimento para insert de novo cliente com telemóvel associado
DELIMITER $$

CREATE PROCEDURE addNovoCliente(
    IN nome VARCHAR(30),
    IN email VARCHAR(50),
    IN pass VARCHAR(15),
    IN concelho VARCHAR(20),
    IN cod_postal VARCHAR(8),
    IN rua VARCHAR(50),
    IN tele VARCHAR(13)
)
BEGIN
    DECLARE ErroTransacao BOOL DEFAULT 0;
    DECLARE novo_cliente_id INT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET ErroTransacao = 1;

    START TRANSACTION;

    -- Inserir novo cliente
    INSERT INTO Cliente (nome, email, pass, concelho, cod_postal, rua)
    VALUES (nome, email, pass, concelho, cod_postal, rua);

    SET novo_cliente_id = LAST_INSERT_ID();

    -- Associar telemóvel ao cliente
    INSERT INTO Tele_cliente (tele_cliente, cliente_id)
    VALUES (tele, novo_cliente_id);

    IF ErroTransacao THEN
        -- Desfazer as operações realizadas.
        ROLLBACK;
        SELECT 'Erro ao adicionar novo cliente.' AS Message;
    ELSE
        -- Confirmar as operações realizadas.
        COMMIT;
        SELECT 'Novo cliente adicionado com sucesso.' AS Message;
    END IF;
END $$
/*
DELIMITER ;
-- Chamada do procedimento
CALL addNovoCliente(
    'Nome', 
    'email', 
    'pass', 
    'Concelho', 
    '0000-000', 
    'Rua', 
    '+351919919919'
);
-- Drop do procedimento
DROP PROCEDURE addNovoCliente;

-- Add Cliente
INSERT INTO Cliente (nome, email, pass, concelho, cod_postal, rua) 
VALUES ('Nome do Cliente', 'cliente@email.com', 'Senha123', 'Concelho', '0000-000', 'Rua do Cliente');

-- Update 
UPDATE Cliente 
SET nome = 'Novo Nome', email = 'novo@email.com', pass = 'NovaSenha123', concelho = 'Novo Concelho', cod_postal = '0000-111', rua = 'Nova Rua' 
WHERE id = 1;

-- Associar numero de telemóvel ao cliente
INSERT INTO Tele_cliente
VALUES ('+351911911911', '1');
-- Delete telemóvel cliente
DELETE FROM Tele_cliente
WHERE tele_cliente = '+351911911911';

-- Visualizar telemoveis cliente
SELECT * FROM Tele_cliente
WHERE cliente_id='1';

-- Visualizar Clientes
SELECT * FROM Cliente;

-- -----------------------------------------
-- AGENTE
-- Add Agente
INSERT INTO Agente (nome, cargo, data_nasc, email, pass, concelho, cod_postal, rua, centro_id, tele) 
VALUES ('Nome', 'Novato', '2024-01-01','mail', 'pass', 'Concelho', '0000-000', 'Rua', '1','+351911911911');

-- update data ( Mudanças de cargo ou centro por exemplo -> Novato, Perito,Veterano, Ex-Detetive)
UPDATE Agente
SET cargo = "Ex-Detetive" 
WHERE id = 1;


-- Visualizar agentes
SELECT * FROM Agente;


-- -----------------------------------------
-- CENTRO
-- Adicionar Centro
INSERT INTO Centro (nome_direcao, concelho, rua, cod_postal, tele) 
VALUES ('Nome do Diretor', 'Concelho', 'rua','0000-000', '+351911911911');

-- Delete 
DELETE FROM Centro 
WHERE id = '1';

-- Visualizar Centros
SELECT * FROM Centro;

-- -----------------------------------------
-- DENUNCIA
-- Adicionar denuncia
INSERT INTO Denuncia (concelho, cod_postal, rua, descricao, cliente_id) 
VALUES ('Concelho','0000-000', 'rua','descrição', '1');

-- Update Caso
UPDATE Caso
SET estado_atual = 'Registada'
WHERE id = 1;

-- Delete 
DELETE FROM Denuncia 
WHERE id = '1';

-- Visualizar denuncias
SELECT * FROM Denuncia;
*/

-- -----------------------------------------
-- CASO
-- Visualizar casos
-- SELECT * FROM Caso;


DELIMITER $$

-- Procedimento de adição de um caso, associado a uma denuncia, agente e tipo
CREATE PROCEDURE addNovoCaso(
    IN denuncia_id INT,
    IN agente_id INT,
    IN tipo_numero INT
)
BEGIN
    DECLARE ErroTransacao BOOL DEFAULT 0;
    DECLARE novo_caso_id INT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET ErroTransacao = 1;
    START TRANSACTION;

    -- Inserir novo caso
    INSERT INTO Caso (denuncia_id) VALUES (denuncia_id);
	SET novo_caso_id = LAST_INSERT_ID();
    
    -- Atualizar estado denúncia 
    UPDATE Denuncia SET estado_atual = "Registado" WHERE id = denuncia_id;
    
    -- Associar agente ao caso
    INSERT INTO Agente_responsavel_caso (agente_id, caso_id) VALUES (agente_id, novo_caso_id);

    -- Associar tipo de caso ao caso
    INSERT INTO Caso_pertence_tipo (caso_id, tipo_numero) VALUES (novo_caso_id, tipo_numero);
    
    IF ErroTransacao THEN
        ROLLBACK; -- Desfazer as operações realizadas.
        SELECT 'Erro ao adicionar novo caso.' AS Message;
    ELSE
        COMMIT; -- Confirmar as operações realizadas.
        SELECT 'Caso adicionado com sucesso.' AS Message;
    END IF;
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL addNovoCaso('1', '1', '1');
-- Drop do procedimento
DROP PROCEDURE addNovoCaso;


-- Procedimento de remoção de um caso, associado a uma denuncia, agente e tipo
DELIMITER $$

CREATE PROCEDURE delCaso(
    IN caso INT
)
BEGIN
    DECLARE ErroTransacao BOOL DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET ErroTransacao = 1;

    START TRANSACTION;

    -- Remover associações de agentes com o caso
    DELETE FROM Agente_responsavel_caso
    WHERE caso_id = caso;

    -- Remover associações de tipos com o caso
    DELETE FROM Caso_pertence_tipo
    WHERE caso_id = caso;

    -- Remover o caso
    DELETE FROM Caso
    WHERE id = caso;

    IF ErroTransacao THEN
        -- Desfazer as operações realizadas.
        ROLLBACK;
        SELECT 'Erro ao remover caso.' AS Message;
    ELSE
        -- Confirmar as operações realizadas.
        COMMIT;
        SELECT 'Caso removido com sucesso.' AS Message;
    END IF;
END $$

DELIMITER ;

-- Chamada do procedimento
CALL delCaso('1');
-- Drop do procedimento
DROP PROCEDURE delCaso;

-- Associar agentes ao caso
INSERT INTO Agente_responsavel_caso
VALUES ('1', '1');
-- Desassociar agente do caso
DELETE FROM Agente_responsavel_caso
WHERE agente_id='1';

-- Associar suspeitos ao caso
 INSERT INTO Caso_apresenta_suspeito
 VALUES ('1', '1');
-- Desassociar suspeito do caso
DELETE FROM Caso_apresenta_suspeito
 WHERE suspeito_id='1';

-- Associar tipos ao caso
INSERT INTO Caso_pertence_tipo
VALUES ('1', '1');
-- Desassociar tipo do caso
DELETE FROM Caso_pertence_tipo
WHERE tipo_numero='1';

-- Update Caso
UPDATE Caso
SET Relatório = 'Relatório', data_final= current_date(), estado_atual = 'Encerrado'
WHERE id = 1;


-- -----------------------------------------
-- EVIDENCIA
-- Visualizar evidência
SELECT * FROM Evidencia;

-- Insert evidencia exemplo
INSERT INTO Evidencia (descricao, caso_id)
VALUES ('Descrição da evidência', '1');

-- Delete evidencia
DELETE FROM Evidencia
WHERE id = '1';


-- -----------------------------------------
-- SUSPEITO
-- Visualizar suspeitos
SELECT * FROM Suspeito;
*/
-- Procedimento para insert de novo suspeito já associado a um caso
DELIMITER $$
CREATE PROCEDURE addNovoSuspeito
	(IN caso INT, IN nome VARCHAR(30), IN descricao VARCHAR(150))
BEGIN
    DECLARE ErroTransacao BOOL DEFAULT 0;
    DECLARE novo_suspeito_id INT;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET ErroTransacao = 1;

    START TRANSACTION;

    -- Inserir novo suspeito
    INSERT INTO Suspeito (nome, descricao)
    VALUES (nome, descricao);

    SET novo_suspeito_id = LAST_INSERT_ID();

    -- Associar suspeito ao caso
    INSERT INTO Caso_apresenta_suspeito (caso_id, suspeito_id)
    VALUES (caso, novo_suspeito_id);

    IF ErroTransacao THEN
        -- Desfazer as operações realizadas.
        ROLLBACK;
        SELECT 'Erro ao adicionar novo suspeito.' AS Message;
    ELSE
        -- Confirmar as operações realizadas.
        COMMIT;
        SELECT 'Novo suspeito adicionado com sucesso.' AS Message;
    END IF;
END $$

DELIMITER ;
/*
-- Chamada do procedimento
CALL addNovoSuspeito('1', 'nome', 'descrição do suspeito');
-- Drop do procedimento
DROP PROCEDURE addNovoSuspeito;



-- -----------------------------------------
-- TIPO DE CASO
-- Visualizar tipos de caso
SELECT * FROM Tipo_de_caso;

-- Insert tipo exemplo
INSERT INTO Tipo_de_caso (nome)
VALUES ('Nome do tipo');

-- Delete tipo
DELETE FROM Tipo_de_caso
WHERE numero = '1';
*/