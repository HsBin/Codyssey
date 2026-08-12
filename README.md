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
$ mkdir -p ~/codyssey/workstation && cd ~/codyssey/workstation
$ pwd
/Users/bubble09085231/codyssey/workstation

# 파일 및 디렉토리 생성
$ echo "Workstation Test" > sample.txt
$ mkdir test_dir

# 권한 변경 전 확인
$ ls -la
drwxr-xr-x  3 bubble09085231  staff    96  8 12 17:00 .
-rw-r--r--  1 bubble09085231  staff    17  8 12 17:00 sample.txt
drwxr-xr-x  2 bubble09085231  staff    64  8 12 17:00 test_dir

# 권한 변경 (파일 755, 디렉토리 700)
$ chmod 755 sample.txt
$ chmod 700 test_dir

# 권한 변경 후 비교 확인
$ ls -la
-rwxr-xr-x  1 bubble09085231  staff    17  8 12 17:00 sample.txt
drwx------  2 bubble09085231  staff    64  8 12 17:00 test_dir
