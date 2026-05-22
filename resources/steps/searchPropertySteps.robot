*** Settings ***
Resource    ../pages/searchPropertyPage.robot

*** Variables ***
# Preenchido em runtime
${anuncios validos}                        none

*** Keywords ***
Dado que sou o usuário e procuro por imóveis em Florianópolis-SC
    Ir para página de imóveis com os filtros aplicados

Quando coleto os anúncios da página de hoje
    ${anuncios validos}=                   Filtra os anúncios na data de hoje
    Set Suite Variable                     ${anuncios validos}

E verifico os anúncios coletados para garantir que são relevantes
    ${anuncios validos}=                   Seleciona os anúncios válidos    ${anuncios validos}
    Set Suite Variable                     ${anuncios validos}

Então envio os anúncios coletados para meu Email
    Enviar email com os dados coletados    ${anuncios validos}

    
