let "uniqueid=$RANDOM*$RANDOM"

export RG=industry$uniqueid \
       REGION=australiaeast \
       CONTAINER_REGISTRY_NAME=summarizeracr$uniqueid \
       STORAGE_ACCOUNT_NAME=summarizer$uniqueid \
       APP_SERVICE_PLAN_NAME=summarizer-app-plan-$uniqueid \
       APP_SERVICE_PLAN_SKU=P3V2 \
       FUNCTION_APP_NAME=summarizer-$uniqueid \
       IMAGE_NAME=summarizer \
       CONTAINER_REGISTRY_REF=$CONTAINER_REGISTRY_NAME.azurecr.io/$IMAGE_NAME


echo "Create Azure Resource Group: $RG"
az group create --name $RG --location $REGION


echo "Create Azure Container Registry: $CONTAINER_REGISTRY_NAME"
az acr create --resource-group $RG --location $REGION --name $CONTAINER_REGISTRY_NAME --sku Basic --admin-enabled true
export CONTAINER_REGISTRY_USERNAME=$(az acr credential show --name=$CONTAINER_REGISTRY_NAME --resource-group $RG --query username --output tsv)
export CONTAINER_REGISTRY_PASSWORD=$(az acr credential show --name=$CONTAINER_REGISTRY_NAME --resource-group $RG --query passwords[0].value --output tsv)


echo "Azure Container Registry Login"
az acr login --name $CONTAINER_REGISTRY_NAME --resource-group $RG --username $CONTAINER_REGISTRY_USERNAME --password $CONTAINER_REGISTRY_PASSWORD


echo "Azure ACR Build & Push Container Image"
az acr build --registry $CONTAINER_REGISTRY_NAME --image $IMAGE_NAME .


echo "Create Storage Account: $STORAGE_ACCOUNT_NAME"
az storage account create --name $STORAGE_ACCOUNT_NAME --location $REGION --resource-group $RG --sku Standard_LRS
export CONNECTION_STRING=$(az storage account show-connection-string --resource-group $RG --name $STORAGE_ACCOUNT_NAME --query connectionString --output tsv)


echo "Create App Service Plan: $APP_SERVICE_PLAN_NAME"
az functionapp plan create --resource-group $RG --name $APP_SERVICE_PLAN_NAME --location $REGION --number-of-workers 1 --sku $APP_SERVICE_PLAN_SKU --is-linux


echo "Create Function App: $FUNCTION_APP_NAME"
az functionapp create --name $FUNCTION_APP_NAME --storage-account $STORAGE_ACCOUNT_NAME --resource-group $RG --plan $APP_SERVICE_PLAN_NAME --deployment-container-image-name $CONTAINER_REFERENCE
az functionapp config appsettings set --name $FUNCTION_APP_NAME --resource-group $RG --settings AzureWebJobsStorage=$CONNECTION_STRING