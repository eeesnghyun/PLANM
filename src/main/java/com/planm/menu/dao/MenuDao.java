package com.planm.menu.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.planm.menu.vo.MenuVO;

@Repository("MenuDao")
public class MenuDao {

	@Autowired
	private SqlSession mybatis;
	
	/** 메뉴 조회 */
	public List<MenuVO> getMenuList(String userid) throws Exception {			
		return mybatis.selectList("menu.getMenuList", userid);
	}
}
