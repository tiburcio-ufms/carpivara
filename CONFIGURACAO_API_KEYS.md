# 🔐 Configuração de API Keys

Este guia explica como configurar as API keys do projeto de forma segura, evitando que sejam commitadas no repositório.

## 📋 Pré-requisitos

1. Ter uma conta no [Google Cloud Console](https://console.cloud.google.com/)
2. Ter criado um projeto no Google Cloud
3. Ter habilitado as seguintes APIs:
   - Google Maps SDK for Android
   - Google Maps SDK for iOS
   - Places API
   - Directions API

## 🔑 Obtendo as API Keys

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Selecione seu projeto
3. Vá em **APIs & Services** > **Credentials**
4. Clique em **Create Credentials** > **API Key**
5. Copie a chave gerada
6. (Recomendado) Configure restrições de aplicativo para maior segurança

## ⚙️ Configuração

### Passo 1: Criar o arquivo .env

Copie o arquivo de exemplo e configure suas chaves:

```bash
cp .env.example .env
```

### Passo 2: Editar o arquivo .env

Abra o arquivo `.env` e substitua os valores:

```env
GOOGLE_MAPS_API_KEY=sua_chave_aqui
GOOGLE_PLACES_API_KEY=sua_chave_aqui
API_BASE_URL=http://localhost:3000
```

**Nota:** Se você usar a mesma chave para Maps e Places, pode deixar `GOOGLE_PLACES_API_KEY` vazio ou usar a mesma chave.

### Passo 3: Configurar plataformas nativas

Para Android e iOS, você precisa atualizar os arquivos nativos. Execute o script:

```bash
./scripts/setup_env.sh
```

Ou configure manualmente:

#### Android

Edite `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data 
    android:name="com.google.android.geo.API_KEY" 
    android:value="SUA_CHAVE_AQUI"/>
```

#### iOS

Edite `ios/Runner/AppDelegate.swift`:

```swift
GMSServices.provideAPIKey("SUA_CHAVE_AQUI")
```

### Passo 4: Instalar dependências

```bash
flutter pub get
```

### Passo 5: Executar o app

```bash
flutter run
```

## 🔒 Segurança

### ✅ O que está protegido:

- O arquivo `.env` está no `.gitignore` e **não será commitado**
- As chaves não aparecem mais no código fonte
- O arquivo `.env.example` serve como template sem valores reais

### ⚠️ Importante:

1. **Nunca** commite o arquivo `.env` no repositório
2. **Nunca** compartilhe suas API keys publicamente
3. Configure **restrições de aplicativo** nas chaves do Google Cloud
4. Use chaves diferentes para desenvolvimento e produção
5. Rotacione as chaves periodicamente

## 🚨 Troubleshooting

### Erro: "API key not found"

- Verifique se o arquivo `.env` existe na raiz do projeto
- Verifique se o arquivo `.env` está listado em `pubspec.yaml` na seção `assets`
- Certifique-se de que executou `flutter pub get` após adicionar o `.env`

### Erro: "Invalid API key"

- Verifique se a chave está correta no arquivo `.env`
- Verifique se as APIs necessárias estão habilitadas no Google Cloud Console
- Verifique se as restrições de aplicativo não estão bloqueando seu app

### Maps não aparecem no Android/iOS

- Verifique se atualizou o `AndroidManifest.xml` (Android)
- Verifique se atualizou o `AppDelegate.swift` (iOS)
- Execute `flutter clean` e `flutter pub get`
- Rebuild o app completamente

## 📝 Notas Adicionais

- O arquivo `.env.example` deve ser commitado no repositório como template
- Cada desenvolvedor deve criar seu próprio arquivo `.env` localmente
- Em CI/CD, configure as variáveis de ambiente diretamente na plataforma

