package com.planm.util.paging.service;

import java.util.Map;

import com.planm.mail.vo.MailVO;

public interface PagingService {

	public int getMailListTotalCount(Map<String, Object> map) throws Exception;
	
	public int setMailListTotalCount(Map<String, Object> map) throws Exception;
	
}
