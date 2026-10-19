
FROM swipl:latest

WORKDIR /app

COPY sistema_experto.pl ./
COPY server.pl ./

EXPOSE 10000

CMD ["swipl", "-q", "-s", "server.pl", "-g", "iniciar_servidor,thread_get_message(_)"]
