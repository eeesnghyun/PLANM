package com.planm.util.paging;

import com.planm.util.paging.vo.PagingVO;

public class PagingController {
	
	private PagingVO pagingVO;
	private int totalPageCnt;		// 게시글의 전체 페이지 수
	private int startPage;			// 페이징에 보여지는 시작 페이지
	private int endPage;			// 페이징에 보여지는 마지막 페이지
	private boolean prev;			// 이전 버튼 여부
	private boolean next;			// 다음 버튼 여부
	private int showPageCnt = 10;	// 페이지당 보여질 게시글의 수
	
	public PagingVO getPagingVO() {
		return pagingVO;
	}

	public void setPagingVO(PagingVO pagingVO) {
		this.pagingVO = pagingVO;
	}

	public int getTotalPageCnt() {
		return totalPageCnt;
	}

	public void setTotalPageCnt(int totalPageCnt) {
		this.totalPageCnt = totalPageCnt;
		getPageData();
	}
	
	private void getPageData() {
		endPage   = (int) (Math.ceil(pagingVO.getNowPage() / (double) showPageCnt) * showPageCnt);		
		startPage = (endPage - showPageCnt) + 1;
		
		if(startPage <= 0) {
			startPage = 1;
		}
		
		int tempEndPage = (int) (Math.ceil(totalPageCnt / (double) pagingVO.getNowPageCnt()));
		
		if(endPage > tempEndPage) {
			endPage = tempEndPage;
		}
		
		prev = startPage == 1 ? false:true;
		next = endPage * pagingVO.getNowPageCnt() < totalPageCnt ? true : false;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public boolean isPrev() {
		return prev;
	}

	public void setPrev(boolean prev) {
		this.prev = prev;
	}

	public boolean isNext() {
		return next;
	}

	public void setNext(boolean next) {
		this.next = next;
	}

	public int getShowPageCnt() {
		return showPageCnt;
	}

	public void setShowPageCnt(int showPageCnt) {
		this.showPageCnt = showPageCnt;
	}
	
	
	
}
