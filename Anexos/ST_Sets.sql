--
-- Unidade Curricular de Bases de Dados.
-- Agência de Detetives "Secret Story"
--
-- POVOAMENTO
-- Povoamento da base de dados
--
-- Grupo 2, 2024
--
-- 

-- Indicação da Base de Dados de Trabalho.

USE Agencia;

-- Inserção de centros
INSERT INTO Centro (nome_direcao, concelho, rua, cod_postal, tele) 
VALUES 
('Orlando', 'Braga', 'Rua da Universidade do Minho', '4710-057', '+351253601100'),
('Vasco', 'Lisboa', 'Rua da Universidade de Lisboa', '1649-014', '+351217998000'),
('André', 'Faro', 'Rua da Universidade do Algarve', '8005-140', '+351289800100'),
('Diana', 'Aveiro', 'Rua da Universidade de Aveiro', '3810-193', '+351234370310'),
('Marisa', 'Bragança', 'Rua do Instituto Politécnico de Bragança', '5300-253', '+351273303200'),
('Regina', 'Castelo Branco', 'Rua do Instituto Politécnico de Castelo Branco', '6000-767', '+351272339600');

-- Inserção de agentes
INSERT INTO Agente (nome, cargo, data_nasc, email, pass, concelho, cod_postal, rua, centro_id, tele) 
VALUES 
('Carlos Ribeira', 'Novato', '1990-05-10', 'carlos@gmail.com', 'carlitos', 'Lisboa', '1600-809', 'Rua das Rochas, 10', 2, '+351911234567'),
('Maria Carvalho', 'Perito', '1985-03-20', 'maria@gmail.com', 'mary', 'Porto', '4350-334', 'Avenida da Marmota, 20', 1, '+351921234567'),
('João Miguel', 'Veterano', '1978-11-11', 'jo@gmail.com', 'jony', 'Faro', '8000-222', 'Rua Açores, 30', 3, '+351931234567'),
('Ana Jussefina', 'Novato', '1992-07-25', 'ana@gmail.com', 'anita', 'Aveiro', '3810-193', 'Rua Municipal, 40', 4, '+351941234567'),
('Pedro da Beira', 'Perito', '1983-04-15', 'pedras@hotmail.com', 'pedri', 'Braga', '4705-471', 'Avenida do Azeite, 50', 5, '+351951234567'),
('Rita Martins', 'Veterano', '1975-09-05', 'rit@gmail.com', 'rits', 'Castelo Branco', '6000-767', 'Rua do Pardal, 60', 6, '+351961234567');

-- Inserção de clientes
CALL addNovoCliente('Pedro Fernandes', 'pedro@sapo.pt', '213', 'Lisboa', '1000-003', 'Rua do Milénio, 5', '+351931234567');
CALL addNovoCliente('Sara Lima', 'sara@gmail.com', '41241', 'Porto', '4000-004', 'Avenida Pastoriana, 15', '+351941234567');
CALL addNovoCliente('Joana Silva', 'joanasil@hotmail.com', 'joana', 'Coimbra', '3000-005', 'Rua das Flores, 8', '+351951234567');
CALL addNovoCliente('Miguel Pereira', 'miguel.pereira@yahoo.com', 'miguele', 'Faro', '8000-006', 'Avenida do Mar, 12', '+351961234567');
CALL addNovoCliente('Ana Costa', 'anocas@gmail.com', 'anocas', 'Braga', '4700-007', 'Rua da Universidade, 20', '+351971234567');
CALL addNovoCliente('Rui Oliveira', 'ruioliveira@outlook.com', 'ruir', 'Lisboa', '1000-008', 'Rua Nova, 30', '+351981234567');
CALL addNovoCliente('Carla Mendes', 'carlamendes@gmail.com', 'carli', 'Porto', '4000-009', 'Travessa do Sol, 5', '+351991234567');
CALL addNovoCliente('Paulo Sousa', 'paulo@gmail.com', 'pauleta', 'Évora', '7000-010', 'Largo da Feira, 25', '+351921234567');

