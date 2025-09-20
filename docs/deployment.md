# 🚀 Manual de Deploy - Estúdio Vértice

## Pré-requisitos

### Software Necessário
- [Terraform](https://www.terraform.io/downloads.html) >= 1.6.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) >= 400.0.0
- [Python](https://www.python.org/downloads/) >= 3.11
- [Git](https://git-scm.com/downloads)

### Configuração Inicial

#### 1. Configurar Google Cloud
```bash
# Autenticar com o Google Cloud
gcloud auth login
gcloud auth application-default login

# Configurar projeto
gcloud config set project estudio-vertice-ai
gcloud config set compute/region us-central1
```

#### 2. Habilitar APIs Necessárias
```bash
gcloud services enable \
  cloudfunctions.googleapis.com \
  cloudrun.googleapis.com \
  workflows.googleapis.com \
  aiplatform.googleapis.com \
  storage.googleapis.com \
  cloudbuild.googleapis.com \
  monitoring.googleapis.com \
  logging.googleapis.com \
  secretmanager.googleapis.com \
  eventarc.googleapis.com \
  pubsub.googleapis.com
```

#### 3. Criar Service Account para Terraform
```bash
# Criar service account
gcloud iam service-accounts create terraform-sa \
  --display-name="Terraform Service Account"

# Adicionar roles necessários
gcloud projects add-iam-policy-binding estudio-vertice-ai \
  --member="serviceAccount:terraform-sa@estudio-vertice-ai.iam.gserviceaccount.com" \
  --role="roles/editor"

gcloud projects add-iam-policy-binding estudio-vertice-ai \
  --member="serviceAccount:terraform-sa@estudio-vertice-ai.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

# Criar chave JSON
gcloud iam service-accounts keys create terraform-key.json \
  --iam-account=terraform-sa@estudio-vertice-ai.iam.gserviceaccount.com
```

## Deploy por Ambiente

### Development Environment

#### 1. Preparar Ambiente
```bash
# Clonar repositório
git clone https://github.com/priscillamatos20-design/Cosmic-Blueprint.git
cd Cosmic-Blueprint

# Criar arquivo de variáveis
cp .env.example .env.development
```

#### 2. Configurar Variáveis
Edite `.env.development`:
```bash
PROJECT_ID="estudio-vertice-ai"
ENVIRONMENT="dev"
REGION="us-central1"
TARGET_PROCESSING_TIME_MINUTES=8
TARGET_QUALITY_SCORE=9.0
TARGET_COST_PER_VIDEO=2.50
```

#### 3. Deploy de Infraestrutura
```bash
cd infrastructure

# Inicializar Terraform
terraform init

# Planejar deployment
terraform plan -var-file="../.env.development" -out=dev.tfplan

# Aplicar infraestrutura
terraform apply dev.tfplan
```

#### 4. Deploy de Functions
```bash
# Voltar para diretório raiz
cd ..

# Executar script de deploy
./scripts/deploy-functions.sh dev
```

### Staging Environment

#### 1. Preparar Branch
```bash
# Criar/checkout branch de staging
git checkout -b staging
git push origin staging
```

#### 2. Deploy Automático via CI/CD
O deploy para staging é automático quando código é mergeado na branch `develop`.

#### 3. Deploy Manual (se necessário)
```bash
# Configurar ambiente
export ENVIRONMENT=staging

# Deploy infraestrutura
cd infrastructure
terraform workspace select staging || terraform workspace new staging
terraform plan -var="environment=staging" -out=staging.tfplan
terraform apply staging.tfplan

# Deploy functions
cd ..
./scripts/deploy-functions.sh staging
```

### Production Environment

#### 1. Pré-requisitos de Produção
- [ ] Testes de integração passando
- [ ] Aprovação de code review
- [ ] Validação de segurança
- [ ] Backup de estado atual

#### 2. Deploy de Produção
```bash
# Criar release branch
git checkout main
git checkout -b release/v4.1.0

# Deploy via CI/CD ou manual
export ENVIRONMENT=prod

cd infrastructure
terraform workspace select prod || terraform workspace new prod
terraform plan -var="environment=prod" -out=prod.tfplan

# CUIDADO: Deploy de produção
terraform apply prod.tfplan
```

## Scripts de Deploy

### Deploy de Functions
Criar arquivo `scripts/deploy-functions.sh`:
```bash
#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}
PROJECT_ID="estudio-vertice-ai"
REGION="us-central1"

echo "🚀 Deploying functions to $ENVIRONMENT environment..."

# Array de workers
WORKERS=("content-analyzer" "script-generator" "visual-designer" "audio-synthesizer" "quality-assurer" "performance-analyzer")

# Deploy cada worker
for worker in "${WORKERS[@]}"; do
  echo "📦 Deploying $worker..."
  
  cd "workers/$worker"
  
  gcloud functions deploy "$ENVIRONMENT-$worker" \
    --gen2 \
    --runtime=python311 \
    --region=$REGION \
    --source=. \
    --entry-point=main \
    --memory=512MB \
    --timeout=540s \
    --max-instances=100 \
    --min-instances=0 \
    --set-env-vars="ENVIRONMENT=$ENVIRONMENT,PROJECT_ID=$PROJECT_ID" \
    --allow-unauthenticated
  
  cd ../..
done

echo "✅ All functions deployed successfully!"
```

### Verificação de Saúde
Criar arquivo `scripts/health-check.sh`:
```bash
#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}
PROJECT_ID="estudio-vertice-ai"
REGION="us-central1"

echo "🔍 Running health checks for $ENVIRONMENT..."

BASE_URL="https://$REGION-$PROJECT_ID.cloudfunctions.net"
WORKERS=("content-analyzer" "script-generator" "visual-designer" "audio-synthesizer" "quality-assurer" "performance-analyzer")

for worker in "${WORKERS[@]}"; do
  echo "Checking $worker..."
  
  response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/$ENVIRONMENT-$worker" -X OPTIONS)
  
  if [[ "$response" == "204" ]]; then
    echo "✅ $worker is healthy"
  else
    echo "❌ $worker health check failed (HTTP $response)"
    exit 1
  fi
done

echo "✅ All health checks passed!"
```

## Rollback Procedures

### Rollback de Functions
```bash
# Listar versões anteriores
gcloud functions versions list --function=$ENVIRONMENT-content-analyzer --region=$REGION

# Rollback para versão específica
gcloud functions deploy $ENVIRONMENT-content-analyzer \
  --source-url=gs://path-to-previous-version.zip \
  --region=$REGION
```

### Rollback de Infraestrutura
```bash
# Reverter para estado anterior
cd infrastructure
terraform plan -destroy -target=module.specific_resource
terraform apply

# Ou restaurar de backup
terraform state pull > current-state.backup
gsutil cp gs://terraform-state-backup/terraform.tfstate ./terraform.tfstate
terraform refresh
```

## Monitoramento Pós-Deploy

### Verificações Obrigatórias
1. **Dashboard de Monitoramento**: Verificar métricas básicas
2. **Logs de Aplicação**: Buscar por erros
3. **Alertas**: Confirmar configuração
4. **Testes de Funcionalidade**: Executar testes básicos

### Comandos de Verificação
```bash
# Verificar logs
gcloud logging read "resource.type=cloud_function" --limit=50

# Verificar métricas
gcloud monitoring metrics list

# Testar pipeline completo
python tests/integration/test_complete_pipeline.py --environment=$ENVIRONMENT
```

## Troubleshooting

### Problemas Comuns

#### Erro de Permissões
```bash
# Verificar permissões do service account
gcloud projects get-iam-policy estudio-vertice-ai

# Adicionar permissões se necessário
gcloud projects add-iam-policy-binding estudio-vertice-ai \
  --member="serviceAccount:terraform-sa@estudio-vertice-ai.iam.gserviceaccount.com" \
  --role="roles/cloudfunctions.admin"
```

#### Timeout de Functions
```bash
# Aumentar timeout
gcloud functions deploy $FUNCTION_NAME \
  --timeout=540s \
  --memory=1GB
```

#### Quota Exceeded
```bash
# Verificar quotas
gcloud compute project-info describe --project=estudio-vertice-ai

# Solicitar aumento de quota no Console
```

### Logs e Debugging
```bash
# Logs em tempo real
gcloud functions logs tail $FUNCTION_NAME --region=$REGION

# Logs específicos
gcloud logging read "resource.type=cloud_function AND resource.labels.function_name=$FUNCTION_NAME" --limit=100

# Debug de workflow
gcloud workflows executions list --workflow=$WORKFLOW_NAME --location=$REGION
```

## Manutenção

### Limpeza Periódica
```bash
# Limpar versões antigas de functions
gcloud functions versions delete VERSION_ID --function=$FUNCTION_NAME --region=$REGION

# Limpar logs antigos (automático com retention policy)

# Limpar storage antigo
gsutil lifecycle set lifecycle.json gs://bucket-name
```

### Atualizações de Segurança
```bash
# Atualizar dependências Python
pip-audit --format=json --output=security-report.json

# Scan de segurança Terraform
checkov -d infrastructure/
```

## Suporte e Contatos

### Equipe Técnica
- **DevOps Lead**: devops@estudio-vertice.com
- **Arquiteto**: architecture@estudio-vertice.com
- **Segurança**: security@estudio-vertice.com

### Recursos Adicionais
- [Documentação GCP](https://cloud.google.com/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [Monitoring Playbooks](docs/monitoring-playbooks.md)

---

## Checklist de Deploy

### Pré-Deploy
- [ ] Code review aprovado
- [ ] Testes unitários passando
- [ ] Testes de integração passando
- [ ] Scan de segurança limpo
- [ ] Documentação atualizada

### Deploy
- [ ] Backup do estado atual
- [ ] Deploy de infraestrutura
- [ ] Deploy de functions
- [ ] Verificação de health checks
- [ ] Testes de smoke

### Pós-Deploy
- [ ] Monitoramento ativo
- [ ] Logs verificados
- [ ] Métricas de performance
- [ ] Notificação para stakeholders
- [ ] Documentação de deploy atualizada