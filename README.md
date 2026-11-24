# 2026_01_devSetup
미션 01. 내 컴퓨터에 개발자용 '작업실' 꾸미기

1. 프로젝트 개요
```
- 코드를 작성하기 전에 개발 환경을 세팅하고, 누구나 같은 방식으로 실행할 수 있는 워크스테이션을 구축한다.
- CLI(터미널): 작업 디렉토리 구성, 파일/디렉토리 권한 설정
- Docker: 이미지/컨테이너 실행·관리, 로그·리소스 점검
- Dockerfile: 웹 서버 컨테이너화 → 포트 매핑 접속 확인 → 바인드 마운트(변경 반영) / 볼륨(데이터 영속성) 검증
- Git/GitHub: 로컬 버전관리 설정 + VSCode에서 GitHub 저장소 연동
```

2. 실행 환경
```
- OS : Ubuntu 26.04
- Shell : bash
- Docker : 29.9.3
- Git : 2.53.0
```

3. 수행 체크리스트
```
[o] 터미널 기본 조작 및 폴더 구성
[o] 권한 변경 실습 (파일 1개 + 디렉토리 1개)
[o] Docker 설치/점검 (--version, info)
[o] Docker 기본 운영 명령 (images, ps, ps -a, logs, stats)
[o] hello-world 실행
[o] ubuntu 컨테이너 진입 + attach/exec 차이 정리
[o] Dockerfile 커스텀 이미지 빌드/실행
[o] 포트 매핑 접속 (2회: 8080, 8081)
[o] 바인드 마운트 반영
[o] 볼륨 영속성
[o] Git 설정 + VSCode GitHub 연동
```

4. 권한 실습 및 증거
```
<!-- 파일: 644 -> 755 -->
user@4F-73:~/codyssey/practice$ ls -l memo.txt
-rw-r--r-- 1 user user 12 Nov 23 19:51 memo.txt
user@4F-73:~/codyssey/practice$ chmod 755 memo.txt
user@4F-73:~/codyssey/practice$ ls -l memo.txt
-rwxr-xr-x 1 user user 12 Nov 23 19:51 memo.txt

<!-- 디렉토리: 755 -> 700 -->
user@4F-73:~/codyssey/practice$ mkdir perm_dir
user@4F-73:~/codyssey/practice$ ls -ld perm_dir
drwxr-xr-x 2 user user 4096 Nov 23 19:56 perm_dir
user@4F-73:~/codyssey/practice$ chmod 700 perm_dir
user@4F-73:~/codyssey/practice$ ls -ld perm_dir
drwx------ 2 user user 4096 Nov 23 19:56 perm_dir

**권한 해석 규칙**: `rwx` = 4+2+1. 세 자리는 순서대로 소유자/그룹/기타.
- `755` → `rwxr-xr-x` : 소유자 전체, 나머지는 읽기·실행
- `644` → `rw-r--r--` : 소유자 읽기·쓰기, 나머지는 읽기만
- 디렉토리에서 `x`는 "들어갈 수 있음(cd)", `r`은 "목록 볼 수 있음(ls)"
```

5. 터미널 조작 로그
```
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

6. Docker 설치 및 기본 점검
```
user@4F-73:~/codyssey$ docker --version
Docker version 29.9.3, build 5457199
user@4F-73:~/codyssey$ docker info
Client:
 Version:    29.9.3
 Context:    default
 Debug Mode: false
 Plugins:
  agent: Docker AI Agent Runner (Docker Inc.)
    Version:  v1.153.0
    Path:     /usr/local/lib/docker/cli-plugins/docker-agent
  ai: Docker AI Agent - Ask Gordon (Docker Inc.)
    Version:  v1.33.0
    Path:     /usr/local/lib/docker/cli-plugins/docker-ai
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.38.1
    Path:     /usr/local/lib/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v5.7.0
    Path:     /usr/local/lib/docker/cli-plugins/docker-compose
  debug: Get a shell into any image or container (Docker Inc.)
    Version:  0.49.0
    Path:     /usr/local/lib/docker/cli-plugins/docker-debug
  desktop: Docker Desktop commands (Docker Inc.)
    Version:  4.99.0
    Path:     /usr/local/lib/docker/cli-plugins/docker-desktop
  dhi: CLI for managing Docker Hardened Images (Docker Inc.)
    Version:  v0.0.10
    Path:     /usr/local/lib/docker/cli-plugins/docker-dhi
  extension: Manages Docker extensions (Docker Inc.)
    Version:  v0.2.32
    Path:     /usr/local/lib/docker/cli-plugins/docker-extension
  init: Creates Docker-related starter files for your project (Docker Inc.)
    Version:  v1.4.1
    Path:     /usr/local/lib/docker/cli-plugins/docker-init
  mcp: Docker MCP Plugin (Docker Inc.)
    Version:  v0.44.3
    Path:     /usr/local/lib/docker/cli-plugins/docker-mcp
  model: Docker Model Runner (Docker Inc.)
    Version:  v1.2.9
    Path:     /usr/local/lib/docker/cli-plugins/docker-model
  offload: Docker Offload (Docker Inc.)
    Version:  v0.7.36
    Path:     /usr/local/lib/docker/cli-plugins/docker-offload
  pass: Docker Pass Secrets Manager Plugin (beta) (Docker Inc.)
    Version:  v0.3.2
    Path:     /usr/local/lib/docker/cli-plugins/docker-pass
  sandbox: "docker sandbox" is deprecated, use Docker Sandboxes instead (Docker Inc.)
    Version:  v0.13.0
    Path:     /usr/local/lib/docker/cli-plugins/docker-sandbox
  scout: Docker Scout (Docker Inc.)
    Version:  v1.28.0
    Path:     /usr/local/lib/docker/cli-plugins/docker-scout

