package com.simple.demo.services.serciceslmp;

import com.simple.demo.common.Constants;
import com.simple.demo.common.EsInfo;
import com.simple.demo.domain.PeopleModel;
import com.simple.demo.domain.PersonModel;
import com.simple.demo.mapper.Mapper;
import com.simple.demo.services.SearchServices;
import lombok.extern.slf4j.Slf4j;
import org.frameworkset.elasticsearch.ElasticSearchHelper;
import org.frameworkset.elasticsearch.boot.BBossESStarter;
import org.frameworkset.elasticsearch.client.ClientInterface;
import org.frameworkset.elasticsearch.entity.ESDatas;
import org.frameworkset.elasticsearch.scroll.HandlerInfo;
import org.frameworkset.elasticsearch.scroll.ScrollHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cglib.beans.BeanMap;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Slf4j
public class SearchServiceslmp implements SearchServices {

    @Autowired
    private Mapper mapper;

    @Autowired
    private BBossESStarter bBossESStarter;

    public ClientInterface clientUtil;

    SearchServiceslmp(){
        this.clientUtil = ElasticSearchHelper.getConfigRestClientUtil("mappings/esmapper/EsMapper.xml");
    }

    /**
     *  按条件查询数据库
     * @param map
     * @return
     */
    @Override
    public List<PersonModel> queryByCondition(Map<String,Object> map) {

        log.info("query request data:{}",map);

        return Optional.ofNullable(map)
                .map(x -> mapper.findByCondition(x)).orElse(null);
    }

    /**
     *  通过id增加数据库数据
     * @param personModel
     * @return
     */
    @Override
    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.READ_UNCOMMITTED, timeout = 3000)
    public Integer addById(PersonModel personModel) {

        log.info("add request data:{}",personModel.toString());

        return Optional.ofNullable(personModel)
                .map(x -> mapper.addById(x)).orElse(null);
    }

    /**
     *  通过id更新数据库数据
     * @param personModel
     * @return
     */
    @Override
    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.READ_UNCOMMITTED, timeout = 3000)
    public Integer updateById(PersonModel personModel) {

        log.info("update request data:{}",personModel.toString());

        return Optional.ofNullable(personModel)
                .map(x -> mapper.updateById(x)).orElse(null);
    }

    /**
     *  根据id删除数据库数据
     * @param id
     * @return
     */
    @Override
    @Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.READ_UNCOMMITTED, timeout = 3000)
    public Integer deleteById(Integer id) {

        log.info("delete id:{}",id);

        return Optional.ofNullable(id)
                .map(x -> mapper.deleteById(x)).orElse(null);
    }

    /**
     *  批量添加数据到ES
     * @param peopleModel
     * @return
     */
    @Override
    public String addDocument(PeopleModel peopleModel) {

        log.info("add data:{}",peopleModel.toString());
        List<Map<String,Object>> doc = new ArrayList<>();
        doc.add(beanToMap(BeanMap.create(peopleModel)));

        return clientUtil.addDocuments(EsInfo.index,EsInfo.type,doc);
    }

    /**
     *  更新ES文档
     * @param peopleModel
     * @return
     */
    @Override
    public String updateDocument(PeopleModel peopleModel) {

        log.info("update data:{}",peopleModel.toString());
        Map<String,Object> param = new HashMap<>();
        param.put(Constants.Condition.getValue(),beanToMap(BeanMap.create(peopleModel)));

        return clientUtil.updateByQuery(EsInfo.index+"/_update_by_query?conflicts=proceed","filterSearch",param);
    }

    /**
     *  删除ES文档
     * @param peopleModel
     * @return
     */
    @Override
    public String deleteDocument(PeopleModel peopleModel) {

        log.info("delete data:{}",peopleModel.toString());
        Map<String,Object> param = new HashMap<>();
        param.put(Constants.Condition.getValue(),beanToMap(BeanMap.create(peopleModel)));

        return clientUtil.deleteByQuery(EsInfo.index+"/_delete_by_query?refresh", "filterSearch",param);
    }

    /**
     *  在ES搜索数据
     * @param
     * @return
     */
    @Override
    public List<Map<String,Object>> searchByCondition(PeopleModel peopleModel) {

        log.info("search condition:{}",peopleModel.toString());
        Map<String,Object> param = new HashMap<>();
        param.put(Constants.Condition.getValue(),beanToMap(BeanMap.create(peopleModel)));

        List<Map<String,Object>> result = new ArrayList<>();

        clientUtil.scroll(EsInfo.index + "/_search", "mutiConditionSearch", "5m", param, Map.class, new ScrollHandler<Map>() {
            @Override
            public void handle(ESDatas<Map> esDatas, HandlerInfo handlerInfo) throws Exception {

                for(Map map:esDatas.getDatas()){
                    result.add(map);
                }
            }
        });

        return result;
    }

    public Map<String,Object> beanToMap(BeanMap beanMap){

        Map<String,Object> map = new HashMap<>();
        for(Object key:beanMap.keySet()){

            if(null != beanMap.get(key)){
                map.put(String.valueOf(key),beanMap.get(key));
            }
        }
        log.info("map:{}",map);
        return map;
    }
}
