# Infrastructure – Stock App (Terraform)

Infraestructura como código para desplegar el stack completo de la **Stock App**, usando **Terraform**, **Render** y **CockroachDB Serverless**.

Este repositorio **solo** gestiona infraestructura.  
El backend y frontend viven en repositorios independientes.

---

## Arquitectura

- **Frontend**: Vue (Render Static Site)
- **Backend**: Go API stateless (Render Web Service)
- **Database**: CockroachDB Serverless (managed)
- **IaC**: Terraform (un solo state, múltiples providers)

Internet
↓
Render Static Site (Vue)
↓
Render Web Service (Go API)
↓
CockroachDB Serverless

---

## Estructura del repositorio

```sh
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── modules/
│ ├── database/
│ ├── backend/
│ └── frontend/
```

Cada módulo tiene una única responsabilidad:

- `database`: cluster y credenciales CockroachDB
- `backend`: API Go + variables de entorno
- `frontend`: sitio estático Vue

---

## Requisitos

- Terraform `>= 1.6.0`
- Cuenta en:
  - Render
  - CockroachDB Cloud
- API Keys válidas para ambos servicios

---

## API Keys

### Render

Generar en:

Account Settings → API Keys

### CockroachDB

Generar en:

Account → API Access

⚠️ Ambos keys se muestran **una sola vez**.

---

## Variables requeridas

Crea un archivo `terraform.tfvars` (no se commitea):

```hcl
# api keys de providers
render_api_key     = "RENDER_API_KEY"
cockroach_api_key = "COCKROACH_API_KEY"

# variables de entorno
project_name = "stock-app"

# variables de backend (API Go, leer readme del repositorio de backend para más detalles)
main_source_stock_uri = "https://your-api-url.com/path"
main_source_stock_key = "your-api-key"
session_secret = "your-session-secret"
gin_mode       = "debug"
```

## Despliegue

Desde la raíz del repo:

```sh
terraform init
terraform plan
terraform apply
```

Terraform:

- Provisiona CockroachDB Serverless

- Despliega el backend Go

- Despliega el frontend Vue

- Conecta todo vía variables de entorno

## Notas

- terraform.tfvars está intencionalmente ignorado por Git

- terraform.tfvars.example sirve como contrato de configuración

- No se ejecuta lógica de aplicación desde Terraform
