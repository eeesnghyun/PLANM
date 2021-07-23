package com.planm.util;

import org.apache.commons.collections.map.ListOrderedMap;
import org.apache.commons.lang.StringUtils;

public class LowerKeyMap extends ListOrderedMap {
    /**
     *  MyBatis 필드 매핑시 대문자로 컬럼명을 키값에 매핑하는 문제로
     *  소문자로 변환해주는 작업을 한다.
     *  
     *  return 타입은 Map<String, Object>의 형태로 한다.
     */
    private static final long serialVersionUID = 1L;
 
    public Object put(Object key, Object value) {
        return super.put(StringUtils.lowerCase((String) key), value);
    }
}