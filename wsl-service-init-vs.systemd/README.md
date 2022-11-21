# wsl-service

## init, systemd 공통
- Linux 시스템이 시작될 때 같이 시작되는 프로세스
- 정상 부팅을 위한 초기화 작업 및 전체 시스템 관리에 이용된다.
- 역할이 비슷하므로, 대부분 Linux에서 둘 중 하나만 채택하여 사용된다.
- 모든 프로세스의 부모 프로세스(parent process)다.

## init
- 과거 시스템
- `service` 명령어로 서비스를 관리
	- e.g.) status 정보 확인시, 현재 동작 유무 등 매우 간소한 정보만 출력해준다.
	```
	# 명령어 예시
	$ sudo service docker start
	$ sudo service docker status
	```
- WSL은 init을 기본적으로 지원한다.

## systemd
- 최신 시스템. 최근 대부분 Linux 배포판들은 systemd 사용
- init프로세스의 기능 포함 + 성능향상 + 기능 추가
- `systemctl` 명령어로 서비스를 관리
	- e.g.) status 정보 확인시, 동작시간 등 상세정보를 출력해준다.
	```
	# 명령어 예시
	$ sudo systemctl start docker.service
	$ sudo systemctl status docker.service
	```
- WSL systemd 지원 여부
	- **Windows11, WSL 0.67.6 이상** 환경에서 공식지원
		- [systemd 활성화 방법(공식)](https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl/)
	- 이하 사양의 경우, 공식지원 안됨
		- 대신 [genie](https://github.com/arkane-systems/genie) 라는 오픈소스 프로젝트를 활용
		- 설치방법은 간단하고, 한글 블로그 자료도 많다.
		- genie는 다음과 같이 끄거나 켤 수 있다.
		```
		# Powershell 관리자 권한에서,
		> wsl --shutdown         # wsl 종료 상태로,
		> wsl genie -s           # 켜기
		> wsl genie --shutdown   # 끄기
		```
