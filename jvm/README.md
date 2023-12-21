# JVM 관리

## Garbage Collection

- [간단한 힙메모리 분석방법, jstat](https://steady-coding.tistory.com/591)
- [Garbage Collection 동작방식 및 용어정리](https://dongwooklee96.github.io/post/2021/04/04/gcgarbage-collector-%EC%A2%85%EB%A5%98-%EB%B0%8F-%EB%82%B4%EB%B6%80-%EC%9B%90%EB%A6%AC.html)
- [힙메모리 설정과 실제 물리메모리가 다르게 표기되는 이유](https://woooongs.tistory.com/85)
  - VIRT,RES,SHR 의미
  - JVM 은 가상메모리에는 최소 힙 사이즈 만큼 공간을 할당하지만, 실제로 객체를 힙에 저장하기 전까지는 물리 메모리를 점유하지 않는다.
  - JVM이 객체저장을 위해 한 번 물리메모리를 점유하고나면, Garbage Collection이 발생해도 해당객체만 할당해제하는 것일 뿐, 이미 점유한 물리메모리는 OS에 반환하지 않는다.
- [자바앱 GC와 timeout,멈춤현상 이유, GC 튜닝방법](https://donghyeon.dev/java/2020/03/31/%EC%9E%90%EB%B0%94%EC%9D%98-JVM-%EA%B5%AC%EC%A1%B0%EC%99%80-Garbage-Collection/)
- [(Naver D2)GC 정상동작 확인과 튜닝여부 결정방법](https://d2.naver.com/helloworld/37111)

## GC 상태를 간단하게 모니터링해볼 수 있는 방법

```sh
java -XX:+PrintFlagsFinal -version 2>&1 | grep -i -E 'heapsize|permsize|version'

pmap -x {jps 번호} | sort -k 3 -n -r | more

jstat -gc {jps 번호}
jstat -gcutil {jps 번호}

# 자바 프로세스 14번의 힙정보를 30초마다 출력
jstat -gc 14 30s
jstat -gcutil 14 30s
```

## GC 종류

jvm 버전 마다 조금씩 GC 종류와 방식이 다르기는 한데, 대략적으로 아래와 같이 파악하고 있으면 될 듯 하다.

### Minor GC (Young Generation GC)

- 힙 메모리중 Young Generation(Eden Space + Survivor Space)에서 발생
- Eden 영역이 가득차면 발생

### Major GC (Old Generation GC)

- Minor GC에서 살아남은 객체 메모리들은 Old 세대로 취급되는데, 이들을 GC
- Old 영역이 가득차면 발생
- Old 영역이 가득차지 않아도 Old 영역의 메모리사용량이 감소하는 경우가 있는데, 이것은 확인필요
  - incremetal GC로 추정된다. Minor GC가 일어날때 마다 Old영역을 조금씩 GC를 해서 Full GC가 발생하는 횟수나 시간을 줄이는 방법이다.[[출처]](https://devyongsik.tistory.com/100)

### Full GC (Complete GC)

- Yonng, Old 영역 전체에서 GC
- 힙메모리가 가득차면 발생
- GC 유형 중 가장 느린 작업이다. 전체 메모리를 조회하기 때문. 메모리가 크면 클수록 GC작업이 길어지고, 앱 중지시간도 길어진다.
- Major GC와 혼용되기도 하는데, 구분할 필요가 있을 듯

## JVM 커스텀 옵션

```sh
# 비율설정 Old영역/New영역 값
-XX:NewRatio=2

# 비율설정 Eden영역/Survivor영역 값 (보통 default 8인데 버전마다 다를 수 있음)
# Survivor 영역이 너무 작으면, 잦은 MinorGC가 일어나거나 MinorGC와 상관없이 Old영역으로 이동됨
-XX:SurvivorRatio=6

# Minor GC에서 몇번 살아남으면 Old로 취급할것인가
# Java11 기본값7 (1~15로 설정가능)
-XX:MaxTenuringThreshold=<n>

```
