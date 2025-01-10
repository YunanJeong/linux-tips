# JMX(Java Management Extensions)로 모니터링 하기

## JVM에서 JMX Remote 활성화

- 자바 앱 실행시 JMX 활성화 및 포트 개방 옵션 필요

## JMX Exporter

- Prometheus와 함게 사용되는 exporter 중 하나이며, 공식 배포도 Prometheus GitHub에 있음
- JMX 모니터링 도구 관점에서만 봐도 상당히 보편적으로 사용되는 방식

## fluentbit or Elastic Beats 사용시

- 먼저 jmx exporter 등으로 자바 메트릭을 http port로 노출 시킨 후 forwarder에서 해당 http port에 접근하는 방식으로 jmx 모니터링 가능
- forwarder에서 jmx remote port에 직접 연결은 불가
- jmx remote port가 http가 아닌 독자 프로토콜이기 때문에 꼭 jmx exporter와 같은 도구가 중간에 필요

## JRE, JDK에서 포함 여부

- JMX Remote Port 활성화는 JRE, JDK 상관없이 가능
- 다만 `jstat` 등의 클라이언트 도구는 JDK에만 내장됨
- JMX Exporter 사용시 JRE로만 배포된 자바앱이여도 가능

## 통상적인 JMX, JMX Exporter 포트와 통신 방향

- 자바 앱 JMX Remote
  - RMI Registry Port: 1099
  - Connector Port: 5000
- JMX Exporter: 5556
- Request 방향: Prometheus==>JMX Exporter==>JMX Remote

## K8s Helm 차트 배포시

- 구현&적용 방법
- 일반적인 오픈소스에서 JMX 모니터링 구현 방식
- 빅데이터 플랫폼 => 대부분 Java 기반
  => bitnami 같은 검증된 출처면 대부분 jvm metrics 기능이 helm차트에 탑재됨
- 독자적인 JMX Exporter 헬름 차트는 효율이 떨어짐
  - 모니터링 대상 앱마다 릴리즈 배포 해야 함
  - 단일 Exporter로 여러 앱 모니터링도 불가능한건 아니지만 손이 많이 감
- 일반적으론 Pod마다 Sidecar형태로 jmx exporter 이미지를 띄워서 모니터링 하는게 보편적인 것 같음. 조금 더 테스트 필요
  - 근데 이거 구현이 안된 헬름차트를 커스텀해서 jmx exporter를 sidecar로 넣으려면 helm value 수정가지곤 안되고 template 수정이 필요
