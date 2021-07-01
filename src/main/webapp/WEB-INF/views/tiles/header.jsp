<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<script>
/* 시큐리티 토큰 */
var token = $("input[name='_csrf']").val();
var header = "X-CSRF-TOKEN";

function fnct_RecordTime() {
	$("#goLeave").modal("show");

	var params = {};

	var data = commonCallAjax("/manage/getMaxWorkday.ajax", params);
	if(data.status == "success") {
		if(data.cnt != 0) {		// 퇴근 기록이 없는 경우
			$("#btn-CommuteF").show();
			$("#btn-CommuteT").hide();
		}
	}
}

/*
 * 유저 정보 조회
 */
function fnct_GetUserInfo() {
	fnct_OpenLayer("usericon", "userInfo", 500, "", 20, -450);

	$("#userInfo").load("/login/userInfo.do");
}

/*
 * 비밀번호 체크
 */
function fnct_CheckPass() {
	if($("#renewPass").val() == "" || $("#newPass").val() == "") {
		alert("비밀번호를 입력해주세요.");
		return;
	}

	if($("#renewPass").val() != $("#newPass").val()) {
		alert("비밀번호가 다릅니다.");
		return;
	}
}

/*
 * 비밀번호 변경
 */
function fnct_EditPass() {
	fnct_CheckPass();

	var params = {
			"beforePass" : $("#beforePass").val(),
			"newPass" : $("#newPass").val()
	};

	var data = commonCallAjax("/login/checkPass.ajax", params);
	if(data.status == "success") {
		alert("비밀번호가 변경되었습니다.");
	} else {
		alert("비밀번호가 틀렸습니다.");
	}

	$("#userPassword").modal("hide");
}

/*
 * 로그아웃 처리
 */
function fnct_Logout() {
	$("#frm_header1").submit();
}

function fnct_GetRealTime() {
	var today = moment();
	var msg = today.format("YYYY.MM.DD HH:mm:ss");

    $("#div-Clock").html(msg);

    setTimeout(fnct_GetRealTime,1000);
}

/*
 * 출,퇴근 기록
 */
function fnct_RecordCommute(flag) {
	var today = moment();
	var date = today.format("YYYY.MM.DD HH:mm:ss");

	var params = {
			"flag"	  : flag,
			"todate"  : date,
			"fromdate": date
	};

	var data = commonCallAjax("/manage/recordCommute.ajax", params);
	if(data.status == "success") {
		alert("확인되었습니다.");
	}
}

$(document).ready(function() {

	/* 업로드 파일 설정 */
	fnct_MultiFile("userImgfile", "img", 1);

	/* 이미지 등록시 체크 */
	$("#frm_header2").submit(function() {
		if($(".MultiFile-title").text() == "" || $(".MultiFile-title").text() == undefined) {
			alert("이미지를 등록해주세요.");
			return false;
		}
	});
});
</script>

<%--
아이디 : <c:out value="${loginVO.userid }" /> <br>
IP : <c:out value="${userIp }" /> <br>
이름 :  <c:out value="${loginVO.username }" /> <br>
회사코드 : <c:out value="${loginVO.cmpcd }" />
 --%>
<body onload="fnct_GetRealTime()">
	<div class="d-flex flex-column flex-md-row align-items-center px-md-4 bg-white border-bottom" style="padding: 8px">
		<h5 class="my-0 mr-md-auto font-weight-normal">
			<a href="/main.do"><img class="thumb-logo" src="/images/<c:out value="${loginVO.cmplogo }" />"></a>｜<strong><c:out value="${loginVO.cmpname }" /></strong>
		</h5>


		<nav class="my-2 my-md-0 mr-md-3">
			<button type="button" class="btn btn-primary mr-2" onclick="fnct_RecordTime()">출/퇴근 체크</button>
			<a href="javascript:fnct_GetUserInfo();"><img src="/images/usericon.png" class="w32-h32" id="usericon"></a>
			<a class="p-2 text-dark" href="javascript:fnct_Logout();"><img class="w18-h18" src="/images/logout.png"></a>
		</nav>

		<sec:authorize access="isAuthenticated()">
			<form:form id="frm_header1" action="/logout.do" method="POST">
		 	</form:form>
		</sec:authorize>
	</div>

	<!-- 사용자 정보 -->
	<div id="userInfo" style="display: none"></div>

	<!-- 출/퇴근 기록 -->
	<div class="modal fade" id="goLeave">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5><strong>출/퇴근 기록</strong></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="clock">
						<h3><strong><span id="div-Clock"></span></strong></h3>
					</div>
				</div>
				<div class="modal-footer">
					<div style="margin: 0px auto">
						<button type="button" class="btn btn-outline-secondary" id="btn-CommuteT" data-dismiss="modal" onclick="fnct_RecordCommute('T')">출 근</button>
						<button type="button" class="btn btn-outline-secondary" id="btn-CommuteF" data-dismiss="modal" onclick="fnct_RecordCommute('F')" style="display: none">퇴 근</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 이미지 업로드 -->
	<form:form id="frm_header2" action="/login/saveUserImg.ajax" method="POST" enctype="multipart/form-data">
	<div class="modal fade" id="userImg">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5><strong>이미지 업로드</strong></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="file" class="form-control" id="userImgfile" name="userImgfile">
					<div id="userImgfile-list"></div>
					<ul class="list-group list-group-flush mt-2">
						<li class="list-group-item list-group-item-secondary">파일 확장자    : jpg, png, gif</li>
						<li class="list-group-item list-group-item-secondary">파일 최대 용량 : 500KByte</li>
						<li class="list-group-item list-group-item-secondary">이미지 Width   : 128px(권장)</li>
						<li class="list-group-item list-group-item-secondary">이미지 Height  : 128px(권장)</li>
					</ul>
				</div>
				<div class="modal-footer">
					<input type="submit" class="btn btn-secondary" value="저장">
					<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
	</form:form>

	<!-- 패스워드 변경 -->
	<form:form id="frm_header3">
	<div class="modal fade" id="userPassword">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5><strong>패스워드 변경</strong></h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="password" class="form-control mb-2" id="beforePass" placeholder="현재 비밀번호">
					<input type="password" class="form-control mb-2" id="newPass"    placeholder="새 비밀번호">
					<input type="password" class="form-control" 	 id="renewPass"  placeholder="새 비밀번호 확인" onchange="fnct_CheckPass()">
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" onclick="fnct_EditPass()">저장</button>
					<button type="button" class="btn btn-outline-secondary" data-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
	</form:form>
</body>