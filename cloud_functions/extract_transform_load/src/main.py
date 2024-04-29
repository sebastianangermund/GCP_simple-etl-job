import functions_framework
import requests
import json
import os

from google.cloud import storage
from google.cloud import bigquery


@functions_framework.http
def main(request):
    # event = request.get_json(silent=True)

    storage_client = storage.Client()
    bucket = storage_client.get_bucket(os.getenv('JSON_SCHEMA_BUCKET'))
    blob = bucket.blob(os.getenv('JSON_SCHEMA_PATH'))
    contents = blob.download_as_string()
    data_schema = json.loads(contents.decode("utf-8").strip())

    data_api_endpoint = os.getenv('API_ENDPOINT')
    r = requests.get(data_api_endpoint)
    data_dicts = r.json()
    prepared = []
    for data_dict in data_dicts:
        prepared.append({key: value for key, value in data_dict.items() if key in data_schema['properties'].keys()})

    table = f'{os.getenv("DATASET_NAME")}.{os.getenv("TABLE_NAME")}'

    bq_client = bigquery.Client()
    bq_client.insert_rows_json(table=table, json_rows=prepared)

    return 'OK'
