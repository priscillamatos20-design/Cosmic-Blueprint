# 🤝 Contribuindo para o Estúdio Vértice

Obrigado por seu interesse em contribuir para o Estúdio Vértice! Este documento fornece diretrizes para contribuições ao projeto.

## 🎯 Visão Geral

O Estúdio Vértice é um pipeline serverless para automação completa de produção de vídeos educacionais baseado na metodologia Kurzgesagt quantificada. Estamos sempre buscando melhorias que possam aumentar a qualidade, eficiência e escalabilidade do sistema.

## 🛠️ Como Contribuir

### Tipos de Contribuições Bem-vindas

- 🐛 **Correção de Bugs**: Identifique e corrija problemas no código
- ✨ **Novas Funcionalidades**: Implemente recursos que melhorem o pipeline
- 📚 **Documentação**: Melhore ou adicione documentação
- 🧪 **Testes**: Adicione ou melhore testes automatizados
- 🎨 **Melhorias de UI/UX**: Aprimore interfaces e experiência do usuário
- ⚡ **Otimizações de Performance**: Melhore velocidade e eficiência
- 🔒 **Segurança**: Identifique e corrija vulnerabilidades

### Áreas de Foco Especiais

#### 1. Metodologia Kurzgesagt
- Refinamento dos algoritmos de análise de conteúdo
- Melhoria dos templates adaptativos
- Otimização do balance "nihilismo otimista"
- Aprimoramento das métricas de engajamento

#### 2. Inteligência Artificial
- Novos modelos de predição de sucesso
- Otimização de modelos existentes
- Integração com APIs de IA mais recentes
- Melhoria da precisão das previsões

#### 3. Performance e Escalabilidade
- Otimização de tempo de processamento
- Redução de custos operacionais
- Melhoria da qualidade de vídeo
- Aumento da capacidade de escala

## 🚀 Processo de Contribuição

### 1. Configuração do Ambiente

```bash
# Fork o repositório no GitHub
git clone https://github.com/SEU_USUARIO/Cosmic-Blueprint.git
cd Cosmic-Blueprint

# Configure o upstream
git remote add upstream https://github.com/priscillamatos20-design/Cosmic-Blueprint.git

# Instale dependências
python -m pip install --upgrade pip
pip install -r requirements-dev.txt

# Configure pre-commit hooks
pre-commit install
```

### 2. Criação de Branch

```bash
# Crie uma branch descritiva
git checkout -b feature/nova-funcionalidade
# ou
git checkout -b bugfix/corrigir-problema
# ou
git checkout -b docs/melhorar-documentacao
```

### 3. Desenvolvimento

#### Padrões de Código

**Python:**
- Siga o PEP 8
- Use Black para formatação: `black --line-length 100 .`
- Use Flake8 para linting: `flake8 --max-line-length=100`
- Use type hints sempre que possível
- Docstrings no formato Google style

**Terraform:**
- Use `terraform fmt` para formatação
- Siga convenções de nomenclatura consistentes
- Adicione comentários para recursos complexos
- Use variáveis para valores reutilizáveis

**Estrutura de Commits:**
```
tipo(escopo): descrição breve

Descrição mais detalhada do que foi alterado e por quê.

Fixes #123
```

Tipos de commit:
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Alterações na documentação
- `style`: Formatação, sem alterações de lógica
- `refactor`: Refatoração sem mudança de funcionalidade
- `test`: Adição ou modificação de testes
- `chore`: Tarefas de manutenção

### 4. Testes

#### Executar Testes Localmente

```bash
# Testes unitários
pytest tests/unit/

# Testes de integração
python tests/integration/test_pipeline.py --environment dev

# Cobertura de código
pytest --cov=workers/ --cov-report=html

# Testes de security
bandit -r workers/
safety check
```

#### Adicionar Novos Testes

- Testes unitários para cada função nova
- Testes de integração para workflows completos
- Testes de performance para otimizações
- Testes de segurança para mudanças relacionadas à security

### 5. Documentação

#### Documentação Obrigatória

- **Código**: Docstrings para todas as funções públicas
- **APIs**: Documentação OpenAPI/Swagger
- **Arquitetura**: Diagramas para mudanças estruturais
- **Deploy**: Atualize guias de deployment se necessário

#### Padrões de Documentação

- Use Markdown para documentação
- Inclua exemplos práticos
- Mantenha linguagem clara e objetiva
- Use emojis moderadamente para melhorar legibilidade

### 6. Pull Request

#### Checklist do PR

- [ ] Código segue padrões estabelecidos
- [ ] Testes adicionados/atualizados e passando
- [ ] Documentação atualizada
- [ ] Sem conflitos com branch principal
- [ ] Título e descrição claros
- [ ] Referencia issues relacionadas

#### Template do PR

