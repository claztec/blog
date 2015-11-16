---
layout: post
title: "Flask 에서 json 형식의 텍스트 파일을 읽어 json 으로 응답하기"
---
json 형식의 파일을 읽어서 flask에서 application/json 형태로 바로 내려야 하는 일이 생겼다.
어렵게 생각했으나 생각보다 쉽게 풀렸다.

## json 형태의 텍스트 파일 준비
templates에 shops.json 파일로 저장  

```bash
[{
    "longitude": "127.10774425583172",
    "new_address": "경기 성남시 분당구 돌마로 52 MD프라자 202호",
    "phone_number": "031-712-2774",
    "latitude": "37.34968891708403",
    "zones": [{
        "name": "미금역",
        "distance": "278.147417185895"
    }, {
        "name": "한국조폐공사",
        "distance": "347.662479999398"
    }, {
        "name": "미금사거리",
        "distance": "436.905939534859"
    }, {
        "name": "한전기공",
        "distance": "498.375360545661"
    }, {
        "name": "금곡사거리",
        "distance": "775.412664326915"
    }, {
        "name": "오리역",
        "distance": "1057.09434455349"
    }, {
        "name": "고기리",
        "distance": "2871.99390667838"
    }],
    "shop_id": "k0723b001",
    "confirm_id": "19155576",
    "name": "최가을헤어드레서 미금점",
    "address": "경기 성남시 분당구 구미동 8-2번지 MD프라자 202호"
}, {
    "longitude": "127.10728770745983",
    "new_address": "경기 성남시 분당구 미금일로154번길 20 2001아울렛 6층",
    "phone_number": "031-786-2899",
    "latitude": "37.34928206704527",
    "zones": [{
        "name": "미금역",
        "distance": "336.808084421577"
    }, {
        "name": "한국조폐공사",
        "distance": "370.094582504698"
    }, {
        "name": "미금사거리",
        "distance": "405.790586387484"
    }, {
        "name": "한전기공",
        "distance": "527.880668332424"
    }, {
        "name": "금곡사거리",
        "distance": "824.584743976614"
    }, {
        "name": "오리역",
        "distance": "1024.03658674358"
    }, {
        "name": "고기리",
        "distance": "2836.23147856368"
    }],
    "shop_id": "k1589b050",
    "confirm_id": "8046675",
    "name": "이가자헤어비스 분당2001아울렛미금점",
    "address": "경기 성남시 분당구 구미동 11-1번지 2001아울렛 6층"
}]
```

## 응답
아래와 같이 render_template을 이용해서 파일을 읽어들인후에 make_response를 이용해서 Content-Type을 설정해준다.

```python
@app.route('/shops.json')
def shops():
    response = make_response(render_template('shops.json'))
    response.headers['Content-Type'] = 'application/json;charset=UTF-8'
    return response
```

## 결과
Content-Type이 application/json 으로 원하는 방식으로 나왔다.
![capture](/assets/20151116/capture.png)
