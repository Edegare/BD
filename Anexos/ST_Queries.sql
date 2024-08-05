--
-- Unidade Curricular de Bases de Dados.
-- Agência de Detetives "Secret Story"
--
-- QUERIES
-- Realização de algumas queries de manipulação da base de dados
--
-- Grupo 2, 2024
--
-- 

-- Indicação da Base de Dados de Trabalho.
USE Agencia;

-- -----------------------------------------------------------------------
-- Procedimento - Visualizar casos associados a um determinado agente ou cliente - RM03
-- Do Cliente
DELIMITER $$
CREATE PROCEDURE verCasosDeCliente(
    IN cliente INT
)
BEGIN
	SELECT Caso.* FROM 
    Caso INNER JOIN Denuncia ON Caso.denuncia_id = Denuncia.id
    WHERE Denuncia.cliente_id = cliente;
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL verCasosDeCliente(1);
-- Drop do procedimento
DROP PROCEDURE verCasosDeCliente;
*/
-- Do Agente
DELIMITER $$
CREATE PROCEDURE verCasosDeAgente(
    IN agente INT
)
BEGIN
    SELECT Caso.*
    FROM Caso INNER JOIN Agente_responsavel_caso ON Caso.id = Agente_responsavel_caso.caso_id
    WHERE Agente_responsavel_caso.agente_id = agente;
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL verCasosDeAgente(1);
-- Drop do procedimento
DROP PROCEDURE verCasosDeAgente;
*/
-- -----------------------------------------------------------------------
-- Saber nº de denúncias feitas por certos clientes, entre datas ou numa determinada localização - RM04
-- Funcão de contar denuncias feitas por certos clientes.
DELIMITER $$

