<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<script>
function fnct_ShowNoticeContent(noticeno) {
	var params = {
			"noticeNo"  : noticeno
	};
	Object.defineProperty(params, "${_csrf.parameterName}", {value : "${_csrf.token}", writable : true, enumerable : true});	
	
	$("#noticeSpace").empty();
	$("#noticeSpace").load("/notice/getNoticeContent.ajax", params);	
}

function fnct_CallPage(url) {
	var url = url + ".do";
	
	$("#noticeSpace").empty();
	$("#noticeSpace").load(url);
}

$(document).ready(function() {		

	fnct_CallPage("/notice/getNoticeList");
	
});
</script>
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
<div class="container-fluid mt-2">
	<div class="text-right">
		<button type="button" class="btn btn-outline-secondary" onclick="fnct_CallPage('/notice/getNoticeList')">목록</button>
		<c:if test="${loginVO.userauth eq 'A'}">
			<button type="button" class="btn btn-outline-secondary" onclick="fnct_CallPage('/notice/writeNotice')">글쓰기</button>
		</c:if>
	</div>
	
	<div class="border-top border-bottom mt-2" id="noticeSpace"></div>		
</div>

