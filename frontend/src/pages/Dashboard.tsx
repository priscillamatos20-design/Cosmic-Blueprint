import React from 'react';

const Dashboard: React.FC = () => {
  return (
    <div className="min-h-screen bg-surface">
      {/* Header */}
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex items-center">
              <h1 className="text-2xl font-bold text-gray-900">
                Estúdio Vértice
              </h1>
            </div>
            <div className="flex items-center space-x-4">
              <span className="text-sm text-gray-500">Bem-vindo!</span>
              <button className="bg-gray-100 p-2 rounded-full">
                <span className="text-sm">👤</span>
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {/* Metrics Cards */}
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-medium text-gray-900">Projetos Ativos</h3>
            <p className="text-3xl font-bold text-primary mt-2">12</p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-medium text-gray-900">Clientes</h3>
            <p className="text-3xl font-bold text-accent mt-2">8</p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-medium text-gray-900">Receita Mensal</h3>
            <p className="text-3xl font-bold text-success mt-2">R$ 45.000</p>
          </div>
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-medium text-gray-900">Reuniões Hoje</h3>
            <p className="text-3xl font-bold text-warning mt-2">3</p>
          </div>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Recent Projects */}
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Projetos Recentes</h3>
            <div className="space-y-3">
              <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                <div>
                  <p className="font-medium">Casa Moderna Santos</p>
                  <p className="text-sm text-gray-500">Cliente: João Silva</p>
                </div>
                <span className="px-2 py-1 text-xs font-medium bg-green-100 text-green-800 rounded">
                  Em Progresso
                </span>
              </div>
              <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                <div>
                  <p className="font-medium">Escritório Corporativo</p>
                  <p className="text-sm text-gray-500">Cliente: Tech Corp</p>
                </div>
                <span className="px-2 py-1 text-xs font-medium bg-blue-100 text-blue-800 rounded">
                  Planejamento
                </span>
              </div>
            </div>
          </div>

          {/* Upcoming Meetings */}
          <div className="bg-white p-6 rounded-lg shadow">
            <h3 className="text-lg font-medium text-gray-900 mb-4">Próximas Reuniões</h3>
            <div className="space-y-3">
              <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                <div>
                  <p className="font-medium">Apresentação Projeto</p>
                  <p className="text-sm text-gray-500">Hoje, 14:00</p>
                </div>
                <span className="text-primary">📅</span>
              </div>
              <div className="flex justify-between items-center p-3 bg-gray-50 rounded">
                <div>
                  <p className="font-medium">Revisão Planta</p>
                  <p className="text-sm text-gray-500">Amanhã, 10:00</p>
                </div>
                <span className="text-primary">📅</span>
              </div>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Dashboard;