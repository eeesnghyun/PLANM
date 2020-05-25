<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<script>
$(document).ready(function() {		
	
});
</script>
<div class="container-fluid">
	<table class="table table-borderless">
		<thead>
		  	<tr>
				<th colspan="2">						
					<h4><strong>공지사항</strong></h4>
				</th>			      			    
			</tr>		
		</thead>
		<colgroup>
			<col width="10%">
			<col width="">
		</colgroup>		
		<tbody>				  		
	  		<tr>
	    		<th>제목</th>
	    		<td colspan="5"><c:out value="${noticeVO.noticetitle }" /> ( <c:out value="${noticeVO.viewcnt }" /> )</td>			    		
	  		</tr>
	  		<tr>
	    		<th>작성자</th>
	    		<td><c:out value="${noticeVO.username }" /></td>	    			    		
	  		</tr>
	  		<tr>
	    		<th>작성일</th>
	    		<td><c:out value="${noticeVO.noticedate }" /></td>	    			    		
	  		</tr>	  		
	  		<tr>
	    		<th>첨부</th>
	    		<td colspan="5">    	    		
	    			<a href='/file/download.do?filePath=notice&fileName=<c:out value="${noticeVO.noticefile }" />'><c:out value="${noticeVO.noticefile }" /></a>
	    		</td>    		
	  		</tr>
	  		<tr class="border-top">
	  			<td colspan="6">
	  				<c:out value="${noticeVO.noticecontent }" escapeXml="false" />
	  			</td>
	  		</tr>				  				  
		</tbody>
	</table>
</div>