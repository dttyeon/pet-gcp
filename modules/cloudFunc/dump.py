# main.py
import functions_framework
from googleapiclient import discovery
from google.auth import default

@functions_framework.http
def export_sql(request):
    """
    HTTP 요청을 받아 Cloud SQL 데이터베이스를 Cloud Storage로 내보내는 함수.
    """
    try:
        # 인증 정보 및 프로젝트 ID 가져오기
        credentials, project = default()
        service = discovery.build('sqladmin', 'v1', credentials=credentials)

        # Cloud SQL 인스턴스 ID, Cloud Storage 버킷 이름, 데이터베이스 이름 설정
        # TODO: 실제 환경에 맞게 이 값들을 변경하세요.
        instance_id = 'ayvet-dev-mysql'  # Cloud SQL 인스턴스 ID
        bucket = 'ayvet-dev-gcs-bu'      # Cloud Storage 버킷 이름
        db = 'petclinic'                 # 내보낼 데이터베이스 이름

        # 내보내기 요청 본문 생성
        body = {
            "exportContext": {
                "fileType": "SQL",
                "uri": f"gs://{bucket}/db_backup.sql.gz", # 내보낼 파일 경로 (GCS 버킷 내)
                "databases": [db]
            }
        }

        print(f"Attempting to export database '{db}' from instance '{instance_id}' to 'gs://{bucket}/db_backup.sql.gz' in project '{project}'...")

        # Cloud SQL Export API 호출
        response = service.instances().export(
            project=project,
            instance=instance_id,
            body=body
        ).execute()

        print(f"Export operation initiated successfully. Response: {response}")
        return f"Export started: {response}"

    except Exception as e:
        print(f"An error occurred: {e}")
        # 오류 발생 시 HTTP 500 응답 반환
        return f"Error during export: {e}", 500