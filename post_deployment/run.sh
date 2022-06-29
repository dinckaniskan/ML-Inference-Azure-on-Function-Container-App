
mkdir /home/site/wwwroot/model_store

python /post_deployment/download_model.py

export TRANSFORMERS_OFFLINE=1 \
       HF_DATASETS_OFFLINE=1
