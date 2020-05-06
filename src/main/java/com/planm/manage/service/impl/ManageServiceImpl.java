package com.planm.manage.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.planm.manage.dao.ManageDao;
import com.planm.manage.service.ManageService;
import com.planm.manage.vo.ManageVO;

@Service("manage.ManageService")
public class ManageServiceImpl implements ManageService {

	@Autowired
	private ManageDao manageDao;
	
	@Override
	public void recordCommute(Map<String, Object> map) throws Exception {
		if(map.get("flag").equals("T")) {	// 출근 기록
			manageDao.recordCommuteT(map);	
		} else {							// 퇴근 기록
			manageDao.recordCommuteF(map);
		}
	}

	@Override
	public int getMaxWorkday(ManageVO manageVO) throws Exception {		
		return manageDao.getMaxWorkday(manageVO);
	}

	@Override
	public List<Map<String, Object>> getCommuteList(Map<String, Object> map) throws Exception {
		return manageDao.getCommuteList(map);
	}

}
