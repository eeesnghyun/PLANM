package com.planm.login.service;

import java.util.Map;

import com.planm.login.vo.LoginVO;

public interface LoginService {
	
	/** 유저 정보 조회 */
	public LoginVO getUserInfo(String userid) throws Exception;
	
	/** 유저 이미지 저장 */
	public int saveUserImg(LoginVO loginVO) throws Exception;
	
	/** 유저 비밀번호 체크 */
	public int checkPass(Map<String, Object> map) throws Exception;

	/** 유저 비밀번호 변경 */
	public int editPass(Map<String, Object> map) throws Exception;
}