CREATE FUNCTION contarDenunciasDoCliente(
    cliente INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE nDenuncias INT;
    
    SELECT COUNT(*) INTO nDenuncias
    FROM Denuncia
    WHERE Denuncia.cliente_id = cliente;
    
    RETURN nDenuncias;
END $$

DELIMITER ;

/*
SELECT C.nome, COUNT(D.id) AS nDenuncias
    FROM Denuncia AS D
    RIGHT JOIN Cliente AS C 
		ON C.id=D.cliente_id
GROUP BY C.id;

-- Usar a função -> Número de Denúncias de cada cliente
SELECT id, nome, contarDenunciasDoCliente(id) AS total_denuncias
FROM Cliente; -- WHERE Cliente.id = '1'; Caso queiramos só as denúncias do cliente com id 1
-- Remover Função
DROP FUNCTION contarDenunciasDoCliente;
*/
-- Função de contar denuncias feitas entre determinadas datas.
DELIMITER $$
CREATE FUNCTION contarDenunciasEntreDatas(
    data_inicial DATE,
    data_final DATE
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE nDenuncias INT;
    
    SELECT COUNT(*) INTO nDenuncias
    FROM Denuncia
    WHERE data_denuncia > data_inicial AND data_denuncia < data_final;
    
    RETURN nDenuncias;
END $$
DELIMITER ;
/*
-- Usar a função -> Número de Denúncias entre datas
SELECT contarDenunciasEntreDatas('2024-01-01','2024-06-01') AS total_denuncias;
-- Remover Função
DROP FUNCTION contarDenunciasEntreDatas;
*/
-- Função de contar denuncias de um determinado concelho
DELIMITER $$
CREATE FUNCTION contarDenunciasNoConcelho(
    concelhoProcurado VARCHAR(20)
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE nDenuncias INT;
    
    SELECT COUNT(*) INTO nDenuncias
    FROM Denuncia
    WHERE Denuncia.concelho = concelhoProcurado;
    
    RETURN nDenuncias;
END $$
DELIMITER ;
/*
-- Usar a função -> Número de Denúncias de um concelho
SELECT contarDenunciasNoConcelho('Braga') AS total_denuncias;
-- Remover Função
DROP FUNCTION contarDenunciasNoConcelho;
*/
-- -----------------------------------------------------------------------
-- Filtrar caso pelo tipo de caso - RM05
-- Procedimento
DELIMITER $$
CREATE PROCEDURE filtrarCasosDoTipo(
    IN tipo INT
)
BEGIN
	SELECT Caso.* FROM 
    Caso INNER JOIN Caso_pertence_tipo ON Caso.id = Caso_pertence_tipo.caso_id
    WHERE Caso_pertence_tipo.tipo_numero = tipo;
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL filtrarCasosDoTipo(1);
-- Drop do procedimento
DROP PROCEDURE filtrarCasosDoTipo;
*/
-- -----------------------------------------------------------------------
-- Num determinado momento, saber o nº de casos resolvidos para um dado agente - RM06
-- Função - Conta o Número de casos resolvidos de um agente
DELIMITER $$
CREATE FUNCTION contarCasosResolvidosAgente(
    agente INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE nCasos INT;
    
    SELECT COUNT(*)
    INTO nCasos FROM 
    Caso INNER JOIN Agente_responsavel_caso ON Caso.id = Agente_responsavel_caso.caso_id
    WHERE Agente_responsavel_caso.agente_id = agente AND Caso.estado_atual = 'Encerrado';
    
    RETURN nCasos;
END $$
DELIMITER ;
/*
-- Uso da função para tabela com o nome do agente escolhido e os casos resolvidos por esse agente
SELECT Agente.id, Agente.nome, contarCasosResolvidosAgente(Agente.id) AS casos_resolvidos
FROM Agente
ORDER BY casos_resolvidos DESC; -- Do agente com mais casos resolvidos para o agente com menos casos resolvidos
-- Drop Função
DROP FUNCTION contarCasosResolvidosAgente;
*/
-- -----------------------------------------------------------------------
-- Filtrar agentes de um certo cargo -RM10
DELIMITER $$
CREATE PROCEDURE filtrarAgentesPorCargo(
    IN cargoProcurado VARCHAR(15)
)
BEGIN
    SELECT * FROM Agente
    WHERE cargo = cargoProcurado;
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL filtrarAgentesPorCargo('Veterano');
-- Drop do procedimento
DROP PROCEDURE filtrarAgentesPorCargo;
*/
-- -----------------------------------------------------------------------
-- Enumerar informação dos agentes responsáveis por um caso - RM12
-- Procedimento - Tabela com Informação dos agentes do caso
DELIMITER $$
CREATE PROCEDURE verAgentesDoCaso(
    IN caso INT
)
BEGIN
    SELECT Agente.* FROM Agente
    INNER JOIN Agente_responsavel_caso ON Agente.id = Agente_responsavel_caso.agente_id
    WHERE Agente_responsavel_caso.caso_id = caso;
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL verAgentesDoCaso(1);
-- Drop do procedimento
DROP PROCEDURE verAgentesDoCaso;
*/
-- -----------------------------------------------------------------------
-- Visualizar casos que começaram/terminaram entre datas - RM13
-- Procedimento - Lista Casos com começo entre essas datas
DELIMITER $$
CREATE PROCEDURE listarCasosInicioEntreData(
    IN data1 DATE,
    IN data2 DATE
)
BEGIN
	SELECT * FROM Caso
    WHERE data_registo >= data1 AND data_registo <= data2
    ORDER BY data_registo ASC; 
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL listarCasosInicioEntreData('2024-01-01', '2024-12-30');
-- Drop do procedimento
DROP PROCEDURE listarCasosInicioEntreData;
*/
-- Procedimento - Lista Casos com fim entre essas datas
DELIMITER $$
CREATE PROCEDURE listarCasosFimEntreData(
    IN data1 DATE,
    IN data2 DATE
)
BEGIN
	SELECT * FROM Caso
    WHERE 
		(data_final IS NOT NULL) OR
		(data_final >= data1 AND data_final <= data2)
	ORDER BY data_final DESC; 
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL listarCasosFimEntreData('2024-01-01', '2024-12-30');
-- Drop do procedimento
DROP PROCEDURE listarCasosFimEntreData;
*/
-- -----------------------------------------------------------------------
-- Contar casos de um certo tipo - RM15
DELIMITER $$
CREATE FUNCTION contarCasosPorTipo(
    tipo INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_casos INT;
    
    SELECT COUNT(*) INTO total_casos FROM Caso_pertence_tipo
    WHERE tipo_numero = tipo;
    
    RETURN total_casos;
END $$
DELIMITER ;

/*
SELECT Tipo_de_caso.*, contarCasosPorTipo(Tipo_de_caso.numero) AS Numero_casos
FROM Tipo_de_caso
ORDER BY Numero_casos DESC;
*/

-- -----------------------------------------------------------------------
-- Listar casos por ordem de data de entrada - RM16
-- Procedimento - Lista Casos dos mais antigos para os mais recentes (antigos em cima)
DELIMITER $$
CREATE PROCEDURE listarCasosPorDataAsc()
BEGIN
    SELECT * FROM Caso
    ORDER BY data_registo ASC;
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL listarCasosPorDataAsc();
-- Drop do procedimento
DROP PROCEDURE listarCasosPorDataAsc;
*/
-- -----------------------------------------------------------------------
-- Visualizar casos com um certo estado (Encerrado, Em progresso) - RM18
DELIMITER $$
CREATE PROCEDURE verCasosEstado(
    IN estado VARCHAR(15)
)
BEGIN
    SELECT * FROM Caso
    WHERE estado_atual = estado
    ORDER BY data_registo ASC;
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL verCasosEstado('Em progresso');
-- Drop do procedimento
DROP PROCEDURE verCasosEstado;
*/
-- -----------------------------------------------------------------------
-- Enumerar/Contar agentes em cada centro de operações da agência - RM20
-- Função - Conta os agentes de um determinado centro
DELIMITER $$
CREATE FUNCTION contarAgentesCentro(
    centro INT
)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_agentes INT;
    
    SELECT COUNT(id) INTO total_agentes FROM Agente
    WHERE centro_id = centro;
    
    RETURN total_agentes;
END $$
DELIMITER ;
/*
-- Uso da função para contar os agentes em cada centro
SELECT Centro.id, 
	Centro.nome_direcao, 
	contarAgentesCentro(Centro.id) AS numero_agentes 
FROM Centro;
-- Drop Função
DROP FUNCTION contarAgentesCentro;
*/
-- -----------------------------------------------------------------------
-- Pesquisar suspeitos, clientes e agentes pelo nome - RM21
-- Procedimento - Pesquisa desse nome  na base de dados, resultando numa tabela unida de supseitos clientes e agentes, com id, nome e o tipo da entidade
DELIMITER $$
CREATE PROCEDURE pesquisarPorNome(
    IN nome_procura VARCHAR(30)
)
BEGIN
    SELECT id, nome, 'Suspeito' AS tipo_entidade
		FROM Suspeito
		WHERE nome LIKE CONCAT('%', nome_procura, '%')
    UNION
    SELECT id, nome, 'Cliente' AS tipo_entidade
		FROM Cliente
		WHERE nome LIKE CONCAT('%', nome_procura, '%')
    UNION
    SELECT id, nome, 'Agente' AS tipo_entidade
		FROM Agente
		WHERE nome LIKE CONCAT('%', nome_procura, '%');
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL pesquisarPorNome('Jo');
-- Drop do procedimento
DROP PROCEDURE pesquisarPorNome;
*/
-- -----------------------------------------------------------------------
-- Enumerar suspeitos/evidências relacionados com um caso - RM22
-- Procedimento - Listar Suspeitos de um caso
DELIMITER $$
CREATE PROCEDURE listarSuspeitosDoCaso(
    IN caso_id INT
)
BEGIN
    SELECT Suspeito.*
    FROM Suspeito INNER JOIN Caso_apresenta_suspeito ON Suspeito.id = Caso_apresenta_suspeito.suspeito_id
    WHERE Caso_apresenta_suspeito.caso_id = caso_id;
    
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL listarSuspeitosDoCaso('1');
-- Drop do procedimento
DROP PROCEDURE listarSuspeitosDoCaso;
*/
-- Procedimento - Listar evidências associadas a um caso
DELIMITER $$
CREATE PROCEDURE listarEvidenciasDoCaso(
    IN caso INT
)
BEGIN
    SELECT Evidencia.*
    FROM Evidencia
    WHERE caso_id = caso;
    
END $$
DELIMITER ;
/*
-- Chamada do procedimento
CALL listarEvidenciasDoCaso('1');
-- Drop do procedimento
DROP PROCEDURE listarEvidenciasDoCaso;
*/
-- -----------------------------------------------------------------------
-- EXTRA QUERIES

-- 
-- Criação de uma vista, onde temos todos os agentes e os seus respetivos casos não terminados
CREATE VIEW CasosEmProgressoPorAgente AS 
SELECT A.id AS agente_id,
       A.nome AS agente_nome,
       C.id AS caso_id,
       C.data_registo AS data_inicio,
       C.relatorio AS relatorio
FROM Agente AS A
INNER JOIN Agente_responsavel_caso AS ARC ON A.id = ARC.agente_id
INNER JOIN Caso AS C ON ARC.caso_id = C.id
WHERE C.estado_atual = 'Em progresso'
ORDER BY caso_id ASC;
/*
SELECT * FROM CasosEmProgressoPorAgente;
-- Drop da Vista
DROP VIEW CasosEmProgressoPorAgente;
*/
--
-- Trigger - Após atualização de um caso para encerrado, irá atualizar o cargo dos agentes
-- caso os mesmos atinjam o limite de casos resolvidos estabelecidos para promoção
-- Limites alteráveis: 5 -> Veterano, 1-> Perito

DELIMITER $$
CREATE TRIGGER atualizarCargoAgente
AFTER UPDATE ON Caso
FOR EACH ROW
BEGIN
    IF NEW.estado_atual = 'Encerrado' AND OLD.estado_atual <> 'Encerrado' THEN
    
		UPDATE Agente
		SET cargo = CASE
            WHEN contarCasosResolvidosAgente(Agente.id) > 0 AND cargo = 'Novato' THEN 'Perito'
            WHEN contarCasosResolvidosAgente(Agente.id) > 4 AND cargo = 'Perito' THEN 'Veterano'
            ELSE cargo  -- Mantém o cargo atual
        END
		WHERE id IN (
			SELECT Agente.id
            FROM Agente_responsavel_caso
			WHERE Agente_responsavel_caso.caso_id = NEW.id
		);
        
    END IF;
END$$
DELIMITER ;
-- Drop Trigger
-- DROP TRIGGER IF EXISTS atualizarCargoAgente;