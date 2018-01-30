---
layout: post
title: "Flask + Flask-SQLAlchemy + MySql 세팅"
author: Derek Choi
comments: true
---
플라스크를 이용해서 웹서비스 프로젝트를 만들면서 정리를 한다.

## 환경
- macOS High Sierra
- PyCharm 2017.3
- Python 3.6 (virtualenv)

## 테스트 코드
http://bablabs.tistory.com/22?category=654479 
밥대상 블로그의 코드를 참고해서 만들었다.
```
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Column

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://사용자:비밀번호@도메인:3306/서비스이름'
db = SQLAlchemy(app)


class ServiceUser(db.Model):
    id = Column(db.Integer, nullable=False, primary_key=True)
    name = Column(db.String(255), nullable=False, default='')
    nick_name = Column(db.String(255), nullable=False, default='')


@app.route('/')
def hello_world():
    row = ServiceUser.query.filter_by(id=84723726).first()
    print(row.nick_name)
    return (row.nick_name, 200)


if __name__ == '__main__':
    app.run()

```

## 설정
프로젝트 인터프리터에 필요한 패키지를 추가야한다.  
필요한 패키지는    
- Flask-SQLAlchemy
- SQLAlchemy
- PyMySQL
- mysqlclient
이다.   
pip install Flask-SQLAlchemy 처럼 명령어로 설치를 할 수도 있지만, 파이참에서 추가를 했다.

### 문제
설치를 하다보면 문제가 발생한다.  
MySQL 연결과 관련된 문제인데 먼저 mysql-connector-c 를 설치하자  
참고 : https://stackoverflow.com/questions/45628814/how-do-you-install-mysql-for-flask  
```
brew install mysql-connector-c
```

설치를 한 이후에도 문제가 발생한다.
mysqlclient 가 pip 으로 설치가 안될것이다. 위에 필요한 패키지에서 mysqlclient 빼고 다 설치가 된다.   
이것은 맥에서만 그런것이고, mysqlclient 위키에 문제와 해결 방법이 나와있다.  
https://github.com/PyMySQL/mysqlclient-python

mysql_config 파일에 
```
libs="$libs -l "
```
을 아래와 같이 변경을 해준다.
```
libs="$libs -lmysqlclient -lssl -lcrypto"
```

mysql_config 파일이 어디있는건가 찾지 못해서 다시 검색을 통해 찾았다.  
파일의 풀 path는 /usr/local/bin/mysql_config 이다. 다시한번 이야기 하면 mysql-connector-c 를 설치해야 생긴다.  

수정을 한 후에 mysqlclient 패키지를 다시 설치한다. 이번엔 제대로 설치된다.  

세팅은 이제 끝. 코딩을 준비완료.

## 참고
https://www.jianshu.com/p/30bcc885411f  
https://stackoverflow.com/questions/45628814/how-do-you-install-mysql-for-flask  
https://github.com/PyMySQL/mysqlclient-python  
