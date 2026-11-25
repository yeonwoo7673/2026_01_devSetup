# 2026_01_devSetup
미션 01. 내 컴퓨터에 개발자용 '작업실' 꾸미기

## 1. 프로젝트 개요
- 코드를 작성하기 전에 개발 환경을 세팅하고, 누구나 같은 방식으로 실행할 수 있는 워크스테이션을 구축한다.
- **CLI(터미널)**: 작업 디렉토리 구성, 파일/디렉토리 권한 설정
- **Docker**: 이미지/컨테이너 실행·관리, 로그·리소스 점검
- **Dockerfile**: 웹 서버 컨테이너화 → 포트 매핑 접속 확인 → 바인드 마운트(변경 반영) / 볼륨(데이터 영속성) 검증
- **Git/GitHub**: 로컬 버전관리 설정 + VSCode에서 GitHub 저장소 연동

## 2. 실행 환경
| 항목 | 값 |
|---|---|
| Host OS | Windows (공용 PC) |
| Linux | WSL2 + Ubuntu 26.04 |
| Shell / 터미널 | bash / VSCode 통합 터미널 (WSL 확장) |
| Docker | Docker Desktop, Engine 29.9.3 (WSL Integration) |
| Git | 2.53.0 |

![실행 환경](docs/images/01.%20실행환경.png)

