# vimrc-settings

how to make vi(m) colorful in both root and home. (sudo vi and vi)

## vim 설정 커스터마이징

- 홈 디렉토리(`~/`)에 `.vimrc` 파일을 생성하고 다음과 같이 쓸 수 있다.

```properties
" 기본 indent
set number      " line 표시
set ai          " auto indent
set si          " smart indent
set cindent     " c style indent

" tab 관련설정
set ts=4 sw=4 expandtab  " 축약형
" set expandtab          " tab 관련 설정시 필요
" set shiftwidth=4       " 자동 공백 채움 시 4칸
" set tabstop=4          " tab을 4칸 공백으로

set ignorecase    " 검색 시 대소문자 무시
set hlsearch      " 검색 시 하이라이트

" set fileencodings=utf-8,euc-kr    " 파일 저장 인코딩 : utf-8, euc-kr
" set fencs=ucs-bom,utf-8,euc-kr    " 한글 파일은 euc-kr, 유니코드는 유니코드


set bs=indent,eol,start    " backspace 사용가능
set ruler           " 상태 표시줄에 커서 위치 좌표 표기
set title           " 제목 표시
set showmatch       " 다른 코딩 프로그램처럼 매칭되는 괄호 보여줌
set wmnu            " tab 을 눌렀을 때 자동완성 가능한 목록
syntax on           " 문법 하이라이트 on
filetype indent on  " 파일 종류에 따른 구문 강조
set mouse=a         " 커서 이동을 마우스로 가능하도록
set nocompatible    " 방향키로 이동 가능

" 컬러 : 터미널마다 표현다름. 환경변수 TERM에 영향 받음.
" WSL은 TERM값이 xterm-256color이고, 나머지 대부분은 xterm
" 어느 환경이든 동일한 색상을 보고 싶으면 TERM을 bashrc로 제어하자
colo murphy         " 컬러 (WSL추천)
" color koehler     " 컬러 (mobaxterm추천)
```

## root 계정에도 적용하기

- 홈 디렉토리에만 설정파일을 두면 `$vi`할 때만 적용된다.
- `$vi`와 `$sudo vi`는 같은 실행파일이 아니기 때문에, 각각 설정 필요
- `$sudo vi` 할 때도 적용하려면,
  - `/root/` 경로에 `.vimrc` 파일을 두면 된다.
  - 루트경로(`/`)가 아니라 루트경로의 "root 디렉토리" (`/root`) 임에 주의

## 빠른 설정 (온라인 환경)

```sh
# 방법1
wget https://raw.githubusercontent.com/YunanJeong/linux-tips/main/vimrc-settings/.vimrc
sudo cp .vimrc /root/.vimrc && sudo mv .vimrc ~/.vimrc
```

```sh
# 방법2
sudo su -c 'curl https://raw.githubusercontent.com/YunanJeong/linux-tips/main/vimrc-settings/.vimrc' > ~/.vimrc
sudo cp ~/.vimrc /root/.vimrc
```

```sh
# 색상기준값 TERM 변경
echo "TERM=xterm-256color" >> ~/.bashrc
source ~/.bashrc
```
