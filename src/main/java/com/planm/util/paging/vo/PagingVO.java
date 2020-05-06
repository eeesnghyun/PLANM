package com.planm.util.paging.vo;

public class PagingVO {
	
	private int nowPage;		// 현재 페이지 번호
	private int nowPageCnt; 	// 현재 페이지의 보여지는 게시글 갯수
	private int startNum;
	
	public int getStartNum() {
		this.startNum = (this.nowPage - 1) * nowPageCnt;
		return startNum;
	}
	
	public void setStartNum(int startNum) {
		this.startNum = startNum;
	}

	// 초기값 설정
	public PagingVO() {
		this.nowPage = 1;
		this.nowPageCnt = 15;
	}
	
	public int getNowPage() {
		return nowPage;
	}

	public void setNowPage(int nowPage) {
		if(nowPage <= 0) {
			this.nowPage = 1;
		} else {
			this.nowPage = nowPage;	
		}		
	}

	public int getNowPageCnt() {
		return nowPageCnt;
	}

	public void setNowPageCnt(int pageCnt) {
		int cnt = this.nowPageCnt;
		
		if(pageCnt != cnt) {
			this.nowPageCnt = cnt;	
		} else {
			this.nowPageCnt = pageCnt;
		}		
	}
}
