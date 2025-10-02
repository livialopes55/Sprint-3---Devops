# DevOps Sprint 3 - Mottu API

Repositório de entrega da disciplina **DevOps Tools & Cloud Computing**.

---

## Descrição da Solução
API RESTful em **.NET 8**, publicada no **Azure App Service (Linux)**, integrada ao **Azure SQL Database (PaaS)**.  

A solução implementa CRUD completo das entidades **Filiais, Pátios e Motos**, com documentação interativa via **Swagger**.

---

##  Benefícios para o Negócio
- Centralização do gerenciamento da frota.  
- Escalabilidade e alta disponibilidade 24/7 na nuvem.  
- Adoção de boas práticas de DevOps (deploy automatizado via CLI/GitHub Actions).  

---

## Passos de Deploy (Azure CLI)

###  Variáveis
```bash
RG=rg-sprint3

LOC=brazilsouth

PLAN=plan-mottu

WEBAPP=web-mottuapi-livia

SQLSERVER=sqlmottusprint3

DB=mottudb

ADMINUSER=sqladminuser

ADMINPASS="challenge2025@2025"

## 1. Criar grupo de recursos

az group create -n $RG -l $LOC

## 2. Criar SQL Server e Banco

az sql server create -g $RG -n $SQLSERVER -l $LOC -u $ADMINUSER -p $ADMINPASS
az sql db create -g $RG -s $SQLSERVER -n $DB -e GeneralPurpose -f Gen5 -c 2
## 3. Permitir acesso ao Azure Services

az sql server firewall-rule create -g $RG -s $SQLSERVER -n AllowAzureServices \
  --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
## 4. Criar App Service Plan + WebApp

az appservice plan create -g $RG -n $PLAN --sku B1 --is-linux
az webapp create -g $RG -p $PLAN -n $WEBAPP --runtime "DOTNETCORE:8.0"

##5. Configurar Connection String

az webapp config connection-string set -g $RG -n $WEBAPP -t SQLAzure \
  --settings DefaultConnection="Server=tcp:$SQLSERVER.database.windows.net,1433;Initial Catalog=$DB;User ID=$ADMINUSER;Password=$ADMINPASS;Encrypt=true;"

## 6. Deploy da aplicação

az webapp deploy -g $RG -n $WEBAPP --src-path site.zip --type zip --clean true

## 7. Logs em tempo real

az webapp log tail -g $RG -n $WEBAPP

##Estrutura do Repositório

MottuApi/ → Código-fonte da API

script_bd.sql → Script de criação/carga inicial do banco

tests.http → Roteiro de testes CRUD (extensão REST Client do VS Code)

README.md → Guia de deploy e execução

## Testes CRUD
A API possui Swagger disponível em: https://web-mottuapi-livia.azurewebsites.net/swagger/index.html


## Exemplos de Requisições
## Filiais

POST /api/v1/filiais
{
  "nome": "Filial Paulista",
  "endereco": "Av. Paulista, 1500 - São Paulo"
}

PUT /api/v1/filiais/1
{
  "id": 1,
  "nome": "Filial São Paulo - Atualizada",
  "endereco": "Av. Paulista, 2000 - Bela Vista, SP"
}

## Pátios

POST /api/v1/patios
{
  "descricao": "Pátio Central",
  "dimensao": "80x50",
  "filialId": 1
}

PUT /api/v1/patios/1
{
  "id": 1,
  "descricao": "Pátio Central - Atualizado",
  "dimensao": "500m²",
  "filialId": 1
}

# Motos
- POST /api/v1/motos
{
  "placa": "XYZ-9999",
  "modelo": "Honda Biz 125",
  "ano": 2024,
  "status": "Disponível",
  "patioId": 1
}

# PUT /api/v1/motos/1
{
  "id": 1,
  "placa": "ABC1234",
  "modelo": "Honda CG 160 Titan - Atualizada",
  "ano": 2024,
  "status": "Disponível",
  "patioId": 1
}

# Testes no Banco

SELECT * FROM Filiais;
SELECT * FROM Patios;
SELECT * FROM Motos;

# Integrantes
Lívia de Oliveira Lopes – RM: 556281

Henrique Pecora Vieira de Souza – RM: 556612

Santhiago De Gobbi Barros de Souza – RM: 98420

# Links de Entrega
Repositório GitHub: https://github.com/livialopes55/Sprint-3---Devops

Swagger Online: https://web-mottuapi-livia.azurewebsites.net/swagger

Vídeo no YouTube: https://youtu.be/jbTOf6U6PCg

# Clone do Repositório

git clone https://github.com/livialopes55/Sprint-3---Devops.git
cd Sprint-3---Devops/MottuApi
