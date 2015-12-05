---
layout: post
title: "Spring Data Jpa 에서 Specification 사용하기"
---
Spring Data를 사용하면서 JpaRepository 인터페이스를 확장(extends)해서 주로 사용하였는데,
이번에 Specification을 이용해 보았다.  
Specification는 도메인 주도 설계(Domain Driven Design) 책에서 처음 봤던 내용인데, Repository에 검색 조건으로 이번에 처음 사용해 본다. 지난번에는 Validation을 위해 사용해 보긴 했다.


## StylerRepository
Repository에서 JpaSpecificationExecutor 인터페이스도 같이 상속받는다.  
repository.findOne(Specification spec) 을 사용하기 위해서이다. findAll, count 메소드가 함께 정의되어 있다.

```java
@Repository
public interface StylerRepository extends JpaRepository<Styler, Long>, JpaSpecificationExecutor<Styler> {

}
```

## Specification 클래스 만들기
도메인에 맞는 Speicifation을 클래스로 만들어서 관리를 하면 유지보수가 쉬워진다.
Specification은 static 메소드로 구현한다.
new Specification()을 해주면, IDE가 알아서 코드를 만들어준다.  
root는 엔티티를 뜻한다. Root<Styler> root의 경우 Styler 엔티티를 의미한다.
접근을 할때는 멤버변수를 텍스트로 써주거나, 별도의 객체를 만들어 사용하는 방법이 있는데, 간단히 텍스트로 적었다.  
아래처럼 Styler 객체에서 Shop 를 참조하는 경우, Shop의 id를 구하고 싶으면 `root.get("shop").get("id)` 이런 식으로 사용하면 된다.

```java
import org.springframework.data.jpa.domain.Specification;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;

/**
 * Created by Derek Choi on 15. 12. 2.
 */
public class StylerSpecification {

    public static Specification<Styler> shopEq(final long shopId) {
        return new Specification<Styler>() {
            @Override
            public Predicate toPredicate(Root<Styler> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
                return cb.equal(root.get("shop").get("id"), shopId);
            }
        };
    }

    public static Specification<Styler> stylerEq(long stylerId) {
        return new Specification<Styler>() {
            @Override
            public Predicate toPredicate(Root<Styler> root, CriteriaQuery<?> query, CriteriaBuilder cb) {
                return cb.equal(root.get("id"), stylerId);
            }
        };
    }

}

```

## 사용
Specifications와 Specification을 혼돈해서는 안된다. 사용할때는 복수형인 Specifications를 써야 한다. 이것 때문에 꽤 시간을 허비했다.  
Specification을 정의하고 and, or 등을 이용해서 계속 덧붙일 수 있다.  
앞서 JpaSpecificationExecutor 를 repository에서 extends 해주어서 findOne 메소드로 엔티티를 가져올 수 있게 되었다.

```java
import org.springframework.data.jpa.domain.Specifications;

    @Transactional
    public Styler getStylerInShop(Long shopId, Long stylerId) {
        Specifications specifications = Specifications.where(StylerSpecification.shopEq(shopId)).and(StylerSpecification.stylerEq(stylerId));
        return stylerRepository.findOne(specifications);
    }
```
