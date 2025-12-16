# 아테나 특정DB만 접근허용하기

## IAM User에게 "특정 아테나 DB 및 테이블"에 접근권한 부여하기

- 아래와 같이 커스텀 권한 정책 생성하여 IAM user에 등록한다.
- 해당 IAM user의 액세스키 생성 후 다른 사람에게 주면, 그 사람이 액세스키를 통해서 특정 아테나DB에 접근가능해진다.
- 예시의 권한 정책은 다음 경우도 고려하여 작성한 것이다.
  - Athena의 실제 데이터가 S3에 있는 경우, S3 읽기 권한 필요
  - Athena 쿼리 기록을 S3에 저장하는 경우, 해당 S3 쓰기 권한 필요
  - 가급적 전체 버킷, 전체 DB 접근권한 등은 제한해야하지만, 특정 권한들은 세분화해서 설정할 수 없는 경우가 있음

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "athena:StartQueryExecution",
                "athena:GetQueryExecution",
                "athena:GetQueryResults",
                "athena:GetTableMetadata",
                "athena:GetQueryResultsStream",
                "athena:GetDatabase",
                "athena:GetDataCatalog",
                "athena:GetNamedQuery",
                "athena:ListTagsForResource",
                "athena:ListQueryExecutions",
                "athena:ListNamedQueries",
                "athena:GetWorkGroup",
                "athena:ListDatabases",
                "athena:StopQueryExecution",
                "athena:BatchGetNamedQuery",
                "athena:ListTableMetadata",
                "athena:BatchGetQueryExecution",
                "athena:ListDataCatalogs"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload",
                "s3:GetBucketLocation",
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::aws-athena-query-results-0000my-account-id0000-ap-northeast-2",
                "arn:aws:s3:::aws-athena-query-results-0000my-account-id0000-ap-northeast-2/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts",
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::my-bucket",
                "arn:aws:s3:::my-bucket/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "glue:Get*",
                "glue:List*"
            ],
            "Resource": [
                "arn:aws:glue:ap-northeast-2:0000my-account-id0000:database/my_db_name",
                "arn:aws:glue:ap-northeast-2:0000my-account-id0000:database/my_db_name2",
                "arn:aws:glue:ap-northeast-2:0000my-account-id0000:table/my_db_name/*",
                "arn:aws:glue:ap-northeast-2:0000my-account-id0000:table/my_db_name2/*",
                "arn:aws:glue:ap-northeast-2:0000my-account-id0000:catalog"
            ]
        }
    ]
}
```