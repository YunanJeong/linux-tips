# password

우분투 패스워드 관리

## 명령어 (ubuntu는 대상 계정이름 예시)

- 현재 패스워드 정보, 만료날짜 등 확인

  ```shell
  sudo chage -l ubuntu
  ```

- 패스워드 변경

  ```shell
  sudo passwd ubuntu
  ```

- 현재 비밀번호 그대로 만료 날짜를 갱신
  - 보안상 좋진 않고, 급할 때 쓰기 좋음
  - 보통 만료기간은 90일이고, 패스워드 변경시 최근변경날짜+90일로 만료일이 설정된다. 이를 이용하여 패스워드가 변경된 것으로 인식하게 하여 만료기간을 초기화하는 방법임  

  ```shell
  # Last password change를 2023년 5월 8일로 변경
  sudo chage -d 2023-05-08 ubuntu
  ```

- 패스워드 만료시,
  - 일반적으로 로그인시 새 패스워드 입력을 요구
  - 로그인 자체가 차단된 경우, root계정 담당자에게 요청

- 패스워드 정책 조회

```sh
# 만료 정책
sudo cat /etc/login.defs

# 생성규칙 정책
sudo cat /etc/pam.d/common-password
```

- 패스워드 정책 변경([블로그](https://velog.io/@ifthenelse/ubuntu-%EA%B3%84%EC%A0%95-%ED%8C%A8%EC%8A%A4%EC%9B%8C%EB%93%9C-%EA%B4%80%EB%A6%AC))

