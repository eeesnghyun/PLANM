package com.planm.util.paging.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.planm.mail.vo.MailVO;
import com.planm.util.paging.dao.PagingDao;
import com.planm.util.paging.service.PagingService;

@Service("paging.PagingService")
public class PagingServiceImpl implements PagingService {
	
	@Autowired
	private PagingDao pagingDao; 
	
	@Override
	public int getMailListTotalCount(Map<String, Object> map) throws Exception {
		return pagingDao.getMailListTotalCount(map); 
	}
	
	@Override
	public int garbageListTotalCount(Map<String, Object> map) throws Exception {
		return pagingDao.garbageListTotalCount(map); 
	}
	
	@Override
	public int setMailListTotalCount(Map<String, Object> map) throws Exception {
		return pagingDao.setMailListTotalCount(map); 
	}

	@Override
	public int getNoticeListTotalCount(String cmpcd) throws Exception {		
		return pagingDao.getNoticeListTotalCount(cmpcd);
	}
}
