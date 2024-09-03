import os
import logging
import random

logger = logging.getLogger()
logger.setLevel(logging.INFO)

if not logger.hasHandlers():
    handler = logging.StreamHandler()
    handler.setLevel(logging.INFO)
    formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    logger.addHandler(handler)

seed = os.environ.get("SEED", "1234")
try:
    seed = int(seed)
except ValueError:
    logger.error("SEED environment variable is not a valid integer")
    seed = 1234

random.seed(seed)

def handler(event, context):
    logger.info("Received processing event: %r", event)
    return {
        "price": random.randint(1, 10000),
    }
