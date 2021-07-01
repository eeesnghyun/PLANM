<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<script>
// 문서 저장
var saveDoc = function() {
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
		  "startDay"   : fnct_ReturnRmvStr($("#docStartDay").val(), "-"),
		  "endDay"     : fnct_ReturnRmvStr($("#docEndDay").val(), "-"),
		  "vacDay"	   : $("#vacDay").val(),
		  "remark"     : $("#remark").val(),
		  "signUser"   : fnct_ReturnRmvStr(signUser),
		  "signLine"   : fnct_ReturnRmvStr(signLine)
	};

	var data = commonCallAjax("/approval/addDoc.ajax", params);

	if(data.status == "success") {
		alert("신청되었습니다.");
		commonCloseLayer('docLayer');
	}
};

// 휴가 사용일 계산
var getLeaveUseday = function() {
	var startDay = moment($("#docStartDay").val());
	var endDay   = moment($("#docEndDay").val());
	var vacDay   = endDay.diff(startDay, 'days') + 1;
	var dayType  = $("#dayType option:selected").val();
	var leaveType  = $("#leaveType option:selected").val();

	if(leaveType == "" || dayType == "") {
		alert("구분, 전일/반일을 선택해주세요.");
		resetDoc();
		return;
	}

	if(!isNaN(startDay) && !isNaN(endDay)) {
		if(endDay < startDay) {
			alert("종료일이 시작일보다 작을 수 없습니다.");
			$("#docEndDay").val("");
			return;
		} else {
			if(dayType != "" && dayType != "all") {		// 반차인 경우
				$("#docEndDay").val($("#docStartDay").val());
				$("#vacDay").val(0.5);
			} else {
				$("#vacDay").val(vacDay);
			}
		}
	}
};

// 사용자 휴가일수 정보
var getUserLeave = function() {
	var params = {};
	var data = commonCallAjax("/approval/getLeaveCnt.ajax", params);

	if(data.status == "success") {
		var result = data.result;

		$("#createDay").val(result.createday);
		$("#useDay").val(result.useday);
		$("#remainDay").val(result.remainday);
	}
};

// 문서 초기화
var resetDoc = function() {
	$("#docStartDay").val("");
	$("#docEndDay").val("");
};

// 결재자 리스트 조회
var getApprovalList = function() {
	var params = {};
	var data = commonCallAjax("/approval/getApprovalList.ajax", params);

	if(data.status == "success") {
   	 	fnct_OpenLayer('', 'approvalUser', 500, 250);

   	 	resultList = data.resultList;
	   	var userHtml   = "";

	   	for(var i = 0; i < resultList.length; i++){
	   		userHtml += "<div class='row mt-2 pb-1 border-bottom'>";
	   		userHtml += "	<div class='col-1 text-center'><div class='custom-control custom-checkbox pb-2'>";
	   		userHtml += "	  <input type='checkbox' class='custom-control-input' id='" + resultList[i].usercd + "' name='" + resultList[i].username + "' onclick='setApprovalUser(this)'>";
	   		userHtml += "	     <label class='custom-control-label' for='" + resultList[i].usercd + "'></label>";
	   		userHtml += "	</div></div>";
	   		userHtml += "	<div class='col text-center'>" + resultList[i].usercd + "</div>";
	   		userHtml += "	<div class='col text-center'>" + resultList[i].username + "</div>";
	   		userHtml += "</div>";
	    }

	   	$("#userList").append(userHtml);
	}
};

// 결재자 지정
var setApprovalUser = function(e) {
	var userHtml = "";
	var liId = "#li-" + e.id;

	if($("input:checkbox[id='" + e.id + "']").is(":checked")){
		userHtml += "<li class='list-group-item' id='li-" + e.id + "'><img src='/images/down.png' class='w18-h18 mr-2'>" + e.name + "(<span class='badge badge-primary badge-pill'>" + e.id + "</span>)</li>";
		$("#signUserList").append(userHtml);
	} else {
		$(liId).remove();
	}
};

$(document).ready(function() {
	$('[data-ax5picker="basic"]').ax5picker({
        direction: "top",
        content: {
            type: 'date'
        }
    });
	$('[data-ax5formatter]').ax5formatter();

	var today = moment().format("YYYY-MM-DD");

	$("#requestYmd").val(today);

	getUserLeave();

	$("#dayType").on("change", function() {
		getLeaveUseday();
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
			<button type="button" class="btn-img mt-2" onclick="commonCloseLayer('approvalUser')"><img src="/images/close.png" class="w10-h10"></button>
		</div>
	</div>
    <div class="card-body text-secondary" style="overflow: auto">
        <div class="container-fluid mb-2">
        	<div class="row">
        		<button type="button" class="btn btn-outline-secondary" onclick="commonCloseLayer('approvalUser')">완료</button>
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
    	<colgroup>
    		<col width="100">
    		<col width="160">
    		<col width="100">
    		<col width="160">
    		<col width="100">
    		<col width="">
    	</colgroup>
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
	    	<td>
	    		<div class="input-group" data-ax5picker="basic">
		            <input class="form-control" type="text" id="requestYmd" data-ax5formatter="date">
		            <span class="input-group-addon"><i class="fa fa-calendar-o"></i></span>
		        </div>
	    	</td>
	      	<th class="th-basic">구분</th>
	      	<td>
	      		<select class="form-control" id="leaveType">
					<option value="">선택</option>
					<option value="year">년차</option>
					<option value="sick">병가</option>
					<option value="trng">훈련</option>
				</select>
	      	</td>
	      	<th class="th-basic">전일/반일</th>
	    	<td>
	    		<select class="form-control" id="dayType">
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
					<div class="input-group" data-ax5picker="basic">
			            <input class="form-control" type="text" id="docStartDay" onchange="getLeaveUseday()" data-ax5formatter="date" placeholder="시작일">
			            <span class="input-group-addon"><i class="fa fa-calendar-o"></i></span>
			        </div>
			        <div class="input-group" data-ax5picker="basic">
			            <input class="form-control" type="text" id="docEndDay" onchange="getLeaveUseday()" data-ax5formatter="date" placeholder="종료일">
			            <span class="input-group-addon"><i class="fa fa-calendar-o"></i></span>
			        </div>
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
				<button type="button" class="btn btn-outline-secondary" onclick="getApprovalList()">설정</button>
			</td>
		</tr>
	</table>
	<ul class="list-group list-group-flush" id="signUserList"></ul>
</div>