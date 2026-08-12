# 🚀 개발 워크스테이션 구축 및 컨테이너 환경 검증 보고서

## 1. 프로젝트 개요
본 프로젝트는 개발 환경의 일관성과 재현성을 확보하기 위해 터미널(CLI), Docker, Git/GitHub을 활용하여 개발 워크스테이션을 구축하고 이를 검증한 기록입니다. 서울캠퍼스 보안 정책(sudo 권한 제한)에 따라 **OrbStack** 기반의 Docker 실행 환경을 구성하였으며, 커스텀 Nginx 웹 서버 컨테이너화, 포트 매핑, 바인드 마운트 및 볼륨 영속성 검증을 완료하였습니다.

---

## 2. 실행 환경
- **OS:** macOS (Apple Silicon / Intel)
- **Shell / Terminal:** zsh / macOS Terminal
- **Container Runtime:** OrbStack v2.0.5 (sudo 권한 없이 Docker 데몬 구동)
- **Docker Version:** Docker version 28.5.2, build ecc6942
- **Git Version:** git version 2.53.0


---

## 3. 수행 항목 체크리스트
- [x] 터미널 기본 조작 및 작업 디렉토리 구성
- [x] 파일 및 디렉토리 권한 변경 실습 (`chmod`)
- [x] OrbStack 기반 Docker 설치 및 데몬 점검 (`docker info`)
- [x] 기본 컨테이너 실행 실습 (`hello-world`, `ubuntu`)
- [x] 커스텀 Dockerfile 작성 및 Nginx 웹 서버 이미지 빌드
- [x] 포트 매핑 매커니즘 검증 (8080, 8081 포트 다중 연결)
- [x] 바인드 마운트(Bind Mount)를 통한 코드 실시간 반영 검증
- [x] Docker 볼륨(Volume)을 통한 데이터 영속성 검증
- [x] Git 사용자 정보 설정 및 기본 브랜치(main) 구성
- [x] 트러블슈팅 사례 정리 (2건 이상)

---

## 4. 수행 및 검증 로그

### 4.1 터미널 조작 및 권한 관리
작업 디렉토리를 생성하고 파일/디렉토리 권한 제어 실습을 진행했습니다.

```bash
# 디렉토리 생성 및 이동
$ mkdir -p ~/codyssey/worksstation
$ cd ~/codyssey/worksstation
$ pwd
/Users/bubble09085231/codyssey/worksstation

# 파일 및 디렉토리 생성
$ echo "Workstation Test" > sample.txt
$ mkdir test_dir

# 권한 변경 전 확인
$ ls -la
total 8
drwxr-xr-x  4 bubble09085231  bubble09085231  128  8 12 17:57 .
drwxr-xr-x  3 bubble09085231  bubble09085231   96  8 12 17:55 ..
-rw-r--r--  1 bubble09085231  bubble09085231   17  8 12 17:56 sample.txt
drwxr-xr-x  2 bubble09085231  bubble09085231   64  8 12 17:57 test_dir

# 권한 변경 (파일 755, 디렉토리 700)
$ chmod 755 sample.txt
$ chmod 700 test_dir

# 권한 변경 후 비교 확인
$ ls -la
total 8
drwxr-xr-x  4 bubble09085231  bubble09085231  128  8 12 17:57 .
drwxr-xr-x  3 bubble09085231  bubble09085231   96  8 12 17:55 ..
-rwxr-xr-x  1 bubble09085231  bubble09085231   17  8 12 17:56 sample.txt
drwx------  2 bubble09085231  bubble09085231   64  8 12 17:57 test_dir
```

### 4.2 Docker 설치 및 기본 점검
OrbStack 환경에서 Docker 엔진 연동을 확인하고 기본 컨테이너를 실행했습니다.

```bash
# Docker 버전 확인
$ docker --version
Docker version 28.5.2, build ecc6942

# hello-world 실행 성공 확인
$ docker run --rm hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pull complete 
Digest: sha256:7f4da0fc94bcece205a8c0b6f4d11c8196924654ffe5c4d1aa439b7f632048b2
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

# ubuntu 대화형 컨테이너 진입 및 내부 명령어 수행
$ docker run -it --name ubuntu-test ubuntu bash
root@d4547fc1648e:/# ls -la
root@d4547fc1648e:/# echo "Inside Container" > hello.txt
root@d4547fc1648e:/# cat hello.txt
Inside Container
root@d4547fc1648e:/# exit
```

###4.3 커스텀 Cockerfile 작성 및 웹 서버 빌드
nginx:alpine 베이스 이미지와 커스텀 HTML을 결합한 웹 서버 이미지를 구축했습니다.


- 프로젝트 구조:
```text
worksstation/
├── Dockerfile
├── sample.txt
├── test_dir/
└── app/
    └── index.html
```
- Dockerfile 내용:
```Bash
FROM nginx:alpine
COPY app/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
- 빌드 명령어 및 결과:
```Bash
$mkdir app$ echo "<h1>My Custom Web Server</h1>" > app/index.html
$vi Dockerfile$ docker build -t my-web-app:1.0 .
[+] Building 7.1s (7/7) FINISHED                                                  docker:orbstack
 => naming to docker.io/library/my-web-app:1.0
```

###4.4 포트 매핑 및 브라우저 접속 검증
동일한 커스텀 이미지를 포트 매핑(8080,8081)으로 두 개의 독립된 컨테이너로 실행했습니다.

```Bash

