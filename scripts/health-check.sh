#!/bin/bash
set -e

# Estúdio Vértice - Health Check Script
# Verify all functions are healthy and responsive

ENVIRONMENT=${1:-dev}
PROJECT_ID="estudio-vertice-ai"
REGION="us-central1"

echo "🔍 Estúdio Vértice - Health Check"
echo "Environment: $ENVIRONMENT"
echo "Project: $PROJECT_ID"
echo "Region: $REGION"
echo "========================================"

BASE_URL="https://$REGION-$PROJECT_ID.cloudfunctions.net"
WORKERS=("content-analyzer" "script-generator" "visual-designer" "audio-synthesizer" "quality-assurer" "performance-analyzer")

TOTAL_WORKERS=${#WORKERS[@]}
CURRENT=0
HEALTHY=0
UNHEALTHY=0

echo "🏥 Checking health of $TOTAL_WORKERS workers..."

for worker in "${WORKERS[@]}"; do
    CURRENT=$((CURRENT + 1))
    echo -n "[$CURRENT/$TOTAL_WORKERS] Checking $worker... "
    
    # Test OPTIONS request (CORS preflight)
    response=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/$ENVIRONMENT-$worker" \
        -X OPTIONS \
        -H "Origin: https://localhost" \
        -H "Access-Control-Request-Method: POST" \
        -H "Access-Control-Request-Headers: Content-Type" \
        --max-time 10)
    
    if [[ "$response" == "204" || "$response" == "200" ]]; then
        echo "✅ HEALTHY (HTTP $response)"
        HEALTHY=$((HEALTHY + 1))
    else
        echo "❌ UNHEALTHY (HTTP $response)"
        UNHEALTHY=$((UNHEALTHY + 1))
        
        # Try to get more details
        echo "   Trying detailed check..."
        detailed_response=$(curl -s "$BASE_URL/$ENVIRONMENT-$worker" -X OPTIONS -v 2>&1 | head -10)
        echo "   Response details: $detailed_response"
    fi
done

echo ""
echo "📊 Health Check Summary:"
echo "  ✅ Healthy functions: $HEALTHY"
echo "  ❌ Unhealthy functions: $UNHEALTHY"
echo "  📈 Success rate: $(( HEALTHY * 100 / TOTAL_WORKERS ))%"

if [[ $UNHEALTHY -eq 0 ]]; then
    echo ""
    echo "🎉 All functions are healthy!"
    echo ""
    echo "🧪 You can now test the complete pipeline:"
    echo "  python tests/integration/test_pipeline.py --environment $ENVIRONMENT"
    exit 0
else
    echo ""
    echo "⚠️  Some functions are unhealthy. Please check:"
    echo "  1. Function deployment logs"
    echo "  2. IAM permissions"
    echo "  3. Network connectivity"
    echo ""
    echo "🔧 Debug commands:"
    echo "  gcloud functions logs tail $ENVIRONMENT-FUNCTION_NAME --region=$REGION"
    echo "  gcloud functions describe $ENVIRONMENT-FUNCTION_NAME --region=$REGION"
    exit 1
fi