Server:
 Containers: 1
  Running: 0
  Paused: 0
  Stopped: 1
 Images: 1
 Server Version: 29.9.3
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
 Logging Driver: local
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 CDI spec directories:
  /etc/cdi
  /var/run/cdi
 Discovered Devices:
  cdi: docker.com/gpu=webgpu
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 nvidia runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: b7a25261e029d68978bbf290df0a62fc819b3c51
 runc version: v1.5.2-0-g29dd3dc2
 init version: de40ad0
 Security Options:
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 6.18.58.1-microsoft-standard-WSL2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 8
 Total Memory: 7.605GiB
 Name: docker-desktop
 ID: 47f4f91f-c4ba-4d1b-aa41-4d7cd0b7cfa8
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 HTTP Proxy: http.docker.internal:3128
 HTTPS Proxy: http.docker.internal:3128
 No Proxy: hubproxy.docker.internal
 Labels:
  com.docker.desktop.address=unix:///var/run/docker-cli.sock
 Experimental: false
 Insecure Registries:
  hubproxy.docker.internal:5555
  127.0.0.0/8
  ::1/128
 Live Restore Enabled: false
 Firewall Backend: iptables
```

7. Docker 기본 운영 명령
```
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
                                                             i Info →   U  In Use
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest   1e4c05b897a7       25.9kB         9.49kB    U   
ubuntu:latest        d66b366dac61        163MB         45.9MB        
user@4F-73:~/codyssey$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
user@4F-73:~/codyssey$ docker logs
docker: 'docker logs' requires 1 argument

Usage:  docker logs [OPTIONS] CONTAINER

Run 'docker logs --help' for more information
user@4F-73:~/codyssey$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED       STATUS                   PORTS     NAMES
a1419138c85f   hello-world   "/hello"   4 hours ago   Exited (0) 4 hours ago             eloquent_kalam
user@4F-73:~/codyssey$ docker logs a1419138c85f

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

user@4F-73:~/codyssey$ docker stats --no-stream
```

8. 컨테이너 실행 실습 (ubuntu)
```
user@4F-73:~/codyssey$ docker run -it --name 1e4c05b897a7 ubuntu bash
root@43aae876882d:/# ls
bin   dev  home  lib64  mnt  proc  run   srv  tmp  var
boot  etc  lib   media  opt  root  sbin  sys  usr
root@43aae876882d:/# echo "inside container"
inside container
root@43aae876882d:/# exit
exit
user@4F-73:~/codyssey$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                     PORTS     NAMES
43aae876882d   ubuntu        "bash"     17 seconds ago   Exited (0) 5 seconds ago             1e4c05b897a7
9c02e3606283   ubuntu        "bash"     14 minutes ago   Up 13 minutes                        a1419138c85f
a1419138c85f   hello-world   "/hello"   5 hours ago      Exited (0) 5 hours ago               eloquent_kalam
user@4F-73:~/codyssey$ docker start 1e4c05b897a7
1e4c05b897a7
user@4F-73:~/codyssey$ exec -it 1e4c05b897a7 bash
bash: exec: -i: invalid option
exec: usage: exec [-cl] [-a name] [command [argument ...]] [redirection ...]
user@4F-73:~/codyssey$ docker exec -it 1e4c05b897a7 bash
root@43aae876882d:/# exit
exit
user@4F-73:~/codyssey$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED              STATUS          PORTS     NAMES
43aae876882d   ubuntu    "bash"    About a minute ago   Up 38 seconds             1e4c05b897a7
9c02e3606283   ubuntu    "bash"    15 minutes ago       Up 14 minutes             a1419138c85f

**attach vs exec 관찰 결과**
- `run -it` / `attach`: 컨테이너의 메인 프로세스(bash)에 붙음 → `exit` 하면 메인 프로세스가 끝나서 컨테이너도 종료
- `exec`: 실행 중인 컨테이너에 **새 프로세스**를 띄움 → `exit` 해도 메인 프로세스는 살아 있어 컨테이너 유지
```

9. Git 설정과 푸시
```
user@4F-73:~/codyssey$ git config --global user.email "nunung.dev@gmail.com"
user@4F-73:~/codyssey$ git config --global init.defaultBranch main
user@4F-73:~/codyssey$ git config --list
user.email=nunung.dev@gmail.com
user.name=yeonwooseo
init.defaultbranch=main
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
```