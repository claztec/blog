---
layout: post
title: "스프링 RestTemplate을 이용해서 GET 요청하기"
author: Derek Choi
comments: true
---

# 스프링 RestTemplate 사용
서버에 요청을 하면 XML 형식으로 응답하는 서버와 HTTP 프로토콜을 이용해서 통신할때 스프링 RestTemplate을 이용해서 처리하는 방법 정리.   
XML로 응답하는 서버에 GET 으로 요청을 하였다.

## RestTemplate
기존에 HttpClient를 이용해서 다른 서버에 Http 요청을 해서 사용했는데, 스프링 프레임워크에서 간단히 사용할 수 있게 추상화 시켜놨다. json이나 xml형태의 응답을 쉽게 객체로 바꾸어 사용할 수 있다.  
없었을때는 HttpClient 라이브러리를 생성하고, 서버에 요청한 후에 응답 값을 직접 json, xml 라이브러리를 사용해서 컨버팅 했는데, RestTemplate을 이용한 후에는 그럴 필요가 없어졌다.

## 사용
RestTemplate 객체를 만들고, 요청하려는 URI과 응답받을 객체를 만들어서 getForObject 등의 메소드를 호출한다.

### 1. RestTemplate 객체 생성
- 기본 생성

```java
        RestTemplate restTemplate = getRestTempalte();
```
- 추가로 timeout 설정을 할때

```java
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        factory.setReadTimeout(1000 * 60 * 5);  // 5분
        factory.setConnectTimeout(5000);
        RestTemplate restTemplate = new RestTemplate(factory);
```

### 2. URI 생성
스프링에서 제공하는 UriComponentsBuilder를 이용하면 체이닝 방식으로 보기 좋게 URI를 만들 수 있다.

```java
        URI uri = UriComponentsBuilder.newInstance().scheme("http").host("docuconv.claztec.net")
                .path("/cgi/{type}")
                .queryParam("path", file.getDownloadUrl())
                .queryParam("realname", file.getName())
                .queryParam("servicecode", file.getServiceCode())
                .queryParam("useragent", file.getUserAgent())
                .queryParam("charset", file.getCharset())
                .queryParam("format", file.getOption())
                .build().expand(file.getType())
                .encode()
                .toUri();
```
- path 에 {type} 의 값은 expand() 의 매개변수와 매칭이 된다.
- queryParam 은 요청하는 파라미터를 넣어주고, 마지막에 encode()를 해준다.  
	`소프트웨어 중심에 존재하는 복잡성에 도전장을 내밀다` 라는 문자열은 `%EC%86%8C%ED%94%84%ED%8A%B8%EC%9B%A8%EC%96%B4%20%EC%A4%91%EC%8B%AC%EC%97%90%20%EC%A1%B4%EC%9E%AC%ED%95%98%EB%8A%94%20%EB%B3%B5%EC%9E%A1%EC%84%B1%EC%97%90%20%EB%8F%84%EC%A0%84%EC%9E%A5%EC%9D%84%20%EB%82%B4%EB%B0%80%EB%8B%A4` 로 변한다.
- 참고로 브라우저 콘솔창에서 자바스크립트의 decodeURI(), encodeURI()로 간단히 encode, decode 해볼 수 있다.

```javascript
decodeURI('%EC%86%8C%ED%94%84%ED%8A%B8%EC%9B%A8%EC%96%B4%20%EC%A4%91%EC%8B%AC%EC%97%90%20%EC%A1%B4%EC%9E%AC%ED%95%98%EB%8A%94%20%EB%B3%B5%EC%9E%A1%EC%84%B1%EC%97%90%20%EB%8F%84%EC%A0%84%EC%9E%A5%EC%9D%84%20%EB%82%B4%EB%B0%80%EB%8B%A4')
"소프트웨어 중심에 존재하는 복잡성에 도전장을 내밀다"
encodeURI('소프트웨어 중심에 존재하는 복잡성에 도전장을 내밀다')
"%EC%86%8C%ED%94%84%ED%8A%B8%EC%9B%A8%EC%96%B4%20%EC%A4%91%EC%8B%AC%EC%97%90%20%EC%A1%B4%EC%9E%AC%ED%95%98%EB%8A%94%20%EB%B3%B5%EC%9E%A1%EC%84%B1%EC%97%90%20%EB%8F%84%EC%A0%84%EC%9E%A5%EC%9D%84%20%EB%82%B4%EB%B0%80%EB%8B%A4"
```
- 마지막으로 toUri()로 URI 형태로 변환한다.