-- Inserção de denuncias
INSERT INTO Denuncia (concelho, cod_postal, rua, descricao, cliente_id) 
VALUES 
('Lisboa', '1000-003', 'Rua Filipe Terceiro, 1', 'Roubo de Identidade', 1),
('Porto', '4000-004', 'Avenida do Quarto', 'Assalto a mão armada', 2),
('Braga', '4705-593', 'Rua do Vinte, 20', 'Traição do Marido', 5),
('Coimbra', '3555-056', 'Avenidita , Porta 40', 'Homícidio da minha irmã com arma', 3),
('Coimbra', '3555-030', 'Avenidona, 50', 'Roubo de carro', 3),
('Leiria', '6545-989', 'Rua do Comércio, 24', 'Roubo de Sapataria, com faca, em plena luz do dia', 8),
('Lisboa', '1000-008', 'Rua da Virtude', 'Pessoas a trocar drogas perto da minha rua', 6),
('Faro', '8000-006', 'Avenida do Mar, 12', 'Golpe financeiro do meu colega de trabalho, ficou com a minha conta do banco', 4);

-- Inserção de dados na tabela Tipo_de_caso
INSERT INTO Tipo_de_caso (nome) 
VALUES 
('Roubo'),
('Mão Armada'),
('Homícido'),
('Rapto'),
('Grupo'),
('Outro'),
('Tráfico'),
('Golpe');

-- Inserção de casos
CALL addNovoCaso(1, 1, 1); -- Associando caso à denúncia 1, agente 1 e tipo 1 (Roubo)
CALL addNovoCaso(2, 2, 2); -- Associando caso à denúncia 2, agente 2 e tipo 2 (Mão Armada)
CALL addNovoCaso(3,3,6); -- tipo Outro
CALL addNovoCaso(4,4,3);
CALL addNovoCaso(5,5,1);
CALL addNovoCaso(6,6,1);

INSERT INTO Caso_pertence_tipo
VALUES ('2', '1'); -- Associar mais um tipo roubo ao caso 2 

INSERT INTO Agente_responsavel_caso
VALUES 
('1','3'),
('1','4'),
('1','5'),
('6','4');

-- Terminar caso
SET SQL_SAFE_UPDATES = 0;
UPDATE Caso 
SET data_final = CURRENT_DATE(), relatorio = 'Qualquer coisa', estado_atual = 'Encerrado'
WHERE id in (1,2); 
SET SQL_SAFE_UPDATES = 1;

-- Inserção de suspeitos
CALL addNovoSuspeito(1, 'João da Silva', 'Sujeito Robusto, entroncado, com suspeitas de participação em vários roubos');
CALL addNovoSuspeito(2, 'Ricardo Brito', 'Sujeito perigoso, amante do álcool, suspeito de ter uma arma em sua posse');

-- Inserção de evidencias
INSERT INTO Evidencia (descricao, caso_id) 
VALUES 
('Impressões digitais encontradas no local do crime', '1'),
('Gravação de câmera de segurança', '2');

-- Visualizar dados inseridos
SELECT * FROM Centro;
SELECT * FROM Agente;
SELECT * FROM Cliente;
SELECT * FROM Denuncia;
SELECT * FROM Tipo_de_caso;
SELECT * FROM Caso;
SELECT * FROM Suspeito;
SELECT * FROM Evidencia;
SELECT * FROM Agente_responsavel_caso;
SELECT * FROM Caso_apresenta_suspeito;
SELECT * FROM Caso_pertence_tipo;

-- Limpar procedures após uso
DROP PROCEDURE IF EXISTS addNovoCliente;
DROP PROCEDURE IF EXISTS addNovoCaso;
DROP PROCEDURE IF EXISTS addNovoSuspeito;

