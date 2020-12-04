<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<!-- CKEditor -->
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>

<script>
$(document).ready(function() {
	
	/* CKEditor 적용 */
	CKEDITOR.replace("noticeContent",
				{
				height: 400,				
    			}
	);	

	/* 업로드 파일 설정 */
	fnct_MultiFile("noticeFile", "file", 1);
});
</script>
<form:form id="frm" action="/notice/writeNotice.ajax" method="POST" enctype="multipart/form-data"> 
<div class="container-fluid">
<!-- 공지사항 작성 페이지 -->
<table class="table table-borderless">
	<thead>
	  	<tr>
			<th colspan="2">						
				<h4><strong>공지사항 작성</strong></h4>
			</th>			      			    
		</tr>
		<tr class="border-top">
			<th colspan="2">
				<button type="submit" class="btn btn-outline-secondary" onclick="">저장</button>
				<button type="button" class="btn btn-outline-secondary" onclick="fnct_MailReset()">초기화</button>			
			</th>									    
		</tr>
	</thead>
	<colgroup>
		<col width="10%" />
		<col width="" />
	</colgroup>				
	<tbody>				  		
  		<tr>
    		<th>제목</th>
    		<td><input type="text" class="form-control" name="noticeTitle" id="noticeTitle"></td>			    		
  		</tr>  		
  		<tr>
    		<th>첨부</th>
    		<td>    	    			
    			<input type="file" class="form-control" id="noticeFile" name="noticeFile">
				<div id="userImgfile-list"></div>
				<ul class="list-group list-group-flush mt-2">									
					<li class="list-group-item list-group-item-secondary">파일 최대 용량 : 500KByte</li> 					
				</ul>
    		</td>    		
  		</tr>
  		<tr>
  			<td colspan="2">
  				<textarea class="form-control" name="noticeContent" id="noticeContent"></textarea>
  			</td>
  		</tr>				  				  
	</tbody>
</table>
</div>
</form:form>