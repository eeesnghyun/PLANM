<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<script type="text/javascript" src="/include/common.js"></script>

<!-- ax5 그리드 -->
<link rel="stylesheet" type="text/css" href="/resources/grid/ax5grid.css">
<script type="text/javascript" src="/resources/grid/ax5core.min.js"></script>
<script type="text/javascript" src="/resources/grid/ax5grid.min.js"></script>
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>

<script>
/* 그리드 */
var API_SERVER = "http://api-demo.ax5.io";
var firstGrid = new ax5.ui.grid();

var filesTempArr = [];		// 파일 데이터를 담을 배열

function fnct_GetUsermail(){
	var params = {}; 	
	var data = fnct_CallPostAjax("/mail/getUsermail.ajax", params);
	
	if(data.status == "success") {
		/* 메일 주수록 열기 */
   	 	fnct_OpenLayer('', 'searchUsermail', 500, 250);	                	        	        	
 
        firstGrid.setConfig({
	       	showLineNumber: true,
	       	showRowSelector: true,
	       	header: { align: "center" },
	        target: $('[data-ax5grid="first-grid"]'),
	        columns: [
	                 {key: "username", label: "이름"},
	                 {key: "usermail", label: "메일"}
	        	    ]
        });
        
        firstGrid.setData(data.resultList);        
	}
}

function fnct_ChooseMail(){
	var mailList = firstGrid.getList("selected");
	var mailHtml = "";
	
	for(var i = 0; i < mailList.length; i++){
		mailHtml += mailList[i].usermail + ",";	
	}
	
	$("#ccUserR").val(fnct_ReturnRmvStr(mailHtml));
	fnct_CloseLayer("searchUsermail");
}

/* 
 * 파일 추가
 */
function fnct_AddFiles(files) {	
	var fileHtml = ""; 
	var fileNum = 0;
	filesTempArr = [];

    var filesArr = Array.prototype.slice.call(files);    
    var filesTempArrLen = filesTempArr.length;        
        
    for(var i = 0; i < filesArr.length; i++) {        
    	filesTempArr.push(filesArr[i]);
    	
    	fileNum = i + 1;
    	fileHtml +=	"<tr><td>" + fileNum + "</td><td class='text-left'>" + filesArr[i].name + "</td><td>" + filesArr[i].size + "</td>";
		fileHtml +=	"<td><img src='/images/delete.png' class='w18-h18' style='cursor: pointer' onclick=\"fnct_DeleteFile(" + (filesTempArrLen + i) + ");\"></td>";
		fileHtml +=	"</tr>";       
    }
    $("#fileList").empty();
    $("#fileList").append(fileHtml);
}

/* 
 * 파일 삭제
 */
function fnct_DeleteFile(orderParam) {
	var fileHtml = ""; 
	var fileNum = 0;

	filesTempArr.splice(orderParam, 1);    
       
    for(var i = 0; i < filesTempArr.length; i++) {
    	fileNum = i + 1;
    	fileHtml +=	"<tr><td>" + fileNum + "</td><td class='text-left'>" + filesTempArr[i].name + "</td><td>" + filesTempArr[i].size + "</td>";
		fileHtml +=	"<td><img src='/images/delete.png' class='w18-h18' style='cursor: pointer' onclick=\"fnct_DeleteFile(" + i + ");\"></td>";
		fileHtml +=	"</tr>";     	
    }    
    
    if(filesTempArr.length == 0) {
    	fnct_FileReset();
    } else {
    	$("#fileListR").empty();
        $("#fileListR").append(fileHtml);
    }     
}

/* 
 * 메일 전송
 */
function fnct_SendMail() {	
	var mailContentR = CKEDITOR.instances.mailContentR.getData();		// CKEditor 사용시 Textarea 값 불러오기
	
	var formData = new FormData($("#frmR")[0]);
	formData.append("toUser"     , $("#toUserR").val());
	formData.append("ccUser"     , $("#ccUserR").val());
	formData.append("mailTitle"  , $("#mailTitleR").text());
	formData.append("CkmailContent", mailContentR);
	
	for(var i = 0; i < filesTempArr.length; i++) {
		formData.append("files", filesTempArr[i]);
	}	

	$.ajax({
		type : "POST",
		url : "/mail/sendMail.ajax",
		data : formData,
		processData: false,
		contentType: false,				
		success : function(data) {				
			if(data.status == "success") {
				alert("메일이 전송되었습니다.");
				
				/* 메일 내용 초기화*/
				$("#toUserR").val("");
				$("#ccUserR").val("");
				$("#mailTitleR").val("");
				CKEDITOR.instances.mailContentR.setData("");	// CKEditor 사용시 Textarea 초기화
				fnct_FileReset();							// 파일 초기화
				$("#replyMailLayer").hide();
			} else {
				alert("메일 전송에 실패하였습니다.");
			}  		    		  
	 	},
	 	error : function(request, status, error) {
	 		alert("code : " + request.status + "\n" + "message : " + request.responseText + "\n" + "error : " + error);
		}
	});
}

