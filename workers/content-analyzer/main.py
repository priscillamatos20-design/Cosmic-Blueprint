"""
Estúdio Vértice - Content Analyzer Worker
Responsável por análise e estruturação de conteúdo
"""

import json
import logging
import os
from datetime import datetime
from typing import Dict, Any, List
import functions_framework
from google.cloud import storage
from google.cloud import aiplatform
import vertexai
from vertexai.language_models import TextGenerationModel

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Vertex AI
PROJECT_ID = os.environ.get('PROJECT_ID', 'estudio-vertice-ai')
REGION = os.environ.get('REGION', 'us-central1')
STORAGE_BUCKET = os.environ.get('STORAGE_BUCKET')

vertexai.init(project=PROJECT_ID, location=REGION)

class KurzgesagtAnalyzer:
    """Analisador baseado na metodologia Kurzgesagt quantificada"""
    
    def __init__(self):
        self.model = TextGenerationModel.from_pretrained("text-bison@002")
        self.storage_client = storage.Client()
        self.bucket = self.storage_client.bucket(STORAGE_BUCKET) if STORAGE_BUCKET else None
        
    def analyze_content_structure(self, content: str) -> Dict[str, Any]:
        """Analisa a estrutura do conteúdo baseado na metodologia Kurzgesagt"""
        
        prompt = f"""
        Analise o seguinte conteúdo usando a metodologia Kurzgesagt quantificada:
        
        CONTEÚDO:
        {content}
        
        ANÁLISE REQUERIDA:
        1. HOOK INICIAL (0-15s): Identifique o potencial para criar um hook envolvente
        2. CONTEXTUALIZAÇÃO (15-45s): Determine como estabelecer relevância pessoal
        3. DESENVOLVIMENTO: Identifique conceitos complexos que precisam de analogias
        4. SÍNTESE FINAL: Sugira mensagem de empoderamento
        
        FILOSOFIA NIHILISMO OTIMISTA:
        - Reconheça a complexidade sem simplificar excessivamente
        - Balance otimismo com realismo científico
        - Conecte problemas individuais com contexto universal
        
        Retorne uma análise estruturada em JSON com:
        - hook_potential: pontuação 0-10
        - complexity_level: baixo/médio/alto
        - target_audience: descrição
        - key_concepts: lista de conceitos principais
        - analogy_opportunities: sugestões de analogias visuais
        - emotional_tone: tom emocional apropriado
        - scientific_accuracy: verificação de precisão científica
        """
        
        try:
            response = self.model.predict(
                prompt,
                temperature=0.2,
                max_output_tokens=1024
            )
            
            # Parse response to extract structured data
            analysis = self._parse_analysis_response(response.text)
            
            return {
                'status': 'success',
                'analysis': analysis,
                'timestamp': datetime.utcnow().isoformat(),
                'methodology': 'kurzgesagt_quantified'
            }
            
        except Exception as e:
            logger.error(f"Error in content analysis: {str(e)}")
            return {
                'status': 'error',
                'error': str(e),
                'timestamp': datetime.utcnow().isoformat()
            }
    
    def _parse_analysis_response(self, response_text: str) -> Dict[str, Any]:
        """Extrai dados estruturados da resposta do modelo"""
        try:
            # Try to extract JSON from response
            start = response_text.find('{')
            end = response_text.rfind('}') + 1
            
            if start != -1 and end != -1:
                json_str = response_text[start:end]
                return json.loads(json_str)
            else:
                # Fallback to structured parsing
                return self._fallback_parse(response_text)
                
        except json.JSONDecodeError:
            return self._fallback_parse(response_text)
    
    def _fallback_parse(self, text: str) -> Dict[str, Any]:
        """Parsing de fallback quando JSON falha"""
        return {
            'hook_potential': 7.5,  # Default values
            'complexity_level': 'médio',
            'target_audience': 'público geral interessado em ciência',
            'key_concepts': ['conceito_principal'],
            'analogy_opportunities': ['analogia_visual_1'],
            'emotional_tone': 'otimista_cauteloso',
            'scientific_accuracy': 'alta',
            'raw_analysis': text
        }
    
    def validate_content_quality(self, content: str) -> Dict[str, Any]:
        """Valida a qualidade do conteúdo para produção de vídeo"""
        
        quality_checks = {
            'length_appropriate': len(content.split()) >= 100,
            'scientific_terms_present': any(term in content.lower() for term in 
                ['pesquisa', 'estudo', 'científico', 'evidência', 'dados']),
            'narrative_potential': len(content.split('.')) >= 5,
            'complexity_manageable': len(content.split()) <= 2000
        }
        
        quality_score = sum(quality_checks.values()) / len(quality_checks) * 10
        
        return {
            'quality_score': quality_score,
            'checks': quality_checks,
            'recommendation': 'approved' if quality_score >= 7.0 else 'needs_revision',
            'timestamp': datetime.utcnow().isoformat()
        }

@functions_framework.http
def main(request):
    """Cloud Function entry point"""
    try:
        # Parse request
        if request.method == 'OPTIONS':
            headers = {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods': 'POST',
                'Access-Control-Allow-Headers': 'Content-Type',
                'Access-Control-Max-Age': '3600'
            }
            return ('', 204, headers)
        
        request_json = request.get_json(silent=True)
        if not request_json:
            return {'error': 'Invalid JSON payload'}, 400
        
        content = request_json.get('content', '')
        if not content:
            return {'error': 'Content is required'}, 400
        
        # Initialize analyzer
        analyzer = KurzgesagtAnalyzer()
        
        # Perform analysis
        structure_analysis = analyzer.analyze_content_structure(content)
        quality_validation = analyzer.validate_content_quality(content)
        
        # Prepare response
        response = {
            'worker': 'content-analyzer',
            'version': '4.1.0',
            'structure_analysis': structure_analysis,
            'quality_validation': quality_validation,
            'processing_time': datetime.utcnow().isoformat(),
            'kurzgesagt_methodology': True
        }
        
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        }
        
        return (json.dumps(response), 200, headers)
        
    except Exception as e:
        logger.error(f"Error in content analyzer: {str(e)}")
        error_response = {
            'error': str(e),
            'worker': 'content-analyzer',
            'timestamp': datetime.utcnow().isoformat()
        }
        return (json.dumps(error_response), 500)

if __name__ == "__main__":
    # For local testing
    import flask
    app = flask.Flask(__name__)
    app.debug = True
    
    @app.route('/', methods=['POST', 'OPTIONS'])
    def local_main():
        return main(flask.request)
    
    app.run(host='0.0.0.0', port=8080)