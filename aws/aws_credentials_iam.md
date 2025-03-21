# S3 전체 권한이 아닌, 특정 S3 버킷만 접근권한 부여하기

- IAM User 생성, Access Key 발급, 이후 IAM User에 S3 Full Access를 할당하면 쉽게 Access Key로 S3에 접근이 가능하다.
- 하지만, 이러면 보안상 좋지 않으므로 다음 방법 중 하나를 이용한다.

## IAM User

### 방법1: 버킷정책설정

"버킷에서" 특정 IAM User(Access Key) 허용하기

- 콘솔 S3의 특정버킷 웹페이지로가면, 상단쯤에 '권한' 탭-'버킷 정책' 으로 등록
- Principal.AWS는 버킷 입장에서 접근 허용할 대상 리소스의 arn을 기술하는 부분으로 IAM User 정보 입력
- ARN(`arn:aws:iam::your-account-id:user/your-iam-user`)은 AWS 리소스를 식별하는 고윳값으로 대상 리소스의 속성에서 확인 가능
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

### 방법2: IAM User 정책 설정

"IAM User가" 특정 버킷에 대한 읽기/쓰기 권한 가지도록 정책 설정

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

## IAM Role: AWS 서비스끼리 액세스키 없이 권한 허용하기

AWS 내부 서비스 간 통신에선 IAM Role 기능으로 자격증명이 가능하다. 액세스키를 관리할 필요 없어, 보안적으로도 유지관리에도 용이하다.

### IAM Role (IAM 역할)

- 새 IAM Role 생성 후 role에 필요한 권한(S3 Access, Athena Access, ..) 부여
- 이후, IAM Role을 `특정 AWS 리소스에 연결`해서 사용하는 개념
  - EC2 인스턴스 설정의 IAM 인스턴스 프로파일 항목에서 IAM Role을 불러올 수 있음
  - 이러면 해당 EC2 인스턴스는 해당 IAM Role에 등록된 권한을 가짐
- `S3 버킷 정책에서 IAM User 대신 IAM Role을 허용하는 방식도 가능하지만, 이 땐 IAM Role이 S3접근권한을 별도로 가지고 있어야 함`
  - 따라서, 대상 리소스(e.g. S3버킷)에서 정책설정하기 보다는 IAM Role 정책만 사용하는 것이 관리하기 편하다. (모든 권한에 대해 중앙집중식 관리하기도 이 편이 나음)

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
# 현재 연결된 인스턴스의 메타데이터(IAM Role) 확인
# VM, Pod, Container 내부에서도 사용가능

# IMDSv1
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

# IMDSv2
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/iam/security-credentials/"
```

- IAM Role 정보가 정상출력될 시 AWS SDK에서 IAM Role을 통해 정상적으로 권한 인증 가능한 상태라는 의미
- `169.254.169.254`
  - AWS에서 제공하는 고정된 주소 (IMDS, Instance Metadata Service)
  - 현재 인스턴스 및 IAM Role 정보를 조회할 때 유용
  - AWS 내부 서비스에서만 접근가능
- AWS SDK가 액세스키 정보를 환경변수, `~/.aws/credentials` 등에서 자동 조회하듯이, `http://169.254.169.254`주소를 통해 현재 연결된 IAM Role을 자동 조회하여 임시 자격증명을 획득한다.
- AWS와 연결하는 서드파티 앱들은 대부분 AWS SDK를 이용해 자격증명 절차를 진행하므로,
  - IAM Role을 가진 EC2 인스턴스에서 앱 실행시 대부분 자동으로 자격증명을 잘 획득한다.
  - 보안이 강화된 IMDSv2의 경우 token이 요구되는데, 이도 AWS SDK가 잘 처리하므로 일반적으론 개발자가 신경 쓸 필요 없다. 위 curl 명령어 쓸 때만 따로 필요.

### AWS 외부에서 IAM Role을 사용하는 경우

- AWS STS(`https://sts.amazonaws.com`)를 통해 Role 권한 획득
- AssumeRole 과정(어떤 Role을 연결할 것인가 결정)에서 액세스키 필요
  - 여전히 액세스키 관리가 필요
  - AssumeRole용 단일 액세스키 + 서버 별 다른 Role을 배정하는 방식으로 액세스키 관리 소요를 줄이는 것은 가능
  - => 여전히 IAM User의 액세스키를 직접 사용하는 것 보다는 보안상 더 좋다고 볼 수 있음
- 어떤 Role을 가져올지 ARN 명시 필요
