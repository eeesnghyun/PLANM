<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>Test WEB</title>

<script>
/* 시큐리티 토큰 */
var token = $("input[name='_csrf']").val();
var header = "X-CSRF-TOKEN"; 


function fcnt_Login(){
	$("#frm_header")[0].reset();
	$("#testDiv").modal("show");
	
}

$(document).ready(function() {
	
});
</script>
</head>
<body class="text-center mt-5">
<form:form id="frm_header" action="/login/testEnter.ajax" method="POST">
	<button type="button" class="btn btn-outline-secondary" onclick="fcnt_Login()">접속</button>
	<div class="modal fade" id="testDiv">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="text" class="form-control mb-2" id="ipt-id" name="ipt-id" placeholder="아이디">
					<input type="password" class="form-control mb-2" id="ipt-pass" name="ipt-pass" placeholder="패스워드">
				</div>
				<div class="modal-footer">
					<div style="margin: 0px auto">
						<button type="submit" class="btn btn-outline-secondary" onclick="fcnt_Enter()">접속</button>
					</div>				
				</div>
			</div>
		</div>
	</div>
</form:form>
</body>