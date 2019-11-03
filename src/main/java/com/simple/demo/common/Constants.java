package com.simple.demo.common;

public enum Constants {

    Condition("condition");

    private String value;

    Constants(String value){
        this.value = value;
    }

    public String getValue(){
        return this.value;
    }
}
