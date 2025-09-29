-- script_bd.sql
-- DDL do banco para Azure SQL Database (PaaS)
-- Cria schema, tabelas e insere dados iniciais

CREATE SCHEMA app;

CREATE TABLE app.Filiais (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nome NVARCHAR(100) NOT NULL,
    Endereco NVARCHAR(200) NOT NULL,
    Capacidade INT NOT NULL
);

CREATE TABLE app.Patios (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Descricao NVARCHAR(100) NOT NULL,
    Dimensao INT NOT NULL,
    FilialId INT NOT NULL FOREIGN KEY REFERENCES app.Filiais(Id)
);

CREATE TABLE app.Motos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Placa NVARCHAR(20) NOT NULL,
    Modelo NVARCHAR(100) NOT NULL,
    Ano INT NOT NULL,
    Status NVARCHAR(50) NOT NULL,
    PatioId INT NOT NULL FOREIGN KEY REFERENCES app.Patios(Id)
);

-- Inserindo registros reais para teste
INSERT INTO app.Filiais (Nome, Endereco, Capacidade)
VALUES ('Filial Centro', 'Rua Principal, 1000 - São Paulo/SP', 150),
       ('Filial Zona Sul', 'Av. dos Bandeirantes, 500 - São Paulo/SP', 200);

INSERT INTO app.Patios (Descricao, Dimensao, FilialId)
VALUES ('Pátio A', 500, 1),
       ('Pátio B', 750, 2);

INSERT INTO app.Motos (Placa, Modelo, Ano, Status, PatioId)
VALUES ('ABC-1234', 'Honda CG 160', 2022, 'Disponível', 1),
       ('XYZ-5678', 'Yamaha Fazer 250', 2023, 'Em manutenção', 2);
