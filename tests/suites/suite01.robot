*** Settings ***
Resource   ../features/searchProperty.robot

Suite Setup       Abrir Navegador
Suite Teardown    Fechar Navegador
Test Teardown     Run Keyword If Test Failed    Capturar screenshot de diagnóstico

*** Test Cases ***
CENÁRIO - Consulta de Imóveis em Florianópolis-SC
    Consulta de Imóveis - 2 Quartos
    