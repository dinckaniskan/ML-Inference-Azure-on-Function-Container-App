
from transformers import PegasusForConditionalGeneration, PegasusTokenizer, pipeline

model = None
tokenizer = None

try:
    model = PegasusForConditionalGeneration.from_pretrained("google/pegasus-xsum")
    tokenizer = PegasusTokenizer.from_pretrained("google/pegasus-xsum")

    model.save_pretrained("/home/site/wwwroot/model_store/pegasus-xsum")
    tokenizer.save_pretrained("/home/site/wwwroot/model_store/pegasus-xsum")

except Exception as e:
    raise Exception(f'ERROR LOADING model AND tokenizer: {str(e)}')