```markdown
## 📝 Descrição

Breve descrição das mudanças realizadas.

## 🔗 Issues Relacionadas

Fixes #123
Closes #456

## 🧪 Como Testar

1. Passos para testar as mudanças
2. Comandos específicos
3. Resultados esperados

## 📸 Screenshots (se aplicável)

Adicione screenshots para mudanças visuais.

## ✅ Checklist

- [ ] Testes passando
- [ ] Documentação atualizada
- [ ] Sem breaking changes
- [ ] Segue padrões de código
```

## 📋 Guidelines Específicas

### Workers (Cloud Functions)

- Cada worker deve ser independente
- Use logging estruturado
- Implemente tratamento de erro robusto
- Otimize para cold start
- Mantenha compatibilidade com versões anteriores

### Terraform

- Use módulos reutilizáveis
- Documente variáveis e outputs
- Implemente data sources quando apropriado
- Use locals para valores computados
- Siga princípios DRY

### Metodologia Kurzgesagt

- Mudanças devem ser baseadas em dados
- Mantenha foco na experiência educacional
- Preserve princípios do "nihilismo otimista"
- Teste impacto em métricas de engajamento

## 🎯 Metas de Qualidade

### Cobertura de Código
- Mínimo de 80% de cobertura para código novo
- 90% de cobertura para componentes críticos

### Performance
- Tempo de processamento < 8 minutos
- Qualidade de vídeo > 9.0/10
- Custo por vídeo < $2.50

### Confiabilidade
- 99.9% de uptime
- Zero data loss
- Recuperação automática de falhas

## 🐛 Reportar Bugs

### Template de Bug Report

```markdown
**Descrição do Bug**
Descrição clara e concisa do problema.

**Para Reproduzir**
1. Vá para '...'
2. Clique em '....'
3. Role para baixo até '....'
4. Veja o erro

**Comportamento Esperado**
Descrição do que você esperava que acontecesse.

**Screenshots**
Se aplicável, adicione screenshots.

**Ambiente:**
- OS: [e.g. Ubuntu 20.04]
- Python: [e.g. 3.11.0]
- Terraform: [e.g. 1.6.0]

**Contexto Adicional**
Qualquer outro contexto sobre o problema.
```

## 💡 Sugerir Funcionalidades

### Template de Feature Request

```markdown
**Problema Relacionado**
Descrição clara do problema que esta funcionalidade resolveria.

**Solução Proposta**
Descrição clara e concisa da solução desejada.

**Alternativas Consideradas**
Descrição de alternativas que você considerou.

**Impacto Esperado**
- Performance: [impacto esperado]
- Usuário: [benefícios para usuário]
- Negócio: [valor de negócio]

**Contexto Adicional**
Qualquer outro contexto ou screenshots.
```

## 🤝 Código de Conduta

### Nossos Valores

- **Respeito**: Trate todos com cortesia e profissionalismo
- **Inclusão**: Valorize perspectivas diversas
- **Colaboração**: Trabalhe junto para soluções melhores
- **Aprendizado**: Esteja aberto a feedback e crescimento
- **Qualidade**: Mantenha altos padrões em tudo que fazemos

### Comportamentos Esperados

- Use linguagem acolhedora e inclusiva
- Respeite pontos de vista diferentes
- Aceite críticas construtivas graciosamente
- Foque no que é melhor para a comunidade
- Mostre empatia com outros membros

### Comportamentos Inaceitáveis

- Linguagem ou imagens sexualizadas
- Ataques pessoais ou políticos
- Assédio público ou privado
- Publicar informações privadas sem permissão
- Qualquer conduta que seria considerada inapropriada

## 📞 Suporte

### Canais de Comunicação

- **Issues**: Para bugs e feature requests
- **Discussions**: Para perguntas e discussões gerais
- **Email**: contato@estudio-vertice.com
- **Slack**: #estudio-vertice (convite por email)

### Equipe Principal

- **@priscillamatos20-design** - Product Owner
- **@devops-team** - DevOps e Infraestrutura
- **@ai-team** - Inteligência Artificial
- **@quality-team** - Quality Assurance

### Horários de Suporte

- **Issues críticos**: 24/7
- **Suporte geral**: Segunda-Sexta, 9h-18h BRT
- **Code reviews**: 48h para resposta inicial

## 🏆 Reconhecimento

### Contributors Hall of Fame

Reconhecemos e agradecemos todos os contributors:

- Contribuições são listadas no CHANGELOG.md
- Contributors são mencionados nos releases
- Contribuições significativas são destacadas no README
- Annual contributor awards

### Como Ser Reconhecido

1. **First-time contributor**: Primeira contribuição aceita
2. **Regular contributor**: 5+ contribuições aceitas
3. **Core contributor**: 20+ contribuições + código review
4. **Maintainer**: Convite da equipe principal

---

## 🎉 Obrigado!

Sua contribuição faz a diferença na democratização da educação através de tecnologia. Juntos, estamos construindo o futuro da criação de conteúdo educacional!

**"A melhor forma de prever o futuro é criá-lo."** - Estúdio Vértice Team

---

Para mais informações:
- [Documentação](docs/)
- [Arquitetura](docs/architecture.md)
- [API Reference](docs/api.md)
- [Deployment Guide](docs/deployment.md)