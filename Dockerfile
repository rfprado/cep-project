FROM python:3.6
ENV DJANGO_SETTINGS_MODULE settings

#####################################
## ATUALIZAÇÃO DOS PACOTES DO LINUX #
#####################################

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

#############################
## DEFINIÇÃO DOS DIRETÓRIOS #
#############################

RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ADD . /app
ADD ./src/ /app 

################################################
## CÓPIA DOS ARQUIVOS PARA DENTRO DO CONTAINER #
################################################

COPY requirements.txt ./
COPY ./src/manage.py ./
COPY ./src/settings.py ./
RUN python manage.py migrate djangocms_modules 


####################################################
## INSTALAÇÃO DO DJANGO, MÓDULOS E DEMAIS FEATURES #
####################################################

RUN pip install -r requirements.txt
RUN pip install pipenv
RUN pipenv install psycopg2-binary
RUN pip install djangocms-modules
RUN pip install --no-cache-dir djangocms-installer
RUN mkdir /usr/src/app/mysite
WORKDIR /usr/src/app/mysite
#RUN python manage.py migrate djangocms_modules 
#RUN python manage.py loaddata data.json


#########################################################
## DEFINIÇÃO DAS PORTAS EXPOSTAS E DEMAIS CONFIGURAÇÕES #
#########################################################

EXPOSE 8000
#RUN python manage.py migrate djangocms_modules 
#RUN python manage.py loaddata data.json

CMD djangocms -f -p . mysite
CMD python manage.py runserver 0.0.0.0:8000
