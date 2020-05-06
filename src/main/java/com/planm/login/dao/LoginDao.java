package com.planm.login.dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.planm.login.vo.LoginVO;

@Repository("LoginDao")
public class LoginDao {

	@Autowired
	private SqlSession mybatis;
	
	/** 유저 정보 조회 */
	public LoginVO getUserInfo(String userid) {
		return mybatis.selectOne("login.getUserInfo", userid);
	}
	
	/** 유저 이미지 저장 */
	public int saveUserImg(LoginVO loginVO) {
		return mybatis.update("login.saveUserImg", loginVO);
	}
	
	/** 유저 비밀번호 체크 */
	public int checkPass(Map<String, Object> map) {
		return mybatis.selectOne("login.checkPass", map);
	}
	
	/** 유저 비밀번호 변경 */
	public int editPass(Map<String, Object> map) {
		return mybatis.update("login.editPass", map);
	}

}
