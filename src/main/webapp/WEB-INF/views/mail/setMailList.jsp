<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="/include/common.js"></script>

<link rel="stylesheet" type="text/css" href="/resources/grid/ax5grid.css">
<script type="text/javascript" src="/resources/grid/ax5core.min.js"></script>
<script type="text/javascript" src="/resources/grid/ax5grid.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>
 
<script>
/*
 * 메일 리스트 조회
 */
function fnct_SetMailList(nowPage){	
	if(nowPage == "" || nowPage == undefined) {
		nowPage = 1;
	}
	
	var params = {
			"nowPage" : nowPage
	};
	
	var data = fnct_CallPostAjax("/mail/setMailList.ajax", params);
	
	if(data.status == "success") {
		var resultList = data.resultList;        	 
	   	var mailHtml   = "";
	   	var pagingHtml = "";
	   	var startPage  = data.paging.startPage;
	   	var endPage    = data.paging.endPage;        	 
	   	$("#mailListSpace").empty();
	   	$("#paging").empty();
	   	
	   	for(var i = 0; i < resultList.length; i++){
	   	 	mailHtml += "<div class='row mt-2 pb-1 border-bottom' id='mailList'>";
	   	 	mailHtml += "	<div class='col-1 text-center'><div class='custom-control custom-checkbox pb-2'>";
	   	 	mailHtml += "	  <input type='checkbox' class='custom-control-input' id='" + resultList[i].mailno + "' name='mailId'>";
	   	 	mailHtml += "	     <label class='custom-control-label' for='" + resultList[i].mailno + "'></label>";
	   	 	mailHtml += "	</div></div>";
	   	 	mailHtml += "	<div class='col-1 text-center'><img src='/images/file_" + resultList[i].mailfile + ".png' class='w18-h18'></div>";
	   	 	mailHtml += "	<div class='col-2 text-center'>" + resultList[i].username + "</div>";
	   		mailHtml += "	<div class='col-4'><a href='javascript:fnct_ShowSetMailContent(" + resultList[i].mailno + ")'>" + resultList[i].mailtitle + "</a></div>";
	   		mailHtml += "	<div class='col-2 text-center'>" + resultList[i].fromdate + "</div>";
	   		mailHtml += "	<div class='col-2 text-center'>" + resultList[i].readdate + "</div>";
	   		mailHtml += "</div>";
	    }
	   	
	   	// 페이징 처리
	   	if(data.paging.prev) {
	   		startPage = startPage - 1;
		   	pagingHtml += "<li class='page-item'>";
		   	pagingHtml += "	<a class='page-link' href='javascript:fnct_SetMailList(" + startPage + ");' tabindex='-1' aria-disabled='true'>이전</a>";
		   	pagingHtml += "</li>";
	   	}
	   	
	   	for(var i = startPage; i < endPage; i++){            	
	   		pagingHtml += "<li class='page-item'>";    
	   		pagingHtml += "	<a class='page-link' href='javascript:fnct_SetMailList(" + i + ");'>" + i + "</a>";
	   		pagingHtml += "</li>";
	   	}
	   	 
	   	if(data.paging.next && endPage > 0) {
	   		endPage = endPage + 1;
	   		pagingHtml += "<li class='page-item'>";
	   		pagingHtml += "	<a class='page-link' href='javascript:fnct_SetMailList(" + endPage + ");'>다음</a>";
			pagingHtml += "</li>";
	   	}
	   	      	       	         	 
	   	$("#mailListSpace").append(mailHtml);
	   	$("#paging").append(pagingHtml);
	}	
}

/*
 * 메일 내용 조회
 */
function fnct_ShowSetMailContent(mailNo) {
	var params = {
			"mailNo" : mailNo
	};
	
	var data = fnct_CallPostAjax("/mail/setMailContent.ajax", params);
	
	if(data.status == "success") {
		var result = data.result;
    	var fromuser = result.username + "(" + result.fromuser + ")" + " - " + result.fromdate;
      	
    	$("#reply-content").empty();
    	$("#mailNo").val(result.mailno);
    	$("#mailTitle").html(result.mailtitle);		// 메일 제목
    	$("#mailContent").html(result.mailcontent);	// 메일 내용
    	$("#toUser").html(result.touser);			// 받는 사람
    	$("#ccUser").html(result.ccuser);			// 참조
    	$("#mailFile").html(result.mailfile);		// 첨부 파일
    	$("#fromUser").html(fromuser);        		// 보낸 사람
    	
    	$("#mailLayer").show();        	
    	$("#card-mail").draggable({						 	// 팝업창 드래그							
			//containment: '#',				 	// 드래그 범위 지정
			opacity: 0.7,							 	// 드래그시 투명도
			cancel: '.card-body' 					 	// .card-body 클래스를 제외한 영역에서 드래그 가능				
		});     	
	}
}

