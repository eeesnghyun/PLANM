<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<html class="h-100">
<head>
<title>PM</title>

<script type="text/javascript">
$(document).ready(function() {	
	var size = fnct_GetClientSize();	// 화면 사이즈 구하기
	/*
	 height() : 요소 크기
	 outerHeight() : 요소 크기 + padding + 테두리
	*/
	
	
	var tempHeight = $("header").outerHeight() + $("footer").height();	
	var contentHeight = size.height - tempHeight;
	
	$(window).on({
		load: function() {			
			$("#content").height(contentHeight);
		},
		resize: function() {			// 화면의 크기가 변경될 때 content 높이를 조절한다.
			size 	   = fnct_GetClientSize();	
			tempHeight = $("header").outerHeight() + $("footer").outerHeight();
			contentHeight = size.height - tempHeight;
			$("#content").height(contentHeight);
		}
	})
});    
</script>
</head>
<body class="d-flex flex-column h-100" style="overflow: hidden">
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
	<header>
		<div id="header">
			<tiles:insertAttribute name="header" />
		</div>   	
	</header>

	<main role="main" class="flex-shrink-0">		
		<div class="container-fluid">
			<div class="row" id="content">
				<div class="col-2" id="left">
					<!-- 좌측 메뉴 -->
					<tiles:insertAttribute name="left" />
				</div>
				
				<div class="col-10" id="body">
					<!-- 메뉴에 해당하는 페이지 위치 -->
					<tiles:insertAttribute name="body" />
				</div>
			</div>
		</div>        		
	</main>

	<footer class="footer mt-auto py-2 border-top text-center">
		<div id="footer">
	    	<tiles:insertAttribute name="footer" />
	    </div>
	</footer>
</body>
</html>