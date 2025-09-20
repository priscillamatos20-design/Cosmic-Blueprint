#!/bin/bash
set -e

# Estúdio Vértice - Deploy Functions Script
# Deploy all worker functions to specified environment

ENVIRONMENT=${1:-dev}
PROJECT_ID="estudio-vertice-ai"
REGION="us-central1"

echo "🎬 Estúdio Vértice - Deploying Functions"
echo "Environment: $ENVIRONMENT"
echo "Project: $PROJECT_ID"
echo "Region: $REGION"
echo "========================================"

# Verificar se gcloud está configurado
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "❌ Please authenticate with gcloud first:"
    echo "gcloud auth login"
    echo "gcloud auth application-default login"
    exit 1
fi

# Array de workers
WORKERS=("content-analyzer" "script-generator" "visual-designer" "audio-synthesizer" "quality-assurer" "performance-analyzer")

# Contar workers para progresso
TOTAL_WORKERS=${#WORKERS[@]}
CURRENT=0

echo "📦 Deploying $TOTAL_WORKERS workers..."

# Deploy cada worker
for worker in "${WORKERS[@]}"; do
    CURRENT=$((CURRENT + 1))
    echo ""
    echo "[$CURRENT/$TOTAL_WORKERS] Deploying $worker..."
    
    if [[ ! -d "workers/$worker" ]]; then
        echo "❌ Directory workers/$worker not found!"
        exit 1
    fi
    
    cd "workers/$worker"
    
    # Verificar arquivos necessários
    if [[ ! -f "main.py" ]]; then
        echo "❌ main.py not found in workers/$worker"
        exit 1
    fi
    
    if [[ ! -f "requirements.txt" ]]; then
        echo "❌ requirements.txt not found in workers/$worker"
        exit 1
    fi
    
    # Deploy da função
    gcloud functions deploy "$ENVIRONMENT-$worker" \
        --gen2 \
        --runtime=python311 \
        --region=$REGION \
        --source=. \
        --entry-point=main \
        --memory=1Gi \
        --timeout=540s \
        --max-instances=100 \
        --min-instances=0 \
        --set-env-vars="ENVIRONMENT=$ENVIRONMENT,PROJECT_ID=$PROJECT_ID,REGION=$REGION" \
        --allow-unauthenticated \
        --quiet
    
    if [[ $? -eq 0 ]]; then
        echo "✅ $worker deployed successfully"
    else
        echo "❌ Failed to deploy $worker"
        exit 1
    fi
    
    cd ../..
done

echo ""
echo "🎉 All functions deployed successfully!"
echo ""
echo "📊 Function URLs:"
BASE_URL="https://$REGION-$PROJECT_ID.cloudfunctions.net"
for worker in "${WORKERS[@]}"; do
    echo "  $worker: $BASE_URL/$ENVIRONMENT-$worker"
done

echo ""
echo "🔍 Next steps:"
echo "  1. Run health checks: ./scripts/health-check.sh $ENVIRONMENT"
echo "  2. Check monitoring dashboard"
echo "  3. Test the complete pipeline"
echo ""
echo "✨ Deploy completed successfully! ✨"