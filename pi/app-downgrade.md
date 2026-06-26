# 라즈베리파이에서 특정 앱 다운그레이드하기

- 현시점 기준 사용 중인 라즈베리파이 3B는 워낙 구형 모델이라 간혹 호환성 충돌이 발생한다.
- 별생각 없이 `apt update`, `apt upgrade`를 했다가 호환성 문제로 앱이 실행되지 않을 수 있다.
- 이번에는 Chromium이 149 버전으로 올라온 뒤 제대로 실행되지 않는 문제가 있었다.
- 아래는 Chromium을 149 → 148로 다운그레이드한 실제 사례로, 다음에 비슷한 일이 생겼을 때 참고하기 위해 남긴다.

## 아키텍처 확인

- `.deb`는 아키텍처별로 제공되므로, 받기 전에 `dpkg --print-architecture`로 내 아키텍처를 확인한다. (`armhf`, `arm64` 등)

```sh
dpkg --print-architecture
```

## 아카이브 주소

- `apt install`은 패키지(설치 파일)를 원격 저장소에서 가져온다.
- 이 저장소 주소는 리눅스 배포판마다 다르다.
- 라즈베리파이OS는 아래 주소를 사용하며, 웹으로 접속하면 아키텍처에 맞는 사용 가능한 버전 인덱스를 직접 확인할 수 있다.
- https://archive.raspberrypi.com/debian/pool/main/c/chromium/

## 설치

- Chromium과 그 의존성인 `chromium-common`의 148 버전 `.deb` 파일을 받은 뒤 설치한다.

```sh
# 되돌아갈 148 버전 deb 파일 다운로드
# wget https://archive.raspberrypi.com/debian/pool/main/c/chromium/chromium_148.0.7778.167-1~deb13u1+rpt1_armhf.deb
# wget https://archive.raspberrypi.com/debian/pool/main/c/chromium/chromium-common_148.0.7778.167-1~deb13u1+rpt1_armhf.deb

# 또는 147(148 너무느리네)
wget https://archive.raspberrypi.com/debian/pool/main/c/chromium/chromium_147.0.7727.116-1~deb13u1+rpt1_armhf.deb
wget https://archive.raspberrypi.com/debian/pool/main/c/chromium/chromium-common_147.0.7727.116-1~deb13u1+rpt1_armhf.deb

# deb 파일로 설치 (다운그레이드 허용)
sudo apt install --allow-downgrades ./chromium_*.deb ./chromium-common_*.deb
```

## 버전 확인

```sh
chromium --version
```

## 업데이트 고정

- 다운그레이드 후 다시 `apt upgrade`로 149로 올라가지 않도록 버전을 고정한다.

```sh
# 업데이트 막기
sudo apt-mark hold chromium chromium-common

# 업데이트 막은 것 해제
sudo apt-mark unhold chromium chromium-common
```
