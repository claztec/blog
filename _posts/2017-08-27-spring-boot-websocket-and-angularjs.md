---
layout: post
title: Spring Boot + AngularJS 웹소캣 적용하기
author: Derek Choi
comments: true
---

트위터 앱에 리트윗과 좋아요를 다른 사람이 누르면 새로 고침 없이 카운트가 반영이 되는걸 볼 수 있다.
이런 효과를 주기 위해 서비스에 웹소캣을 적용해 보기로 했다.

환경은 Spring boot 와 AngularJS (1.5x) 이다.

## 서버
 
### build.gradle 에 Spring Boot 설정
build.gradle 에 spring-boot-starter-websocket 을 추가한다.

```
    compile "org.springframework.boot:spring-boot-starter-websocket:$spring_boot_version"

```

### WebSocketConfig.java 추가
웹소캣 설정을 위한 파일을 만든다. 
```java
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig extends AbstractWebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/v3/promotion/stylers/like");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/gs-guide-websocket").withSockJS();
    }

}
```
이후 자바스크립트에서 SockJS 객체를 만들때 registerStompEndpoints 함수에서 추가한 gs-guide-websocket 을 사용하게 된다. 이름은 변경이 가능하다.  
configureMessageBroker 에서 config.enableSimpleBroker 에서 클라이언트로 메시지를 보낼 수 있도록 브로커를 설정하였다.

### StylerPromotionController.java
서버와 클라이언트가 통신을 위해 웹소캣을 사용하는 부분.
 
기능은 like는 스타일러의 좋아요를 모아서 보여주는 API 이고 like/add 는 좋아요를 증가하는 API 이다.  
v2는 HTTP 요청이고 v3는 웹소캣 요청이다.
```
/v2/promotion/stylers/like 
/v2/promotion/stylers/{stylerCode}/like/add
/v3/promotion/stylers/like
/v3/promotion/stylers/{stylerCode}/like/add
```

```java
@RestController
@Slf4j
public class StylerPromotionController {

    @NoAuthCheck
    @RequestMapping(value = "/v2/promotion/stylers/like", method = RequestMethod.GET)
    public List<StylerPromotionLikeResponse> getStylersLikeCount(@PathVariable String stylerCode) {
        List<StylerLikeDto> stylerLikeDtoList = stylerLikeService.getStylersLikeCountAll();
        return StylerPromotionLikeResponse.createList(stylerLikeDtoList);
    }

    @NoAuthCheck
    @RequestMapping(value = "/v2/promotion/stylers/{stylerCode}/like/add", method = RequestMethod.GET)
    public StylerPromotionLikeResponse addStylerLikeCount(@PathVariable String stylerCode, HttpSession httpSession) {
        StylerLikeDto stylerLikeDto = stylerLikeService.addStylerLikeCount(stylerCode);
        return StylerPromotionLikeResponse.create(stylerLikeDto);
    }


    @NoAuthCheck
    @MessageMapping(value = "/v3/promotion/stylers/{stylerCode}/add")
    @SendTo("/v3/promotion/stylers/like")
    public List<StylerPromotionLikeResponse> broadCasting(@DestinationVariable String stylerCode) {
        stylerLikeService.addStylerLikeCount(stylerCode);
        List<StylerLikeDto> stylerLikeDtoList = stylerLikeService.getStylersLikeCountAll();
        return StylerPromotionLikeResponse.createList(stylerLikeDtoList);
    }

```

웹소캣을 사용한 broadCasting 메소드를 보면 @MessageMapping 으로 설정한 주소로 요청을 받고, @SendTo 를 통해 클라이언트에게 변화된 값을 브로드캐스팅한다.  
@RequestMapping 은 @MessageMapping 으로 사용해야 한다. @PathVariable 이 웹소캣에서는 @DestinationVariable 로 받을 수 있다.  
아쉽게도 @MessageMapping 으로 웹소캣을 이용할때 HttpSession 을 받아올 수 가 없었다. 뭔가 방법을 찾지 못한 듯 하다.

## 클라이언트
 
### index.html 에 디펜던시 추가
```
        <script src="vendor/sockjs-client/dist/sockjs.js"></script>
        <script src="vendor/stomp-websocket/lib/stomp.js"></script>
```
angular에 ng-stomp 같은 모듈이 있긴 하지만 모듈을 사용하지 않고 만들어 보았다. bower 에서 제대로 디펜던시를 가져오지 못해 파일을 다운받았다. 

## top-styler-event.controller.js
앵귤러의 컨트롤러 파일에서 sockjs, stomp 를 사용하는 코드다.  
``` js
        $scope.vm.addLike = addLike;

        $scope.client;

        function addLike($event, stylerCode) {
            $event.preventDefault();
            window.console.log(stylerCode);
            $scope.client.send("/v3/promotion/stylers/" + stylerCode + "/like/add", {}, JSON.stringify({'stylerCode': stylerCode}));

            __addFavorite(stylerCode);

        }

        function _socketInit() {
            var socket = new SockJS('/gs-guide-websocket');
            $scope.client = Stomp.over(socket);
            $scope.client.connect({}, function(frame) {
                window.console.log('connected stopmp over sockjs ', frame);
                $scope.client.subscribe('/v3/promotion/stylers/like', function(message) {
                    var data = JSON.parse(message.body);
                    __calculateLikeCount(data);
                });
            });
        }

        _socketInit();


 	// 페이지 나갈때 disconnection 해줘야 할까??
        $scope.$on("$destroy", function() {
           window.console.log("디스트로이 콜");
            if ($scope.client) {
                $scope.client.disconnect();
                window.console.log("클라이언트 디스커넥션");
            }
        });
```
처음 페이지가 로딩되면 _socketInit() 을 호출해서 서버와 커넥션을 맺는다. 그리고 subscribe 에 스프링 부트에서 @SendTo로 지정한 url을 구독한다.  
addLike는 좋아요 버튼을 클릭하면 발생하는 이벤트이고 서버에 스프링부트에 @MessageMapping 에 등록한 url로 요청을 보낸다.  
`JSON.stringify({'stylerCode': stylerCode}` 이런식으로 데이터도 보낼 수 있다. 이 샘플 코드에서는 불필요한 코드인데 테스트를 하다가 미쳐 지우지를 못했다.  
페이지를 떠나게 되면 웹소캣을 disconnect 하도록 했다.   

## 정리
스프링 부트 웹소캣을 이용하니 생각보다 쉽게 웹소캣 사용이 쉬웠다.  
angularjs 에서도 꼭 모듈을 사용할 필요없이 바로 웹소캣을 사용하면 되었다.

정리를 하면 서버 @MessageMapping 과 클라이언트 send 의 url 을 맞추고, 서버 @SendTo 와 클라이언트 subscribe 의 url 을 맞춰서 사용하면 쉽게 할 수 있다.

## 참고
- 처음 개념 잡기 좋았다.  
[http://adrenal.tistory.com/20](http://adrenal.tistory.com/20)  
[http://asfirstalways.tistory.com/359](http://asfirstalways.tistory.com/359)
- 클라이언트 코드 참고를 많이 하였다.  
[http://netframework.tistory.com/entry/Spring-4x%EC%97%90%EC%84%9C%EC%9D%98-WebSocket-SockJS-STOMP](http://netframework.tistory.com/entry/Spring-4x%EC%97%90%EC%84%9C%EC%9D%98-WebSocket-SockJS-STOMP)
