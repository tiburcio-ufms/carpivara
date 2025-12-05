#!/bin/bash

# Script para configurar variáveis de ambiente nas plataformas nativas
# Execute este script após criar o arquivo .env

if [ ! -f .env ]; then
    echo "Erro: Arquivo .env não encontrado!"
    echo "Por favor, copie o arquivo .env.example para .env e configure suas chaves de API."
    exit 1
fi

# Carrega variáveis do .env
source .env

# Atualiza AndroidManifest.xml
if [ -f android/app/src/main/AndroidManifest.xml ]; then
    # Substitui o placeholder pela API key real
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/\${GOOGLE_MAPS_API_KEY}/$GOOGLE_MAPS_API_KEY/g" android/app/src/main/AndroidManifest.xml
    else
        # Linux
        sed -i "s/\${GOOGLE_MAPS_API_KEY}/$GOOGLE_MAPS_API_KEY/g" android/app/src/main/AndroidManifest.xml
    fi
    echo "✓ AndroidManifest.xml atualizado"
fi

# Exporta variáveis de ambiente para o build do Android (caso necessário)
export GOOGLE_MAPS_API_KEY

# Atualiza AppDelegate.swift
if [ -f ios/Runner/AppDelegate.swift ]; then
    # Substitui o placeholder pela API key real
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/YOUR_API_KEY_HERE/$GOOGLE_MAPS_API_KEY/g" ios/Runner/AppDelegate.swift
    else
        # Linux
        sed -i "s/YOUR_API_KEY_HERE/$GOOGLE_MAPS_API_KEY/g" ios/Runner/AppDelegate.swift
    fi
    echo "✓ AppDelegate.swift atualizado"
fi

echo "✓ Configuração concluída!"

