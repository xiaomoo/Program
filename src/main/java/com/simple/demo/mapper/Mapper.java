package com.simple.demo.mapper;

import com.simple.demo.domain.PersonModel;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface Mapper {

   List<PersonModel> findByCondition(Map<String,Object> map);

   Integer addById(PersonModel personModel);

   Integer updateById(PersonModel personModel);

   Integer deleteById(Integer id);

}
