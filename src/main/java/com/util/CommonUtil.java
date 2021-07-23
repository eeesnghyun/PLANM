package com.planm.util;

public class CommonUtil {

	/*
	 * 마지막 문자열을 제거하여 리턴한다.
	 */
	public String returnRmvStr(String str) {	    
		if (str.length() > 0) {
	    	str = str.substring(0, str.length() - 1);
	    }
	    
	    return str;
	}
}
