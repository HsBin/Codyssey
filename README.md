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

# Docker info 확인
$ docker info
Client:
 Version:    28.5.2
 Context:    orbstack
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.29.1
    Path:     /Users/bubble09085231/.docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v2.40.3
    Path:     /Users/bubble09085231/.docker/cli-plugins/docker-compose

Server:
 Containers: 5
  Running: 4
  Paused: 0
  Stopped: 1
 Images: 3
 Server Version: 28.5.2
 Storage Driver: overlay2
  Backing Filesystem: btrfs
  Supports d_type: true
  Using metacopy: false
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 CDI spec directories:
  /etc/cdi
  /var/run/cdi
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 1c4457e00facac03ce1d75f7b6777a7a851e5c41
 runc version: d842d7719497cc3b774fd71620278ac9e17710e0
 init version: de40ad0
 Security Options:
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 6.17.8-orbstack-00308-g8f9c941121b1
 Operating System: OrbStack
 OSType: linux
 Architecture: x86_64
 CPUs: 6
 Total Memory: 15.67GiB
 Name: orbstack
 ID: 624d350b-c84d-4c3b-99a3-bbfc63c4b2f7
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Experimental: false
 Insecure Registries:
  ::1/128
  127.0.0.0/8
 Live Restore Enabled: false
 Product License: Community Engine
 Default Address Pools:
   Base: 192.168.97.0/24, Size: 24
   Base: 192.168.107.0/24, Size: 24
   Base: 192.168.117.0/24, Size: 24
   Base: 192.168.147.0/24, Size: 24
   Base: 192.168.148.0/24, Size: 24
   Base: 192.168.155.0/24, Size: 24
   Base: 192.168.156.0/24, Size: 24
   Base: 192.168.158.0/24, Size: 24
   Base: 192.168.163.0/24, Size: 24
   Base: 192.168.164.0/24, Size: 24
   Base: 192.168.165.0/24, Size: 24
   Base: 192.168.166.0/24, Size: 24
   Base: 192.168.167.0/24, Size: 24
   Base: 192.168.171.0/24, Size: 24
   Base: 192.168.172.0/24, Size: 24
   Base: 192.168.181.0/24, Size: 24
   Base: 192.168.183.0/24, Size: 24
   Base: 192.168.186.0/24, Size: 24
   Base: 192.168.207.0/24, Size: 24
   Base: 192.168.214.0/24, Size: 24
   Base: 192.168.215.0/24, Size: 24
   Base: 192.168.216.0/24, Size: 24
   Base: 192.168.223.0/24, Size: 24
   Base: 192.168.227.0/24, Size: 24
   Base: 192.168.228.0/24, Size: 24
   Base: 192.168.229.0/24, Size: 24
   Base: 192.168.237.0/24, Size: 24
   Base: 192.168.239.0/24, Size: 24
   Base: 192.168.242.0/24, Size: 24
   Base: 192.168.247.0/24, Size: 24
   Base: fd07:b51a:cc66:d000::/56, Size: 64

WARNING: DOCKER_INSECURE_NO_IPTABLES_RAW is set


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

### 4.3 커스텀 Dockerfile 작성 및 웹 서버 빌드
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

### 4.4 포트 매핑 및 브라우저 접속 검증
동일한 커스텀 이미지를 포트 매핑(8080,8081)으로 두 개의 독립된 컨테이너로 실행했습니다.

```Bash

# 포트 매핑 컨테이너 실행
$ docker run -d -p 8080:80 --name web-8080 my-web-app:1.0
cee30d97a978557c3dfff47be61596144879e3bed1282aec83049ab6a4ea3a58

$ docker run -d -p 8081:80 --name web-8081 my-web-app:1.0
2e0965f20753afca0f7b4ca09ce808ef2a755e39842ddfa35339e243aec18acf
```
<img width="2022" height="1117" alt="스크린샷 2026-08-12 오후 6 11 49" src="https://github.com/user-attachments/assets/ffdf8262-6379-49ca-bad9-056cbb21de31" />
<img width="1861" height="920" alt="스크린샷 2026-08-12 오후 6 11 57" src="https://github.com/user-attachments/assets/029085ae-ed59-43ad-8cfa-09c69bed0da2" />

