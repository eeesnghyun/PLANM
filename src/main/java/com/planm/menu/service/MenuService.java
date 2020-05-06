package com.planm.menu.service;

import java.util.List;

import com.planm.menu.vo.MenuVO;

public interface MenuService {
	
	/** 메뉴 조회 */
	public List<MenuVO> getMenuList(String userid) throws Exception;
}
