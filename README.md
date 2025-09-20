# Estúdio Vértice - Sistema de Gestão

Sistema completo de gestão para estúdio de arquitetura, desenvolvido com React + TypeScript no frontend e Node.js + Express no backend.

## 🏗️ Arquitetura

- **Frontend**: React.js + TypeScript + TailwindCSS
- **Backend**: Node.js + Express.js + TypeScript
- **Banco de Dados**: PostgreSQL + Prisma ORM
- **Autenticação**: JWT + bcrypt
- **Upload de Arquivos**: Multer
- **Validação**: Zod

## 🚀 Configuração e Instalação

### Pré-requisitos

- Node.js (v18 ou superior)
- PostgreSQL (v12 ou superior)
- npm ou yarn

### 1. Clonar o repositório

```bash
git clone <repository-url>
cd Cosmic-Blueprint
```

### 2. Instalar dependências

```bash
# Instalar dependências de todos os projetos
npm run install:all

# Ou instalar individualmente
npm install
cd frontend && npm install
cd ../backend && npm install
```

### 3. Configurar ambiente

```bash
# Copiar arquivo de exemplo do backend
cd backend
cp .env.example .env
```

Editar o arquivo `.env` com suas configurações:

```env
DATABASE_URL="postgresql://username:password@localhost:5432/estudio_vertice?schema=public"
JWT_SECRET="your-super-secret-jwt-key"
JWT_EXPIRES_IN="7d"
PORT=3001
NODE_ENV="development"
UPLOAD_DIR="uploads"
MAX_FILE_SIZE=10485760
```

### 4. Configurar banco de dados

```bash
# Gerar cliente Prisma
npm run prisma:generate

# Executar migrações
npm run prisma:migrate

# (Opcional) Abrir Prisma Studio
npm run prisma:studio
```

### 5. Executar a aplicação

```bash
# Rodar frontend e backend simultaneamente
npm run dev

# Ou rodar separadamente
npm run dev:frontend  # Porta 3000
npm run dev:backend   # Porta 3001
```

## 📁 Estrutura do Projeto

```
Cosmic-Blueprint/
├── frontend/                 # React + TypeScript
│   ├── src/
│   │   ├── components/      # Componentes React
│   │   ├── pages/          # Páginas da aplicação
│   │   ├── hooks/          # Custom hooks
│   │   ├── store/          # Zustand store
│   │   ├── types/          # TypeScript types
│   │   ├── utils/          # Utilitários
│   │   └── services/       # API services
│   └── public/
├── backend/                  # Node.js + Express
│   ├── src/
│   │   ├── controllers/    # Controllers da API
│   │   ├── middleware/     # Middlewares
│   │   ├── models/         # Modelos de dados
│   │   ├── routes/         # Rotas da API
│   │   ├── utils/          # Utilitários
│   │   └── types/          # TypeScript types
│   └── prisma/            # Schema e migrações
└── uploads/               # Arquivos enviados
```

## 🎯 Funcionalidades Principais

### ✅ Implementado (Fase 1)

- [x] Configuração inicial do projeto
- [x] Estrutura de pastas frontend/backend
- [x] Configuração React + TypeScript
- [x] Configuração TailwindCSS
- [x] Configuração Express + TypeScript
- [x] Schema do banco de dados (Prisma)
- [x] Páginas básicas (Login/Dashboard)
- [x] Build system funcionando

### 🔄 Em Desenvolvimento

- [ ] Sistema de autenticação (Fase 2)
- [ ] Dashboard principal (Fase 3)
- [ ] Gestão de clientes (Fase 4)
- [ ] Gestão de projetos (Fase 5)
- [ ] Gestão financeira (Fase 6)
- [ ] Agenda e reuniões (Fase 7)
- [ ] Biblioteca de recursos (Fase 8)
- [ ] Relatórios e analytics (Fase 9)
- [ ] Finalização e deploy (Fase 10)

## 🔧 Scripts Disponíveis

```bash
# Desenvolvimento
npm run dev                  # Executar frontend e backend
npm run dev:frontend         # Apenas frontend
npm run dev:backend          # Apenas backend

# Build
npm run build               # Build completo
npm run build:frontend      # Build frontend
npm run build:backend       # Build backend

# Banco de dados
npm run prisma:generate     # Gerar cliente Prisma
npm run prisma:migrate      # Executar migrações
npm run prisma:studio       # Abrir Prisma Studio

# Instalação
npm run install:all         # Instalar todas as dependências
```

## 📋 Módulos do Sistema

1. **Autenticação e Usuários** - Login, perfis, permissões
2. **Dashboard Principal** - Métricas, gráficos, visão geral
3. **Gestão de Clientes** - CRUD clientes, histórico, documentos
4. **Gestão de Projetos** - CRUD projetos, etapas, timeline
5. **Gestão Financeira** - Orçamentos, pagamentos, relatórios
6. **Agenda e Reuniões** - Calendário, agendamentos, convites
7. **Biblioteca de Recursos** - Upload, organização, busca
8. **Relatórios e Analytics** - Dashboards, exportação, métricas

## 🛠️ Tecnologias Utilizadas

### Frontend
- React 18
- TypeScript
- TailwindCSS
- React Router DOM
- Zustand (estado)
- React Hook Form + Zod
- Lucide React (ícones)
- Recharts (gráficos)

### Backend
- Node.js
- Express.js
- TypeScript
- Prisma ORM
- PostgreSQL
- JWT + bcrypt
- Multer (upload)
- CORS

## 📄 Licença

MIT License - Estúdio Vértice
