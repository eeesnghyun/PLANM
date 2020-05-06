package com.planm.login.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.planm.login.dao.LoginDao;
import com.planm.login.service.LoginService;
import com.planm.login.vo.LoginVO;

@Service("login.LoginService")
public class LoginServiceImpl implements LoginService {

	@Autowired
	private LoginDao loginDao;
	
	@Override
	public LoginVO getUserInfo(String userid) throws Exception {
		return loginDao.getUserInfo(userid);
	}

	@Override
	public int saveUserImg(LoginVO loginVO) throws Exception {		
		return loginDao.saveUserImg(loginVO);
	}

	@Override
	public int checkPass(Map<String, Object> map) throws Exception {
		return loginDao.checkPass(map);
	}

	@Override
	public int editPass(Map<String, Object> map) throws Exception {		
		return loginDao.editPass(map);
	}
}