```Bash
# 컨테이너 상태 확인
$ docker ps -a
CONTAINER ID   IMAGE            COMMAND                   CREATED       STATUS                   PORTS                                     NAMES
39945b7bda9f   ubuntu           "sleep infinity"          2 hours ago   Up 2 hours                                                         vol-app-2
b3bbe1540475   my-web-app:1.0   "/docker-entrypoint.…"   2 hours ago   Up 2 hours               0.0.0.0:8082->80/tcp, [::]:8082->80/tcp   bind-test
2e0965f20753   my-web-app:1.0   "/docker-entrypoint.…"   2 hours ago   Up 2 hours               0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   web-8081
cee30d97a978   my-web-app:1.0   "/docker-entrypoint.…"   2 hours ago   Up 2 hours               0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   web-8080
d4547fc1648e   ubuntu           "bash"                    2 hours ago   Exited (0) 2 hours ago

# 컨테이너 로그 확인
$ docker logs b3bbe1540475
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/08/12 09:13:28 [notice] 1#1: using the "epoll" event method
2026/08/12 09:13:28 [notice] 1#1: nginx/1.31.3
2026/08/12 09:13:28 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
2026/08/12 09:13:28 [notice] 1#1: OS: Linux 6.17.8-orbstack-00308-g8f9c941121b1
2026/08/12 09:13:28 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 20480:1048576
2026/08/12 09:13:28 [notice] 1#1: start worker processes
2026/08/12 09:13:28 [notice] 1#1: start worker process 30
2026/08/12 09:13:28 [notice] 1#1: start worker process 31
2026/08/12 09:13:28 [notice] 1#1: start worker process 32
2026/08/12 09:13:28 [notice] 1#1: start worker process 33
2026/08/12 09:13:28 [notice] 1#1: start worker process 34
2026/08/12 09:13:28 [notice] 1#1: start worker process 35
192.168.215.1 - - [12/Aug/2026:09:13:56 +0000] "GET / HTTP/1.1" 200 30 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36" "-"
2026/08/12 09:13:56 [error] 31#31: *1 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 192.168.215.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "localhost:8082", referrer: "http://localhost:8082/"
192.168.215.1 - - [12/Aug/2026:09:13:56 +0000] "GET /favicon.ico HTTP/1.1" 404 555 "http://localhost:8082/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36" "-"
192.168.215.1 - - [12/Aug/2026:09:17:21 +0000] "GET / HTTP/1.1" 200 33 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36" "-"

# 컨테이너 리소스 사용 상태 확인
$docker stats
2026/08/12 09:08:43 [notice] 1#1: nginx/1.31.3
2026/08/12 09:08:43 [notice] 1#1: built by gcc 15.2.0 (Alpine 15.2.0) 
CONTAINER ID   NAME        CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O        PIDS 
39945b7bda9f   vol-app-2   0.00%     1.699MiB / 15.67GiB   0.01%     830B / 126B       16.4MB / 0B      1 
b3bbe1540475   bind-test   0.00%     5.402MiB / 15.67GiB   0.03%     5.13kB / 2.94kB   12MB / 8.19kB    7 
2e0965f20753   web-8081    0.00%     5.41MiB / 15.67GiB    0.03%     3.68kB / 1.96kB   4.6MB / 8.19kB   7 
cee30d97a978   web-8080    0.00%     5.012MiB / 15.67GiB   0.03%     4.46kB / 2.27kB   971kB / 8.19kB   7 

```

### 4.5 바인드 마운트 및 볼륨 영속성 검증
[A] 바인드 마운트 (호스트 변경사항 즉시 반영)

