package com.simple.demo.aop;

import com.simple.demo.domain.PersonModel;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Aspect
@Slf4j
@Component
public class ValidateId {

    @Pointcut(value = "execution(* com.simple.demo.services.serciceslmp.SearchServiceslmp.updateById(..))")
    public void validateId(){};

//    验证是否有id
    @Before(value = "validateId() && args(personModel)")
   public PersonModel doBefore(PersonModel personModel){

        log.info("recived：{} before execute method",personModel);

        return Optional.ofNullable(personModel)
                .map(x -> x.getId()!=null?x:null).orElse(null);
    }
}
