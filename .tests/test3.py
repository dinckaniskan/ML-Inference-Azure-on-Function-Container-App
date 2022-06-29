import logging
import os
import pickle
# import azure.functions as func
import json
import glob
from transformers import AutoTokenizer, AutoModelForSeq2SeqLM, AutoModel


def getModel():

    tokenizer = AutoTokenizer.from_pretrained("google/pegasus-xsum")
    model = AutoModelForSeq2SeqLM.from_pretrained("google/pegasus-xsum")

    tokenizer.save_pretrained("./model_store/pegasus-xsum")
    model.save_pretrained("./model_store/pegasus-xsum")


    files = glob.glob('./model_store/pegasus-xsum/*.*', recursive=True)

    if len(files) == 0:
        getModel()


    tokenizer = AutoTokenizer.from_pretrained("./model_store/pegasus-xsum")
    model = AutoModel.from_pretrained("./model_store/pegasus-xsum")


getModel()