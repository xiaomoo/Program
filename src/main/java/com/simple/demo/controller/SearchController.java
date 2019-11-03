package com.simple.demo.controller;

import com.simple.demo.domain.PeopleModel;
import com.simple.demo.domain.PersonModel;
import com.simple.demo.services.SearchServices;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@CrossOrigin
public class SearchController {

    @Autowired
    private SearchServices searchServices;

    @PostMapping("/query")
    @ApiOperation(value = "/query",notes = "数据库查询数据接口",httpMethod = "POST")
    public ResponseEntity<List<PersonModel>> query(@RequestBody Map<String,Object> map){

        return new ResponseEntity<>(searchServices.queryByCondition(map),HttpStatus.OK);
    }

    @PostMapping("/add")
    @ApiOperation(value = "/add",notes = "数据库添加数据接口",httpMethod = "POST")
    public ResponseEntity<Integer> add(@RequestBody PersonModel personModel){

        return new ResponseEntity<>(searchServices.addById(personModel),HttpStatus.OK);
    }

    @PostMapping("/update")
    @ApiOperation(value = "/query",notes = "数据库查询接口",httpMethod = "POST")
    public ResponseEntity<Integer> update(@RequestBody PersonModel personModel){

        return new ResponseEntity<>(searchServices.updateById(personModel),HttpStatus.OK);
    }

    @GetMapping("/delete")
    @ApiOperation(value = "/delete",notes = "数据库删除数据接口",httpMethod = "GET")
    public ResponseEntity<Integer> delete(@RequestParam Integer id){

        return new ResponseEntity<>(searchServices.deleteById(id),HttpStatus.OK);
    }

    @PostMapping("/search")
    @ApiOperation(value = "/search",notes = "ES数据搜索接口",httpMethod = "POST")
    public ResponseEntity<List<Map<String,Object>>> search(@RequestBody PeopleModel peopleModel){

        return new ResponseEntity<>(searchServices.searchByCondition(peopleModel),HttpStatus.OK);
    }

    @PostMapping("/addDoc")
    @ApiOperation(value = "/addDoc",notes = "ES数据添加接口",httpMethod = "POST")
    public ResponseEntity<String> addDocument(@RequestBody PeopleModel peopleModel){

        return new ResponseEntity<>(searchServices.addDocument(peopleModel),HttpStatus.OK);
    }

    @PostMapping("/updateDoc")
    @ApiOperation(value = "/query",notes = "ES数据更新接口",httpMethod = "POST")
    public ResponseEntity<String> updateByquery(@RequestBody PeopleModel peopleModel){

        return new ResponseEntity<>(searchServices.updateDocument(peopleModel),HttpStatus.OK);
    }

    @PostMapping("/deleteDoc")
    @ApiOperation(value = "/query",notes = "ES数据删除接口",httpMethod = "POST")
    public ResponseEntity<String> deleteByquery(@RequestBody PeopleModel peopleModel){

        return new ResponseEntity<>(searchServices.deleteDocument(peopleModel),HttpStatus.OK);
    }
}
