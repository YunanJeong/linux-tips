# wslconfig

wsl 설정 (램메모리 사용량 제한하기)

## 문제

- WSL2가 메모리부족시 동적할당으로 계속 할당받고나서 반환을 하지않는다.

## 해결방법

- `C:\Users\{Username}` 경로에 파일명 `.wslconfig`로 파일생성 후, 다음 내용을 기입한다.

```shell
[wsl2]
memory=12G   
swap=1G
#memory=<size>              # How much memory to assign to the WSL2 VM.
#kernel=<path>              # An absolute Windows path to a custom Linux kernel.
#processors=<number>        # How many processors to assign to the WSL2 VM.
#swap=<size>                # How much swap space to add to the WSL2 VM. 0 for no swap file.
#swapFile=<path>            # An absolute Windows path to the swap vhd.
#localhostForwarding=<bool> # Boolean specifying if ports bound to wildcard or localhost in the WSL2 VM should be connectable from the host via localhost:port (default true).

# <path> entries must be absolute Windows paths with escaped backslashes, for example C:\\Users\\Ben\\kernel
# <size> entries must be size followed by unit, for example 8GB or 512MB
```

- powershell에서 `$wsl --shutdown`으로 wsl을 완전종료한다.
- wsl 재실행 후, `$htop`으로 설정 메모리로 표기되는지 확인한다.
  - 디폴트에선 윈도우호스트 메모리의 80% 정도로 표기되는데, 위 설정 후엔 설정값(12GB)으로 표기된다.

- 메모리 제한 외에 많이들 쓰는 옵션
  - swap (default: 0)
    - 메모리 부족시 ssd를 끌어와 가상메모리로 쓰는 기능
    - `swap=1G`와 같이 용량단위 설정
    - `memory` 옵션을 걸어놓지 않으면 의미가 없다. 메모리 제한 없을시, 실제 램메모리를 다 집어삼키고 swap이 작동되기 때문
    - 호스트PC에 ssd가 있다면 켜두는 것이 낫다. 메모리 부족시 wsl터미널이 전부 죽어버리는 현상을 완화해준다.

  - localhostForwarding (default: true)
    - 윈도우호스트에서 localhost IP를 이용해 wsl 내 프로세스에 접근가능하게 해주는 기능
    - wsl도 vm이기 때문에 가상어댑터에 할당된 IP를 쓰는게 맞지만, 편의상 MS에서 넣어준 기능이라고 보면된다.
    - 역으로, wsl 내부에서 localhost로 윈도우호스트에 접근하는 것은 원천적으로 불가
