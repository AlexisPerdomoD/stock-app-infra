# Infrastructure – Stock App (Terraform + LocalStack)

Este repositorio contiene la **infraestructura como código (IaC)** para desplegar el stack completo de la **Stock App**, usando **Terraform** y **LocalStack** para pruebas locales, o AWS para producción.

> ⚠️ Este repo **solo gestiona infraestructura**.
> El backend y frontend viven en repositorios independientes.

---

## Arquitectura

- **Frontend**: Vue 3 (static site) desplegado en **S3**
- **Backend**: Go API stateless en **EC2**, con variables de entorno y binario precompilado
- **Database**: CockroachDB Serverless (managed)
- **Networking**: VPC, subnets públicas y privadas, seguridad por Security Groups
- **IaC**: Terraform con múltiples módulos y providers

Flujo de datos:

```
Internet
↓
Frontend Vue (S3 Static Website)
↓
Backend Go (EC2)
↓
CockroachDB Serverless
```

---

## Estructura del repositorio

```text
.
├── docker-compose.yml
├── envs/
│   └── localstack/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── terraform.tfvars
│       └── terraform.tfvars.example
├── modules/
│   ├── compute/ec2/         # Backend EC2 + IAM Role
│   ├── database/cockroachdb/ # CockroachDB Serverless
│   ├── frontend/s3_site/     # Frontend Vue estático en S3
│   ├── loadbalancer/alb/     # Opcional: ALB para backend
│   ├── network/               # VPC + subnets + routing
│   └── segurity/              # Security Groups
├── README.md
└── terraform.tfstate*
```

Cada módulo tiene **una única responsabilidad**:

- `network`: VPC, subnets públicas, routing
- `security`: Security Groups para backend y frontend
- `database`: CockroachDB Serverless y credenciales
- `backend`: EC2, IAM Role, variables de entorno, acceso a artefactos S3
- `frontend`: S3 bucket, hosting estático, upload de build (`dist/`)

---

## Requisitos

- Terraform `>= 1.6.0`
- LocalStack (para pruebas locales) o AWS real
- API Keys de CockroachDB Cloud
- Opcional: AWS account para producción

---

## Variables

Se define un archivo `terraform.tfvars` que **no se commitea**:

```hcl
# Project
project_name = "stock-app"

# Backend
backend_instance_type       = "t3.micro"
backend_ami_id              = "ami-0e5c7c1b9d1f6e0d3"
backend_artifact_bucket     = "stock-artifacts"
backend_artifact_key        = "backend"
backend_main_data_source_uri = "https://your-api-url.com/path"
backend_main_data_source_key = "YOUR_API_KEY"
backend_gin_mode             = "debug"

# Frontend
frontend_artifact_bucket = "stock-frontend"
frontend_dist_path       = "../../frontend/dist"

# CockroachDB
cockroach_api_key = "YOUR_COCKROACH_API_KEY"

# LocalStack endpoint (solo para pruebas locales)
localstack_ep = "http://localhost:4566"
```

> ⚠️ `terraform.tfvars.example` sirve como **contrato de configuración**.

---

## Despliegue

### 1. Inicializar Terraform

```bash
cd envs/localstack
terraform init
```

### 2. Planificar cambios

```bash
terraform plan
```

### 3. Aplicar infraestructura

```bash
terraform apply
# Escribir "yes" cuando se solicite
```

---

## Qué hace Terraform

- **Network**: VPC, subnets, rutas
- **Security**: Security Groups para backend y frontend
- **Database**: CockroachDB Serverless + credenciales
- **Backend**: EC2 con IAM Role mínimo, variables de entorno, descarga de artefactos desde S3
- **Frontend**: S3 bucket con hosting estático, sube build (`dist/`) de Vue
- **Outputs**: URLs de frontend y backend

> En LocalStack, todo se simula para pruebas locales.
> En AWS real, se puede desplegar con las mismas configuraciones.

---

## Buenas prácticas aplicadas

- Cada módulo es **autocontenido y reusable**
- Backend usa **IAM Role con permisos mínimos** para S3
- Frontend tiene **bucket propio** para separar responsabilidades
- Variables parametrizadas (`dist_path`, `bucket_name`, `AMI`, `instance_type`)
- SPA friendly: `index.html` como documento de error en S3

---

## Notas importantes

- **terraform.tfvars** está intencionalmente ignorado por Git
- La infraestructura **no ejecuta lógica de aplicación**, solo despliega recursos
- LocalStack permite probar AWS sin costo
- Puedes agregar ALB en módulo `loadbalancer` para simular producción (no llegue a hacerlo yo :P)

---

## Referencias

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [CockroachDB Terraform Provider](https://registry.terraform.io/providers/cockroachdb/cockroach/latest/docs)
- [LocalStack](https://docs.localstack.cloud/)
