---
layout: post
title:  "지킬 시작하기"
---
우여곡절 끝에 jekyll을 설치하였다. 맥북에 설치하려고 했지만 거지같은 ruby 설정에 지쳐서 포기. 오히려 윈도우에 설치하는게 휠씬 쉽고 잘 되는것 같다.

## 설치 참고
윈도우에 지킬을 설치하면서 참고한 페이지들

### 윈도우에 git 설치
exe 설치 파일 받아서 설치하면 끝.
나중에 파일올리기 위해 사용.
http://emflant.tistory.com/120

### 윈도우에 jekyll 설치
파일을 다운받고 cmd를 열어서 사용하면 된다.
`jekyll serve` 도 된다.
http://jekyllis.com/install-jekyll/
http://blog.saltfactory.net/jekyll/upgrade-github-pages-dependency-versions.html

### 리눅스(우분투)에 jekyll 설치

curl과 nodejs는 이미 설치.

```bash
claztec@claztec-ThinkPad:~$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
claztec@claztec-ThinkPad:~$ \curl -sSL https://get.rvm.io | bash -s stable
claztec@claztec-ThinkPad:~$ source /home/claztec/.rvm/scripts/rvm 
claztec@claztec-ThinkPad:~$ rvm requirements
claztec@claztec-ThinkPad:~$ rvm install 2.2.2
claztec@claztec-ThinkPad:~$ rvm use 2.2.2 --default
claztec@claztec-ThinkPad:~$ gem install jekyll
```

터미털에서 login shell 설정을 꼭 해주자.

http://jekyllis.com/install-jekyll/
http://sharadchhetri.com/2014/06/30/install-jekyll-on-ubuntu-14-04-lts/


## 설정
### 폰트
기본 폰트가 별로라서 폰트를 구글 noto로 수정.
코드 하이라이트 부분 폰트 사이즈도 조절.

### 코드 하이라이트
http://jekyllrb.com/docs/templates/

```를 쓰기 위해 markdown을 redcarpet으로 변경

```java
@Controller
public class ArticleController {

    @Autowired
    private ArticleService articleService;

    @RequestMapping(value = "/articles", method = {RequestMethod.GET})
    public String getArticles(@ModelAttribute Page page, Model model) {
        List<Article> articleList = articleService.getArticleListAll(page);
        model.addAttribute("articles", articleList);
        model.addAttribute("page", page);
        return "index";
    }

    @RequestMapping(value = "/articles", method = {RequestMethod.POST})
    public String addArticle(@ModelAttribute @Valid Article article, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            List<ObjectError> errors = bindingResult.getAllErrors();
            Map<String, String> errorMap = new HashMap<String, String>();

            for (ObjectError error : errors) {
                if (error instanceof FieldError) {
                    FieldError fieldError = (FieldError)error;
                    String field = fieldError.getField() + "Err";
                    String message = fieldError.getDefaultMessage();
                    model.addAttribute(field, message);
                }
            }
            model.addAttribute("article", article);
            return "add_form";
        } else {
            articleService.addArticle(article);
            return "redirect:/articles";
        }
    }
```

gist 지원
{% gist claztec/4207310402cff9e342c0 %}

### archive
http://joshualande.com/jekyll-github-pages-poole/