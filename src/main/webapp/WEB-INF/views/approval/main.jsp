<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>
<%@ include file="/WEB-INF/views/approval/common.jsp" %>

<script>
/*
 * 문서 리스트 조회
 */
function fnct_GetDocList(doc) {
	/*
	* 문서 조회 구분 - MYDOC:내문서함, SIGNDOC:결재문서
	* 결재 상태 구분 - W:결재대기, S:결재완료, R:반려
	*/
	var docGubun  = doc;	
	var docStatus = $("#docStatus option:selected").val();	
	var params = {
			"startDay" : fnct_ReturnRmvStr($("#startOfMonth").val(), "-"),
			"endDay"   : fnct_ReturnRmvStr($("#endOfMonth").val(), "-"),
			"docGubun" : docGubun,
			"docStatus": docStatus
	};
	
	var data = fnct_CallPostAjax("/approval/getDocList.ajax", params);		
	if(data.status == "success") {
		var resultList = data.resultList;        	 
	   	var docHtml   = "";
	   	
	   	for(var i = 0; i < resultList.length; i++){
	   		docHtml += "<div class='row mt-2 pb-1 border-bottom' onclick=\"fnct_GetDocInfo('" + resultList[i].docno + "','" + docGubun + "')\">";
		   	docHtml += "	<div class='col-2 text-center'>" + resultList[i].docno + "</div>";
		   	docHtml += "	<div class='col-2 text-center'>" + resultList[i].docname + "</div>";
		   	docHtml += "	<div class='col-2 text-center'>" + resultList[i].username + " (" + resultList[i].usercd + ")</div>";
		   	docHtml += "	<div class='col-2 text-center'>" + resultList[i].requestymd + "</div>";
		   	docHtml += "	<div class='col-2 text-center'>" + resultList[i].signymd + "</div>";
		   	docHtml += "	<div class='col-2 text-center'>" + resultList[i].docstatus + "</div>";
		   	docHtml += "</div>";
	    }
	   	$("#docListSpace").empty();
	   	$("#docListSpace").append(docHtml);
	}
}

/*
 * 문서 작성
 */
function fnct_WriteDoc() {
	$("#docType").val("");
	$("#docSpace").empty();
	$("#docLayer").show();
	$("#docLayer").draggable({						 	// 팝업창 드래그							
		//containment: '#',				 	// 드래그 범위 지정
		opacity: 0.7,							 	// 드래그시 투명도
		cancel: '.card-body' 					 	// .card-body 클래스를 제외한 영역에서 드래그 가능				
	});  
}

/*
 * 문서 종류별 페이지 로드
 */
function fnct_LoadDocType(value) {	
	 var docType = value;
	 var url = "";
	 
	 switch(docType) {
	 	case "L" :
	 		url = "leavePage.do";
	 		break;
	 	case "P" :
	 		url = "prfPage.do";
	 		break;		 	
	 }		 		 
		
	 $("#docSpace").load(url);
}

/*
 * 결재 문서 조회
 */
function fnct_GetDocInfo(docNo, docGubun) {	
	var params = {
			"docNo" : docNo,
			"docGubun" : docGubun
	};
	Object.defineProperty(params, "${_csrf.parameterName}", {value : "${_csrf.token}", writable : true, enumerable : true});	
	
	$("#signSpace").empty();	
	$("#signLayer").show();
	$("#signLayer").draggable({						 	// 팝업창 드래그							
		//containment: '#',				 	// 드래그 범위 지정
		opacity: 0.7,							 	// 드래그시 투명도
		cancel: '.card-body' 					 	// .card-body 클래스를 제외한 영역에서 드래그 가능				
	});  	
	$("#signSpace").load("/approval/signDocPage.do", params)
}