### 3. Object 생성
- 응답 XML

```xml
<?xml version="1.0"?>
<result>
<code>200</code>
<url>http://docuconv.claztec.net/3/1440052137_98391fc84281414c9a33c1cda3a44c50/0.htm</url>
<msg></msg>
<loss>false</loss>
</result>
```

- XML을 java 객체로 표현
XmlRootElement 아래로 XmlElement로 구조를 잡아준다.
자동으로 만드는 방법도 있지만, 불필요한게 많이 생긴다. 하나하나 해주는 방법이 더 나은 것 같다.

```java
@XmlRootElement(name = "result")
public class Result {
    @XmlElement
    private Integer code;

    @XmlElement
    private String url;

    @XmlElement
    private String msg;

    @XmlElement
    private Boolean loss;

    public Integer getCode() {
        return code;
    }

    public String getUrl() {
        return url;
    }

    public String getMsg() {
        return msg;
    }

    public Boolean getLoss() {
        return loss;
    }
}
```

### 4. 요청

```java
        Result result = restTemplate.getForObject(uri, Result.class);
```

## 코드
ConvertService.java

```java
@Service
public class ConvertService {

    private RestTemplate getRestTempalte() {
        HttpComponentsClientHttpRequestFactory factory = new HttpComponentsClientHttpRequestFactory();
        factory.setReadTimeout(1000 * 60 * 5);  // 5분
        factory.setConnectTimeout(5000);
        RestTemplate restTemplate = new RestTemplate(factory);
        return restTemplate;
    }

    public Result convert(String downloadUrl) {
        RestTemplate restTemplate = getRestTempalte();
        URI uri = UriComponentsBuilder.fromHttpUrl(downloadUrl).build().toUri();
        Result result = restTemplate.getForObject(uri, Result.class);
        return result;
    }

    public Result convert(File file) throws UnsupportedEncodingException {
        RestTemplate restTemplate = getRestTempalte();
        URI uri = UriComponentsBuilder.newInstance().scheme("http").host("docuconv.claztec.net")
                .path("/cgi/{type}")
                .queryParam("path", file.getDownloadUrl())
                .queryParam("realname", file.getName())
                .queryParam("servicecode", file.getServiceCode())
                .queryParam("useragent", file.getUserAgent())
                .queryParam("charset", file.getCharset())
                .queryParam("format", file.getOption())
                .build().expand(file.getType())
                .encode()
                .toUri();
        Result result = restTemplate.getForObject(uri, Result.class);
        return result;
    }
}
```

ConvertServiceTest.java

```java
    @Autowired
    private ConvertService convertService;

    @Test
    public void testConvert() throws UnsupportedEncodingException {
        File file = new File();
        file.setDownloadUrl("http://cloud.tools.com/p/file/20110619.ppt");
        file.setName("소프트웨어 중심에 존재하는 복잡성에 도전장을 내밀다");
        file.setExtension("ppt");

        Result result = convertService.convert(file);
        assertNotNull(result);
        assertThat(200, is(result.getCode()));
        log.debug("url:" + result.getUrl());
    }
```

## 참고
[http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html](http://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html)
[http://howtodoinjava.com/2015/02/20/spring-restful-client-resttemplate-example/](http://howtodoinjava.com/2015/02/20/spring-restful-client-resttemplate-example/)
[http://sooin01.tistory.com/80](http://sooin01.tistory.com/80)