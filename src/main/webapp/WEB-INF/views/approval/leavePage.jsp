<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script>
/*
 * 휴가 사용일 계산
 */
function fnct_CalVacday() {	
	var startDay = moment($("#startDay").val());
	var endDay   = moment($("#endDay").val());
	var vacDay   = endDay.diff(startDay, 'days') + 1;	// endDay 에서 startDay 까지 일(day) Count
	var dayType  = $("#dayType option:selected").val();
	var leaveType  = $("#leaveType option:selected").val();
	
	if(leaveType == "" || dayType == "") {
		alert("구분, 전일/반일을 선택해주세요.");
		fnct_ResetDoc();
		return;
	}

	if(!isNaN(startDay) && !isNaN(endDay)) {
		if(endDay < startDay) {
			alert("종료일이 시작일보다 작을 수 없습니다.");
			$("#endDay").val("");
			return;
		} else {		
			if(dayType != "" && dayType != "all") {		// 반차인 경우
				$("#endDay").val($("#startDay").val());
				$("#vacDay").val(0.5);
			} else {				
				$("#vacDay").val(vacDay);			
			}	
		}	 
	}		
}

/*
 * 휴가일수 정보
 */
function fnct_GetLeaveInfo() {
	var params = {};

	var data = fnct_CallPostAjax("/approval/getLeaveCnt.ajax", params);
	if(data.status == "success") {	
		var result = data.result;
		
		$("#createDay").val(result.createday);
		$("#useDay").val(result.useday);
		$("#remainDay").val(result.remainday);
	}
}

/*
 * 초기화
 */
function fnct_ResetDoc() {
	$("#startDay").val("");
	$("#endDay").val("");
}

/*
 * 결재자 지정
 */
function fnct_GetApprovalUser() {
	var params = {}; 	
	var data = fnct_CallPostAjax("/approval/getApprovalUser.ajax", params);
	
	if(data.status == "success") {
   	 	fnct_OpenLayer('', 'approvalUser', 500, 250);	                	        	        	
   		
   	 	var resultList = data.resultList;        	 
	   	var userHtml   = "";
	   	
	   	for(var i = 0; i < resultList.length; i++){
	   		userHtml += "<div class='row mt-2 pb-1 border-bottom'>";
	   		userHtml += "	<div class='col-1 text-center'><div class='custom-control custom-checkbox pb-2'>";
	   		userHtml += "	  <input type='checkbox' class='custom-control-input' id='" + resultList[i].usercd + "' name='" + resultList[i].username + "' onclick='fnct_SetUser(this)'>";
	   		userHtml += "	     <label class='custom-control-label' for='" + resultList[i].usercd + "'></label>";
	   		userHtml += "	</div></div>";	   	 	
	   		userHtml += "	<div class='col text-center'>" + resultList[i].usercd + "</div>";
	   		userHtml += "	<div class='col text-center'>" + resultList[i].username + "</div>";	   		
	   		userHtml += "</div>";
	    }
	   	$("#userList").append(userHtml);
	}			
}

/*
 * 문서 저장
 */
function fnct_SaveDoc() {		
	if($(".list-group-item").length == 0) { 	// 결재자 지정 확인
		alert("결재자를 지정해주세요.");
		return;
	}
		
	if(parseInt($("#remainDay").val()) < parseInt($("#vacDay").val())) {
		alert("잔여일수를 확인해주세요.");
		return;
	}	
	
	var signUser = "";
	var signLine = "";
	
	$("#signUserList").find('span').each(function() {		
		signUser += $(this).text() + ",";
	});
	$("#signUserList").find('li').each(function() {		
		signLine += $(this).text() + ">";
	});
	
	var params = {
		  "docType"    : "L",
		  "leaveType"  : $("#leaveType").val(),
		  "dayType"    : $("#dayType").val(),
		  "requestYmd" : fnct_ReturnRmvStr($("#requestYmd").val(), "-"),
		  "startDay"   : fnct_ReturnRmvStr($("#startDay").val(), "-"),
		  "endDay"     : fnct_ReturnRmvStr($("#endDay").val(), "-"),
		  "vacDay"	   : $("#vacDay").val(),
		  "remark"     : $("#remark").val(),
		  "signUser"   : fnct_ReturnRmvStr(signUser),
		  "signLine"   : fnct_ReturnRmvStr(signLine)
	};	
	
	var data = fnct_CallPostAjax("/approval/addDoc.ajax", params);	
	if(data.status == "success") {
		alert("신청되었습니다.");
		fnct_CloseLayer('docLayer');
	}
}

