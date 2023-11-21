# JVM 관리

## Garbage Collection

- [간단한 힙메모리 분석방법, jstat](https://steady-coding.tistory.com/591)
- [Garbage Collection 동작방식 및 용어정리](https://dongwooklee96.github.io/post/2021/04/04/gcgarbage-collector-%EC%A2%85%EB%A5%98-%EB%B0%8F-%EB%82%B4%EB%B6%80-%EC%9B%90%EB%A6%AC.html)

- [힙메모리 설정과 실제 물리메모리가 다르게 표기되는 이유](https://woooongs.tistory.com/85)
  - VIRT,RES,SHR 의미
  - JVM 은 가상메모리에는 최소 힙 사이즈 만큼 공간을 할당하지만, 실제로 객체를 힙에 저장하기 전까지는 물리 메모리를 점유하지 않는다.
  - JVM이 객체저장을 위해 한 번 물리메모리를 점유하고나면, Garbage Collection이 발생해도 해당객체만 할당해제하는 것일 뿐, 이미 점유한 물리메모리는 OS에 반환하지 않는다.

- [자바앱 GC와 timeout,멈춤현상 이유, GC 튜닝방법](https://donghyeon.dev/java/2020/03/31/%EC%9E%90%EB%B0%94%EC%9D%98-JVM-%EA%B5%AC%EC%A1%B0%EC%99%80-Garbage-Collection/)

- [GC 정상동작 확인과 튜닝여부 결정방법](https://d2.naver.com/helloworld/37111)


```sh
java -XX:+PrintFlagsFinal -version 2>&1 | grep -i -E 'heapsize|permsize|version'

pmap -x {jps 번호} | sort -k 3 -n -r | more

jstat -gc {jps 번호}
jstat -gcutil {jps 번호}
```

## GC 종류

- Minor GC (Young Generation GC)
  - 힙 메모리중 Young Generation(Eden Space + Survivor Space)에서 발생
  - Eden 영역이 가득차면 발생
- Major GC (Old Generation GC)
  - Minor GC에서 살아남은 객체 메모리들은 Old 세대로 취급되는데, 이들을 GC
  - Old 영역이 가득차면 발생
  - Old 영역이 가득차지 않아도 Old 영역의 메모리사용량이 감소하는 경우가 있는데, 이것은 확인필요
- Full GC (Complete GC)
  - Yonng, Old 영역 전체에서 GC
  - 힙메모리가 가득차면 발생
  - Major GC와 혼용되기도 하는데, 구분할 필요가 있을 듯
