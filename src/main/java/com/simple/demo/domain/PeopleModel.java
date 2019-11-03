package com.simple.demo.domain;

import lombok.Data;

@Data
public class PeopleModel {

    private Integer female_amount;
    private Integer male_amount;
    private Integer apartment_amount;
    private String province_name;

    @Override
    public String toString(){
        return "{"+
                    "\"male_amount\":"+male_amount+","+"\"female_amount\":"+female_amount+","+
                    "\"apartment_amount\":"+apartment_amount+","+"\"province_name\":"+province_name+
                "}";
    }
}
