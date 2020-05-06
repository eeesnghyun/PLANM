package com.planm.menu.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.planm.menu.dao.MenuDao;
import com.planm.menu.service.MenuService;
import com.planm.menu.vo.MenuVO;

@Service("menu.MenuService")
public class MenuServiceImpl implements MenuService {
	
	@Autowired
	private MenuDao menuDao;
	
	@Override
	public List<MenuVO> getMenuList(String userid) throws Exception {
		return menuDao.getMenuList(userid);		
	}
}
