/**
 * Author  : LSH
 * Content : 공통으로 사용하는 JS 선언
 * Ver 1.0 
 */
 
/*
 * 공통 POST 방식의 Ajax
 * return type은 json으로 통일한다. 
 */
function fnct_CallPostAjax(url, params) {
	var returnData = {};

	$.ajax({        	
        type       : "POST",    
        async      : false,
        url        : url,
        cache      : false,  
        dataType   : "json",
        data       : JSON.stringify(params),            
        contentType: "application/json; charset=utf-8",     
        beforeSend : function(xhr)
	    {   
	        xhr.setRequestHeader("X-CSRF-TOKEN", $("input[name='_csrf']").val());
	    },
        success: function(data) {  
        	returnData = data;     	
        },	
		error : function(request, status, error) {
			alert("code : " + request.status + "\n" + "message : " + request.responseText + "\n" + "error : " + error);
		}
	});
	
	return returnData;
}

/*
 * Jquery UI 날짜선택 함수
 * - id : Elements id
 */
function fnct_DatePicker(id) {	
	var divId = "#" + id;
	
	$(divId).datepicker();										// Datepicker 로드	
	$(divId).datepicker("option", "dateFormat", "yy-mm-dd");	// 날짜 포맷 설정
	$(divId).datepicker("option", "changeYear", true);			// 년도 변경 옵션
	$(divId).datepicker("option", "changeMonth", true);			// 월 변경 옵션	
	$(divId).datepicker("show");
}

/*
 * 사용중인 화면의 사이즈를 구한다.
 */
function fnct_GetClientSize() {
    var width = 0, height = 0;

    if(typeof(window.innerWidth) == 'number') {
          width = window.innerWidth;
          height = window.innerHeight;
    } else if (document.documentElement && (document.documentElement.clientWidth || document.documentElement.clientHeight)) {
          width = document.documentElement.clientWidth;
          height = document.documentElement.clientHeight;
    } else if (document.body && (document.body.clientWidth || document.body.clientHeight)) {
          width = document.body.clientWidth;
          height = document.body.clientHeight;
    }

    return {width: width, height: height};
}

/*
 * 레이어 팝업 창을 그린다.
 * - id1 : 레이어의 위치를 구하기 위한 Elements id
 * - id2 : 그리고자 하는 Elements id
 * - width : 레이어 width
 * - height : 레이어 height
 * - top, left : 레이어 위치 조절하고 싶은 경우 사용
 */
function fnct_OpenLayer(id1, id2, width, height, top, left){
	var divId1;
	var divId2 = "#" + id2;
	var layerTop;
	var layerLeft;
		
	if(id1 == null || id1 == "") {		// 상대 좌표가 없는 경우
		layerTop = 0;
		layerLeft = 0;
	} else {
		divId1 = "#" + id1;		
		layerTop  = $(divId1).offset().top;
		layerLeft = $(divId1).offset().left;	
	}	
	
	if(top != null  || top != "")  layerTop = layerTop + top;
	if(left != null || left != "") layerLeft = layerLeft + left;
			
	$(divId2).css({
		"position" : "absolute",
		"z-index" : 10,
		"top" : layerTop + 20,
		"left": layerLeft + 20,
		"width" : width,
		"height" : height
	});
	
	$(divId2).show();
}

/*
 * 레이어 팝업 창을 닫는다.
 * - param : Elements id
 */
function fnct_CloseLayer(id){
	var divId = "#" + id;
	$(divId).hide();	
}

/*
 * 문자의 특정 열을 자른다.
 * - str : str2가 없는 경우 마지막 문자를 제거한다.
 * - str2 : 특정 문자를 제거한다.
 */
function fnct_ReturnRmvStr(str, str2){
	if(str2 == "" || str2 == undefined) {
		if (str.length > 0) {
			str = str.substring(0, str.length - 1);
		}	
	} else {
		str = str.split(str2).join("");
	}
	
	return str;
}

/*
 * 파일 업로드 공통 함수
 * - id : input file 태크 아이디
 * - cnt : file 업로드 갯수 
 */
function fnct_MultiFile(id, gubun ,cnt) {
	var fileId = "#" + id; 
	var fileList = fileId + "-list";
	var fileType = "";
	var maxfile = 1;
	
	if(cnt != null || cnt != "") maxfile = cnt;

	if(gubun == "img") {
		fileType = "jpg|png|gif";
	} else if(gubun == "file") {
		fileType = "jpg|png|gif|pdf";
	}
	
    $(fileId).MultiFile({        
        max: maxfile			 // 업로드 할 수 있는 최대 파일 갯수
      , list: fileList			 // 파일 리스트
      , accept: fileType	 	 // 업로드 파일 확장자 지정
      //, maxfile: 1024			 // 각 파일 최대 업로드 크기
      , max_size: 500  			 // 전체 파일 최대 업로드 크기(500KByte)
      // alet 커스터마이징
      , STRING: {   			
    	  	  remove: "<img src='/images/delete.png' class='w18-h18'>",   // 삭제 이미지   
              denied: '$ext 파일은 업로드 할 수 없습니다.',    // 확장자 제한 문구   
              duplicate: '$file 는(은) 이미 추가된 파일입니다.',              // 중복 파일 문구  
              toomuch: "업로드할 수 있는 파일의 최대 크기를 초과하였습니다.($size)", // 파일 용량 제한 문구	 
              toomany: "업로드할 수 있는 파일의 최대 갯수는 $max개 입니다."		  // 업로드 제한 문구
        }   

    }); 
}

$(document).ready(function() {
	
	
});