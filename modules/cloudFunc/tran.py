import os
import boto3
from google.cloud import storage

def transfer_to_s3(event, context):
    bucket_name = event['bucket']
    file_name = event['name']

    # GCS → 임시 디렉토리 다운로드
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(file_name)
    local_path = f'/tmp/{file_name.split("/")[-1]}'
    blob.download_to_filename(local_path)

    # S3 업로드
    s3 = boto3.client(
        's3',
        aws_access_key_id=os.environ['AWS_ACCESS_KEY_ID'],
        aws_secret_access_key=os.environ['AWS_SECRET_ACCESS_KEY'],
        region_name=os.environ['AWS_REGION']
    )
    s3.upload_file(local_path, os.environ['S3_BUCKET'], file_name)
    print(f'Successfully transferred {file_name} from GCS to S3.')
