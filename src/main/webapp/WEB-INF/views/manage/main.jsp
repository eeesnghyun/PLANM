<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/sources.jsp" %>
<%@ include file="/WEB-INF/views/manage/common.jsp" %>

<script>
var today = moment();	

/*
 * 조회 기간 생성(SELECT BOX)
 */
function fnct_MakeDate() {	
	var thisYear = today.format("YYYY");	
	var dateHtml = "";
	
	for(var i = 1; i <= 12; i++) {
		var month = i < 10 ? "0" + i : i;		
		dateHtml += "<option value=" +thisYear + month+ ">" + thisYear + "." + month + "</option>"; 		
	}
	
	$("#dateChar").append(dateHtml);
}

/*
 * 근태 기록 조회
 */
function fnct_GetCommuteList(month) {	
	var url = "/manage/getCommuteList.do";
	var params = {
			"dateChar" : month 
	};
	Object.defineProperty(params, "${_csrf.parameterName}", {value : "${_csrf.token}", writable : true, enumerable : true});
	
	$("#commuteSpace").load(url, params);	 
}

$(document).ready(function() {		
	fnct_MakeDate();		
	
	var thisMonth = today.format("YYYYMM");
	
	$("#dateChar").val(thisMonth);
	
	var month = $("#dateChar").val();
	
	fnct_GetCommuteList(month);
		
});
</script>
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
<div class="container-fluid">   
	<div class="row">
		<div class="col-12">
			<table class="table table-borderless">
			  	<colgroup>
			  			<col width="5%">
			  			<col width=""> 
			  		</colgroup>		
			  	<tr>
					<th colspan="2">						
						<h4><strong><c:out value="${loginVO.username }" /></strong>님의 근태</h4>
					</th>			      			    
				</tr>
				<tr>
					<th>기간</th>	
					<td>			
						<select class="form-control w100" id="dateChar" onchange="fnct_GetCommuteList(this.value)"></select>						
					</td>								    			
				</tr>			
			</table>
		</div>
	</div>
	<div class="row">
		<div class="col-12">
			<div id="commuteSpace"></div>
		</div>
	</div>
</div>

