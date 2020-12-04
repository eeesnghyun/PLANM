<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>예제 모음</title>
<!-- jQuery 최신 버전 -->
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>

<!-- jQuery UI -->
<script src="/resources/jquery-ui/jquery-ui.js" type="text/javascript"></script>  
<link href="/resources/jquery-ui/jquery-ui.css"  rel="stylesheet">      

<!-- Bootstrap 4.4.1 -->
<script src="/resources/bootstrap/bootstrap.min.js" type="text/javascript"></script>  
<link href="/resources/bootstrap/bootstrap.css"  rel="stylesheet">   

<!-- SELECT2 Plugin -->
<link href="/resources/select2/css/select2.min.css" rel="stylesheet">
<script src="/resources/select2/js/select2.min.js"></script>

<!-- Font -->
<link href='//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSans-kr.css' rel='stylesheet' type='text/css'>
<link href='//spoqa.github.io/spoqa-han-sans/css/SpoqaHanSans-jp.css' rel='stylesheet' type='text/css'>
<style>
body, button, div, input, select, table, textarea {
  font-size: 13px;
  font-family: 'Spoqa Han Sans', 'Spoqa Han Sans JP', 'Sans-serif';
  text-rendering: optimizeLegibility;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  outline: none
}
</style>
<script>
function setFruit(value) {
	var fruit = value;
	
	$("#fruitCombo").val(fruit).select2();
}

function resetFruit() {
	$("#fruitCombo").val("").select2();
}

function getFruit() {
	var fruit = $("#fruitCombo").val();
	
	alert("선택된 과일 : " + fruit);
}

$(document).ready(function() {
	$("#fruitCombo").select2();
});
</script>
</head>
<body>
<form>
<div class="container">
	<div class="row border-bottom">
		<div class="col-12">
			<p class="h1">예제 모음</p>
		</div>
	</div>
	
	<div class="row">	
		<div class="col-12">
			<h3>SELECT2 플러그인</h3>	
			콤보박스 : 
			<select id="fruitCombo" style="width: 200px">	
				<option value="">선택</option>
				<option value="apple">사과</option>
				<option value="watermelon">수박</option>
				<option value="peach">복숭아</option>
			</select>
			
			<button type="button" class="btn btn-primary" onclick="setFruit('apple')">사과</button>
			<button type="button" class="btn btn-primary" onclick="setFruit('watermelon')">수박</button>
			<button type="button" class="btn btn-primary" onclick="setFruit('peach')">복숭아</button>			
			<button type="button" class="btn btn-primary" onclick="getFruit()">선택</button>
			<button type="button" class="btn btn-primary" onclick="resetFruit()">초기화</button>			
		</div>
	</div>
</div>
</form>
</body>