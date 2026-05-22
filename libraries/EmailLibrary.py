import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from robot.api.deco import keyword    # 👈 importar o decorator

class EmailLibrary:

    @keyword("Montar Corpo Anuncios")
    def montar_corpo_anuncios(self, anuncios: dict) -> str:
        """Recebe o dicionário {href: title} e monta um HTML formatado."""

        if not anuncios:
            return "<p>Nenhum anúncio encontrado.</p>"

        linhas = ""
        for i, (href, title) in enumerate(anuncios.items(), start=1):
            linhas += f"""
                <tr>
                    <td style="padding:8px; border:1px solid #ddd;">{i}</td>
                    <td style="padding:8px; border:1px solid #ddd;">{title}</td>
                    <td style="padding:8px; border:1px solid #ddd;">
                        <a href="{href}" target="_blank">Ver anúncio</a>
                    </td>
                </tr>
            """

        return f"""
            <html><body>
                <h2>🏠 Imóveis encontrados na OLX</h2>
                <p>Total de anúncios encontrados: <strong>{len(anuncios)}</strong></p>
                <table style="border-collapse:collapse; width:100%;">
                    <thead>
                        <tr style="background:#f2f2f2;">
                            <th style="padding:8px; border:1px solid #ddd;">#</th>
                            <th style="padding:8px; border:1px solid #ddd;">Título</th>
                            <th style="padding:8px; border:1px solid #ddd;">Link</th>
                        </tr>
                    </thead>
                    <tbody>
                        {linhas}
                    </tbody>
                </table>
                <br>
                <p style="color:gray; font-size:12px;">Enviado automaticamente pelo Robot Framework.</p>
            </body></html>
        """

    @keyword("Enviar Email Gmail")
    def enviar_email_gmail(self, remetente, senha, destinatario, assunto, corpo):
        """Envia um email HTML via Gmail usando SMTP."""

        msg = MIMEMultipart("alternative")
        msg["Subject"] = assunto
        msg["From"]    = remetente
        msg["To"]      = destinatario

        msg.attach(MIMEText(corpo, "html"))

        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.ehlo()
            server.starttls()
            server.login(remetente, senha)
            server.sendmail(remetente, destinatario, msg.as_string())

        print(f"✅ Email enviado com sucesso para {destinatario}")