<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
/*
 * 신청서 조회(휴가)
 */
function fnct_GetLeaveDoc() {
	var docno = "${docNo}";
	var params = {
			"docNo" : docno
	};
	
	var data = fnct_CallPostAjax("/approval/getDocLeave.ajax", params);		
	if(data.status == "success") {
		var result = data.result;
		var resultList = data.resultList;
		var signHtml = "";

		$("#docnoS").val(result.docno);
		$("#requestYmdS").val(result.requestymd);
		$("#leaveTypeS").val(result.leavetype);
		$("#docTypeS").val(result.doctype);
		$("#docStatusS").val(result.docstatus);
		$("#dayTypeS").val(result.daytype);
		$("#startDayS").val(result.startday);
		$("#endDayS").val(result.endday);
		$("#remarkS").html(result.remark);
		$("#username").text(result.username);		
		$("#usercd").text(result.usercd);
		$("#returnCause").html(result.returncause);
		
		for(var i = 0; i < resultList.length; i++) {	
			if(resultList[i].signuser == "${loginVO.usercd }") {
				signHtml += "<li class='list-group-item' style='background-color: #ff6f61'><img src='/images/down.png' class='w18-h18 mr-2'>"	
			} else {
				signHtml += "<li class='list-group-item'><img src='/images/down.png' class='w18-h18 mr-2'>"
			}			
			signHtml += resultList[i].username + "<span class='badge badge-primary badge-pill mr-2'>(" + resultList[i].signuser + ")</span>";
			signHtml += resultList[i].docstatus + "<span class='badge badge-primary badge-pill'>(" + resultList[i].signymd + ")</span>";
			signHtml += "</li>"; 					
		}		
		
		/* 최종 결재가 된 문서 */
		if(resultList[resultList.length-1].signymd != "-") {
			$("#btnSign").attr("disabled", true);
			$("#btnReturn").attr("disabled", true);
		}
		
		$("#signLineS").append(signHtml);	
	}
		
}

/*
 * 신청서 결재/반려 처리
 */
function fnct_SignDoc(docStatus) {
	if(docStatus == "R") {
		$("#returnCause").attr("disabled", false);
		
		if($("#returnCause").val() == "") {
			alert("반려사유를 입력해주세요.");
			return;
		}
	}	

	var params = {
			"usercd": $("#usercd").text(),
			"docNo" : $("#docnoS").val(),			
			"docType" : $("#docTypeS").val(),
			"docStatus" : docStatus,
			"returnCause" : $("#returnCause").val()		
	};
	
	var data = fnct_CallPostAjax("/approval/editDocSign.ajax", params);		
	if(data.status == "success") {
		alert("결재되었습니다.");
		fnct_CloseLayer('signLayer');
	}
}

$(document).ready(function() {
	fnct_GetLeaveDoc();
});

</script>
<c:if test="${docGubun eq 'SIGNDOC'}">
<div class="container-fluid mb-2">
	<div class="row">
		<div class="col-12 text-center">
			<button type="button" class="btn btn-outline-secondary" id="btnSign" onclick="fnct_SignDoc('S')">결 재</button>
			<button type="button" class="btn btn-outline-secondary" id="btnReturn" onclick="fnct_SignDoc('R')">반 려</button>
		</div>
	</div>	
</div>
</c:if>

<div class="container-fluid">
<input type="hidden" id="docnoS">
	<div class="row mt-2" id="returnCauseSpace">
		<div class="col-12">
			<div class="form-group">
			    <label for="returnCause">반려사유</label>
				<textarea class="form-control" id="returnCause" disabled="disabled"></textarea>
			</div>			
		</div>
	</div>
    <table class="table table-hover">
    	<tr>
    		<th class="th-basic">신청자</th>
    		<td colspan="5"><span id="username"></span>(<span id="usercd"></span>)</td>
    	</tr>
    	<tr class="border-bottom">
	    	<th class="th-basic">문서구분</th>
	    	<td>
	    		<select class="form-control" id="docTypeS" disabled="disabled">
					<option value="">선택</option>
					<option value="L">휴가신청서</option>
					<option value="P">제증명 신청서</option>
				</select>
	    	</td>
	    	<th class="th-basic">결재상태</th>
	    	<td colspan="3">
	    		<select class="form-control w100" id="docStatusS" disabled="disabled">
					<option value="">전체</option>
					<option value="W">결재대기</option>
					<option value="S">결재완료</option>
					<option value="R">반려</option>
				</select>
	    	</td>	    	
	    </tr>	
		<tr>
	    	<th class="th-basic">신청일</th>
	    	<td><input type="text" class="form-control w100" id="requestYmdS" disabled="disabled"></td>
	      	<th class="th-basic">구분</th>
	      	<td>
	      		<select class="form-control w100" id="leaveTypeS" disabled="disabled">
					<option value="">선택</option>
					<option value="year">년차</option>
					<option value="sick">병가</option>
					<option value="trng">훈련</option>
				</select>
	      	</td>
	      	<th class="th-basic">전일/반일</th>
	    	<td>
	    		<select class="form-control w100" id="dayTypeS" disabled="disabled">
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
	    			<input class="form-control w100" type="text" name="startDayS" id="startDayS" disabled="disabled"> ~
	    			<input class="form-control w100" type="text" name="endDayS" id="endDayS" disabled="disabled">	    		
	    		</div>
	    	</td>
	    </tr>
	    <tr>
	    	<th class="th-basic">휴가사유</th>
	    	<td colspan="5"><textarea class="form-control" id="remarkS" disabled="disabled"></textarea></td>	      	
	    </tr>
	    <tr class="border-top border-bottom">
			<th colspan="6">결재선 (*결재시, 본인의 결재선까지 자동 결재됩니다.)</th>			
		</tr>			
	</table>
	<ul class="list-group list-group-flush" id="signLineS"></ul>	
</div>