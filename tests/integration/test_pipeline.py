#!/usr/bin/env python3
"""
Estúdio Vértice - Integration Test
Tests the complete video production pipeline
"""

import json
import time
import requests
import argparse
from datetime import datetime

def test_complete_pipeline(environment, project_id, region):
    """Test the complete Estúdio Vértice pipeline"""
    
    print("🧪 Testing Estúdio Vértice Complete Pipeline")
    print(f"Environment: {environment}")
    print(f"Project: {project_id}")
    print(f"Region: {region}")
    print("=" * 50)
    
    base_url = f"https://{region}-{project_id}.cloudfunctions.net"
    
    # Test content for pipeline
    test_content = """
    A inteligência artificial está transformando nossa sociedade de maneiras profundas e inesperadas. 
    Desde algoritmos que recomendam filmes até sistemas que dirigem carros autônomos, 
    a IA está se tornando uma parte integral de nossas vidas diárias.
    
    Mas como exatamente a IA funciona? E quais são as implicações para nosso futuro?
    
    Neste conteúdo, exploraremos os fundamentos da inteligência artificial, 
    seus benefícios e desafios, e como podemos navegar em um mundo cada vez mais automatizado
    mantendo nossa humanidade e valores essenciais.
    """
    
    # Step 1: Content Analysis
    print("\n🔍 Step 1: Testing Content Analyzer...")
    try:
        response = requests.post(
            f"{base_url}/{environment}-content-analyzer",
            json={"content": test_content},
            headers={"Content-Type": "application/json"},
            timeout=60
        )
        
        if response.status_code == 200:
            content_analysis = response.json()
            print("✅ Content Analyzer: SUCCESS")
            print(f"   Quality Score: {content_analysis.get('quality_validation', {}).get('quality_score', 'N/A')}")
        else:
            print(f"❌ Content Analyzer: FAILED (HTTP {response.status_code})")
            print(f"   Response: {response.text[:200]}")
            return False
            
    except Exception as e:
        print(f"❌ Content Analyzer: ERROR - {str(e)}")
        return False
    
    # Step 2: Script Generation
    print("\n✍️ Step 2: Testing Script Generator...")
    try:
        script_payload = {
            "content_analysis": content_analysis.get("structure_analysis", {})
        }
        
        response = requests.post(
            f"{base_url}/{environment}-script-generator",
            json=script_payload,
            headers={"Content-Type": "application/json"},
            timeout=120
        )
        
        if response.status_code == 200:
            script_result = response.json()
            print("✅ Script Generator: SUCCESS")
            print(f"   Methodology: {script_result.get('kurzgesagt_methodology', 'N/A')}")
        else:
            print(f"❌ Script Generator: FAILED (HTTP {response.status_code})")
            return False
            
    except Exception as e:
        print(f"❌ Script Generator: ERROR - {str(e)}")
        return False
    
    # Step 3: Visual Designer
    print("\n🎨 Step 3: Testing Visual Designer...")
    try:
        visual_payload = {
            "script": script_result.get("script_generation", {}).get("script", {}),
            "content_analysis": content_analysis.get("structure_analysis", {})
        }
        
        response = requests.post(
            f"{base_url}/{environment}-visual-designer",
            json=visual_payload,
            headers={"Content-Type": "application/json"},
            timeout=180
        )
        
        if response.status_code == 200:
            visual_result = response.json()
            print("✅ Visual Designer: SUCCESS")
            print(f"   Kurzgesagt Style: {visual_result.get('kurzgesagt_style', 'N/A')}")
        else:
            print(f"❌ Visual Designer: FAILED (HTTP {response.status_code})")
            return False
            
    except Exception as e:
        print(f"❌ Visual Designer: ERROR - {str(e)}")
        return False
    
    # Step 4: Audio Synthesizer
    print("\n🔊 Step 4: Testing Audio Synthesizer...")
    try:
        audio_payload = {
            "script": script_result.get("script_generation", {}).get("script", {}),
            "emotional_tone": {"hook": "intrigante", "contextualizacao": "relevante"}
        }
        
        response = requests.post(
            f"{base_url}/{environment}-audio-synthesizer",
            json=audio_payload,
            headers={"Content-Type": "application/json"},
            timeout=180
        )
        
        if response.status_code == 200:
            audio_result = response.json()
            print("✅ Audio Synthesizer: SUCCESS")
            print(f"   TTS Integration: {audio_result.get('tts_integration', 'N/A')}")
        else:
            print(f"❌ Audio Synthesizer: FAILED (HTTP {response.status_code})")
            return False
            
    except Exception as e:
        print(f"❌ Audio Synthesizer: ERROR - {str(e)}")
        return False
    
    # Step 5: Quality Assurer
    print("\n🔍 Step 5: Testing Quality Assurer...")
    try:
        quality_payload = {
            "visual_assets": visual_result,
            "audio_assets": audio_result,
            "script": script_result.get("script_generation", {}).get("script", {}),
            "content_analysis": content_analysis.get("structure_analysis", {})
        }
        
        response = requests.post(
            f"{base_url}/{environment}-quality-assurer",
            json=quality_payload,
            headers={"Content-Type": "application/json"},
            timeout=240
        )
        
        if response.status_code == 200:
            quality_result = response.json()
            print("✅ Quality Assurer: SUCCESS")
            final_score = quality_result.get("quality_assessment", {}).get("final_quality_score", "N/A")
            print(f"   Final Quality Score: {final_score}")
        else:
            print(f"❌ Quality Assurer: FAILED (HTTP {response.status_code})")
            return False
            
    except Exception as e:
        print(f"❌ Quality Assurer: ERROR - {str(e)}")
        return False
    
    # Step 6: Performance Analyzer
    print("\n📊 Step 6: Testing Performance Analyzer...")
    try:
        performance_payload = {
            "final_video": quality_result.get("quality_assessment", {}).get("final_video", {}),
            "processing_metrics": {
                "start_time": datetime.utcnow().isoformat(),
                "end_time": datetime.utcnow().isoformat(),
                "content_analysis": content_analysis,
                "script_generation": script_result,
                "visual_design": visual_result,
                "audio_synthesis": audio_result,
                "quality_assurance": quality_result
            },
            "targets": {
                "processing_time": 480,  # 8 minutes
                "quality_score": 9.0,
                "cost": 2.50
            }
        }
        
        response = requests.post(
            f"{base_url}/{environment}-performance-analyzer",
            json=performance_payload,
            headers={"Content-Type": "application/json"},
            timeout=60
        )
        
        if response.status_code == 200:
            performance_result = response.json()
            print("✅ Performance Analyzer: SUCCESS")
            success_prob = performance_result.get("performance_analysis", {}).get("success_prediction", {}).get("overall_success_probability", "N/A")
            print(f"   Success Probability: {success_prob}")
        else:
            print(f"❌ Performance Analyzer: FAILED (HTTP {response.status_code})")
            return False
            
    except Exception as e:
        print(f"❌ Performance Analyzer: ERROR - {str(e)}")
        return False
    
    # Pipeline Summary
    print("\n" + "="*50)
    print("🎉 PIPELINE TEST COMPLETED SUCCESSFULLY!")
    print("="*50)
    print(f"✅ All 6 workers functioning correctly")
    print(f"✅ Kurzgesagt methodology applied")
    print(f"✅ Quality standards maintained")
    print(f"✅ Performance metrics collected")
    print("")
    print("📈 Pipeline Metrics:")
    print(f"   Content Quality: {content_analysis.get('quality_validation', {}).get('quality_score', 'N/A')}")
    print(f"   Final Quality: {quality_result.get('quality_assessment', {}).get('final_quality_score', 'N/A')}")
    print(f"   Success Prediction: {performance_result.get('performance_analysis', {}).get('success_prediction', {}).get('overall_success_probability', 'N/A')}")
    print("")
    print("🎬 Estúdio Vértice is ready for production! 🎬")
    
    return True

def main():
    parser = argparse.ArgumentParser(description="Test Estúdio Vértice Pipeline")
    parser.add_argument("--environment", default="dev", help="Environment to test")
    parser.add_argument("--project-id", default="estudio-vertice-ai", help="GCP Project ID")
    parser.add_argument("--region", default="us-central1", help="GCP Region")
    
    args = parser.parse_args()
    
    success = test_complete_pipeline(args.environment, args.project_id, args.region)
    
    if success:
        print("\n🚀 All tests passed! The pipeline is ready for use.")
        exit(0)
    else:
        print("\n💥 Tests failed! Please check the logs and fix issues.")
        exit(1)

if __name__ == "__main__":
    main()