# AWS

편의상 AWS 관련 소소한 팁도 이 레포지토리에 기록한다.

## S3 버킷에 특정 액세스키로 접근하는 것을 허용하기

- IAM User 생성, Access Key 발급, 이후 IAM User에 S3 Full Access를 할당하면 쉽게 Access Key로 S3에 접근이 가능하다.
- 하지만, 이러면 보안이 떨어지므로 다음과 같은 방법을 이용한다. 

### "버킷에서" 특정 IAM User(Access Key) 허용하기

- 콘솔 S3의 특정버킷 웹페이지로가면, 상단쯤에 '권한' 탭-'버킷 정책' 으로 등록
- Principal.AWS는 버킷 입장에서 접근 허용할 대상 리소스의 arn을 기술하는 부분으로 IAM User, IAM Role 둘 다 기술 가능
- ARN(`arn:aws:iam::your-account-id:user/your-iam-user`)은 AWS 리소스를 식별하는 고윳값으로 대상 리소스에서 속성 값을 참조하면 확인 가능
- `Version` 섹션의 날짜는 고정 값이다. 당일날짜를 적는게 아니다.

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::your-account-id:user/your-iam-user"
            },
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::your-account-id:user/your-iam-user"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::your-bucket-name"
        }
    ]
}
```

### "IAM User가" 특정 버킷에 대한 읽기/쓰기 권한 가지도록 정책 설정

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket"],
      "Resource": ["arn:aws:s3:::TARGET_BUCKET"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Resource": ["arn:aws:s3:::TARGET_BUCKET/*"]
    }
  ]
}
```

## AWS 서비스끼리 액세스키 없이 권한 허용하기

### IAM Role (IAM 역할)

- 새 IAM Role 생성 후 role에 필요한 권한(S3 Access, Athena Access, ..) 부여
- 이후, IAM Role을 `특정 AWS 리소스에 연결`해서 사용하는 개념
  - EC2 인스턴스 설정의 IAM 인스턴스 프로파일 항목에서 IAM Role을 불러올 수 있음
  - 이러면 해당 EC2 인스턴스는 해당 IAM Role에 등록된 권한을 가짐

### IAM Role이 특정 버킷에 대한 권한 가지도록 정책 설정 예시

- IAM User와 정책 설정 양식은 동일함

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject"
      ],
      "Resource": "arn:aws:s3:::TARGET_BUCKET/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ],
      "Resource": "arn:aws:s3:::TARGET_BUCKET"
    }
  ]
}
```

### 확인

```sh
# IAM Role이 연결된 EC2 인스턴스 내부에서 실행
# 현재 연결된 IAM Role 정보 확인
# VM, Pod, Container 내부에서도 사용가능
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

- IAM Role 정보가 정상출력될 시 AWS SDK에서 IAM Role을 통해 정상적으로 권한 인증 가능한 상태라는 의미
- `169.254.169.254`는 AWS에서 제공하는 고정된 주소 (IMDS, Instance Metadata Service)로, 현재 인스턴스 및 IAM Role 정보를 조회할 때 유용
- AWS SDK가 액세스키 정보를 환경변수, `~/.aws/credentials` 등에서 자동 조회하듯이, `http://169.254.169.254`주소를 통해 연결된 IAM Role을 자동 조회하여 임시 자격증명을 획득한다.
- AWS와 연결하는 서드파티 앱들은 대부분 AWS SDK를 이용해 자격증명 절차를 진행하기 때문에 동일한 방식이 보장된다.
