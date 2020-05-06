<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="/WEB-INF/views/common/sources.jsp" %>
<!DOCTYPE html>
<html>
<head>
<title>Test WEB</title>

<style>
html,
body {
  height: 100%;
}

body {
  display: -ms-flexbox;
  display: flex;
  -ms-flex-align: center;
  align-items: center;
  padding-top: 40px;
  padding-bottom: 40px;
  /* background-color: #f5f5f5; */
  background-image: url("/images/login_image.png");
  background-repeat: no-repeat;
  background-size: cover;
}

.form-signin {
  width: 100%;
  max-width: 330px;
  padding: 15px;
  margin: auto;
  background-color: rgba(255,255,255,0.5);
  border-radius: 10px;
}
.form-signin .checkbox {
  font-weight: 400;
}
.form-signin .form-control {
  position: relative;
  box-sizing: border-box;
  height: auto;
  padding: 10px;
  font-size: 16px;
}
.form-signin .form-control:focus {
  z-index: 2;
}
.form-signin input[type="email"] {
  margin-bottom: -1px;
  border-bottom-right-radius: 0;y
  border-bottom-left-radius: 0;
}
.form-signin input[type="password"] {
  margin-bottom: 10px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
}
</style>
<script>

</script>
</head>
<body class="text-center">
<c:url value="/login.do" var="loginUrl" />
	<form:form class="form-signin" action="${loginUrl}" method="POST">
		
		<img class="logo" src="/images/logo.png">
		
		<label for="inputEmail" class="sr-only">Email address</label>
		<input type="text" class="form-control" id="userid" name="userid" value="" placeholder="아이디 또는 회사 이메일" required autofocus>
		
		<label for="inputPassword" class="sr-only">Password</label>
		<input type="password" class="form-control" id="password" name="password" value="" placeholder="패스워드" required>
				
		<div class="custom-control custom-checkbox mb-3">
		   <input type="checkbox" class="custom-control-input" id="customControlInline">
		   <label class="custom-control-label" for="customControlInline">아이디 저장</label>
		</div>
		
		<button class="btn btn-lg btn-primary btn-block" type="submit">로그인</button>
		<c:if test="${param.result == 'err'}">
			<p style="color: red">ID와 Password를 확인해주세요.</p>
		</c:if>	 
	</form:form>	
</body>