<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
/*
 * (Modal)header.jsp에 위치
 *  Modal창이 가려지는 현상 때문에 header에 위치(userImg, userPassword)
 */
function fcnt_SaveUserImg() {
	$("#userImgfile").MultiFile("reset");	// 파일 초기화
	$("#userImg").modal("show");
}

function fnct_UserPassword() {
	$("#frm_header3")[0].reset();
	$("#userPassword").modal("show");
}

function fcnt_DeleteUserImg() {

}

$(document).ready(function() {
	var img = "${loginVO.userimg }";

	if(img == "userimg.png") {		// 기본 이미지일 때
		$("#deleteImgBtn").attr("disabled", true);
	}
});
</script>

<div class="card border-theme">
	<div class="card-header">
    	<div class="float-left">
    		개인정보
    	</div>
    	<div class="float-right">
    		<button type="button" class="btn-img" onclick="commonCloseLayer('userInfo')"><img src="/images/close.png" class="w10-h10"></button>
    	</div>
  	</div>
  	<div class="card-body" id="card-content" style="height: 445px; overflow: auto">
  		<div class="container-fluid border-bottom">
	  		<div class="row">
				<div class="col-12 text-center mb-2">
					<img src="/mfile/user/<c:out value="${loginVO.userimg }" />" class="w128-h128">
					<hr>
				</div>
				<div class="col-12 text-center mb-2">
					<button type="button" class="btn btn-outline-secondary" id="saveImgBtn" onclick="fcnt_SaveUserImg()">등록</button>
					<button type="button" class="btn btn-outline-secondary" id="deleteImgBtn" onclick="fcnt_DeleteUserImg()">삭제</button>
				</div>
			</div>

			<div class="row mt-2">
				<div class="col-12">
					<table class="table">
						<colgroup>
							<col width="100px"/>
							<col width="*"/>
							<col width="100px"/>
							<col width="*"/>
						</colgroup>
						<tr class="border-top">
							<th class="th-basic">아이디</th>
							<td><c:out value="${loginVO.userid }" /></td>
							<th class="th-basic">패스워드</th>
							<td><button type="button" class="btn btn-outline-secondary" onclick="fnct_UserPassword()">패스워드변경</button></td>
						</tr>
						<tr>
							<th class="th-basic">사번</th>
							<td><c:out value="${loginVO.usercd }" /></td>
							<th class="th-basic">이름</th>
							<td><c:out value="${loginVO.username }" /></td>
						</tr>
						<tr>
							<th class="th-basic">핸드폰</th>
							<td><c:out value="${loginVO.mobileno }" /></td>
							<th class="th-basic">PLANM 이메일</th>
							<td><c:out value="${loginVO.usermail }" /></td>
						</tr>
						<tr>
							<th class="th-basic">회사</th>
							<td><c:out value="${loginVO.cmpname }" /></td>
							<th class="th-basic">회사전화번호</th>
							<td><c:out value="${loginVO.cmptel }" /></td>

						</tr>
						<tr>
							<th class="th-basic">부서</th>
							<td colspan="3"></td>
						</tr>
						<tr>
							<th class="th-basic">직위</th>
							<td></td>
							<th class="th-basic">직책</th>
							<td></td>
						</tr>
						<tr class="border-bottom">
							<th class="th-basic">회사주소</th>
							<td colspan="3"><c:out value="${loginVO.cmpaddr }" /></td>
						</tr>
					</table>
				</div>
			</div>
  		</div>
  	</div>
</div>

