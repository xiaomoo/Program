package com.simple.demo.services;

import com.simple.demo.domain.PeopleModel;
import com.simple.demo.domain.PersonModel;

import java.util.List;
import java.util.Map;

public interface SearchServices {

    List<PersonModel> queryByCondition(Map<String,Object> map);

    Integer addById(PersonModel personModel);

    Integer updateById(PersonModel personModel);

    Integer deleteById(Integer id);

    List<Map<String,Object>> searchByCondition(PeopleModel peopleModel);

    String addDocument(PeopleModel peopleModel);

    String updateDocument(PeopleModel peopleModel);

    String deleteDocument(PeopleModel peopleModel);

}
