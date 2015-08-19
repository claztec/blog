---
layout: post
title: "스프링 부트(Spring Boot) 시작하기"
---

# 스프링 부트 프로젝트 세팅
스프링에서도 python의 flask, django 나 ruby on rails 처럼 빠르게 웹 프로젝트를 만드는 스프링 부트(Spring Boot)기술이 등장하였다.  
나름 스프링 부트로 프로젝트를 구성하면서 정리한 내용이다.

## 개발환경
* java 8
* gradle 2.5
* intellij

## intellij 에서 프로젝트 생성
먼저 intellij에서 프로젝트를 생성한다.  
File - New - Project 에서 왼쪽 메뉴에 Gradle 선택
![setup 1](/assets/spring-boot-1.png)

Groupid는 개발 조직에 대한 이름. 보통 uri를 거꾸로 한다.  
Artifact는 프로젝트를 나타내는 이름.
![setup 2](/assets/spring-boot-2.png)

Create directories for empty content roots automatically 를 체크하면 기본으로 main과 test 디렉토리를 생성해준다.  
Use local gradle distribution 을 선택하면 Gradle home 에서 로컬에 설치한 gradle을 이용할 수 있다. (선택사항)  
Gradle JVM은 원하는 자바 버전이 설치된 경로 설정.
![setup 3](/assets/spring-boot-3.png)

마지막으로 프로젝트가 생성될 디렉토리를 설정
![setup 4](/assets/spring-boot-4.png)

## String Boot 기본 설정
### 기본적으로 사용되는 파일 설정
#### build.gradle
프로젝트에 필요한 라이브러리를 추가하는 설정을 한다.  

```
buildscript {
    repositories {
        maven {url 'http://repo.spring.io/libs-snapshot'}
    }
    dependencies {
        classpath ('org.springframework.boot:spring-boot-gradle-plugin:1.2.4.BUILD-SNAPSHOT')
    }
}

apply plugin: 'spring-boot'
apply plugin: 'java'
apply plugin: 'idea'
apply plugin: 'war'

war {
    baseName = 'docuconv'
    version = '0.1.0'
}

version = '1.0'

repositories {
//    mavenLocal()
    mavenCentral()
    jcenter()
    maven { url 'http://repo.spring.io/libs-snapshot' }
}

configurations {
    providedRuntime
}

dependencies {
    compile 'org.springframework.boot:spring-boot-starter-web:1.2.5.RELEASE'
    compile 'org.springframework.boot:spring-boot-starter-velocity:1.2.5.RELEASE'
    compile 'aspectj:aspectjrt:1.5.4'
    compile 'org.aspectj:aspectjweaver:1.8.5'
    compile 'org.slf4j:slf4j-api:1.7.12'
    compile 'ch.qos.logback:logback-classic:1.1.3'
    testCompile 'org.springframework.boot:spring-boot-starter-test:1.2.5.RELEASE'
    testCompile 'junit:junit:4.12'
}

test {
    testLogging {
        events 'started', 'passed'
    }

    onOutput { descriptor, event ->
        logger.lifecycle(event.message)
    }
}
```

이후 View - Tool Windows - Gradle을 선택하고 gradle properties 에서 Refresh를 눌러줘야 참조하는 라이브러리를 받아오고, 설정이 변경된다.

#### .gitignore
불필요한 파일은 git에 commit이 안되게 설정한다.  
https://www.gitignore.io 에서 몇번의 선택으로 쉽게 만들 수 있다.

