---
layout: post
title: "Python3 Virtualenv 설정"
author: Derek Choi
---
python2 와 python3 가 같이 설치되어 있는 PC에서 python3로 virtualenv를 설정하기

## 작업 디렉토리 만들기
tools 라는 이름의 디렉토리를 임의로 만들었다.

```bash
claztec@claztec-ThinkPad:~/git$ mkdir tools; cd tools
claztec@claztec-ThinkPad:~/git/tools$
```

## virtualenv 설정
-p python3 를 설정하는게 포인트

```bash
(venv)claztec@claztec-ThinkPad:~/git/tools$ virtualenv -p /usr/bin/python3 venv
Running virtualenv with interpreter /usr/bin/python3
Using base prefix '/usr'
New python executable in venv/bin/python3
Also creating executable in venv/bin/python
Installing setuptools, pip, wheel...done.
(venv)claztec@claztec-ThinkPad:~/git/tools$ ll
합계 16
drwxrwxr-x  3 claztec claztec 4096 11월 13 15:45 ./
drwxrwxr-x 23 claztec claztec 4096 11월 13 15:44 ../
drwxrwxr-x  5 claztec claztec 4096 11월 13 15:45 venv/
```

## python3 activate
```bash
(venv)claztec@claztec-ThinkPad:~/git/tools$ . venv/bin/activate
(venv)claztec@claztec-ThinkPad:~/git/tools$ python --version
Python 3.4.3+
(venv)claztec@claztec-ThinkPad:~/git/tools$
```