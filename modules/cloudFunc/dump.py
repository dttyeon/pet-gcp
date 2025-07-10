# main.py
import os
import functions_framework
from googleapiclient import discovery
from google.auth import default
from google.auth.transport.requests import Request


@functions_framework.http
def export_sql(request):
    """
    HTTP 요청을 받아 Cloud SQL 데이터베이스를 Cloud Storage로 내보내는 함수.
    """
    try:
        # 인증 정보 및 프로젝트 ID 가져오기
        credentials, project = default()
        credentials.refresh(Request())

        # Cloud SQL 인스턴스 ID, Cloud Storage 버킷 이름, 데이터베이스 이름 설정
        instance_id = os.environ.get('INSTANCE_ID')
        bucket = os.environ.get('EXPORT_BUCKET')
        db = os.environ.get('DATABASE_NAME')

        if not all([instance_id, bucket, db]):
            raise ValueError("환경변수 설정 누락: INSTANCE_ID, EXPORT_BUCKET, DATABASE_NAME 모두 필요합니다.")

        # 내보내기 요청 본문 생성
        body = {
            "exportContext": {
                "fileType": "SQL",
                "uri": f"gs://{bucket}/db_backup.sql.gz",
                "databases": [db]
            }
        }

        print(f"Attempting to export database '{db}' from instance '{instance_id}' to 'gs://{bucket}/db_backup.sql.gz' in project '{project}'...")

        # Cloud SQL Admin API 호출
        service = discovery.build('sqladmin', 'v1', credentials=credentials)
        response = service.instances().export(
            project=project,
            instance=instance_id,
            body=body
        ).execute()

        print(f"Export operation initiated successfully. Response: {response}")
        return f"Export started: {response}"

    except Exception as e:
        print(f"An error occurred: {e}")
        return f"Error during export: {e}", 500
