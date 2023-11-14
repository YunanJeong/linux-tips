# AWS

편의상 AWS 관련 소소한 팁도 이 레포지토리에 기록한다.

## S3 버킷에 특정 액세스키로 접근하는 것을 허용하기

- IAM User 생성, Access Key 발급, 이후 IAM User에 S3 Full Access를 할당하면 쉽게 Access Key로 S3에 접근이 가능하다.
- 하지만, 이러면 보안이 떨어지므로 다음과 같은 방법을 이용한다. 

### "버킷에서" 특정 IAM User(Access Key) 허용하기

- 콘솔 S3의 특정버킷 웹페이지로가면, 상단쯤에 '권한' 탭-'버킷 정책' 으로 등록
- `arn:aws:iam::your-account-id:user/your-iam-user`부분은 IAM User 개별항목으로 가면 복사할 수 있다.
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

### "IAM User가" 특정 버킷에 대한 읽기/쓰기 권한 가지도록 만들기

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketLocation",
        "s3:ListAllMyBuckets"
      ],
      "Resource": "*"
    },
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
- EC2 인스턴스 생성시 IAM 인스턴스 프로파일 항목에서 IAM Role을 불러올 수 있다.

## [NAT 게이트웨이 구성하기](https://docs.aws.amazon.com/ko_kr/vpc/latest/userguide/vpc-nat-gateway.html#nat-gateway-creating)

### 필요한 상황

- EC2에 구축된 클러스터 시스템에서 외부 시스템에 접근할 때, 외부시스템에서 이를 하나의 소스 공인 IP로 인식하도록 하기 위함
- 외부 시스템이 소스 IP에 대해 인가하는 구조일 수 있는데, 클러스터 시스템이 스케일 아웃될 때마다 새로 할당되는 노드 IP의 인가를 처리하는 것은 비효율적일 수 있기 때문

### 참고

- VPC와 서브넷 설정이 필요
- VPC가 큰 네트워크 단위고 VPC안에 속한 작은 단위가 서브넷
  - VPC에 큰 private ip 대역이 있고, 서브넷마다 세부 대역으로 나눠 쓰는 개념
- VPC내부 인스턴스 간 private ip로 통신가능
- 서브넷은 Public과 Private으로 나눠짐
  - Private: 내부 전용. 외부 연결시 NAT 필요하고 내부->외부 방향의 request만 가능(반대 방향 불가)
  - Public: 외부 통신 자유롭게 가능
- 네트워크 경계 그룹: `ap-northeast-2` 와 같은 것을 의미
- 가용 영역
  - ap-northeast-2a, ap-northeast-2b, ap-northeast-2c, ap-northeast-2d 와 같이 표현되는 것들
  - 실제 AWS 데이터센터 위치를 의미하며 한 서브넷은 한 가용영역에 있어야 함.