> ⚠️ 재현 시 주의
> - 공용 PC라 관리자 권한이 없어 WSL2 + Docker Desktop(사용자별 설치)으로 구성했다. ([15. 트러블슈팅](#15-트러블슈팅) 참고)
> - 실습은 WSL의 리눅스 홈(`~`)에서 진행했다. `/mnt/c/...`(Windows 디스크)에서는 `chmod`가 제대로 반영되지 않을 수 있다.
> - Linux/macOS에서는 Docker Engine만 설치하면 같은 명령으로 재현할 수 있다.

## 3. 수행 체크리스트
<!-- 실제로 끝낸 항목만 [x]. 남은 항목은 완료 후 체크 -->
- [x] 터미널 기본 조작 및 폴더 구성
- [x] 권한 변경 실습 (파일 1개 + 디렉토리 1개)
- [x] Docker 설치/점검 (`--version`, `info`)
- [ ] Docker 기본 운영 명령 (`images`, `ps`, `ps -a`, `logs`, `stats`) ← stats 출력 보완 필요
- [ ] hello-world 실행 ← 실행 로그 보완 필요
- [x] ubuntu 컨테이너 진입 + attach/exec 차이 정리
- [ ] Dockerfile 커스텀 이미지 빌드/실행
- [ ] 포트 매핑 접속 (2회: 8080, 8081)
- [ ] 바인드 마운트 반영
- [ ] 볼륨 영속성
- [ ] Git 설정 + VSCode GitHub 연동 ← VSCode 캡처 필요

## 4. 검증 방법 및 증거
| 항목 | 검증 명령 | 확인 내용 | 증거 위치 |
|---|---|---|---|
| 실행 환경 | `cat /etc/os-release`, `docker --version`, `git --version` | OS·Docker·Git 버전 출력 | [2. 실행 환경](#2-실행-환경), [캡처1](docs/images/01.%20실행환경.png) |
| 터미널 조작 | `pwd`, `ls -la`, `mkdir`, `cd`, `touch`, `echo >`, `cat`, `cp`, `mv`, `rm` | 생성·복사·이동·이름 변경·삭제 후 `ls -la`로 반영 확인 | [5. 터미널 조작 로그](#5-터미널-조작-로그), [캡처2](docs/images/02-1.터미널%20조작%20로그.png), [캡처3](docs/images/02-2.터미널%20조작%20로그.png), [캡처4](docs/images/02-3.터미널%20조작%20로그.png) |
| 권한 (파일) | `ls -l` → `chmod 755` → `ls -l` | `-rw-r--r--`(644) → `-rwxr-xr-x`(755) | [6. 권한 실습](#6-권한-실습), [캡처5](docs/images/03.권한%20실습.png) |
| 권한 (디렉토리) | `ls -ld` → `chmod 700` → `ls -ld` | `drwxr-xr-x`(755) → `drwx------`(700) | [6. 권한 실습](#6-권한-실습), [캡처5](docs/images/03.권한%20실습.png) |
| Docker 설치 | `docker --version` | `Docker version 29.9.3` 출력 | [7. Docker 점검](#7-docker-설치-및-기본-점검), [캡처6](docs/images/04-1.Docker%20설치%20및%20기본%20점검.png) |
| 데몬 동작 | `docker info` | Server 섹션 출력 (`Server Version: 29.9.3`, `OSType: linux`) | [7. Docker 점검](#7-docker-설치-및-기본-점검), [캡처7](docs/images/04-2.Docker%20설치%20및%20기본%20점검.png) |
| 이미지 관리 | `docker pull ubuntu`, `docker images` | `hello-world`, `ubuntu` 이미지 목록 | [8. 운영 명령](#8-docker-기본-운영-명령) |
| hello-world | `docker run hello-world`, `docker logs <ID>` | `Hello from Docker!` 출력 | [8. 운영 명령](#8-docker-기본-운영-명령) |
| 컨테이너 상태 | `docker ps`, `docker ps -a` | 실행 중(Up) / 종료(Exited) 구분 | [8. 운영 명령](#8-docker-기본-운영-명령) |
| 리소스 확인 | `docker stats --no-stream` | 컨테이너별 CPU·메모리 사용량 | [8. 운영 명령](#8-docker-기본-운영-명령) |
| ubuntu 컨테이너 | `docker run -it ... ubuntu bash` → `ls`, `echo` | 컨테이너 내부 명령 실행 결과 | [9. 컨테이너 실습](#9-컨테이너-실행-실습-ubuntu) |
| attach vs exec | `exit` 후 `docker ps -a` / `docker exec` 후 `exit` → `docker ps` | run -it 종료 시 Exited, exec 종료 후에도 Up 유지 | [9. 컨테이너 실습](#9-컨테이너-실행-실습-ubuntu) |
| 커스텀 이미지 | `docker build -t my-web:1.0 .`, `docker images` | `my-web:1.0` 이미지 생성 | [10. Dockerfile](#10-dockerfile-커스텀-이미지) |
| 포트 매핑 | `curl localhost:8080`, `curl localhost:8081`, 브라우저 접속 | 두 포트 모두 같은 페이지 응답 | [11. 포트 매핑](#11-포트-매핑-접속), [8080 캡처](docs/images/port-8080.png), [8081 캡처](docs/images/port-8081.png) |
| 바인드 마운트 | 호스트 `site/index.html` 수정 전·후 `curl` | 재빌드 없이 변경 반영 | [12. 바인드 마운트](#12-바인드-마운트-반영) |
| 볼륨 영속성 | 컨테이너 삭제 후 새 컨테이너에서 `cat /data/hello.txt` | 삭제 후에도 `hi` 유지 | [13. 볼륨](#13-볼륨-영속성) |
| Git 설정 | `git config --list` | `user.name`, `user.email`(마스킹), `init.defaultbranch=main` | [14. Git](#14-git-설정-및-github-연동) |
| GitHub 연동 | `git remote -v`, `git push origin main`, VSCode 계정 | push 성공(`main -> main`), VSCode GitHub 로그인 | [14. Git](#14-git-설정-및-github-연동), [VSCode 캡처](docs/images/vscode-github.png) |

## 5. 터미널 조작 로그
```bash
user@4F-73:~/codyssey$ pwd
/home/user/codyssey
user@4F-73:~/codyssey$ ls -la
total 16
drwxr-xr-x 4 user user 4096 Nov 23 19:44 .
drwxr-x--- 8 user user 4096 Nov 23 15:57 ..
drwxr-xr-x 5 user user 4096 Nov 23 19:49 2026_01_devSetup
drwxr-xr-x 2 user user 4096 Nov 23 19:29 logs
user@4F-73:~/codyssey$ mkdir -p practice/sub
user@4F-73:~/codyssey$ cd practice
user@4F-73:~/codyssey/practice$ touch empty.txt
user@4F-73:~/codyssey/practice$ echo "hello world" > memo.txt
user@4F-73:~/codyssey/practice$ cat memo.txt
hello world
user@4F-73:~/codyssey/practice$ cp memo.txt memo_copy.txt
user@4F-73:~/codyssey/practice$ mv memo_copy.txt sub/
user@4F-73:~/codyssey/practice$ mv sub/memo_copy.txt sub/renamed.txt
user@4F-73:~/codyssey/practice$ ls -la sub
total 12
drwxr-xr-x 2 user user 4096 Nov 23 19:52 .
drwxr-xr-x 3 user user 4096 Nov 23 19:52 ..
-rw-r--r-- 1 user user   12 Nov 23 19:51 renamed.txt
user@4F-73:~/codyssey/practice$ rm empty.txt
user@4F-73:~/codyssey/practice$ rm -r sub
user@4F-73:~/codyssey/practice$ ls -la
total 12
drwxr-xr-x 2 user user 4096 Nov 23 19:53 .
drwxr-xr-x 5 user user 4096 Nov 23 19:50 ..
-rw-r--r-- 1 user user   12 Nov 23 19:51 memo.txt
```

| 수행 항목 | 사용 명령 |
|---|---|
| 현재 위치 확인 | `pwd` |
| 목록 확인 (숨김 파일 포함) | `ls -la` |
| 생성 / 이동 | `mkdir -p`, `cd` |
| 빈 파일 생성 / 내용 확인 | `touch`, `cat` |
| 복사 / 이동·이름 변경 / 삭제 | `cp`, `mv`, `rm`, `rm -r` |

## 6. 권한 실습
```bash
# 파일: 644 → 755
user@4F-73:~/codyssey/practice$ ls -l memo.txt
-rw-r--r-- 1 user user 12 Nov 23 19:51 memo.txt
user@4F-73:~/codyssey/practice$ chmod 755 memo.txt
user@4F-73:~/codyssey/practice$ ls -l memo.txt
-rwxr-xr-x 1 user user 12 Nov 23 19:51 memo.txt

# 디렉토리: 755 → 700
user@4F-73:~/codyssey/practice$ mkdir perm_dir
user@4F-73:~/codyssey/practice$ ls -ld perm_dir
drwxr-xr-x 2 user user 4096 Nov 23 19:56 perm_dir
user@4F-73:~/codyssey/practice$ chmod 700 perm_dir
user@4F-73:~/codyssey/practice$ ls -ld perm_dir
drwx------ 2 user user 4096 Nov 23 19:56 perm_dir
```

**권한 해석 규칙**: `r`=4, `w`=2, `x`=1을 더한 숫자 세 자리가 순서대로 소유자/그룹/기타 사용자의 권한이다.
- `755` → `rwxr-xr-x`: 소유자는 전체, 나머지는 읽기·실행
- `644` → `rw-r--r--`: 소유자는 읽기·쓰기, 나머지는 읽기만
- `700` → `rwx------`: 소유자만 접근 가능
- 디렉토리에서 `x`는 "들어갈 수 있음(cd)", `r`은 "목록을 볼 수 있음(ls)"

## 7. Docker 설치 및 기본 점검
```bash
user@4F-73:~/codyssey$ docker --version
Docker version 29.9.3, build 5457199

user@4F-73:~/codyssey$ docker info
Client:
 Version:    29.9.3
 Context:    default
 Debug Mode: false
 Plugins:
  (플러그인 목록 생략)

Server:
 Containers: 1
  Running: 0
  Paused: 0
  Stopped: 1
 Images: 1
 Server Version: 29.9.3
 Storage Driver: overlayfs
 Logging Driver: local
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Kernel Version: 6.18.58.1-microsoft-standard-WSL2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 8
 Total Memory: 7.605GiB
 Name: docker-desktop
 Docker Root Dir: /var/lib/docker
 (이하 생략)
```
- `Server:` 섹션이 출력되면 Docker 데몬이 정상 동작 중이다.
- `Kernel Version`에 `WSL2`, `Operating System`에 `Docker Desktop`이 나오므로 WSL2 기반 Docker Desktop 엔진임을 확인할 수 있다.

## 8. Docker 기본 운영 명령
```bash
# hello-world 실행
user@4F-73:~/codyssey$ docker run hello-world
(실행 출력 붙여넣기 — Hello from Docker! ...)

# 이미지 다운로드 / 목록
user@4F-73:~/codyssey$ docker pull ubuntu
Using default tag: latest
latest: Pulling from library/ubuntu
96aae9022e0e: Pull complete
517b871c26ea: Pull complete
e211d985152c: Download complete
Digest: sha256:d66b366dac61b575bee2aef07e9c26e8070096fbe84a3d4d3eb0da069b5d76db
Status: Downloaded newer image for ubuntu:latest
docker.io/library/ubuntu:latest

user@4F-73:~/codyssey$ docker images
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest   1e4c05b897a7       25.9kB         9.49kB    U
ubuntu:latest        d66b366dac61        163MB         45.9MB

# 컨테이너 목록
user@4F-73:~/codyssey$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
user@4F-73:~/codyssey$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED       STATUS                   PORTS     NAMES
a1419138c85f   hello-world   "/hello"   4 hours ago   Exited (0) 4 hours ago             eloquent_kalam

# 로그 확인
user@4F-73:~/codyssey$ docker logs a1419138c85f

Hello from Docker!
This message shows that your installation appears to be working correctly.
(이하 생략)

# 리소스 확인 (실행 중인 컨테이너가 있을 때)
user@4F-73:~/codyssey$ docker stats --no-stream
(출력 붙여넣기)
```

## 9. 컨테이너 실행 실습 (ubuntu)
```bash
# run -it 로 진입 → exit
user@4F-73:~/codyssey$ docker run -it --name my-ubuntu ubuntu bash
root@xxxx:/# ls
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr
root@xxxx:/# echo "inside container"
inside container
root@xxxx:/# exit
exit
user@4F-73:~/codyssey$ docker ps -a
(my-ubuntu 가 Exited 상태인 출력)

# exec 로 진입 → exit
user@4F-73:~/codyssey$ docker start my-ubuntu
my-ubuntu
user@4F-73:~/codyssey$ docker exec -it my-ubuntu bash
root@xxxx:/# exit
exit
user@4F-73:~/codyssey$ docker ps
(my-ubuntu 가 Up 상태로 유지된 출력)
```

**attach vs exec 관찰 결과**
- `run -it` / `attach`: 컨테이너의 메인 프로세스(bash)에 붙는다. `exit` 하면 메인 프로세스가 끝나서 컨테이너도 종료(Exited)된다.
- `exec`: 실행 중인 컨테이너 안에 **새 프로세스**를 띄운다. `exit` 해도 메인 프로세스는 살아 있어서 컨테이너가 유지(Up)된다.

## 10. Dockerfile 커스텀 이미지
- 선택 방식: **(A) 웹 서버 베이스 이미지 활용**
- 베이스 이미지: `nginx:alpine` (경량 Alpine Linux + NGINX 공식 이미지)

```dockerfile
FROM nginx:alpine
LABEL org.opencontainers.image.title="yeonwoo-devsetup-web"
ENV APP_ENV=dev
COPY site/ /usr/share/nginx/html/
EXPOSE 80
```

| 커스텀 포인트 | 목적 |
|---|---|
| `LABEL` | 이미지 메타데이터(이름) 기록 → 이미지 식별 |
| `ENV APP_ENV=dev` | 실행 모드를 코드가 아닌 설정으로 분리 |
| `COPY site/` | 기본 NGINX 페이지를 내 정적 페이지로 교체 |
| `EXPOSE 80` | 컨테이너가 사용하는 포트 문서화 |

```bash
user@4F-73:~/codyssey/2026_01_devSetup$ docker build -t my-web:1.0 .
(출력 붙여넣기)
user@4F-73:~/codyssey/2026_01_devSetup$ docker images | grep my-web
(출력 붙여넣기)
```

## 11. 포트 매핑 접속
```bash
user@4F-73:~/codyssey/2026_01_devSetup$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
user@4F-73:~/codyssey/2026_01_devSetup$ curl http://localhost:8080
(출력 붙여넣기)

user@4F-73:~/codyssey/2026_01_devSetup$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
user@4F-73:~/codyssey/2026_01_devSetup$ curl http://localhost:8081
(출력 붙여넣기)

user@4F-73:~/codyssey/2026_01_devSetup$ docker ps
(출력 붙여넣기)
```
![8080 접속](docs/images/port-8080.png)
![8081 접속](docs/images/port-8081.png)

## 12. 바인드 마운트 반영
```bash
user@4F-73:~/codyssey/2026_01_devSetup$ docker run -d -p 8082:80 --name my-web-bind \
    -v "$(pwd)/site":/usr/share/nginx/html my-web:1.0
user@4F-73:~/codyssey/2026_01_devSetup$ curl http://localhost:8082
(변경 전 출력)

user@4F-73:~/codyssey/2026_01_devSetup$ echo "<h1>bind mount updated</h1>" > site/index.html
user@4F-73:~/codyssey/2026_01_devSetup$ curl http://localhost:8082
(변경 후 출력)
```
- 이미지를 다시 빌드하지 않았는데 호스트 파일 수정이 바로 반영된다 → 컨테이너가 호스트 폴더를 직접 보고 있다.

## 13. 볼륨 영속성
```bash
user@4F-73:~/codyssey$ docker volume create mydata
user@4F-73:~/codyssey$ docker volume ls
(출력 붙여넣기)

user@4F-73:~/codyssey$ docker run -d --name vol-test -v mydata:/data ubuntu sleep infinity
user@4F-73:~/codyssey$ docker exec vol-test bash -lc "echo hi > /data/hello.txt && cat /data/hello.txt"
(출력 붙여넣기)
user@4F-73:~/codyssey$ docker rm -f vol-test

user@4F-73:~/codyssey$ docker run -d --name vol-test2 -v mydata:/data ubuntu sleep infinity
user@4F-73:~/codyssey$ docker exec vol-test2 bash -lc "cat /data/hello.txt"
(출력 붙여넣기)
```
- 컨테이너(vol-test)를 삭제한 뒤 새 컨테이너(vol-test2)에서도 같은 데이터가 보인다 → 데이터는 컨테이너가 아니라 볼륨에 저장된다.

## 14. Git 설정 및 GitHub 연동
```bash
user@4F-73:~/codyssey/2026_01_devSetup$ git config --global user.name "yeonwooseo"
user@4F-73:~/codyssey/2026_01_devSetup$ git config --global user.email "nun***@gmail.com"
user@4F-73:~/codyssey/2026_01_devSetup$ git config --global init.defaultBranch main
user@4F-73:~/codyssey/2026_01_devSetup$ git config --list
user.email=nun***@gmail.com
user.name=yeonwooseo
init.defaultbranch=main
(이하 core.* 등)

user@4F-73:~/codyssey/2026_01_devSetup$ git remote -v
(출력 붙여넣기)

user@4F-73:~/codyssey/2026_01_devSetup$ git status
On branch main
Your branch is up to date with 'origin/main'.
...
user@4F-73:~/codyssey/2026_01_devSetup$ git add .
user@4F-73:~/codyssey/2026_01_devSetup$ git commit -m "[docs]:261124_git 설정과 푸시"
[main 7af0cb0] [docs]:261124_git 설정과 푸시
 1 file changed, 14 insertions(+)
user@4F-73:~/codyssey/2026_01_devSetup$ git push origin main
...
To https://github.com/yeonwoo7673/2026_01_devSetup.git
   112e54e..7af0cb0  main -> main
```
![VSCode GitHub 연동](docs/images/vscode-github.png)
<!-- 왼쪽 아래 WSL: Ubuntu + 계정 아이콘(GitHub 로그인) + 소스 제어 탭이 보이게 캡처 -->

## 15. 트러블슈팅

### 1) 공용 PC에서 Docker Desktop 설치 실패
- **문제**: 설치 중 `Docker Desktop requires the "Virtual Machine Platform" Windows feature, which is not enabled` 오류
- **원인 가설**: 해당 Windows 기능을 켜려면 관리자 권한이 필요한데, 공용 PC라 권한이 없다.
- **확인**: 설치 프로그램 안내 메시지, `wsl --status`
- **해결**: (실제로 해결한 방법 기록 — 예: 관리자에게 `wsl --install` 요청 후 WSL2 + Ubuntu 설치 → Docker Desktop 사용자별 설치 → WSL Integration 활성화)

### 2) 상위 폴더에 중첩된 Git 저장소로 commit/push 실패
- **문제**: `~/codyssey`에서 commit 시 `modified: 2026_01_devSetup (modified content)`만 반복되고, `git push origin main` 시 `src refspec main does not match any` 오류
- **원인 가설**: 저장소 바깥 폴더(`~/codyssey`)도 Git 저장소(`master` 브랜치)로 초기화돼 있어서, 진짜 저장소가 하위 저장소로 취급됐다.
- **확인**
  ```bash
  user@4F-73:~/codyssey$ git config --list   # core.* 항목 출력 → 여기도 저장소
  user@4F-73:~/codyssey$ git log --oneline
  6b37793 (HEAD -> master) [docs]:README.md edit
  ...
  user@4F-73:~/codyssey$ ls -a
  .  ..  .git  2026_01_devSetup  logs  practice
  ```
- **해결**: 진짜 저장소 폴더로 이동해서 실행 → `main -> main` push 성공
  ```bash
  user@4F-73:~/codyssey$ cd ~/codyssey/2026_01_devSetup
  user@4F-73:~/codyssey/2026_01_devSetup$ git push origin main
  ```
- **추가로 배운 점**: `git push main`은 `main`을 원격 이름으로 해석한다. 형식은 `git push <원격> <브랜치>`다.

### 3) `docker logs` / `exec` 명령 실수
- **문제 1**: `docker logs` → `'docker logs' requires 1 argument`
  - **해결**: `docker ps -a`로 컨테이너 ID 확인 후 `docker logs a1419138c85f`
- **문제 2**: `exec -it ... bash` → `bash: exec: -i: invalid option`
  - **원인**: `docker`를 빼먹어서 bash 내장 명령 `exec`로 실행됐다.
  - **해결**: `docker exec -it <컨테이너> bash`

## 16. 개념 정리
- **절대 경로 vs 상대 경로**: 절대 경로는 `/`부터 시작하는 전체 경로(`/home/user/codyssey`)라서 어디서 실행해도 같은 위치를 가리킨다. 상대 경로는 현재 위치 기준(`./practice`, `../`)이다. `~`는 홈 디렉토리(`/home/user`)의 축약이다.
- **파일 권한**: [6. 권한 실습](#6-권한-실습) 참고
- **커스텀 이미지**: 공식 베이스 이미지(`nginx:alpine`) 위에 내 설정·콘텐츠만 덧입혀서, 누구나 같은 결과를 재현하는 이미지를 만든다.
- **포트 매핑이 필요한 이유**: 컨테이너는 격리된 네트워크를 갖기 때문에 내부 포트(80)에 호스트가 바로 접근할 수 없다. `-p 호스트:컨테이너`로 연결해야 접속할 수 있고, 호스트 포트만 바꾸면 같은 이미지를 여러 개 띄울 수 있다.
- **바인드 마운트 vs 볼륨**: 바인드 마운트는 호스트의 특정 폴더를 연결하는 방식이라 개발 중 코드 변경 반영에 적합하다. 볼륨은 Docker가 관리하는 저장 공간이라, 컨테이너를 삭제해도 데이터가 남아서 DB 같은 영속 데이터에 쓴다.
- **Git vs GitHub**: Git은 내 PC에서 변경 이력을 관리하는 로컬 버전관리 도구다. GitHub는 Git 저장소를 원격에 올려 공유하고 협업(PR, 이슈)하는 플랫폼이다.