/*
 * 결재자 지정
 */
function fnct_SetUser(e) {
	var userHtml = "";
	var liId = "#li-" + e.id;
		
	if($("input:checkbox[id='" + e.id + "']").is(":checked")){
		userHtml += "<li class='list-group-item' id='li-" + e.id + "'><img src='/images/down.png' class='w18-h18 mr-2'>" + e.name + "(<span class='badge badge-primary badge-pill'>" + e.id + "</span>)</li>";
		$("#signUserList").append(userHtml);		
	} else {
		$(liId).remove();
	}
	
}


$(document).ready(function() {
	var today = moment().format("YYYY-MM-DD");
	
	$("#requestYmd").val(today);
	
	fnct_GetLeaveInfo();
	
	$("#dayType").change(function() {
		fnct_CalVacday();
	});
});
</script>
<!-- 결재자 리스트 -->
<div class="card border-theme" id="approvalUser" style="display: none">
	<div class="card-header">
		<div class="float-left">
			<h5><strong>결재자 지정</strong></h5>
		</div>
		<div class="float-right">
			<button type="button" class="btn-img mt-2" onclick="fnct_CloseLayer('approvalUser')"><img src="/images/close.png" class="w10-h10"></button>
		</div>
	</div>			
    <div class="card-body text-secondary" style="overflow: auto">        
        <div class="container-fluid mb-2">
        	<div class="row">        		
        		<button type="button" class="btn btn-outline-secondary" onclick="fnct_CloseLayer('approvalUser')">완료</button>        		        	
        	</div>        	
        </div>             
        <div class="container-fluid">
	        <div class="row mb-2 bg-theme3">
				<div class="col-1"></div>
				<div class="col"><h6><strong>사번</strong></h6></div>
				<div class="col"><h6><strong>성명</strong></h6></div>				
			</div>
        </div>
        <div class="container-fluid" id="userList"></div>
    </div>                
</div>

<div class="container-fluid">
    <table class="table table-hover">
		<tr class="border-top">
	    	<th class="th-basic">발생일수</th>
	    	<td><input type="text" class="form-control w80" id="createDay" disabled></td>
	      	<th class="th-basic">사용일수</th>
	      	<td><input type="text" class="form-control w80" id="useDay" disabled></td>
	      	<th class="th-basic">잔여일수</th>
	    	<td><input type="text" class="form-control w80" id="remainDay" disabled></td>
	    </tr>
		<tr>
	    	<th class="th-basic">신청일</th>
	    	<td><input type="text" class="form-control w100" id="requestYmd" onclick="fnct_DatePicker('requestYmd')"></td>
	      	<th class="th-basic">구분</th>
	      	<td>
	      		<select class="form-control w100" id="leaveType">
					<option value="">선택</option>
					<option value="year">년차</option>
					<option value="sick">병가</option>
					<option value="trng">훈련</option>
				</select>
	      	</td>
	      	<th class="th-basic">전일/반일</th>
	    	<td>
	    		<select class="form-control w100" id="dayType">
					<option value="">선택</option>
					<option value="all">전일</option>
					<option value="am">오전반차</option>
					<option value="pm">오후반차</option>
				</select>
	    	</td>	      		    
	    </tr>	    
	    <tr>
	    	<th class="th-basic">기간</th>
	    	<td colspan="5">
	    		<div class="form-inline">
	    			<input class="form-control w100" type="text" name="startDay" id="startDay" onclick="fnct_DatePicker('startDay')" onchange="fnct_CalVacday()" placeholder="시작일"> ~
	    			<input class="form-control w100" type="text" name="endDay" id="endDay" onclick="fnct_DatePicker('endDay')" onchange="fnct_CalVacday()" placeholder="종료일">
	    			(일수 :  <input class="form-control w80" type="text" name="vacDay" id="vacDay" disabled>)
	    		</div>
	    	</td>
	    </tr>
	    <tr>
	    	<th class="th-basic">휴가사유</th>
	    	<td colspan="5"><textarea class="form-control" id="remark"></textarea></td>	      	
	    </tr>
	    <tr class="border-top">
			<th>결재선</th>
			<td colspan="5">
				<button type="button" class="btn btn-outline-secondary" onclick="fnct_GetApprovalUser()">설정</button>				
			</td>
		</tr>		
	</table>
	<ul class="list-group list-group-flush" id="signUserList"></ul>	
</div>