$(document).ready(function() {
	var startOfMonth = moment().startOf('month').format('YYYY-MM-DD');
	var endOfMonth   = moment().endOf('month').format('YYYY-MM-DD');
		
	$("#startOfMonth").val(startOfMonth);
	$("#endOfMonth").val(endOfMonth);
	
	fnct_GetDocList('MYDOC');
	$("#docList li:first-child").click();
	
	/*
	 * 리스트 형태 클릭시 색상 변경
	 */
	$("#docList li").click(function(event) {
		$("#docList li").removeClass("bg-theme2");
		$(this).addClass("bg-theme2");		
	});
});
</script>
<div class="container-fluid">
    <table class="table table-borderless">
	  	<colgroup>
   			<col width="5%">
   			<col width=""> 
   		</colgroup>		
	  	<tr>
			<th colspan="2">						
				<h4><strong><c:out value="${loginVO.username }" /></strong>님의 전자결재</h4>
			</th>			      			    
		</tr>
		<tr class="border-top">
			<th>기안</th>
			<th>	
				<button type="button" class="btn btn-outline-secondary" onclick="fnct_WriteDoc()">문서작성</button>				
			</th>									    			
		</tr>
		<tr>
			<th>기간</th>	
			<td>
				<div class="form-inline">
			    	<input class="form-control w100" type="text" id="startOfMonth" onclick="fnct_DatePicker('startOfMonth')"> ~
			    	<input class="form-control w100" type="text" id="endOfMonth"   onclick="fnct_DatePicker('endOfMonth')">
			    </div>
			</td>								    			
		</tr>		
		<tr>
			<th>결재상태</th>	
			<td>
				<select class="form-control w100" id="docStatus">
					<option value="ALL">전체</option>
					<option value="W">결재대기</option>
					<option value="S">결재완료</option>
					<option value="R">반려</option>
				</select>																		
			</td>				
		</tr>
		<tr>
			<th>문서조회</th>	
			<td>			
				<ul class="list-group list-group-horizontal" id="docList">
				  <li class="list-group-item"><a href="javascript:fnct_GetDocList('MYDOC');" class="a-basic">내문서함</a></li>
				  <li class="list-group-item"><a href="javascript:fnct_GetDocList('SIGNDOC');" class="a-basic">결재문서</a></li>
				  <li class="list-group-item"><a href="javascript:fnct_GetDocList('ALL');" class="a-basic">문서현황</a></li>
				</ul>						
			</td>					
		</tr>		
	</table>
</div>

<div id="approvalSpace">
	<div class="container-fluid">
		<div class="row mb-2 bg-theme3">
			<div class="col-2"><h6><strong>문서번호</strong></h6></div>
			<div class="col-2"><h6><strong>유형</strong></h6></div>		
			<div class="col-2"><h6><strong>작성자</strong></h6></div>
			<div class="col-2"><h6><strong>신청일</strong></h6></div>
			<div class="col-2"><h6><strong>결재일</strong></h6></div>		
			<div class="col-2"><h6><strong>결재상태</strong></h6></div>
		</div>
	</div>
	
	<div class="container-fluid" id="docListSpace"></div>
	
	<!-- 페이징 위치 -->
	<nav class="mt-2">
		<ul class="pagination justify-content-center" id="paging">
		</ul>
	</nav>
</div>

<!-- 레이어 팝업 : 문서 작성(공통) -->
<div class="layer-doc" id="docLayer">
	<div class="card border-theme" style="width: 800px">
		<div class="card-header">
	    	<div class="float-left">
	    		문서작성	    		
	    	</div>
	    	<div class="float-right">
	    		<button type="button" class="btn-img" onclick="fnct_CloseLayer('docLayer')"><img src="/images/close.png" class="w10-h10"></button>
	    	</div>
	  	</div>
	  	<div class="card-body" id="card-content" style="height: 500px; overflow: auto">	    	
	    	<div class="container-fluid">
		    	<table class="table table-sm w-80">	    						    	
			    	<tr>
			      		<th>사번</th>
			      		<td><input type="text" class="form-control w80" id="userCd" value="<c:out value="${loginVO.usercd }" />" disabled></td>
			      		<th>성명</th>
			      		<td><input type="text" class="form-control w80" id="userName" value="<c:out value="${loginVO.username }" />" disabled></td>
			      		<th>입사일</th>
			      		<td><input type="text" class="form-control w80" id="enterYmd" value="<c:out value="${loginVO.enterymd }" />" disabled></td>			      
			    	</tr>
			    	<tr>
			      		<th>구분</th>
			      		<td colspan="5">
			      			<select class="form-control" id="docType" onchange="fnct_LoadDocType(this.value)">
	  							<option value="">선택</option>
	  							<option value="L">휴가신청서</option>
	  							<option value="P">제증명 신청서</option>
							</select>
						</td>			      
			    	</tr>		    			   
				</table>
			</div>
			
			<!-- 신청서 영역 -->
			<div class="mt-2" id="docSpace"></div>	
	  	</div>
	  	<div class="card-footer">
	  		<div class="text-center">
		  		<button type="button" class="btn btn-outline-secondary" onclick="fnct_SaveDoc()">저 장</button>
			</div>			
	  	</div>
	</div>
</div>

<!-- 레이어 팝업 : 결재 문서(공통) -->
<div class="layer-sign" id="signLayer">
	<div class="card border-theme" style="width: 800px">
		<div class="card-header">
	    	<div class="float-left">
	    		문서결재    		
	    	</div>
	    	<div class="float-right">
	    		<button type="button" class="btn-img" onclick="fnct_CloseLayer('signLayer')"><img src="/images/close.png" class="w10-h10"></button>
	    	</div>
	  	</div>
	  	<div class="card-body" id="card-content" style="height: 500px; overflow: auto">	    					
			<!-- 결재 문서 영역 -->
			<div class="mt-2" id="signSpace"></div>	
	  	</div>
	</div>
</div>