import runpod
import asyncio
import aiohttp
import requests
import json
import time
import os

# ---------------------------------------------------------------------------- #
#                               Functions                                      #
# ---------------------------------------------------------------------------- #

def wait_for_service(url, max_retries=1000, delay=0.2):
    retries = 0
    while retries < max_retries:
        try:
            requests.get(url)
            return
        except requests.exceptions.RequestException:
            print("Service not ready yet. Retrying...")
        except Exception as err:
            print("Error: ", err)
        time.sleep(delay)
        retries += 1
    raise Exception("Service not available after max retries.")

async def stream_response(job):
    config = {
        "baseurl": "http://127.0.0.1:4444",
        "baseFuncUrl": "http://127.0.0.1:4447",
        "api": {
            "completions": ("POST", "/v1/completions"),
            "chat_completions": ("POST", "/v1/chat/completions")
        },
        "timeout": 300
    }

    api_name = job["input"].get("api_name")
    if api_name in config["api"]:
        api_verb, api_path = config["api"][api_name]
    else:
        raise Exception(f"Method '{api_name}' not yet implemented")

    url = f'{config["baseurl"]}{api_path}'
    params = job["input"].get("params", {})
    isStream = params.get("stream", False)
    useFuncModel = params.get("useFuncModel", False)
    if useFuncModel:
        url = f'{config["baseFuncUrl"]}{api_path}'

    async with aiohttp.ClientSession() as session:
        try:
            async with session.post(url, json=params, timeout=config["timeout"]) as response:
                if response.status != 200:
                    yield {"error": await response.text()}
                    return

                content_type = response.headers.get('Content-Type', '')

                if not isStream or 'application/json' in content_type:
                    yield await response.json()
                    return

                async for line in response.content:
                    decoded_line = line.decode('utf-8').strip()
                    if decoded_line.startswith("data: "):
                        yield f"{decoded_line}\n\n"
                    elif decoded_line == "data: [DONE]":
                        yield "data: [DONE]\n\n"
                        break

        except aiohttp.ClientError as e:
            yield {"error": str(e)}
            return


# ---------------------------------------------------------------------------- #
#                                RunPod Handler                                #
# ---------------------------------------------------------------------------- #
async def async_generator_handler(job):
    async for output in stream_response(job):
        yield output

def concurrency_modifier(currenct_concurrency):
    max_concurrency = os.getenv('MAX_CONCURRENCY', 10)
    return int(max_concurrency)

if __name__ == "__main__":
    try:
        wait_for_service(url='http://127.0.0.1:4447/v1/completions')
    except Exception as e:
        print("Service failed to start:", str(e))
        exit(1)

    print("Aphrodite Engine API Service is ready. Starting RunPod...")

    runpod.serverless.start(
        {
            "handler": async_generator_handler,
            "concurrency_modifier": concurrency_modifier,
            "return_aggregate_stream": True,
        }
    )
