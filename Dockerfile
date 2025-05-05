FROM mcr.microsoft.com/mssql/server:2019-latest

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=YourStrong!Passw0rd
ENV DEBIAN_FRONTEND=noninteractive

USER root

# Install prerequisites and mssql-tools
RUN apt-get update && \
    apt-get install -y curl gnupg apt-transport-https software-properties-common && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev && \
    ln -s /opt/mssql-tools/bin/* /usr/bin/ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER mssql

COPY ./backup /var/opt/mssql/backup
COPY ./restore.sh /usr/src/app/restore.sh

CMD ["/bin/bash", "/usr/src/app/restore.sh"]