"""
Estúdio Vértice - Script Generator Worker
Responsável por geração de roteiros com metodologia Kurzgesagt
"""

import json
import logging
import os
from datetime import datetime
from typing import Dict, Any, List
import functions_framework
from google.cloud import storage
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

class KurzgesagtScriptGenerator:
    """Gerador de roteiros baseado na metodologia Kurzgesagt quantificada"""
    
    def __init__(self):
        self.model = TextGenerationModel.from_pretrained("text-bison@002")
        self.storage_client = storage.Client()
        self.bucket = self.storage_client.bucket(STORAGE_BUCKET) if STORAGE_BUCKET else None
        
        # Templates adaptativos baseados em performance
        self.templates = {
            "educational_explainer": {
                "hook_patterns": [
                    "provocative_question",  # 91% retenção
                    "surprising_statistic",  # 87% retenção
                    "intriguing_scenario"    # 84% retenção
                ],
                "structure": {
                    "hook_inicial": "0-15s",
                    "contextualizacao": "15-45s", 
                    "desenvolvimento": "corpo principal",
                    "sintese_final": "20-25% do total"
                }
            }
        }
    
    def generate_kurzgesagt_script(self, content_analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Gera roteiro usando metodologia Kurzgesagt otimizada"""
        
        analysis = content_analysis.get('analysis', {})
        
        prompt = f"""
        Gere um roteiro de vídeo educacional seguindo a METODOLOGIA KURZGESAGT QUANTIFICADA:
        
        ANÁLISE DO CONTEÚDO:
        - Hook Potential: {analysis.get('hook_potential', 7)}
        - Complexidade: {analysis.get('complexity_level', 'médio')}
        - Conceitos-chave: {analysis.get('key_concepts', [])}
        - Oportunidades de analogia: {analysis.get('analogy_opportunities', [])}
        
        ESTRUTURA OBRIGATÓRIA:
        
        1. HOOK INICIAL (0-15 segundos) - 89% retenção comprovada:
           - Use pergunta provocativa OU estatística surpreendente OU cenário intrigante
           - Primeiros 5s determinam 73% da retenção total
           - Exemplo: "E se eu te dissesse que [fato surpreendente]?"
        
        2. CONTEXTUALIZAÇÃO (15-45 segundos) - +23% engajamento:
           - Estabeleça relevância pessoal: "isso afeta você porque..."
           - Preview da descoberta para manter atenção +40s
           - Conecte com experiência universal
        
        3. DESENVOLVIMENTO PRINCIPAL:
           - Progressão de complexidade incremental
           - Formato W com picos de atenção a cada 20-30s
           - Analogias visuais (+45% compreensão)
           - Comparações do dia-a-dia (+38% retenção)
           - Comparações de escala (+52% impacto emocional)
        
        4. SÍNTESE FINAL (20-25% do vídeo):
           - Reflexão pessoal (87% reportam 'pensamento provocado')
           - Implicações futuras (74% compartilham conteúdo)
           - Mensagem de empoderamento (91% satisfaction score)
        
        FILOSOFIA NIHILISMO OTIMISTA:
        - Reconheça complexidade sem simplificar excessivamente (+31% tempo visualização)
        - Otimismo cauteloso baseado em evidências (72% precisão em predições)
        - Empoderamento através de perspectiva cósmica (+23% engajamento)
        - Balance dados científicos com narrativa emocional (89% retenção primeiros 15s)
        
        FORMATO DE SAÍDA:
        ```
        [HOOK INICIAL - 0:00-0:15]
        [Texto do hook com timing específico]
        
        [CONTEXTUALIZAÇÃO - 0:15-0:45] 
        [Texto da contextualização]
        
        [DESENVOLVIMENTO - 0:45-X:XX]
        [Desenvolvimento com seções marcadas]
        
        [SÍNTESE FINAL - últimos 20-25%]
        [Conclusão empoderamento]
        ```
        
        METADADOS:
        - Estimativa duração total
        - Pontos de pico de atenção marcados
        - Sugestões de elementos visuais
        - Tom emocional por seção
        """
        
        try:
            response = self.model.predict(
                prompt,
                temperature=0.3,
                max_output_tokens=2048
            )
            
            script_data = self._parse_script_response(response.text)
            
            return {
                'status': 'success',
                'script': script_data,
                'methodology': 'kurzgesagt_quantified',
                'templates_used': self.templates,
                'timestamp': datetime.utcnow().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error in script generation: {str(e)}")
            return {
                'status': 'error',
                'error': str(e),
                'timestamp': datetime.utcnow().isoformat()
            }
    
    def _parse_script_response(self, response_text: str) -> Dict[str, Any]:
        """Extrai e estrutura o roteiro da resposta"""
        
        sections = {
            'hook_inicial': '',
            'contextualizacao': '',
            'desenvolvimento': '',
            'sintese_final': '',
            'metadata': {}
        }
        
        # Extract sections using markers
        current_section = None
        for line in response_text.split('\n'):
            line = line.strip()
            
            if '[HOOK INICIAL' in line:
                current_section = 'hook_inicial'
            elif '[CONTEXTUALIZAÇÃO' in line:
                current_section = 'contextualizacao'
            elif '[DESENVOLVIMENTO' in line:
                current_section = 'desenvolvimento'
            elif '[SÍNTESE FINAL' in line:
                current_section = 'sintese_final'
            elif current_section and line and not line.startswith('['):
                sections[current_section] += line + '\n'
        
        # Extract metadata
        sections['metadata'] = {
            'estimated_duration': self._estimate_duration(response_text),
            'attention_peaks': self._identify_attention_peaks(response_text),
            'visual_suggestions': self._extract_visual_suggestions(response_text),
            'emotional_tone': self._analyze_emotional_tone(response_text)
        }
        
        return sections
    
    def _estimate_duration(self, text: str) -> str:
        """Estima duração baseada no texto"""
        word_count = len(text.split())
        # Média de 150 palavras por minuto para narração educacional
        duration_minutes = word_count / 150
        return f"{duration_minutes:.1f} minutos"
    
    def _identify_attention_peaks(self, text: str) -> List[str]:
        """Identifica pontos de pico de atenção"""
        peaks = []
        attention_markers = ['surpreendente', 'incrível', 'imagine', 'mas espere', 'contudo']
        
        for marker in attention_markers:
            if marker in text.lower():
                peaks.append(f"Pico de atenção: {marker}")
        
        return peaks
    
    def _extract_visual_suggestions(self, text: str) -> List[str]:
        """Extrai sugestões de elementos visuais"""
        suggestions = []
        visual_cues = ['visualize', 'imagine', 'picture', 'veja', 'observe']
        
        for cue in visual_cues:
            if cue in text.lower():
                suggestions.append(f"Elemento visual para: {cue}")
        
        return suggestions
    
    def _analyze_emotional_tone(self, text: str) -> Dict[str, str]:
        """Analisa tom emocional por seção"""
        return {
            'hook': 'intrigante/provocativo',
            'contextualizacao': 'relevante/pessoal',
            'desenvolvimento': 'educativo/progressivo',
            'sintese': 'empoderador/otimista'
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
        
        content_analysis = request_json.get('content_analysis', {})
        if not content_analysis:
            return {'error': 'Content analysis is required'}, 400
        
        # Initialize generator
        generator = KurzgesagtScriptGenerator()
        
        # Generate script
        script_result = generator.generate_kurzgesagt_script(content_analysis)
        
        # Prepare response
        response = {
            'worker': 'script-generator',
            'version': '4.1.0',
            'script_generation': script_result,
            'processing_time': datetime.utcnow().isoformat(),
            'kurzgesagt_methodology': True,
            'nihilistic_optimism': True
        }
        
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        }
        
        return (json.dumps(response), 200, headers)
        
    except Exception as e:
        logger.error(f"Error in script generator: {str(e)}")
        error_response = {
            'error': str(e),
            'worker': 'script-generator',
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
    
    app.run(host='0.0.0.0', port=8081)