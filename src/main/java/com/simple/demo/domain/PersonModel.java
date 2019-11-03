package com.simple.demo.domain;

import lombok.Data;

@Data
public class PersonModel {

    private Integer id;
    private String name;
    private String sex;
    private Integer age;
    private String introduce;

    @Override
    public String toString(){
        return "{"+
                "\"id\":"+this.id+","+"\"name\":"+this.name+","+"\"sex\":"+this.sex+","+
                "\"age\":"+age+","+"\"introduce\":"+this.introduce+
                "}";
    }
}