/* 
 * 업로드 파일 초기화
 */
function fnct_FileReset(){	
    var agent = navigator.userAgent.toLowerCase();
    
	if ( (navigator.appName == "Netscape" && navigator.userAgent.search("Trident") != -1) || (agent.indexOf("msie") != -1) ){ // IE일 때 
		$("#mailFileR").replaceWith( $("#mailFileR").clone(true));
	}else{    			   		// Other browser
    	$("#mailFileR").val("");
	}
    $("#fileListR").empty();   
}

$(document).ready(function() {
	
	/* CKEditor 적용 */
	CKEDITOR.replace("mailContentR",
				{
				height: 300,				
    			}
	);
	
	/* 파일 첨부 */
	$("#mailFileR").on("change", function(){ 
		fnct_AddFiles(this.files); 
	});
});
</script>
<form:form id="frmR" method="POST"> 
<!-- 사용자 메일 리스트 -->
<div class="card border-secondary" id="searchUsermail" style="display: none">
	<div class="card-header">
		<div class="float-left">
			<h5><strong>메일 주소록</strong></h5>
		</div>
		<div class="float-right">
			<button type="button" class="btn-img mt-2" onclick="fnct_CloseLayer('searchUsermail')"><img src="/images/close.png" class="w10-h10"></button>
		</div>
	</div>			
    <div class="card-body text-secondary" style="overflow: auto">        
        <div class="container-fluid mb-2">
        	<div class="row">        		
        		<button type="button" class="btn btn-outline-secondary" onclick="fnct_ChooseMail()">선택</button>        		
        	</div>        	
        </div>             
        <div data-ax5grid="first-grid" data-ax5grid-config="{}" style="height: 300px;"></div>
    </div>                
</div>

<div class="container-fluid">
<!-- 메일 작성 페이지 -->
<table class="table table-borderless">
	<thead>
	  	<tr>
			<th colspan="2">						
				<h4><strong>
				<c:choose>
					<c:when test="${mailVO.replyOrF eq 'F'}">
					메일전달
					</c:when>
					<c:otherwise>
					메일회신	
					</c:otherwise>
				</c:choose>
				</strong></h4>
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
    		<td><span id="mailTitleR">
    			<c:choose>
					<c:when test="${mailVO.replyOrF eq 'F'}">
						FW : <c:out value="${mailVO.mailTitle }" />
					</c:when>
					<c:otherwise>
						RE : <c:out value="${mailVO.mailTitle }" />
					</c:otherwise>
				</c:choose>	   
    		</span></td>			    		
  		</tr>
  		<tr>
    		<th>받는사람</th>
    		<td>    			
      			<div class="input-group">   				
	        		<c:choose>
						<c:when test="${mailVO.replyOrF eq 'F'}">
						<div class="input-group">
		    				<div class="input-group-prepend">
			          			<div class="input-group-text" onclick="fnct_GetUsermail('toUserR')"><img src="/images/address.png" class="w18-h18"></div>
			        		</div>
			        		<input type="text" class="form-control" id="toUserR" placeholder="">
		    			</div>  
						</c:when>
						<c:otherwise>
						<div class="input-group">
		    				<div class="input-group-prepend">
			          			<div class="input-group-text" onclick="fnct_GetUsermail('toUserR')"><img src="/images/address.png" class="w18-h18"></div>
			        		</div>
			        		<input type="text" class="form-control" id="toUserR" placeholder="" value="<c:out value="${mailVO.toUser }" />">
		    			</div>							
						</c:otherwise>
					</c:choose>	        		
    			</div>    			
    		</td>
  		</tr>
  		<tr>
    		<th>참조(CC)</th>
    		<td>
    			<div class="input-group">
    				<div class="input-group-prepend">
	          			<div class="input-group-text" onclick="fnct_GetUsermail()"><img src="/images/address.png" class="w18-h18"></div>
	        		</div>
	        		<input type="text" class="form-control" id="ccUserR" placeholder="">
    			</div>  
    		</td>	    		
  		</tr>			  		  		
  		<tr>
    		<th>첨부</th>
    		<td>    	    			
    			<div class="input-group">					 
					<table class="table table-bordered table-sm">
						<thead class="thead-light text-center">
					    	<tr>
						   		<th>No</th>
					      		<th>파일명</th>
						   		<th>크기(Bytes)</th>
						   		<th>수정</th>				      		
						   	</tr>
						   	<tr>
						   		<th class="text-center" colspan="4">
						   			<input type="file" class="form-control" multiple="multiple" id="mailFileR" name="mailFileR[]">	
						   		</th>				      						     
						   	</tr>
						</thead>
						<tbody id="fileListR" class="text-center"></tbody>					
					</table>
				</div>
    		</td>    		
  		</tr>
  		<tr>
  			<td colspan="2">
  				<textarea class="form-control" name="mailContentR" id="mailContentR" style="height: 400px"><c:out value="${mailVO.replyContent }" escapeXml="false" /></textarea>  			
  			</td>
  		</tr>				  				  
	</tbody>
</table>
</div>
</form:form>