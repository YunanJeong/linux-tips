# JVM 관리

## Garbage Collection

- [간단한 힙메모리 분석방법, jstat](https://steady-coding.tistory.com/591)
- [Garbage Collection 동작방식 및 용어정리](https://dongwooklee96.github.io/post/2021/04/04/gcgarbage-collector-%EC%A2%85%EB%A5%98-%EB%B0%8F-%EB%82%B4%EB%B6%80-%EC%9B%90%EB%A6%AC.html)
- [실제 점유메모리가 힙메모리 설정보다 낮을 때 이유](https://woooongs.tistory.com/85)
  - VIRT,RES,SHR 의미
  - JVM 은 가상메모리에는 최소 힙 사이즈 만큼 공간을 할당하지만, 실제로 객체를 힙에 저장하기 전까지는 물리 메모리를 점유하지 않는다.
  - JVM이 객체저장을 위해 한 번 물리메모리를 점유하고나면, Garbage Collection이 발생해도 해당객체만 할당해제하는 것일 뿐, 이미 점유한 물리메모리는 OS에 반환하지 않는다.
- [자바앱 GC와 timeout,멈춤현상 이유, GC 튜닝방법](https://donghyeon.dev/java/2020/03/31/%EC%9E%90%EB%B0%94%EC%9D%98-JVM-%EA%B5%AC%EC%A1%B0%EC%99%80-Garbage-Collection/)
- [(Naver D2)GC 정상동작 확인과 튜닝여부 결정방법](https://d2.naver.com/helloworld/37111)

## 간단한 GC 상태 모니터링 방법 (jdk 내장 명령어)

```sh
java -XX:+PrintFlagsFinal -version 2>&1 | grep -i -E 'heapsize|permsize|version'

pmap -x {jps 번호} | sort -k 3 -n -r | more

jstat -gc {jps 번호}
jstat -gcutil {jps 번호}

# 자바 프로세스 14번의 힙정보를 30초마다 출력
jstat -gc 14 30s
jstat -gcutil 14 30s
```

### jstat 지표 설명

- S0C (Survivor 0 Capacity): Survivor 0 영역의 용량 (KB 단위)
- S1C (Survivor 1 Capacity): Survivor 1 영역의 용량 (KB 단위)
- S0U (Survivor 0 Utilization): Survivor 0 영역의 사용량 (KB 단위)
- S1U (Survivor 1 Utilization): Survivor 1 영역의 사용량 (KB 단위)
- `EC (Eden Capacity): Eden 영역의 용량 (KB 단위)`
- `EU (Eden Utilization): Eden 영역의 사용량 (KB 단위)`
- `OC (Old Capacity): Old 영역의 용량 (KB 단위)`
- `OU (Old Utilization): Old 영역의 사용량 (KB 단위)`
- MC (Metaspace Capacity): Metaspace 영역의 용량 (KB 단위)
- MU (Metaspace Utilization): Metaspace 영역의 사용량 (KB 단위)
- CCSC (Compressed Class Space Capacity): 압축된 클래스 공간의 용량 (KB 단위)
- CCSU (Compressed Class Space Utilization): 압축된 클래스 공간의 사용량 (KB 단위)
- `YGC (Young Generation GC Count): Young Generation에서 발생한 GC 횟수`
- `YGCT (Young Generation GC Time): YGC에 소요된 총 누적 시간 (sec)`
- CGC (Concurrent Garbage Collection Count): CMS(Concurrent Mark-Sweep) GC와 같은 병행 GC 알고리즘에서 발생한 GC의 횟수
- CGCT (Concurrent Garbage Collection Time): CMS GC와 같은 병행 GC 알고리즘에서 발생한 GC에 소요된 총 시간
- `FGC (Full GC Count): 전체 힙에서 발생한 GC 횟수`
- `FGCT (Full GC Time): FGC에 소요된 총 누적 시간 (sec)`

### **jstat보면서 실제로 고려할 것**

- YGC를 얼마나 자주하는가? (EC 점유율 오르는 속도)
- FGC를 얼마나 자주하는가?
- YGC 1회의 평균처리시간 = YGCT / YGC
- FGC 1회의 평균처리시간 = FGCT / FGC
- 위 값이 적정치가 되도록 JVM 커스텀 옵션을 변경하면됨. (제일 하단 참고)
- 적정치 기준은 앱마다 다르나, [(Naver D2)GC 정상동작 확인과 튜닝여부 결정방법](https://d2.naver.com/helloworld/37111)에 아주 잘 정리되어있음.

## JVM 메모리 구조

```tree
JVM Memory
├── Heap Memory
│ ├── Young Generation
│ │ ├── Eden Space
│ │ ├── Survivor Space 0 (S0)
│ │ └── Survivor Space 1 (S1)
│ └── Old Generation
└── Non-Heap Memory
└── Metaspace
```

## GC 종류

- Minor GC, Major GC, Full GC는 GC개념에서 사용되는 통상적인 용어이며, jvm 버전, GC 알고리즘마다 명칭, 방식이 다를 수 있음
  - jdk 9 이후 default 알고리즘: `G1GC`
  - YGC, CGC, Mixed GC, incremental GC, ... 는 범용적이기보다는 좀 더 파생적인 용어인데 블로그에서 자주 혼용되니까 참고

```sh
# 현재 JVM 설정 및 GC 알고리즘 확인
jinfo -flags {jps로 확인한 pid}
```

### Minor GC

- **대상**: Young Generation (Eden Space + Survivor Space)
- **주기**: 비교적 자주 발생
- **목적**: Young Generation에서 살아남지 못한(더 참조되지 않는) 객체를 청소하고, 살아남은 객체를 Survivor Space 또는 Old Generation으로 이동
- **트리거**: `Young Generation의 Eden Space가 가득 찬 경우`
- **특징**:
  - 빠르게 수행됨
  - 애플리케이션의 일시 중지 시간이 짧음
  - `jstat에서 EC 가득차면 YGC 1번 발생`하는 것으로 보면 됨

### Major GC

- **대상**: 주로 Old Generation
- **주기**: 비교적 덜 자주 발생
- **목적**: Old Generation에서 살아남지 못한(더 참조되지 않는) 객체를 청소
- **트리거**: `Old Generation이 가득 찬 경우`
- **특징**:
  - Minor GC보다 시간이 더 오래 걸림
  - 애플리케이션의 일시 중지 시간이 길어질 수 있음
  - 실제 GC알고리즘에선 `오래걸리는 Old 세대 GC(Major, Full GC)를 가급적 피하기 위해 Old 영역이 가득차기 전 미리 동적조절`하는 방법이 추가적으로 활용됨
  - 이에 따라 실제 구현에선 MajorGC라고 직접 칭해지기 보다는 다양한 이름으로 불림
  - e.g. Mixed GC(G1GC 알고리즘), incremental GC(CMS GC 알고리즘) 등
  - `jstat 지표에서도 YGC(Minor GC), FGC는 있지만 Major GC와 1:1 대응하는 항목은 없음`
  - 일부 GC 알고리즘에서는 Young Generation도 대상으로 포함

### Full GC

- **대상**: 힙 전체 (Young Generation과 Old Generation 모두)
- **주기**: 매우 드물게 발생
- **목적**: 힙 전체를 청소하고, 메모리 단편화를 해결
- **트리거**: 주로 메모리 부족, 메타스페이스 부족, 또는 GC 알고리즘의 내부 실패 시
- **특징**:
  - Major GC보다 시간이 더 오래 걸림
  - 애플리케이션의 모든 스레드를 일시 중지시킴
  - 모든 세대(Young, Old, Metaspace 등)를 포함하여 전체 힙을 청소

## JVM 커스텀 옵션

```sh
# 비율설정 Old영역/New영역 값 (정수만 가능) 1~4 정도 값 주면 좋음
-XX:NewRatio=2

# 비율설정 Eden영역/Survivor영역 값 (보통 default 8인데 버전마다 다를 수 있음)
# Survivor 영역이 너무 작으면, 잦은 MinorGC가 일어나거나 MinorGC와 상관없이 Old영역으로 이동됨
-XX:SurvivorRatio=6

# Minor GC에서 몇번 살아남으면 Old로 취급할것인가
# Java11 기본값7 (1~15로 설정가능)
-XX:MaxTenuringThreshold=<n>

# -XX:+UnlockDiagnosticVMOptions: 추가 옵션(GCLockerRetryAllocationCount)을 활성화하기 위해 사용
# GCLocker 관련옵션: https://discuss.elastic.co/t/gclocker-too-often-allocating-256-words/323769/2
# GCLocker 장기화로 인한 OOM 방지(하단 항목 참고)
-XX:+UnlockDiagnosticVMOptions -XX:GCLockerRetryAllocationCount=100


# 최대 가용량 대비 힙 비율 설정 # -Xms, -Xmx가 함께 지정되면 비율설정은 무시됨
# 클라우드 or 컨테이너 기반 환경에서 스케일 조정시 매우 유용하다!!  (requests.limits.memory, 없으면 노드 사양 기준)
-XX:InitialRAMPercentage=50 -XX:MaxRAMPercentage=50
```

### GCLocker 관련 OOM에 대응

#### GCLocker?

- JVM에서 특정 상황(주로 네이티브 코드가 Java 객체에 접근할 때)에서 `가비지 컬렉션(GC)을 일시적으로 멈추게` 하는 메커니즘임. 네이티브 코드가 Java 객체를 안전하게 사용할 수 있도록 보장함.

#### 이슈 사례: GCLocker 장기화로 인한 OOM

1. 일부 작업 구간에서 GCLocker 활성시간이 길어져, JVM의 GC가 지속적으로 차단될 수 있음 (특히, `다수 Task 작업시 Task마다 GCLocker가 발생하면 이럴 가능성이 큼`)
2. JVM은 정해진 작업에 따라 신규 메모리 할당 진행
3. 여유 메모리가 없어지면 GC가 수행되어야 하나, GCLocker로 인해 더 이상 신규 메모리 할당불가
4. JVM은 계속 메모리할당을 재시도
5. 재시도 횟수 초과시 JVM은 이를 OOM으로 판단(default retry: 5)
6. GCLocker 비활성화를 대기하다가 `늦게라도 GC가 수행된다면 충분할 메모리 사양에도 불구하고, Fake(?) OOM이 발생하여 앱 전체가 중단`되는 사태 발생

#### 해결책

- 재시도 횟수 커스터마이징
  - default가 5번인데, 꽤 적은 수치로 보임
  - `GCLockerRetryAllocationCount` 옵션으로 조정가능
  - 충분한 재시도 횟수로 JVM은 GCLocker 비활성화를 대기하게 됨
  - 일부 작업 구간에서 앱실행속도가 느릴 수는 있어도 GC가 정상수행되므로 OOM으로 인한 중단 방지 가능

```java
-XX:+UnlockDiagnosticVMOptions -XX:GCLockerRetryAllocationCount=100
```

- **스케일업**
  - 클라우드 등 서버 사양에 자유로운 환경이라면 스케일업도 방법임
  - 경험상 메모리보다는 CPU 증설이 나았음.메모리 증설만 할 시, 터무니 없이 많은 메모리가 요구됨
  - CPU 증설: GCLocker 구간을 빨리 탈출
  - 메모리 증설: GCLocker 활성화 중에도 여유메모리가 많으므로 신규 메모리할당에 실패하지 않을 수 있음