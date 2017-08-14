---
layout: post
title: "터미널에서 gradlew 실행시 jdk 설정"
author: Derek Choi
comments: true
---
서버와 안드로이드 개발을 한 PC에서 하다보니 jdk 버전을 번갈아 가면서 사용해야 하는 상황이 발생했다.
gradle 명령을 터미널에서 할때 jdk를 설정할 수 있는 방법을 찾았다.

## 방법
/home/claztec/Program/jdk1.8.0_25는 java 1.8 버전이 있는 디렉토리.

```bash
claztec@claztec-ThinkPad:~/git/beauty$ ./gradlew -Dorg.gradle.java.home=/home/claztec/Program/jdk1.8.0_25 web:defaultData
```






