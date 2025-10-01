# DevOps Sprint 3 - Mottu API

Repositório de entrega da disciplina DevOps Tools & Cloud Computing.

# Descrição da Solução

API RESTful em .NET 8 publicada no Azure App Service (Linux), integrada ao Azure SQL Database (PaaS).

A solução permite CRUD completo de Filiais, Pátios e Motos, com documentação interativa via Swagger.

# Benefícios para o Negócio

Centralização do gerenciamento da frota.

Escalabilidade e alta disponibilidade 24/7 na nuvem.

Uso de boas práticas de DevOps (deploy automatizado via GitHub Actions).

# Passos de Deploy (Azure CLI)
-Variáveis

RG=rg-sprint3

LOC=brazilsouth

PLAN=plan-mottu

WEBAPP=web-mottuapi-livia

SQLSERVER=sqlmottusprint3

DB=mottudb

ADMINUSER=sqladminuser

ADMINPASS="SenhaForte123!"

# 1. Criar grupo de recursos
az group create -n $RG -l $LOC

# 2. Criar SQL Server e Banco
az sql server create -g $RG -n $SQLSERVER -l $LOC -u $ADMINUSER -p $ADMINPASS

az sql db create -g $RG -s $SQLSERVER -n $DB -e GeneralPurpose -f Gen5 -c 2

# 3. Permitir acesso ao Azure Services
az sql server firewall-rule create -g $RG -s $SQLSERVER -n AllowAzureServices --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0

# 4. Criar App Service Plan + WebApp
az appservice plan create -g $RG -n $PLAN --sku B1 --is-linux

az webapp create -g $RG -p $PLAN -n $WEBAPP --runtime "DOTNETCORE:8.0"

# 5. Configurar Connection String
az webapp config connection-string set -g $RG -n $WEBAPP \
    
    -t SQLAzure \
    
    --settings DefaultConnection="Server=tcp:$SQLSERVER.database.windows.net,1433;Initial Catalog=$DB;User ID=$ADMINUSER;Password=$ADMINPASS;Encrypt=true;"

# 6. Publicar aplicação (ZipDeploy ou GitHub Actions)
az webapp deploy -g $RG -n $WEBAPP --src-path site.zip --type zip

# 7. Logs em tempo real
az webapp log tail -g $RG -n $WEBAPP

# Estrutura do Repositório

MottuApi/ → Código-fonte da API

script_bd.sql → Script de criação/carga inicial do banco

tests.http → Roteiro de testes CRUD (executar via extensão REST Client do VS Code)

README.md → Este guia de deploy e execução

Testes CRUD

# A API possui Swagger disponível em:
 https://web-mottuapi-livia.azurewebsites.net/swagger

# Exemplos de Requisições

POST /api/Filiais → cria nova filial

POST /api/Patios → cria novo pátio vinculado a uma filial

POST /api/Motos → cadastra moto vinculada a um pátio

GET /api/Motos → lista todas as motos

PUT /api/Motos/{id} → atualiza dados da moto

DELETE /api/Motos/{id} → remove uma moto

# (Observação)

Foram inseridos pelo menos 2 registros reais por tabela (Filiais, Pátios e Motos) para atender aos requisitos da sprint.

# Integrantes
Lívia de Oliveira Lopes – RM: 556281

Henrique Pecora Vieira de Souza – RM: 556612

Santhiago De Gobbi Barros de Souza – RM: 98420

# Links de Entrega

Repositório GitHub: https://github.com/livialopes55/Sprint-3---Devops

Swagger Online: https://web-mottuapi-livia.azurewebsites.net/swagger

Vídeo no YouTube: (adicionar link após gravação)
