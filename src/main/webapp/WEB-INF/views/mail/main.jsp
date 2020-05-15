<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>
<%@ include file="/WEB-INF/views/mail/common.jsp" %>

<script>
$(document).ready(function() {
	
	fnct_CallPage("/mail/getMailList");

});
</script>
<div class="container-fluid">	
    <div class="row h-100">
    	<div class="col-2 border-right pr-0">
			<table class="table table-hover">
				<thead>
					<tr>
						<th colspan="2">						
							<h4><strong><c:out value="${loginVO.username }" /></strong>님의 메일</strong></h4>
						</th>			      			    
					</tr>
					<tr class="bg-theme1">
						<th class="border-right">
							<a href="javascript:fnct_WriteMail('/mail/writeMail', 'S');" style="color: #fff">메일쓰기</a>
						</th>
						<th>
							<a href="javascript:fnct_WriteMail('/mail/writeMail', 'M');" style="color: #fff">내게쓰기</a>
						</th>			     
					</tr>
				</thead>
				<tbody>
					<tr>			      
						<td colspan="2"><a class="nav-link" href="javascript:fnct_CallPage('getMailList');">받은메일함</a></td>			      
					</tr>
					<tr>
						<td colspan="2"><a class="nav-link" href="javascript:fnct_CallPage('myList');">내게쓴메일함</a></td>		
					</tr>
					<tr>
						<td colspan="2"><a class="nav-link" href="javascript:fnct_CallPage('setMailList');">보낸메일함</a></td>		
					</tr>					
					<tr>
						<td colspan="2"><a class="nav-link" href="javascript:fnct_CallPage('garbageList');">휴지통</a></td>		
					</tr>
				</tbody>
			</table>
    	</div>
    	<div class="col-10">
			<div id="mailSpace">									
			</div>
		</div>
	</div>
</div>