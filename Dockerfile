# To enable ssh & remote debugging on app service change the base image to the one below
FROM mcr.microsoft.com/azure-functions/python:3.0-python3.9-appservice
# FROM mcr.microsoft.com/azure-functions/python:3.0-python3.9

ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

COPY requirements.txt /
RUN pip install -r /requirements.txt

COPY ./app/ /home/site/wwwroot
COPY ./post_deployment /post_deployment 
RUN ["chmod", "+x", "/post_deployment/run.sh"]

RUN /post_deployment/run.sh