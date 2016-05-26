```
logging:
  level:
    com.kakao.beauty.web: DEBUG
    org.springframework: INFO
    org.hibernate.SQL: debug
    org.hibernate.type: trace
spring:
  main:
    showBanner: false
  datasource:
    url: jdbc:h2:mem:beauty;INIT=CREATE SCHEMA IF NOT EXISTS BEAUTY;DB_CLOSE_ON_EXIT=FALSE;
    username: sa
    password: sa
    driverClassName: org.h2.Driver
  jpa:
    showSql: false
    database: h2
    hibernate:
      ddlAuto: create
  resources:
    staticLocations: classpath:/web/app/

```