```
# Created by https://www.gitignore.io

### Java ###
*.class

# Mobile Tools for Java (J2ME)
.mtj.tmp/

# Package Files #
*.jar
*.war
*.ear

# virtual machine crash logs, see http://www.java.com/en/download/help/error_hotspot.xml
hs_err_pid*


### Gradle ###
.gradle
build/

# Ignore Gradle GUI config
gradle-app.setting

# Avoid ignoring Gradle wrapper jar file (.jar files are usually ignored)
!gradle-wrapper.jar


### Intellij ###
# Covers JetBrains IDEs: IntelliJ, RubyMine, PhpStorm, AppCode, PyCharm

*.iml

## Directory-based project format:
.idea/
# if you remove the above rule, at least ignore the following:

# User-specific stuff:
# .idea/workspace.xml
# .idea/tasks.xml
# .idea/dictionaries

# Sensitive or high-churn files:
# .idea/dataSources.ids
# .idea/dataSources.xml
# .idea/sqlDataSources.xml
# .idea/dynamic.xml
# .idea/uiDesigner.xml

# Gradle:
# .idea/gradle.xml
# .idea/libraries

# Mongo Explorer plugin:
# .idea/mongoSettings.xml

## File-based project format:
*.ipr
*.iws

## Plugin-specific files:

# IntelliJ
/out/

# mpeltonen/sbt-idea plugin
.idea_modules/

# JIRA plugin
atlassian-ide-plugin.xml

# Crashlytics plugin (for Android Studio and IntelliJ)
com_crashlytics_export_strings.xml
crashlytics.properties
crashlytics-build.properties

```

#### application.properties
레퍼런스 참조 해서 스프링 부트의 기본 설정을 해준다.  
[http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#common-application-properties](http://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#common-application-properties)  
지금은 view 기술로 velocity를 build.gradle 에서 설정해서 velocity 설정만 하였다.

src/main/resources/application.properties

```
spring.velocity.charSet=UTF-8
spring.velocity.properties.input.encoding=UTF-8
spring.velocity.output.encoding=UTF-8
```

### logback.xml logback-test.xml
로깅을 위해서 resources에 logback 설정을 한다.  
일단 둘다 같은 설정을 해둔다.  

src/main/resources/logback.xml  
src/test/resources/logback-test.xml

```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <layout class="ch.qos.logback.classic.PatternLayout">
            <Pattern>%d{HH:mm} %-5level %logger{36} - %msg%n</Pattern>
        </layout>
    </appender>

    <logger name="net.daum.docuconv" level="DEBUG"/>
    <root level="INFO">
        <appender-ref ref="STDOUT" />
    </root>
</configuration>
```

### error.vm
스프링 부트에서 기본적으로 resources/templates 에 있는 view 파일을 참조한다. velocity 로 설정하였기 때문에 error.vm 이라는 더미 파일을 하나 만들어준다.  
이름은 상관없고, resources/templates 디렉토리를 만드는게 중요하다. 없으면 나중에 내장 서버를 구동할때 디렉토리가 없다는 에러가 발생한다.  

src/main/resources/templates/error.vm

```
ERROR !!!
```

### ApplicationConfig
junit을 이용한 유닛 테스트를 위해서 만든 클래스이다.  
@ComponentScan을 통해 지정한 패키지 부터 스프링 빈을 스캔한다. @EnableAutoConfiguration을 통해 스프링 부트에서 기본적으로 세팅된 설정을 불러온다.  

스프링 부트에서는 보통 application.properties을 통해 datasource나 기타 자주 사용되는 설정을 정할 수 있는데,   junit으로 유닛 테스트할 경우 스프링 부트에서 자동으로 만들어주는 빈을 사용할때가 있다.
  이럴경우를 위해 선언해준다.

ArticleDaoImple에는 스프링부트 설정을 통해 선언된 JdbcTemplate 이 있고, 이를 테스트하기 위한 ArticleDaoTest 파일을 작성중이라면,

`@ContextConfiguration(classes = {ApplicationConfig.class}, loader = SpringApplicationContextLoader.class)` 이런식으로 `@EnableAutoConfiguration` 을 선언한 파일을 설정한다.

ApplicationConfig.java

```java
@Configuration
@ComponentScan("net.daum.docuconv")
@EnableAutoConfiguration
public class ApplicationConfig {
}
```

ArticleDaoTest.java

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {ApplicationConfig.class}, loader = SpringApplicationContextLoader.class)
public class ArticleDaoTest {

    private static final Logger log = LoggerFactory.getLogger(ArticleDaoTest.class);

    @Autowired
    private ArticleDao articleDao;

