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

## [AWS NAT 게이트웨이 구성하기](https://docs.aws.amazon.com/ko_kr/vpc/latest/userguide/vpc-nat-gateway.html#nat-gateway-creating)

### NAT

- 내부 네트워크의 사설IP 주소를 외부네트워크의 공인IP주소로 변환하는 기술
- NAT를 통하면 내부->외부로 request는 되지만 반대반향 request는 불가

### 필요한 상황

- 개별 서버를 외부에 노출되지 않도록할 때 사용
- EC2에 구축된 클러스터 시스템에서 외부 시스템에 접근할 때, 외부시스템이 여러 노드로부터 온 트래픽을 하나의 소스 공인 IP로 인식하도록 하기 위해 필요
- 외부 시스템이 소스 IP에 대해 인가하는 구조일 수 있는데, 클러스터 시스템이 스케일 아웃될 때마다 새로 할당되는 노드 IP를 인가하는 것은 비효율적이기 때문

### 참고

- VPC와 서브넷 설정이 필요
- VPC가 큰 네트워크 단위고 VPC안에 속한 작은 단위가 서브넷
  - VPC에 큰 private ip 대역이 있고, 서브넷마다 세부 대역으로 나눠 쓰는 개념
- VPC내부 인스턴스 간 private ip로 통신가능
- 서브넷은 Public과 Private으로 나눠짐
  - Private: 내부 전용. 외부 연결시 NAT로 내부->외부만 가능. 반대방향은 원천적으로 불가.
  - Public: 개별 인스턴스 단위로 Public IP 등록시 외부 통신 자유롭게 가능
- 네트워크 경계 그룹: `ap-northeast-2` 와 같은 것을 의미
- 가용 영역
  - ap-northeast-2a, ap-northeast-2b, ap-northeast-2c, ap-northeast-2d 와 같이 표현되는 것들
  - 실제 AWS 데이터센터 위치를 의미하며 한 서브넷은 한 가용영역에 있어야 함.
- `AWS NAT GW는 특정 서브넷에 종속`된다.

### 라우팅 테이블

- [라우팅 테이블 생성 방법](https://docs.aws.amazon.com/ko_kr/vpc/latest/userguide/WorkWithRouteTables.html#SubnetRouteTables)
- AWS NAT GW를 쓰려면 라우팅테이블이 필요하다.
  - 개별 인스턴스에서 라우팅 테이블에 등록된 목적지IP로 request를 보내면 NAT GW를 거쳐 포워딩된다. 이 과정에서 트래픽의 소스IP가 변조된다.
  - 특정 인스턴스만 해당 GW를 쓸 수 있게 하려면, 특정 서브넷에 인스턴스를 격리해야 한다.
- AWS의 라우팅 테이블은 VPC의 하위항목이고, 개별 서브넷과 연결되어 사용되는 개념이다.
- `하나의 서브넷은 하나의 라우팅 테이블만 가진다.`
- 하나의 라우팅 테이블은 여러 서브넷에서 사용될 수 있다.
- `기존 서브넷이 VPC의 default 라우팅테이블을 사용 중일 때, 새로운 라우팅 테이블이 연결되면 default 라우팅테이블과의 연결은 해제`된다.
  - 기존 서브넷에 새로운 라우팅테이블을 연결할 때 조심하자. 다른 서비스가 먹통될 수 있다.

- 라우팅 테이블 작성방법
  - 라우팅 테이블은 목적지IP 기준으로 트래픽을 분류한다.
  - 소스IP로 트래픽 분류는 불가
  - 라우팅 테이블 컬럼에 한글로 "대상"이 두 개인데 첫번째 대상이 목적지IP를 의미, 두번째 대상이 경유할 GW를 의미한다.
  - 라우팅 테이블 내에서 목적지IP가 겹치는 규칙이 있는 경우, 더 구체적인 규칙을 우선적용한다. 앞서 처리된 트래픽은 이후 규칙에 적용받지 않는다. (중복처리 안됨)
    - e.g. `192.168.0.19/32가 192.168.0.0/24, 0.0.0.0/0보다 우선 적용`된다.

### 요약

- AWS NAT GW 쓰려면 라우팅테이블이 필요하고, AWS NAT GW와 라우팅테이블 모두 특정 서브넷 기준으로 등록하는 개념이라고 보면 된다.
- 새로운 서비스에 NAT 사용시, 새로운 서브넷을 생성하여 인스턴스들을 격리하는 것이 깔끔하다.
- 기존 서브넷을 유지해야 한다면, 다른 서비스에 영향이 가지않도록 기존 라우팅테이블의 정보를 포함하여 새로운 라우팅테이블을 만들어 준다.
- `가급적 신규 서비스는 NAT 필요유무를 판단하여 초기에 개별 서브넷으로 시작`하자. NAT와 관련된 모든 것들(GW, Elastic IP, instance 등)은 동일한 서브넷에 있어야 하며, 생성된 이후에 이전은 불가능하다. 수동으로 재생성 해야한다.