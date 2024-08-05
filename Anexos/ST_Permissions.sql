--
-- Unidade Curricular de Bases de Dados.
-- Agência de Detetives "Secret Story"
--
-- PERMISSÕES DE UTILIZADOR
-- Criação/Remoção de utilizadores e suas permissões na base de dados
--
-- Grupo 2, 2024
--
-- 

-- Indicação da Base de Dados de Trabalho.
USE Agencia;

-- Exemplos de permissões e users
-- Criação de user
CREATE USER 'user' IDENTIFIED BY 'password';

--
-- DIREÇÃO
-- Criação de uma função para a direção
CREATE ROLE 'diretores';
-- Garantir todas as permissões para estes
GRANT ALL ON Agencia TO 'diretores';

--
-- AGENTES
-- Criação de uma função para os agentes
CREATE ROLE 'agentes';
-- Garantir certas permissões para estes
-- Permissão para ver casos
GRANT SELECT ON Caso TO 'agentes';
-- Permissão para atualizar casos
GRANT UPDATE ON Caso TO 'agentes';

-- Permissão para ver os seus dados
GRANT SELECT ON Agente TO 'agentes';
-- Permissão para atualizar os seus dados
GRANT UPDATE (nome, data_nasc, email, pass, concelho, cod_postal, rua, centro_id, tele) ON Agente TO 'agentes';
-- Permissão para ver dados dos clientes
GRANT SELECT (nome, email, concelho, cod_postal, rua) ON Cliente TO 'agentes';
GRANT SELECT ON Tele_cliente TO 'agentes';

-- Permissão para ver evidencias
GRANT SELECT ON Evidencia TO 'agentes';
-- Permissão para inserir evidencias
GRANT INSERT ON Evidencia TO 'agentes';
-- Permissão para ver suspeitos
GRANT SELECT ON Suspeito TO 'agentes';
-- Permissão para atualizar suspeitos
GRANT UPDATE ON Suspeito TO 'agentes';
-- Permissão para inserir suspeitos
GRANT INSERT ON Suspeito TO 'agentes';

-- Permissão para associar/desassociar suspeitos
GRANT INSERT ON Caso_apresenta_suspeito TO 'agentes';
GRANT DELETE ON Caso_apresenta_suspeito TO 'agentes';

-- Permissão para ver centros de operações disponíveis
GRANT SELECT ON Centro TO 'agentes';

-- 
-- CLIENTES
-- Criação de uma função para os clientes
CREATE ROLE 'clientes';

-- Garantir certas permissões para estes
-- Permissão para adicionar denúncias
GRANT INSERT ON Denuncia TO 'clientes';

-- Permissão para ver os seus casos
GRANT SELECT ON Caso TO 'clientes';

-- Permissão para ver os seus dados
GRANT SELECT ON Cliente TO 'clientes';
-- Permissão para atualizar os seus dados
GRANT UPDATE ON Cliente TO 'clientes';

-- Permissão para ver centros de operações disponíveis
GRANT SELECT ON Centro TO 'clientes';

-- Role para um user
GRANT 'diretores' TO 'diretor_user';
GRANT 'agentes' TO 'agente_user';
GRANT 'clientes' TO 'cliente_user';