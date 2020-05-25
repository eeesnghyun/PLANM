<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!-- ax5 그리드 -->
<link rel="stylesheet" type="text/css" href="/resources/grid/ax5grid.css">
<script type="text/javascript" src="/resources/grid/ax5core.min.js"></script>
<script type="text/javascript" src="/resources/grid/ax5grid.min.js"></script>
<!-- CKEditor -->
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>

<script>
/* 그리드 */
var API_SERVER = "http://api-demo.ax5.io";
var firstGrid = new ax5.ui.grid();

var userFlag = "";
var filesTempArr = [];		// 파일 데이터를 담을 배열

var toUserCdStr = "";
var ccUserCdStr = "";

/*
 * 유저 메일 가져오기
 */
function fnct_GetUsermail(id){
	userFlag = id;
	var params = {}; 	
	var data = fnct_CallPostAjax("/mail/getUsermail.ajax", params);
	
	if(data.status == "success") {
		/* 메일 주소록 열기 */
   	 	fnct_OpenLayer('', 'searchUsermail', 500, 250);	                	        	        	
 
        firstGrid.setConfig({
	       	showLineNumber: true,
	       	showRowSelector: true,
	       	header: { align: "center" },
	        target: $('[data-ax5grid="first-grid"]'),
	        columns: [
	        		 {key: "usercd"	 , label: "사번"},
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
	var userId = "#" + userFlag;
	
	if(userFlag == "ccUserW") {		// 참조자
		ccUserCdStr = "";	
	} else {
		toUserCdStr = "";	
	}
	
	for(var i = 0; i < mailList.length; i++){
		if(userFlag == "ccUserW") {	// 참조자	
			ccUserCdStr += mailList[i].usercd + ",";	
		} else {
			toUserCdStr += mailList[i].usercd + ",";
		}
				
		mailHtml += mailList[i].usermail + ",";	
	}
	
	if(userFlag == "ccUserW") {		// 참조자	
		ccUserCdStr = fnct_ReturnRmvStr(ccUserCdStr);	
	} else {
		toUserCdStr = fnct_ReturnRmvStr(toUserCdStr);	
	}	
		
	$(userId).val(fnct_ReturnRmvStr(mailHtml));
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
    $("#fileListW").empty();
    $("#fileListW").append(fileHtml);
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
    	$("#fileListW").empty();
        $("#fileListW").append(fileHtml);
    }     
}

/* 
 * 메일 전송
 */
function fnct_SendMail(flag) {	
	var mailStatus = flag;	
	var toUserCd = toUserCdStr;
	var ccUserCd = ccUserCdStr;
	var mailTitle = $("#mailTitleW").val();
	var mailContent = CKEDITOR.instances.mailContentW.getData();		// CKEditor 사용시 Textarea 값 불러오기
	var mailNo = "${mailNo}";											// 임시저장 후에 메일 작성하는 경우 사용
	
	/* 내게쓰기로 들어온 경우 */
	if("${mailStatus}" == "M") {		
		mailStatus = "M";
		toUserCd = "${loginVO.usercd}";
		alert($("#toUserW").val());
	}
	
	if(mailTitle == "") {
		alert("제목을 입력해주세요.");
		return;
	}
	
	if(mailNo == "" || mailNo == undefined) mailNo = "X"
	
	var formData = new FormData($("#frmW")[0]);
	
	formData.append("mailNo"     , mailNo);
	formData.append("toUser"     , $("#toUserW").val());
	formData.append("toUserCd"   , toUserCd);
	formData.append("ccUser"     , $("#ccUserW").val());
	formData.append("ccUserCd"   , ccUserCd);
	formData.append("mailTitle"  , $("#mailTitleW").val());
	formData.append("CkmailContent", mailContent);
	formData.append("mailStatus" , mailStatus);
	
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
				
				fnct_MailReset();
			} else {
				alert("작업에 실패하였습니다.\n관리자에게 문의해주세요.");
			}  		    		  
	 	},
	 	error : function(request, status, error) {
	 		alert("code : " + request.status + "\n" + "message : " + request.responseText + "\n" + "error : " + error);
		}
	});
}

/*
 * 메일 초기화
 */
function fnct_MailReset() {	
	CKEDITOR.instances.mailContentW.setData("");	// CKEditor 사용시 Textarea 초기화
	$("#frmW")[0].reset();
	fnct_FileReset();	
}
 
/* 
 * 업로드 파일 초기화
 */
function fnct_FileReset() {	
    var agent = navigator.userAgent.toLowerCase();
    
	if ( (navigator.appName == "Netscape" && navigator.userAgent.search("Trident") != -1) || (agent.indexOf("msie") != -1) ){ // IE일 때 
		$("#mailFileW").replaceWith( $("#mailFileW").clone(true));
	}else{    			   		// Other browser
    	$("#mailFileW").val("");
	}
    $("#fileListW").empty();   
}

$(document).ready(function() {
	
	/* CKEditor 적용 */
	CKEDITOR.replace("mailContentW",
				{
				height: 300,				
    			}
	);
	
	/* 파일 첨부 */
	$("#mailFileW").on("change", function(){ 
		fnct_AddFiles(this.files); 
	});		
	
	var mailNo = "${mailNo}";		
	/* 내게쓰기로 들어온 경우 */
	if("${mailStatus}" == "M") {			
		var usermail = "${loginVO.usermail}";
		$("#toUserW").val(usermail);		
	}		
});
</script>
<form:form id="frmW" method="POST"> 
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
				<h4><strong>메일작성</strong></h4>
			</th>			      			    
		</tr>
		<tr class="border-top">
			<th colspan="2">
				<button type="button" class="btn btn-outline-secondary" onclick="fnct_SendMail('G')">보내기</button>
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
    		<td><input type="text" class="form-control" name="mailTitleW" id="mailTitleW"></td>			    		
  		</tr>
  		<tr>
    		<th>받는사람</th>
    		<td>    			
      			<div class="input-group">
    				<div class="input-group-prepend">
	          			<div class="input-group-text" onclick="fnct_GetUsermail('toUserW')"><img src="/images/address.png" class="w18-h18"></div>
	        		</div>
	        		<input type="text" class="form-control" id="toUserW" placeholder="">	        		
    			</div>    			
    		</td>
  		</tr>
  		<tr>
    		<th>참조(CC)</th>
    		<td>
    			<div class="input-group">
    				<div class="input-group-prepend">
	          			<div class="input-group-text" onclick="fnct_GetUsermail('ccUserW')"><img src="/images/address.png" class="w18-h18"></div>
	        		</div>
	        		<input type="text" class="form-control" id="ccUserW" placeholder="">	        		
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
						   			<input type="file" class="form-control" multiple="multiple" id="mailFileW" name="mailFileW[]">	
						   		</th>				      						     
						   	</tr>
						</thead>
						<tbody id="fileListW" class="text-center"></tbody>					
					</table>
				</div>
    		</td>    		
  		</tr>
  		<tr>
  			<td colspan="2">
  				<textarea class="form-control" name="mailContentW" id="mailContentW"></textarea>
  			</td>
  		</tr>				  				  
	</tbody>
</table>
</div>
</form:form>