    @Test
    public void testAddArticle() {
        Article article = new Article();
        article.setTitle("test");
        article.setContents("content");
        Article insertedArticle = articleDao.insert(article);
        assertThat(article.getTitle(), is(insertedArticle.getTitle()));
    }
```

ArticleDaoImp.java

```java
@Repository
public class ArticleDaoImpl implements ArticleDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public Article insert(Article article) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement ps = con.prepareStatement("insert into article (title, contents, regdttm) values (?, ?, now())", new String[]{"id"});
                ps.setString(1, article.getTitle());
                ps.setString(2, article.getContents());
                return ps;
            }
        }, keyHolder);
//        jdbcTemplate.update("insert into article (title, contents, regdttm) values (?, ?, now())", new Object[]{article.getTitle(), article.getContents()});
        article.setArticleId(keyHolder.getKey().toString());
        return article;
    }
```

### Application
스프링 부트에서 쉽게 내장 톰캣을 실행할때 사용한다.  
intellij에서 Application.java 파일에서 오른쪽 클릭 - Run 'Application' 를 누르면 바로 내장 톰캣이 구동한다.

```java
@Configurable
@EnableAutoConfiguration
@ComponentScan("net.daum.docuconv")
public class Application extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }


    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(applicationClass);
    }

    private static Class<Application> applicationClass = Application.class;
}

```

### HelloController, HelloControllerTest
샘플 컨트롤러와 컨트롤러 테스트를 만든다.

HelloControllerTest.java

```java
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
public class HelloControllerTest {

    private MockMvc mvc;

    @Before()
    public void setUp() throws Exception {
        mvc = MockMvcBuilders.standaloneSetup(new HelloController()).build();
    }

    @Test
    public void getHello() throws Exception {
        mvc.perform(MockMvcRequestBuilders.get("/hello").accept(MediaType.TEXT_HTML))
                .andExpect(status().isOk())
                .andExpect(content().string(equalTo("hello")));
    }
```

HelloController.java

```java
@Controller
public class HelloController {
    public static final Logger log = LoggerFactory.getLogger(HelloController.class);

    @RequestMapping(value = "/hello")
    @ResponseBody
    public String helloToText() {
        log.debug("@@@@@ hello @@@@@");
        return "hello";
    }

    @RequestMapping(value = "/hello.json")
    @ResponseBody
    public Object helloToJson() {
        Map<String, Object> model = new HashMap<>();
        model.put("time", new Date());
        model.put("message", "welcome");
        String title = "타이틀";
        model.put("title", title);
        return model;
    }
```

## 실행
intellij에서 Application.java 에서 run 을 하거나 터미널에서 `gradle run` 을 하면 내장 서버가 구동되면서 어플리케이션이 실행된다.  
localhost:8080 으로 접속하면 확인할 수 있다.

![run](/assets/spring-boot-5.png)

## 전체 프로젝트 구조
![project](/assets/spring-boot-6.png)


## 정리
* intellij 에서 gradle을 사용해서 프로젝트를 만들려면 프로젝트에서 gradle을 선택해서 만든다.
	* 중간에 Create directories for empty content roots automatically 는 꼭 체크해주자
* build.gradle에서 각종 jar 설정을 해준다.
	* spring-boot-starter 로 시작하는 jar들이 있어서 편해졌다.
	* 설정이 바껴도 intellij 에서 자동으로 라이브러리를 다시 로딩하지 않으니 귀찮더라도 gradle 을 refrash 해줘야 한다.
* application.properties 에서 설정만으로 귀찮은 작업들을 줄일 수 있다. 하지만 마법처럼 자동으로 되다보니, 다른 설정을 하게 되거나 사용하지 않으려면 꽤나 고생하게 된다.
* xml 설정은 최소화하고 대부분 bean 설정은 코드로 한다.
* spring boot 에서는 jar 명령으로 내장 서버를 띄울 수 있다. 확실히 서버 세팅하는 부분이 사라져 개발하기 편하다.
* 실제 서비스에 적용하는건 jar로 내장 서버로 구동하거나, 기존처럼 설치된 서버에 war를 배포해서 구동할 수 있다.

## 참고할 수 있는 코드
스프링 부트를 이용한 게시판 만들기
[https://github.com/claztec/grboard](https://github.com/claztec/grboard)