*** Variables ***
${URL_BASE}                https://www.olx.com.br
${URL_BASE_IMOVEIS}        ${URL_BASE}/imoveis/aluguel/${QUARTOS}-quartos/estado-${UF_ESTADO}
${DEFAULT_TIMEOUT}         60s

# Localizações
${ESTADO}                  Santa Catarina
${UF_ESTADO}               sc
${CIDADE}                  florianopolis-e-regiao
${REGIÃO}                  norte
${BAIRRO}                  ingleses-do-rio-vermelho

# Preços
${PREÇO_MIN}               1000
${PREÇO_MAX}               2000

#Quartos
${QUARTOS}                 2

# Variáveis para email
${EMAIL_REMETENTE}         guilhermeguaitasouza@gmail.com
${EMAIL_DESTINATARIO}      guilhermeguaitasiuza@gmail.com 

# Declarar variável em tempo de execução
${EMAIL_SENHA}             %{GMAIL_SENHA}