# 포트 매핑 컨테이너 실행
$ docker run -d -p 8080:80 --name web-8080 my-web-app:1.0
cee30d97a978557c3dfff47be61596144879e3bed1282aec83049ab6a4ea3a58

$ docker run -d -p 8081:80 --name web-8081 my-web-app:1.0
2e0965f20753afca0f7b4ca09ce808ef2a755e39842ddfa35339e243aec18acf

# 컨테이너 상태 확인
$ docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                    NAMES
2e0965f20753   my-web-app:1.0   "/docker-entrypoint.…"   4 seconds ago    Up 3 seconds    0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   web-8081
cee30d97a978   my-web-app:1.0   "/docker-entrypoint.…"   41 seconds ago   Up 39 seconds   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   web-8080
```

###4.5 바인드 마운트 및 볼륨 영속성 검증
[A] 바인드 마운트 (호스트 변경사항 즉시 반영)
# 호스트 디렉토리 바인드 마운트 실행

```Bash
$docker run -d -p 8082:80 -v$(pwd)/app:/usr/share/nginx/html --name bind-test my-web-app:1.0
b3bbe1540475a0d6a194b1570d45fc6532f2f6aaeabb74d10da701067f6bbde5

# 호스트 파일 내용 수정
$ echo '<h1>Updated via Bind Mount!</h1>' > app/index.html

# 브라우저(http://localhost:8082) 접속 시 변경 사항이 즉시 응답됨을 확인
```

[B] Docker 볼륨 영속성 (컨테이너 삭제 후 데이터 유지)

```Bash
# 1. 볼륨 생성
$ docker volume create my-app-data
my-app-data

# 2. 첫 번째 컨테이너 생성 및 볼륨 데이터 작성
$ docker run -d --name vol-app-1 -v my-app-data:/data ubuntu sleep infinity
78ae080239239a29e03d65aa48a1562e7aaddb94c1e3d1e4c5a3e4d0a6f77c93

$ docker exec vol-app-1 sh -c "echo 'Persistent Data' > /data/hello.txt"
$ docker exec vol-app-1 cat /data/hello.txt
Persistent Data

# 3. 컨테이너 강제 삭제
$ docker rm -f vol-app-1
vol-app-1

# 4. 두 번째 컨테이너 생성 후 동일 볼륨 연결하여 데이터 유지 검증
$ docker run -d --name vol-app-2 -v my-app-data:/data ubuntu sleep infinity
39945b7bda9f39b2d0f45d2b58f30b60266ece13c3fc56205acc34cd1e4bd1eb

$ docker exec vol-app-2 cat /data/hello.txt
Persistent Data
```

###4.6 Git 및 GitHub 연동

```Bash
# Git 사용자 정보 및 기본 브랜치 설정
$ git config --global user.name "장익빈"
$ git config --global user.email "your_email@example.com"
$ git config --global init.defaultBranch main

# 설정 결과 확인 (개인정보 마스킹 처리)
$ git config --list
credential.helper=osxkeychain
user.name=장익빈
user.email=your_***@example.com
init.defaultbranch=main

# GitHub 원격 저장소 연동 및 푸시
$ git init
$git add .$ git commit -m "docs: Add workstation mission README"
$git branch -M main$ git remote add origin [https://github.com/HsBin/Codyssey.git](https://github.com/HsBin/Codyssey.git)
$ git push -u origin main
```

###5 트러블슈팅
이슈 1: Docker 이미지명 공백 오타로 인한 Pull Access Denied 에러
문제 현상: docker run 실행 시 pull access denied for my, repository does not exist 에러 발생.

원인 가설: 명령어 마지막 파라미터 입력 시 my-web-app:1.0 대신 공백이 들어가 my와 web-app:1.0으로 분리되어 인지됨.

확인 과정: 입력 로그 확인 (my web-app:1.0).

해결/대안: 이미지명을 my-web-app:1.0으로 붙여서 재실행하여 컨테이너 정상 생성 및 구동 완료.

이슈 2: zsh 쉘에서 특수문자(!) 해석 에러 (event not found)
문제 현상: echo "<h1>Updated via Bind Mount!</h1>" > app/index.html 입력 시 zsh: event not found: </h1> 에러 발생.

원인 가설: zsh 쉘 특성상 큰따옴표("") 내부의 느낌표(!)를 커맨드 히스토리 이벤트 확장 명령으로 해석함.

확인 과정: 이스케이프 문자 미적용 시 발생 확인.

해결/대안: 작은따옴표('')를 사용해 echo '<h1>Updated via Bind Mount!</h1>' > app/index.html로 실행하여 정상 수정 완료.

이슈 3: GitHub 비밀번호 인증 중단으로 인한 Push 실패 및 Keychain 적용
문제 현상: git push 진행 시 remote: Invalid username or token. Password authentication is not supported 에러 발생.

원인 가설: GitHub 정책상 계정 비밀번호 인증이 차단되고 Personal Access Token(PAT) 사용이 필수임.

확인 과정: 계정 비밀번호 입력 시 인증 거부 확인.

해결/대안: git config --global credential.helper osxkeychain 명령어로 macOS 열쇠고리 패스워드 저장소를 활성화한 후, 비밀번호 란에 발급받은 Personal Access Token을 입력하여 최종 푸시(main -> main) 완료.

###6. 보안 및 개인정보 보호
본 기술 문서, 실행 로그 및 commit 기록에는 비밀번호, Personal Access Token 등 어떠한 민감 정보도 포함되어 있지 않으며 이메일 정보는 마스킹 처리되었습니다.
