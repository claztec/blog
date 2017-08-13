---
layout: post
title: "gradle로 java 프로젝트 다루기"
author: Derek Choi
---
어느순간 gradle이 대세가 되지 않을까?
튜토리얼 보며 gradle 따라해보기.

## 디렉토리 만들기
gradle-java 라는 이름의 디렉토리를 임의로 만들었다.

```bash
claztec:Desktop claztec$ mkdir gradle-java
claztec:Desktop claztec$ cd gradle-java/
claztec:gradle-java claztec$ pwd
/Users/claztec/Desktop/gradle-java
claztec:gradle-java claztec$
```

## 디렉토리 구조 잡기
src/main/java 과 src/test/java 로 디렉토리 구조를 잡는다.

```bash
claztec:gradle-java claztec$ mkdir -p src/main/java/net/claztec/hello
claztec:gradle-java claztec$ mkdir -p src/test/java
claztec:gradle-java claztec$ find .
.
./src
./src/main
./src/main/java
./src/main/java/net
./src/main/java/net/claztec
./src/main/java/net/claztec/hello
./src/test
./src/test/java
claztec:gradle claztec$
```

## 실행할 클래스 파일 만들기
/src/main/java/net/claztec/hello/Hello.java 를 만든다.
net.claztec.hello 패키지에 Hello.java 클래스를 만들었다.

```java
package net.claztec.hello;
public class Hello {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
```

## build.gradle 파일 만들기
프로젝트 최상단에 build.gradle 파일을 만든다.

```bash
claztec:gradle-java claztec$ ll
total 8
drwxr-xr-x   4 claztec  staff   136  3 22 22:04 .
drwx------+ 52 claztec  staff  1768  3 22 21:54 ..
-rw-r--r--   1 claztec  staff   537  3 22 21:38 build.gradle
drwxr-xr-x   4 claztec  staff   136  3 22 19:35 src
claztec:gradle-java claztec$
```

아래와 같이 build.gradle 파일을 작성한다.
java 플러그인을 사용하면 build나 clean 등을 사용할 수 있다.
repositories와 dependencies는 jar 파일을 가져올 수 있는지 확인을 위해 추가.
jar와 uploadArchives 는 jar 파일로 패키징을 하기 위해 추가하였다.
jar manifes에 Main-Class 속성 지정이 꽤나 중요하다.


```java
apply plugin: 'java'

repositories {
    mavenCentral()
}

dependencies {
    compile group: 'commons-collections', name: 'commons-collections', version: '3.2'
    testCompile group:'junit',name:'junit',version:'4.+'

}

sourceCompatibility = 1.5
version = 1.0
jar {
    manifest {
        attributes 'Implementation-Title': 'Gradle Quickstart',
                    'Implementation-Version': version,
                    'Main-Class': 'net.claztec.hello.Hello'
        }
}

test {
    systemProperties 'property':'value'
}

uploadArchives {
    repositories {
        flatDir {
            dirs 'repos'
        }
    }
}
```

## gradle build 하기
gradle build 명령을 날린다.

```bash
claztec:gradle-java claztec$ gradle build
:compileJava
warning: [options] bootstrap class path not set in conjunction with -source 1.5
warning: [options] source value 1.5 is obsolete and will be removed in a future release
warning: [options] target value 1.5 is obsolete and will be removed in a future release
warning: [options] To suppress warnings about obsolete options, use -Xlint:-options.
4 warnings
:processResources UP-TO-DATE
:classes
:jar
:assemble
:compileTestJava UP-TO-DATE
:processTestResources UP-TO-DATE
:testClasses UP-TO-DATE
:test UP-TO-DATE
:check UP-TO-DATE
:build

BUILD SUCCESSFUL

Total time: 3.72 secs
claztec:gradle-java claztec$
```

아래와 같이 class 파일이 생기고, jar로도 묶어준다.

```bash
claztec:gradle-java claztec$ find build
build
build/classes
build/classes/main
build/classes/main/net
build/classes/main/net/claztec
build/classes/main/net/claztec/hello
build/classes/main/net/claztec/hello/Hello.class
build/dependency-cache
build/libs
build/libs/gradle-java-1.0.jar
build/tmp
build/tmp/compileJava
build/tmp/jar
build/tmp/jar/MANIFEST.MF
```

## 실행하기
java 명령어로 만든 프로그램을 실행하본다.
build/classes/main으로 이동한 후에 패키지명까지 줘서 실행한다.

```bash
claztec:gradle-java claztec$ cd build/classes/main
claztec:main claztec$ java  net.claztec.hello.Hello
Hello, World!
claztec:main claztec$
```

.jar도 실행해본다.
gradle-java-1.0.jar 파일이 위치한 곳으로 이동한 후 실행한다.

``` bash
claztec:gradle-java claztec$ cd build/libs/
claztec:libs claztec$ java -jar gradle-java-1.0.jar
Hello, World!
claztec:libs claztec$ pwd
/Users/claztec/Desktop/gradle-java/build/libs
claztec:libs claztec$
```

## gradle uploadArchives
jar로 아카이빙 해본다. repos 디렉토리로 jar파일을 묶는 task 다.
위에서 jar로 묶은거랑 별반 다르지 않다.

```bash
claztec:gradle-java claztec$ gradle uploadArchives
:compileJava UP-TO-DATE
:processResources UP-TO-DATE
:classes UP-TO-DATE
:jar UP-TO-DATE
:uploadArchives

BUILD SUCCESSFUL

Total time: 3.133 secs
```

```bash
laztec:gradle-java claztec$ cd repos/
claztec:repos claztec$ ll
total 32
drwxr-xr-x  6 claztec  staff   204  3 22 22:28 .
drwxr-xr-x  7 claztec  staff   238  3 22 22:28 ..
-rw-r--r--  1 claztec  staff  1120  3 22 22:28 gradle-java-1.0.jar
-rw-r--r--  1 claztec  staff    40  3 22 22:28 gradle-java-1.0.jar.sha1
-rw-r--r--  1 claztec  staff  1344  3 22 22:28 ivy-1.0.xml
-rw-r--r--  1 claztec  staff    40  3 22 22:28 ivy-1.0.xml.sha1
claztec:repos claztec$
```


## 참고
[http://www.gradle.org/docs/current/userguide/tutorial_java_projects.html#N103DE](http://www.gradle.org/docs/current/userguide/tutorial_java_projects.html#N103DE
)

[http://www.petrikainulainen.net/programming/gradle/getting-started-with-gradle-our-first-java-project/](http://www.petrikainulainen.net/programming/gradle/getting-started-with-gradle-our-first-java-project/)