$(document).ready(function() {
	fnct_SetMailList();
});
</script>
<!-- 사용자 메일 리스트 -->
<div class="card border-secondary" id="searchUsermail" style="display: none">
	<div class="card-header">
		<div class="float-left">
			<h5><strong>메일 주소록</strong></h5>
		</div>
		<div class="float-right">
			<button type="button" class="btn-img mt-2" onclick="fnct_CloseLayer('searchUsermail')"><img src="/images/close.png" class="w10-h10"></button>
		</div>
	</div>			
    <div class="card-body text-secondary" style="overflow: auto">        
        <div class="container-fluid mb-2">
        	<div class="row">        		
        		<button type="button" class="btn btn-outline-secondary" onclick="fnct_ChooseMail()">선택</button>        		
        	</div>        	
        </div>             
        <div data-ax5grid="first-grid" data-ax5grid-config="{}" style="height: 300px;"></div>
    </div>                
</div>

<div class="container-fluid">	
	<table class="table table-borderless">
	  	<tr>
			<th colspan="4">						
				<h4><strong>보낸메일함</strong></h4>
			</th>			      			    
		</tr>
		<tr class="border-top">
			<th colspan="4">
				<button type="button" class="btn btn-outline-secondary" onclick="fnct_SetMailStatus('P')">휴지통</button>
				<button type="button" class="btn btn-outline-secondary" onclick="fnct_SetMailStatus('D')">삭 제</button>												
			</th>									    
		</tr>
	</table>
</div>
<div class="container-fluid">
	<div class="row mb-2 bg-theme3">
		<div class="col-1">
			<div class="custom-control custom-checkbox pt-1">
				<input type="checkbox" class="custom-control-input" id="allMail" onclick="fnct_AllMail()">
				<label class="custom-control-label" for="allMail"></label>
			</div>
		</div>
		<div class="col-1"><h6><strong>첨부</strong></h6></div>
		<div class="col-2"><h6><strong>보낸사람</strong></h6></div>
		<div class="col-4"><h6><strong>제목</strong></h6></div>
		<div class="col-2"><h6><strong>받은날짜</strong></h6></div>
		<div class="col-2"><h6><strong>읽은날짜</strong></h6></div>
	</div>
</div>

<div class="container-fluid" id="mailListSpace"></div>

<!-- 페이징 위치 -->
<nav class="mt-2">
	<ul class="pagination justify-content-center" id="paging">
	</ul>
</nav>

<!-- 레이어 팝업 : 회신/전달 메일 -->
<div class="layer-mail" id="replyMailLayer">
	<div class="card" id="card-reply" style="width: 800px">
		<div class="card-header">
	    	<div class="float-left">
	    		<img src="/images/mailopen.png" class="w18-h18"> : 
	    	</div>
	    	<div class="float-right">
	    		<button type="button" class="btn-img" onclick="fnct_CloseLayer('replyMailLayer')"><img src="/images/close.png" class="w10-h10"></button>
	    	</div>
	  	</div>
	  	<div class="card-body" id="reply-content" style="height: 500px; overflow: auto">	    			
	  	</div>
	  	<div class="card-footer">
	  		<div class="text-center">
		  		<button type="button" class="btn btn-outline-secondary" id="btn-send" onclick="fnct_SendMail()">보내기</button>
			</div>			
	  	</div>
	</div>
</div>

<!-- 레이어 팝업 : 보낸 메일 -->
<div class="layer-mail" id="mailLayer">
	<input type="hidden" id="mailNo">
	<div class="card" id="card-mail" style="width: 800px">
		<div class="card-header">
	    	<div class="float-left">
	    		<img src="/images/mailopen.png" class="w18-h18"> : <span id="fromUser"></span>
	    	</div>
	    	<div class="float-right">
	    		<button type="button" class="btn-img" onclick="fnct_CloseLayer('mailLayer')"><img src="/images/close.png" class="w10-h10"></button>
	    	</div>
	  	</div>
	  	<div class="card-body" id="card-content" style="height: 500px; overflow: auto">	    	
	    	<table class="table table-sm">
	    		<colgroup>
	    			<col width="15%">
	    			<col width=""> 
	    		</colgroup>				
		    	<tr>
		      		<th colspan="2"><h4 class="ml-4"><strong><span id="mailTitle"></span></strong></h4></th>		      					   
		    	</tr>
		    	<tr>
		      		<th>받는사람</th>
		      		<td><span id="toUser"></span></td>			      
		    	</tr>
		    	<tr>
		      		<th>참조(CC)</th>
		      		<td><span id="ccUser"></span></td>			      
		    	</tr>
		    	<tr class="border-bottom">
		      		<th>첨부파일</th>
		      		<td><span id="mailFile"></span></td>			      
		    	</tr>
		    	<tr>		      		
		      		<td colspan="2"><span id="mailContent"></span></td>			      
		    	</tr>		    				    
			</table>			
	  	</div>
	  	<div class="card-footer">
	  		<div class="text-center">
		  		<button type="button" class="btn btn-outline-secondary" id="btn-reply" onclick="fnct_ReplyMail('R')">답 장</button>
				<button type="button" class="btn btn-outline-secondary" id="btn-forward" onclick="fnct_ReplyMail('F')">전 달</button>
			</div>			
	  	</div>
	</div>
</div>