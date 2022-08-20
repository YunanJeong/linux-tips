# wsl-settings
wsl 설정 (램 사용량 제한하기)

## 문제
- wsl2가 메모리부족시 동적할당으로 계속 할당받고나서 반환을 하지않는다.

## 해결방법
- `C:\Users\{Username}` 경로에 파일명 `.wslconfig`로 파일생성 후, 다음과 같은 내용을 기입한다.
```
[wsl2]
memory=8G              	    

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
  - 16GB PC에서 일반실행시, 기존엔 12GB 정도(윈도우의 80%)로 표기된다. 위 설정을 완료하면, 설정값(8GB)으로만 표기된다.

- 메모리 제한 외에 많이들 쓰는 옵션
  - swap
    - 메모리 부족시 ssd를 끌어와 가상메모리로 쓰는 기능
    - `memory` 옵션을 걸어놓지 않으면, 의미가 없다. 실제 램메모리를 다 집어삼키고 작동되기 때문
    - `swap=0`로 설정시 가상메모리 기능이 꺼진다. 
    - 가상메모리 기능은 일반적으로 많이 쓰이므로, hdd만 쓰는게 아니라면 켜두는 것이 나쁘지 않다.
    
  - localhostForwarding
    - 윈도우에서 localhost IP로 wsl 내 프로세스에 접근가능토록 해주는 기능이다. 
    - wsl도 vm이기 때문에 가상어댑터에 할당된 IP를 쓰는게 맞지만, 편의상 MS에서 넣어준 기능이라고 보면된다.
    - 역으로, wsl 내부에서 localhost로 윈도우에 접근하는 것은 원천적으로 안된다.

