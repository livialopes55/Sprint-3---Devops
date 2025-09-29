# DevOps Sprint 3 - Mottu API

Repositório de entrega da disciplina **DevOps Tools & Cloud Computing**.

## 🚀 Descrição da Solução
API RESTful em .NET 8 publicada no **Azure App Service (Linux)**, integrada ao **Azure SQL Database (PaaS)**.  
Permite CRUD de **Filiais, Pátios e Motos** com Swagger disponível online.

## ✅ Benefícios para o Negócio
- Facilita o gerenciamento centralizado da frota.  
- Escalável e disponível 24/7 na nuvem.  
- Adoção de boas práticas DevOps (CI/CD simplificado via Azure CLI).  

## 🛠️ Passos de Deploy (Azure CLI)

```bash
# Variáveis
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
az webapp config connection-string set -g $RG -n $WEBAPP     -t SQLAzure     --settings DefaultConnection="Server=tcp:$SQLSERVER.database.windows.net,1433;Initial Catalog=$DB;User ID=$ADMINUSER;Password=$ADMINPASS;Encrypt=true;"

# 6. Publicar aplicação (ZipDeploy)
az webapp deploy -g $RG -n $WEBAPP --src-path site.zip --type zip

# 7. Logs em tempo real
az webapp log tail -g $RG -n $WEBAPP
```

## 📂 Estrutura do Repositório
- `script_bd.sql` → Criação e carga inicial do banco  
- `tests.http` → Roteiro de testes CRUD (usar no VS Code com extensão REST Client)  
- `README.md` → Este guia de deploy/teste

## 🧪 Testes
A API possui Swagger disponível em:
```
https://<NOME_WEBAPP>.azurewebsites.net/swagger
```

Execute os endpoints manualmente ou use o arquivo `tests.http`.

---

## 👨‍💻 Integrantes
- Lucas Martins Soliman - RM 556281  
- Diego Bassalo Canals Silva - RM 558710  
- Pedro Henrique Jorge de Paula - RM 558833  

---

## 📎 Links Entrega
- Repositório GitHub: (adicione aqui o link)  
- Vídeo no YouTube: (adicione aqui o link)
