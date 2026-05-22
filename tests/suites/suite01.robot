*** Settings ***
Resource   ../features/searchProperty.robot

Suite Setup       Abrir Navegador
Suite Teardown    Fechar Navegador

*** Test Cases ***
CENÁRIO - Consulta de Imóveis em Florianópolis-SC
    Consulta de Imóveis - 2 Quartos
    