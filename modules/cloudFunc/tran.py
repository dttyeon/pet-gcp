import os
import json
import boto3
from google.cloud import storage, secretmanager

def get_secret(secret_id):
    project_id = os.environ["GOOGLE_CLOUD_PROJECT"]
    name = f"projects/{project_id}/secrets/{secret_id}/versions/latest"

    client = secretmanager.SecretManagerServiceClient()
    response = client.access_secret_version(request={"name": name})
    return response.payload.data.decode("UTF-8")


def transfer_to_s3(request):
    data = request.get_json()
    bucket_name = data["bucket"]
    file_name = data["name"]

    # GCS → 임시 다운로드
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    local_path = f"/tmp/{file_name.split('/')[-1]}"
    blob.download_to_filename(local_path)

    # AWS Credentials 가져오기
    secret_id = os.environ["SECRET_ID"]
    secrets = get_secret(secret_id)

    # S3 업로드
    s3 = boto3.client(
        's3',
        aws_access_key_id=secrets['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key=secrets['AWS_SECRET_ACCESS_KEY'],
        region_name=secrets['AWS_REGION']
    )
    s3.upload_file(local_path, secrets['S3_BUCKET'], file_name)

    print(f"Transferred {file_name} from GCS to S3 successfully.")
    return "Success", 200