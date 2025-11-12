# Carpivara

Aplicativo de carona compartilhada desenvolvido em Flutter para facilitar o transporte entre estudantes universitários.

## 📋 Índice

- [Arquitetura](#-arquitetura)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Pré-requisitos](#-pré-requisitos)
- [Como Rodar o Projeto](#-como-rodar-o-projeto)
- [Testes](#-testes)
- [Tecnologias e Dependências](#-tecnologias-e-dependências)
- [Estrutura de Pastas](#-estrutura-de-pastas)

## 🏗️ Arquitetura

Este projeto utiliza uma arquitetura baseada no padrão **MVVM (Model-View-ViewModel)** combinado com o **Repository Pattern**, seguindo as melhores práticas recomendadas pela documentação oficial do Flutter.

### Padrão MVVM

O padrão MVVM separa a lógica de apresentação da lógica de negócio, facilitando a manutenção e testabilidade do código:

- **Model**: Representa os dados e a lógica de negócio da aplicação
- **View**: Interface do usuário (Widgets Flutter)
- **ViewModel**: Gerencia o estado da View e coordena com os repositórios

### Camadas da Arquitetura

#### 1. **Camada de Apresentação (Presentation Layer)**
- **Views**: Widgets Flutter que compõem a interface do usuário
- **ViewModels**: Classes que estendem `ChangeNotifier` para gerenciar o estado da UI
- **Factories**: Responsáveis por criar e injetar dependências nas Views e ViewModels

#### 2. **Camada de Domínio (Domain Layer)**
- **Models**: Entidades de dados (User, Ride, Address, etc.)
- **Protocols/Interfaces**: Contratos que definem os comportamentos esperados

#### 3. **Camada de Dados (Data Layer)**
- **Repositories**: Abstraem o acesso a dados, implementando o Repository Pattern
- **Services**: Serviços que fazem comunicação com APIs externas
- **Mocks**: Implementações mockadas para desenvolvimento e testes

### Princípios Aplicados

- **Separação de Responsabilidades**: Cada classe tem uma única responsabilidade
- **Inversão de Dependências**: Dependências são injetadas via construtor
- **Testabilidade**: ViewModels e Repositories podem ser facilmente testados com mocks
- **Reutilização**: Componentes podem ser reutilizados em diferentes contextos

### Dependency Injection

O projeto utiliza `get_it` para injeção de dependências através do `DependencyContainer`, facilitando o gerenciamento de instâncias e permitindo fácil substituição de implementações (ex: mocks em desenvolvimento, implementações reais em produção).

### Routing

A navegação é gerenciada pelo `go_router`, que oferece navegação declarativa e type-safe, com suporte a rotas nomeadas e passagem de parâmetros.

## 📁 Estrutura do Projeto

```
lib/
├── components/          # Componentes reutilizáveis
├── models/             # Modelos de dados
├── modules/            # Módulos da aplicação
│   ├── home/          # Tela inicial (passageiro/motorista)
│   ├── profile/       # Perfil do usuário
│   ├── ride/          # Funcionalidades de corrida
│   └── session/       # Autenticação
├── repositories/       # Repositórios (abstração de dados)
│   └── mocks/         # Implementações mockadas
├── services/          # Serviços (APIs, etc.)
└── support/           # Utilitários e configurações
    ├── dependencies/  # Container de dependências
    ├── styles/        # Estilos e temas
    ├── utils/         # Utilitários
    └── view/          # Classes base (ViewModel, View)
```

## 🔧 Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.9.2 ou superior)
- [Dart SDK](https://dart.dev/get-dart) (incluído com Flutter)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/) com extensões Flutter e Dart
- Emulador Android/iOS ou dispositivo físico para testes

### Verificando a Instalação

```bash
flutter doctor
```

Este comando verifica se todas as dependências estão instaladas corretamente.

## 🚀 Como Rodar o Projeto

### 1. Clone o repositório

```bash
git clone git@github.com:tiburcio-ufms/carpivara.git
cd carpivara
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Configure um dispositivo

#### Opção A: Emulador Android

1. Abra o Android Studio
2. Vá em `Tools` > `Device Manager`
3. Crie um novo emulador ou inicie um existente

#### Opção B: Dispositivo Físico

1. Conecte seu dispositivo via USB
2. Ative a **Depuração USB** nas opções de desenvolvedor
3. Autorize o computador no dispositivo

### 4. Verifique os dispositivos disponíveis

```bash
flutter devices
```

Você deve ver seu dispositivo ou emulador listado.

### 5. Execute o aplicativo

```bash
flutter run
```

O aplicativo será compilado e executado no dispositivo selecionado.

### Comandos Úteis

```bash
# Executar em modo release (otimizado)
flutter run --release

# Executar em modo debug com hot reload
flutter run --debug

# Limpar build anterior
flutter clean

# Atualizar dependências
flutter pub upgrade
```

## 🧪 Testes

O projeto possui uma suíte completa de testes unitários para todos os ViewModels.

### Executar todos os testes

```bash
flutter test
```

### Executar testes específicos

```bash
flutter test test/modules/session/sign_in/sign_in_view_model_test.dart
```

### Executar testes com cobertura

```bash
flutter test --coverage
```

### Estrutura de Testes

Os testes seguem o padrão **AAA (Arrange-Act-Assert)**:

- **Arrange**: Configuração do ambiente de teste (mocks, dados de teste)
- **Act**: Execução da ação a ser testada
- **Assert**: Verificação dos resultados esperados

Cada ViewModel possui seus próprios testes, utilizando mocks para isolar as dependências e garantir testabilidade.

## 📦 Tecnologias e Dependências

### Principais Dependências

- **flutter**: Framework principal
- **dio**: Cliente HTTP para requisições à API
- **get_it**: Injeção de dependências
- **go_router**: Gerenciamento de rotas
- **google_maps_flutter**: Integração com Google Maps
- **geolocator**: Serviços de localização
- **permission_handler**: Gerenciamento de permissões
- **flutter_secure_storage**: Armazenamento seguro de dados

### Dependências de Desenvolvimento

- **flutter_test**: Framework de testes
- **flutter_lints**: Regras de linting
- **mockito**: Criação de mocks para testes
- **build_runner**: Geração de código

## 📚 Estrutura de Pastas Detalhada

### `/lib/models`
Contém todas as entidades de dados da aplicação:
- `user.dart`: Modelo de usuário
- `ride.dart`: Modelo de corrida
- `address.dart`: Modelo de endereço
- `session.dart`: Modelo de sessão
- E outros modelos relacionados

### `/lib/modules`
Organizado por funcionalidades, cada módulo contém:
- `*_view.dart`: Interface do usuário
- `*_view_model.dart`: Lógica de apresentação
- `*_factory.dart`: Factory para criação de Views/ViewModels

### `/lib/repositories`
Implementa o Repository Pattern:
- Interfaces (Protocols) definem contratos
- Implementações concretas fazem chamadas aos serviços
- Mocks disponíveis para desenvolvimento e testes

### `/lib/services`
Serviços que fazem comunicação externa:
- `api_service.dart`: Comunicação com API REST
- `places_service.dart`: Integração com Google Places API

### `/lib/support`
Utilitários e configurações compartilhadas:
- `dependencies/`: Container de injeção de dependências
- `styles/`: Temas e estilos da aplicação
- `utils/`: Funções utilitárias
- `view/`: Classes base (ViewModel, View)

## 🔍 Exemplo de Fluxo de Dados

```
View (UI)
  ↓ (chama métodos)
ViewModel (lógica de apresentação)
  ↓ (chama métodos)
Repository (abstração de dados)
  ↓ (chama métodos)
Service (comunicação externa)
  ↓
API Externa / Banco de Dados
```

## 📖 Recursos Adicionais

- [Documentação Oficial do Flutter](https://docs.flutter.dev/)
- [Guia de Arquitetura Flutter](https://docs.flutter.dev/app-architecture)  
- [Repository Pattern](https://martinfowler.com/eaaCatalog/repository.html)

## 🤝 Contribuindo

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
