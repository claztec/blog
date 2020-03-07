---
layout: post
title: ubuntu에서 mysql 8 설치하기
author: Derek Choi
comments: true
---

## 환경

ubuntu 19.10
mysql 8

## 설치
### repository update

```
sudo apt update
sudo apt upgrade
```

### mysql 설치
너무 쉽다. 우분투 19.10 부터는 mysql 8 이 기본
```
sudo apt install mysql-server
```

### mysql 설정

root password 설정 (여기서는 임의로 XXXXX로 설정)

```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'XXXXX';

FLUSH PRIVILEGES;
```

종료
```
exit
```

### database 생성

database를 생성한다.
위에서 password 설정을 해서 password를 치고 들어가야 한다.

```
sudo mysql -u root -p

create database ziel_piano;

```


### 계정 생성

root 로 접속할게 아니기 때문에 사용할 계정을 생성 (임의로 XXXXX로 설정)

```
CREATE USER 'ziel'@'%' IDENTIFIED BY 'XXXXX';
```

### 계정 권한 추가
새로 생성한 계정에 데이터베이스 접속 권한을 준다.
```
GRANT ALL PRIVILEGES ON ziel_piano.* to 'ziel'@'%';
```

### bind-address
mysql 8 은 경로가 달라졌다.  
```
sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf
```
bind-address 값을 변경한다.   
```
#bind-address           = 127.0.0.1
bind-address            = 0.0.0.0
```
mysql 재시작  
```
sudo systemctl restart mysql.service
```

### datagrip 에서 접속
serverTimezone 값을 같이 넣어줘야 한다.  
```
?serverTimezone=Asia/Seoul
``
관련링크  
[DataGrip 2019.1 连接mysql 8.0.16](https://blog.csdn.net/weixin_41843699/article/details/91354992){:target="_blank"}


## 참고

[How to install MySQL in Ubuntu 19.10 a Step by Step guide for beginners](https://www.cyberpratibha.com/how-to-install-mysql-in-ubuntu/){:target="_blank"} 

[How to Install MySQL 8 on Ubuntu 19.10 & 18.04 - Easy Way » TubeMint](https://tubemint.com/install-mysql-8-on-ubuntu/){:target="_blank"}

[mysql8.0 install in ubuntu 18.04](https://tristan91.tistory.com/540?category=564625){:target="_blank"}

[우분투 에서 Mysql DB 새로운 계정 추가 및 권한 주기 (Ubuntu, grant, create user)](https://sosobaba.tistory.com/218){:target="_blank"}

[Mysql8.0 외부 접속 허용](https://hhhhhhhong.tistory.com/17){:target="_blank"}

[mysql 8.0 설치부터 셋팅까지](https://nasanx2001.tistory.com/entry/mysql-80-%EC%84%A4%EC%B9%98%EB%B6%80%ED%84%B0-%EC%85%8B%ED%8C%85%EA%B9%8C%EC%A7%80){:target="_blank"}

[DataGrip 2019.1 连接mysql 8.0.16](https://blog.csdn.net/weixin_41843699/article/details/91354992){:target="_blank"}

[林肯公园](https://www.cnblogs.com/linkenpark/p/10908101.html){:target="_blank"}

[MySQL Bind Address - FOSS TechNix](https://www.fosstechnix.com/tutorial/mysql/mysql-bind-address/){:target="_blank"}
