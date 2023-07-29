# permission-denined
- 파일권한 변경시 사용
- 특히 *.sh파일을 새로 생성하면 실행가능하도록 허용필요 
```shell
sudo chmod +x {대상file}
```

# vscode로 wsl에서 작업시 권한 문제로 수정이 안된다고 할 때
- 보통, 파일들을 다른 디렉토리로 복제하고 작업을 시도할 때 이런 문제가 발생
```shell
sudo chown -R {계정} {대상디렉토리}
```