```Bash
# 호스트 디렉토리 바인드 마운트 실행
$docker run -d -p 8082:80 -v$(pwd)/app:/usr/share/nginx/html --name bind-test my-web-app:1.0
b3bbe1540475a0d6a194b1570d45fc6532f2f6aaeabb74d10da701067f6bbde5
```
<img width="1970" height="1005" alt="스크린샷 2026-08-12 오후 6 14 07" src="https://github.com/user-attachments/assets/acdcca49-f861-43a7-8bd0-2f6acbd16b67" />

```Bash
# 호스트 파일 내용 수정
$ echo '<h1>Updated via Bind Mount!</h1>' > app/index.html

# 브라우저(http://localhost:8082) 접속 시 변경 사항이 즉시 응답됨을 확인
```

<img width="1188" height="554" alt="스크린샷 2026-08-12 오후 6 17 26" src="https://github.com/user-attachments/assets/bdb90a6b-bbe1-4e62-a980-8d066df27f3d" />


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

### 4.6 Git 및 GitHub 연동

```Bash
# Git 사용자 정보 및 기본 브랜치 설정
$ git config --global user.name "장익빈"
$ git config --global user.email "wkddlrqls908@gmail.com"
$ git config --global init.defaultBranch main

# 설정 결과 확인 (개인정보 마스킹 처리)
$ git config --list
credential.helper=osxkeychain
user.name=장익빈
user.email=wkddlrqls908@gmail.com
init.defaultbranch=main

# GitHub 원격 저장소 연동 및 푸시
$ git init
$git add .$ git commit -m "docs: Add workstation mission README"
$git branch -M main$ git remote add origin [https://github.com/HsBin/Codyssey.git](https://github.com/HsBin/Codyssey.git)
$ git push -u origin main
```

### 5 트러블슈팅
```text
- 이슈 1: Docker 이미지명 공백 오타로 인한 Pull Access Denied 에러
문제 현상: docker run 실행 시 pull access denied for my, repository does not exist 에러 발생.

원인 가설: 명령어 마지막 파라미터 입력 시 my-web-app:1.0 대신 공백이 들어가 my와 web-app:1.0으로 분리되어 인지됨.

확인 과정: 입력 로그 확인 (my web-app:1.0).

해결/대안: 이미지명을 my-web-app:1.0으로 붙여서 재실행하여 컨테이너 정상 생성 및 구동 완료.

- 이슈 2: zsh 쉘에서 특수문자(!) 해석 에러 (event not found)
문제 현상: echo "<h1>Updated via Bind Mount!</h1>" > app/index.html 입력 시 zsh: event not found: </h1> 에러 발생.

원인 가설: zsh 쉘 특성상 큰따옴표("") 내부의 느낌표(!)를 커맨드 히스토리 이벤트 확장 명령으로 해석함.

확인 과정: 이스케이프 문자 미적용 시 발생 확인.

해결/대안: 작은따옴표('')를 사용해 echo '<h1>Updated via Bind Mount!</h1>' > app/index.html로 실행하여 정상 수정 완료.

- 이슈 3: GitHub 비밀번호 인증 중단으로 인한 Push 실패 및 Keychain 적용
문제 현상: git push 진행 시 remote: Invalid username or token. Password authentication is not supported 에러 발생.

원인 가설: GitHub 정책상 계정 비밀번호 인증이 차단되고 Personal Access Token(PAT) 사용이 필수임.

확인 과정: 계정 비밀번호 입력 시 인증 거부 확인.

해결/대안: git config --global credential.helper osxkeychain 명령어로 macOS 열쇠고리 패스워드 저장소를 활성화한 후, 비밀번호 란에 발급받은 Personal Access Token을 입력하여 최종 푸시(main -> main) 완료.
```

### 6. 보안 및 개인정보 보호
본 기술 문서, 실행 로그 및 commit 기록에는 비밀번호, Personal Access Token 등 어떠한 민감 정보도 포함되어 있지 않으며 이메일 정보는 마스킹 처리되었습니다.
