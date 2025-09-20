#!/bin/bash

# Make scripts executable
chmod +x scripts/deploy-functions.sh
chmod +x scripts/health-check.sh
chmod +x tests/integration/test_pipeline.py

echo "✅ All scripts are now executable!"

# Quick start guide
echo ""
echo "🎬 Estúdio Vértice - Quick Start"
echo "================================"
echo ""
echo "1. Configure Google Cloud:"
echo "   gcloud auth login"
echo "   gcloud config set project estudio-vertice-ai"
echo ""
echo "2. Deploy infrastructure:"
echo "   cd infrastructure"
echo "   terraform init"
echo "   terraform plan"
echo "   terraform apply"
echo ""
echo "3. Deploy functions:"
echo "   ./scripts/deploy-functions.sh dev"
echo ""
echo "4. Run health checks:"
echo "   ./scripts/health-check.sh dev"
echo ""
echo "5. Test the pipeline:"
echo "   python tests/integration/test_pipeline.py --environment dev"
echo ""
echo "🚀 Happy video creation with Kurzgesagt methodology!"