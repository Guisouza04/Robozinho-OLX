*** Settings ***
Resource    ../../resources/steps/searchPropertySteps.robot

*** Keywords ***
Consulta de Imóveis - 2 Quartos
    Dado que sou o usuário e procuro por imóveis em Florianópolis-SC
    Quando coleto os anúncios da página de hoje
    E verifico os anúncios coletados para garantir que são relevantes 
    Então envio os anúncios coletados para meu Email

    