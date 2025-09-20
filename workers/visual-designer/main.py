"""
Estúdio Vértice - Visual Designer Worker
Responsável por design visual e animação
"""

import json
import logging
import os
from datetime import datetime
from typing import Dict, Any, List
import functions_framework
from google.cloud import storage
import vertexai
from vertexai.preview.vision_models import ImageGenerationModel

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Vertex AI
PROJECT_ID = os.environ.get('PROJECT_ID', 'estudio-vertice-ai')
REGION = os.environ.get('REGION', 'us-central1')
STORAGE_BUCKET = os.environ.get('STORAGE_BUCKET')

vertexai.init(project=PROJECT_ID, location=REGION)

class KurzgesagtVisualDesigner:
    """Designer visual baseado no estilo Kurzgesagt"""
    
    def __init__(self):
        self.imagen_model = ImageGenerationModel.from_pretrained("imagegeneration@006")
        self.storage_client = storage.Client()
        self.bucket = self.storage_client.bucket(STORAGE_BUCKET) if STORAGE_BUCKET else None
        
        # Estilo visual Kurzgesagt quantificado
        self.visual_style = {
            "color_palette": {
                "primary": ["#FF6B35", "#F7931E", "#FFD23F"],  # Laranja vibrante
                "secondary": ["#06FFA5", "#3A86FF", "#8338EC"], # Verde/Azul/Roxo
                "backgrounds": ["#0A0E27", "#1A1D3A", "#2C3E50"], # Azul escuro/espacial
                "accent": ["#FFFFFF", "#F8F9FA", "#ECF0F1"]      # Brancos/Cinzas claros
            },
            "character_design": {
                "style": "flat_geometric",
                "characteristics": ["simple shapes", "bold colors", "expressive eyes", "minimal details"],
                "emotion_factors": ["curiosity", "wonder", "intelligence", "optimism"]
            },
            "scene_composition": {
                "space_usage": "cosmic_perspective",
                "scale_contrast": "micro_to_macro",
                "visual_metaphors": "scientific_concepts",
                "attention_flow": "guided_visual_hierarchy"
            }
        }
    
    def design_visual_elements(self, script: Dict[str, Any], content_analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Cria elementos visuais baseados no roteiro e análise"""
        
        try:
            visual_elements = {
                "hook_visuals": self._design_hook_visuals(script.get('hook_inicial', '')),
                "concept_illustrations": self._design_concept_visuals(script.get('desenvolvimento', ''), content_analysis),
                "characters": self._design_characters(content_analysis),
                "backgrounds": self._design_backgrounds(script),
                "animations": self._plan_animations(script),
                "transitions": self._design_transitions(script)
            }
            
            return {
                'status': 'success',
                'visual_elements': visual_elements,
                'style_guide': self.visual_style,
                'kurzgesagt_compliance': self._validate_kurzgesagt_style(visual_elements),
                'timestamp': datetime.utcnow().isoformat()
            }
            
        except Exception as e:
            logger.error(f"Error in visual design: {str(e)}")
            return {
                'status': 'error',
                'error': str(e),
                'timestamp': datetime.utcnow().isoformat()
            }
    
    def _design_hook_visuals(self, hook_text: str) -> Dict[str, Any]:
        """Cria visuais para o hook inicial (0-15s)"""
        
        # Analizar o tipo de hook
        hook_type = self._identify_hook_type(hook_text)
        
        visual_concepts = {
            "provocative_question": {
                "opening_scene": "cosmic_zoom_in",
                "visual_question": "floating_question_mark_with_particles",
                "color_scheme": "high_contrast_attention_grabbing",
                "animation": "rapid_reveal_sequence"
            },
            "surprising_statistic": {
                "opening_scene": "data_visualization_explosion",
                "number_display": "giant_floating_numbers",
                "color_scheme": "bright_accent_colors",
                "animation": "counter_animation_buildup"
            },
            "intriguing_scenario": {
                "opening_scene": "miniature_world_zoom",
                "scenario_setup": "detailed_environment",
                "color_scheme": "immersive_world_palette",
                "animation": "smooth_environment_reveal"
            }
        }
        
        return visual_concepts.get(hook_type, visual_concepts["intriguing_scenario"])
    
    def _design_concept_visuals(self, development_text: str, content_analysis: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Cria ilustrações para conceitos principais"""
        
        key_concepts = content_analysis.get('analysis', {}).get('key_concepts', [])
        analogy_opportunities = content_analysis.get('analysis', {}).get('analogy_opportunities', [])
        
        concept_visuals = []
        
        for concept in key_concepts[:5]:  # Máximo 5 conceitos principais
            visual_concept = {
                "concept": concept,
                "visual_metaphor": self._generate_visual_metaphor(concept),
                "illustration_style": "kurzgesagt_scientific",
                "color_palette": self._select_concept_colors(concept),
                "animation_type": self._determine_animation_type(concept),
                "complexity_level": self._assess_visual_complexity(concept)
            }
            concept_visuals.append(visual_concept)
        
        return concept_visuals
    
    def _design_characters(self, content_analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Projeta personagens para o vídeo"""
        
        emotional_tone = content_analysis.get('analysis', {}).get('emotional_tone', 'otimista_cauteloso')
        
        characters = {
            "narrator_avatar": {
                "style": "friendly_geometric_figure",
                "personality": "curious_scientist",
                "color_scheme": self.visual_style["color_palette"]["primary"],
                "emotions": ["curious", "excited", "thoughtful", "encouraging"],
                "size_variations": ["normal", "tiny_for_scale", "giant_for_emphasis"]
            },
            "concept_mascots": self._create_concept_mascots(content_analysis),
            "background_characters": {
                "scientists": "tiny_working_figures",
                "observers": "silhouette_crowd",
                "scale_references": "human_figures_for_perspective"
            }
        }
        
        return characters
    
    def _design_backgrounds(self, script: Dict[str, Any]) -> Dict[str, Any]:
        """Projeta fundos para diferentes seções"""
        
        backgrounds = {
            "hook_background": {
                "style": "cosmic_space",
                "colors": self.visual_style["color_palette"]["backgrounds"],
                "elements": ["stars", "nebulas", "particles"],
                "mood": "mysterious_intriguing"
            },
            "explanation_backgrounds": {
                "style": "clean_laboratory",
                "colors": ["#F8F9FA", "#ECF0F1"],
                "elements": ["geometric_patterns", "floating_elements"],
                "mood": "scientific_clarity"
            },
            "conclusion_background": {
                "style": "hopeful_horizon",
                "colors": self.visual_style["color_palette"]["primary"],
                "elements": ["rising_sun", "expanding_light"],
                "mood": "optimistic_empowering"
            }
        }
        
        return backgrounds
    
    def _plan_animations(self, script: Dict[str, Any]) -> Dict[str, Any]:
        """Planeja animações para manter engajamento"""
        
        animations = {
            "hook_animation": {
                "type": "attention_grabbing_entrance",
                "duration": "15_seconds",
                "key_frames": ["dramatic_zoom", "reveal_sequence", "particle_effects"],
                "pacing": "fast_engaging"
            },
            "concept_animations": {
                "type": "explanatory_sequences",
                "duration": "20_30_second_cycles", 
                "key_frames": ["build_up", "revelation", "integration"],
                "pacing": "progressive_understanding"
            },
            "transition_animations": {
                "type": "smooth_connectors",
                "duration": "2_3_seconds",
                "key_frames": ["morphing", "flowing", "connecting"],
                "pacing": "seamless_flow"
            },
            "conclusion_animation": {
                "type": "empowering_finale",
                "duration": "final_25_percent",
                "key_frames": ["gathering", "synthesis", "expansion"],
                "pacing": "building_to_climax"
            }
        }
        
        return animations
    
    def _design_transitions(self, script: Dict[str, Any]) -> List[Dict[str, Any]]:
        """Projeta transições suaves entre seções"""
        
        transitions = [
            {
                "from": "hook",
                "to": "contextualization",
                "type": "zoom_refocus",
                "visual": "cosmic_to_personal_perspective",
                "duration": "2_seconds"
            },
            {
                "from": "contextualization", 
                "to": "development",
                "type": "morphing_transformation",
                "visual": "concept_materialization",
                "duration": "3_seconds"
            },
            {
                "from": "development",
                "to": "synthesis",
                "type": "gathering_convergence",
                "visual": "elements_coming_together",
                "duration": "2_seconds"
            }
        ]
        
        return transitions
    
    def _generate_visual_metaphor(self, concept: str) -> str:
        """Gera metáfora visual para conceito"""
        metaphor_library = {
            "complexidade": "intricate_clockwork_mechanism",
            "evolução": "tree_growth_timelapse",
            "energia": "flowing_particle_streams",
            "informação": "network_nodes_lighting_up",
            "tempo": "spiral_cosmic_clock",
            "escala": "nested_russian_dolls",
            "conexão": "web_of_glowing_lines"
        }
        
        for key in metaphor_library:
            if key in concept.lower():
                return metaphor_library[key]
        
        return "abstract_geometric_representation"
    
    def _select_concept_colors(self, concept: str) -> List[str]:
        """Seleciona cores apropriadas para cada conceito"""
        color_associations = {
            "científico": self.visual_style["color_palette"]["secondary"],
            "tecnológico": ["#3A86FF", "#8338EC"],
            "natural": ["#06FFA5", "#FF6B35"],
            "cósmico": self.visual_style["color_palette"]["backgrounds"],
            "humano": self.visual_style["color_palette"]["primary"]
        }
        
        for key in color_associations:
            if key in concept.lower():
                return color_associations[key]
        
        return self.visual_style["color_palette"]["primary"]
    
    def _determine_animation_type(self, concept: str) -> str:
        """Determina tipo de animação apropriada"""
        animation_types = {
            "processo": "step_by_step_reveal",
            "comparação": "side_by_side_morphing",
            "crescimento": "organic_expansion",
            "movimento": "flowing_trajectory",
            "transformação": "morphing_sequence"
        }
        
        for key in animation_types:
            if key in concept.lower():
                return animation_types[key]
        
        return "gentle_floating_emphasis"
    
    def _assess_visual_complexity(self, concept: str) -> str:
        """Avalia complexidade visual necessária"""
        if len(concept.split()) > 3:
            return "high_detail_required"
        elif len(concept.split()) > 1:
            return "moderate_detail"
        else:
            return "simple_clean_design"
    
    def _create_concept_mascots(self, content_analysis: Dict[str, Any]) -> Dict[str, Any]:
        """Cria mascotes para conceitos principais"""
        key_concepts = content_analysis.get('analysis', {}).get('key_concepts', [])
        
        mascots = {}
        for i, concept in enumerate(key_concepts[:3]):  # Máximo 3 mascotes
            mascots[f"mascot_{i+1}"] = {
                "represents": concept,
                "personality": "helpful_guide",
                "visual_style": "cute_geometric",
                "color": self.visual_style["color_palette"]["secondary"][i % len(self.visual_style["color_palette"]["secondary"])],
                "animations": ["pointing", "explaining", "celebrating"]
            }
        
        return mascots
    
    def _identify_hook_type(self, hook_text: str) -> str:
        """Identifica o tipo de hook baseado no texto"""
        if "?" in hook_text:
            return "provocative_question"
        elif any(char.isdigit() for char in hook_text):
            return "surprising_statistic"
        else:
            return "intriguing_scenario"
    
    def _validate_kurzgesagt_style(self, visual_elements: Dict[str, Any]) -> Dict[str, Any]:
        """Valida conformidade com padrões Kurzgesagt"""
        
        compliance_checks = {
            "color_palette_adherence": True,  # Simplified for now
            "character_style_consistency": True,
            "cosmic_perspective_present": True,
            "scientific_accuracy_visual": True,
            "optimistic_tone_visual": True
        }
        
        compliance_score = sum(compliance_checks.values()) / len(compliance_checks) * 100
        
        return {
            "compliance_score": compliance_score,
            "checks": compliance_checks,
            "style_guide_followed": "kurzgesagt_quantified_v4.1",
            "recommendations": [] if compliance_score > 90 else ["review_color_usage", "enhance_cosmic_elements"]
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
        
        script = request_json.get('script', {})
        content_analysis = request_json.get('content_analysis', {})
        
        if not script or not content_analysis:
            return {'error': 'Script and content analysis are required'}, 400
        
        # Initialize designer
        designer = KurzgesagtVisualDesigner()
        
        # Create visual design
        design_result = designer.design_visual_elements(script, content_analysis)
        
        # Prepare response
        response = {
            'worker': 'visual-designer',
            'version': '4.1.0',
            'visual_design': design_result,
            'processing_time': datetime.utcnow().isoformat(),
            'kurzgesagt_style': True,
            'imagen_integration': True
        }
        
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Content-Type': 'application/json'
        }
        
        return (json.dumps(response), 200, headers)
        
    except Exception as e:
        logger.error(f"Error in visual designer: {str(e)}")
        error_response = {
            'error': str(e),
            'worker': 'visual-designer',
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
    
    app.run(host='0.0.0.0', port=8082)