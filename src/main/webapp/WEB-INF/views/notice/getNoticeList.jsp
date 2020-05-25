<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<script>
function fnct_GetNoticeList(nowPage) {	
	if(nowPage == "" || nowPage == undefined) {
		nowPage = 1;
	}
	
	var params = {
			"nowPage"    : nowPage
	};
	
	var data = fnct_CallPostAjax("/notice/getNoticeList.ajax", params);
	
	if(data.status == "success") {
		var resultList = data.resultList;        	 
	   	var noticeHtml = "";
	   	var pagingHtml = "";
	   	var startPage  = data.paging.startPage;
	   	var endPage    = data.paging.endPage;        	 
	   	$("#noticeList").empty();
	   	$("#paging").empty();
	   	
	   	for(var i = 0; i < resultList.length; i++){
	   	 	noticeHtml += "<div class='row mt-2 pb-1' id='mailList'>";
	   	 	noticeHtml += "  <div class='col-2 text-center'>" + resultList[i].noticeno + "</div>";
	   	 	noticeHtml += "	 <div class='col-6'><a href='javascript:fnct_ShowNoticeContent(" + resultList[i].noticeno + ")'>" + resultList[i].noticetitle + "</a></div>";
	   		noticeHtml += "	 <div class='col-2 text-center'>" + resultList[i].username + "</div>";
	   		noticeHtml += "	 <div class='col-2 text-center'>" + resultList[i].noticedate + "</div>";
	   		noticeHtml += "</div>";
	    }
	   	
	   	// 페이징 처리
	   	if(data.paging.prev) {
	   		startPage = startPage - 1;
		   	pagingHtml += "<li class='page-item'>";
		   	pagingHtml += "	<a class='page-link' href='javascript:fnct_GetNoticeList(" + startPage + ");' tabindex='-1' aria-disabled='true'>이전</a>";
		   	pagingHtml += "</li>";
	   	}
	   	
	   	for(var i = startPage; i < endPage; i++){            	
	   		pagingHtml += "<li class='page-item'>";    
	   		pagingHtml += "	<a class='page-link' href='javascript:fnct_GetNoticeList(" + i + ");'>" + i + "</a>";
	   		pagingHtml += "</li>";
	   	}
	   	 
	   	if(data.paging.next && endPage > 0) {
	   		endPage = endPage + 1;
	   		pagingHtml += "<li class='page-item'>";
	   		pagingHtml += "	<a class='page-link' href='javascript:fnct_GetNoticeList(" + endPage + ");'>다음</a>";
			pagingHtml += "</li>";
	   	}
	   	      	       	         	 
	   	$("#noticeList").append(noticeHtml);
	   	$("#paging").append(pagingHtml);
	}	
}


$(document).ready(function() {		
	fnct_GetNoticeList(1);
});
</script>
<div class="container-fluid">
	<div class="row text-center">		
		<div class="col-2"><h6><strong>No</strong></h6></div>
		<div class="col-6"><h6><strong>제목</strong></h6></div>
		<div class="col-2"><h6><strong>작성자</strong></h6></div>
		<div class="col-2"><h6><strong>작성날짜</strong></h6></div>			
	</div>
	<div class="row">
		<div class="col-12">
			<div id="noticeList"></div>
		</div>
	</div>
	<nav class="mt-2">
		<ul class="pagination justify-content-center" id="paging"></ul>
	</nav>
</div>

