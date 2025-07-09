import os
import json
import boto3
from google.cloud import storage, secretmanager

def get_secret(secret_id, project_id):
    client = secretmanager.SecretManagerServiceClient()
    name = f"projects/{project_id}/secrets/{secret_id}/versions/latest"
    response = client.access_secret_version(request={"name": name})
    return json.loads(response.payload.data.decode("UTF-8"))

def transfer_to_s3(event, context):
    bucket_name = event['bucket']
    file_name = event['name']

    # GCS → 임시 디렉토리 다운로드
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    local_path = f'/tmp/{file_name.split("/")[-1]}'
    blob.download_to_filename(local_path)

    # Secret Manager에서 AWS Credentials 가져오기
    secret_id = os.environ.get('SECRET_ID')
    project_id = os.environ.get('GCP_PROJECT')  # Cloud Function에서 자동 설정됨
    secrets = get_secret(secret_id, project_id)

    # S3 업로드
    s3 = boto3.client(
        's3',
        aws_access_key_id=secrets['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key=secrets['AWS_SECRET_ACCESS_KEY'],
        region_name=secrets['AWS_REGION']
    )
    s3.upload_file(local_path, secrets['S3_BUCKET'], file_name)
    print(f'Successfully transferred {file_name} from GCS to S3.')
