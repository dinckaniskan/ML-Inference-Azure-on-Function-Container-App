import logging
import os
import pickle
import azure.functions as func
import json
import glob
from transformers import PegasusForConditionalGeneration, PegasusTokenizer, pipeline
from .pegasus_model import model, tokenizer


def main(req: func.HttpRequest) -> func.HttpResponse:
    global tokenizer, model

    logging.info('Python HTTP trigger function processed a request.')
    
    if model != None and tokenizer != None:

        # get request body and run model inference
        try:
            input_text = None

            req_body = req.get_json()
            input_text = req_body['text']
            min_length = int(req_body['min_length'])
            max_length = int(req_body['max_length'])

            if input_text is not None:
            
                tokens = tokenizer(input_text, truncation=True, padding="longest", return_tensors="pt")

                summary = model.generate(**tokens, min_length=min_length, max_length=max_length)

                summary_result = tokenizer.decode(summary[0])

                result = {
                    'summary': summary_result
                }

                return func.HttpResponse(json.dumps(result), status_code=200)

            else:
                return func.HttpResponse(json.dumps({ 'error': 'Bad input' }), status_code=500)
                
        except Exception as e:
            return func.HttpResponse(json.dumps({ 'error': str(e) }), status_code=500)
    else:
        return func.HttpResponse(json.dumps({ 'error': 'model or tokenizer is None.' }), status_code=500)