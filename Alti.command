#!/bin/bash
# Wrapper automático - Gerado automaticamente

# Vai para a pasta do script
cd "$(dirname "$0")"

echo "🐍 Executando script Python"
echo "📁 Pasta: $(pwd)"
echo ""

# Lista arquivos para debug
echo "🔍 Verificando arquivos na pasta:"
ls -la | grep -E "(venv|\.venv|env|\.py)"
echo ""

# Procura e ativa ambiente virtual
VENV_ATIVADO=false

for venv_name in venv .venv env virtualenv; do
    if [ -d "$venv_name" ]; then
        echo "🔄 Tentando ativar ambiente virtual: $venv_name"
        
        if [ -f "$venv_name/bin/activate" ]; then
            source "$venv_name/bin/activate"
            echo "✅ Ambiente virtual $venv_name ativado"
            VENV_ATIVADO=true
            break
        else
            echo "❌ Arquivo activate não encontrado em $venv_name/bin/"
        fi
    fi
done

if [ "$VENV_ATIVADO" = false ]; then
    echo "❌ Nenhum ambiente virtual encontrado ou ativado!"
    echo "Tentando executar com Python do sistema..."
fi

echo ""

# Detecta qual comando Python usar
PYTHON_CMD=""
if command -v python >/dev/null 2>&1; then
    PYTHON_CMD="python"
    echo "✅ Usando: python ($(python --version))"
elif command -v python3 >/dev/null 2>&1; then
    PYTHON_CMD="python3"
    echo "✅ Usando: python3 ($(python3 --version))"
else
    echo "❌ Nenhum comando Python encontrado!"
    echo "Comandos testados: python, python3"
    echo ""
    echo "🔧 Possíveis soluções:"
    echo "1. Instale Python: brew install python"
    echo "2. Verifique se o venv foi criado corretamente"
    echo "3. Recrie o ambiente virtual: python3 -m venv venv"
    echo ""
    echo "Pressione Enter para fechar..."
    read
    exit 1
fi

# Encontra o arquivo Python para executar
SCRIPT_PY=""
for py_file in *.py; do
    if [ -f "$py_file" ]; then
        SCRIPT_PY="$py_file"
        break
    fi
done

if [ -z "$SCRIPT_PY" ]; then
    echo "❌ Nenhum arquivo .py encontrado na pasta!"
    echo "Pressione Enter para fechar..."
    read
    exit 1
fi

echo "📄 Arquivo a executar: $SCRIPT_PY"
echo ""

# Executa o script Python
echo "▶️  Iniciando execução..."
echo "----------------------------------------"
$PYTHON_CMD "$SCRIPT_PY"
exit_code=$?
echo "----------------------------------------"
echo ""

# Mostra informações finais
if [ $exit_code -eq 0 ]; then
    echo "✅ Script executado com sucesso!"
else
    echo "❌ Script terminou com erro (código: $exit_code)"
fi

echo ""
echo "🏁 Execução finalizada."
echo "💡 Pressione Enter para fechar esta janela..."
read
