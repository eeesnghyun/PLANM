<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script>
var mailStatus = "";

/*
 * 페이지 호출
 */
function fnct_CallPage(url){
	var url = url + ".do";

	$("#mailSpace").load(url);
}

/*
 * 메일쓰기 / 내게쓰기
 */
function fnct_WriteMail(url, mailStatus, mailno){
	var url = url + ".do";
	var params = {
			"mailStatus" : mailStatus,
			"mailNo"     : mailno
	};
	Object.defineProperty(params, "${_csrf.parameterName}", {value : "${_csrf.token}", writable : true, enumerable : true});
	$("#mailSpace").load(url, params);
}

/*
 * 메일 상태 변경
 */
function fnct_SetMailStatus(mailStatus) {
	var mailNo = "";
	var mailId = "";

	$("input:checkbox[name=mailId]").each(function() {
		if(this.checked == true) {
			mailId += $(this).attr("id") + ",";
		}
	});

	if(mailId == "" || mailId == undefined) {
		mailNo = $("#mailNo").val();
	} else {
		mailNo = fnct_ReturnRmvStr(mailId);
	}

	var params = {
			"mailNo"     : mailNo,
			"mailStatus" : mailStatus
	};

	var data = fnct_CallPostAjax("/mail/setMailStatus.ajax", params);
	if(data.status == "success") {
		if(mailStatus == "P") {
			alert("메일이 휴지통으로 이동되었습니다.");
		} else if(mailStatus == "D") {
			alert("메일이 삭제되었습니다.");
		} else if(mailStatus == "G") {
			alert("메일이 받은메일함으로 이동되었습니다.")
		}

		$("input[type=checkbox]").prop("checked", false);
		fnct_GetMailList();
	}
}

/*
 * 메일 체크
 */
function fnct_AllMail() {
	if ($("#allMail").is(':checked')) {
        $("input[type=checkbox]").prop("checked", true);
    } else {
        $("input[type=checkbox]").prop("checked", false);
    }
}

/*
 * 메일 리스트 조회
 */
function fnct_GetMailList(nowPage){
	if(nowPage == "" || nowPage == undefined) {
		nowPage = 1;
	}

	var params = {
			"nowPage"    : nowPage,
			"mailStatus" : mailStatus
	};

	var data = fnct_CallPostAjax("/mail/getMailList.ajax", params);

	if(data.status == "success") {
		var resultList = data.resultList;
	   	var mailHtml   = "";
	   	var pagingHtml = "";
	   	var startPage  = data.paging.startPage;
	   	var endPage    = data.paging.endPage;
	   	$("#mailListSpace").empty();
	   	$("#paging").empty();

	   	for(var i = 0; i < resultList.length; i++){
	   	 	mailHtml += "<div class='row mt-2 pb-1 border-bottom' id='mailList'>";
	   	 	mailHtml += "	<div class='col-1 text-center'><div class='custom-control custom-checkbox pb-2'>";
	   	 	mailHtml += "	  <input type='checkbox' class='custom-control-input' id='" + resultList[i].mailno + "' name='mailId'>";
	   	 	mailHtml += "	     <label class='custom-control-label' for='" + resultList[i].mailno + "'></label>";
	   	 	mailHtml += "	</div></div>";
	   	 	mailHtml += "	<div class='col-1 text-center'><img src='/images/file_" + resultList[i].mailfile + ".png' class='w18-h18'></div>";
	   	 	mailHtml += "	<div class='col-2 text-center'>" + resultList[i].fromusername + "</div>";
	   		mailHtml += "	<div class='col-4'><a href='javascript:fnct_ShowMailContent(" + resultList[i].mailno + ")'>" + resultList[i].mailtitle + "</a></div>";
	   		mailHtml += "	<div class='col-2 text-center'>" + resultList[i].fromdate + "</div>";

	   		// 보낸 메일함
	   		if(mailStatus == "S") {
	   			mailHtml += "	<div class='col-2 text-center'><img class='w18-h18' src='/images/read" + resultList[i].readdate + ".png'></div>";
	   		} else {
	   			mailHtml += "	<div class='col-2 text-center'>" + resultList[i].readdate + "</div>";
	   		}

	   		mailHtml += "</div>";
	    }

	   	// 페이징 처리
	   	if(data.paging.prev) {
	   		startPage = startPage - 1;
		   	pagingHtml += "<li class='page-item'>";
		   	pagingHtml += "	<a class='page-link' href='javascript:fnct_GetMailList(" + startPage + ");' tabindex='-1' aria-disabled='true'>이전</a>";
		   	pagingHtml += "</li>";
	   	}

	   	for(var i = startPage; i < endPage; i++){
	   		pagingHtml += "<li class='page-item'>";
	   		pagingHtml += "	<a class='page-link' href='javascript:fnct_GetMailList(" + i + ");'>" + i + "</a>";
	   		pagingHtml += "</li>";
	   	}

	   	if(data.paging.next && endPage > 0) {
	   		endPage = endPage + 1;
	   		pagingHtml += "<li class='page-item'>";
	   		pagingHtml += "	<a class='page-link' href='javascript:fnct_GetMailList(" + endPage + ");'>다음</a>";
			pagingHtml += "</li>";
	   	}

	   	$("#mailListSpace").append(mailHtml);
	   	$("#paging").append(pagingHtml);
	}
}

/*
 * 메일 내용 조회
 */
function fnct_ShowMailContent(mailNo) {
	var params = {
			"mailNo" : mailNo
	};

	var data = fnct_CallPostAjax("/mail/getMailContent.ajax", params);

	if(data.status == "success") {
		var result = data.result;
    	var fromuser = "From. " + result.fromusername + "(" + result.fromuser + ")" + " - " + result.fromdate;

    	var mailfile = "";
    	var fileArr = result.mailfile.split(",");

    	if(result.mailfile != "X") {
    		for(var i in fileArr) {
        		mailfile += "<a href='/file/download.do?filePath=mail&fileName=" + fileArr[i] + "'>" + fileArr[i] + "</a><br>";
        	}
    	}

    	$("#reply-content").empty();
    	$("#mailNo").val(result.mailno);
    	$("#mailTitle").html(result.mailtitle);		// 메일 제목
    	$("#mailContent").html(result.mailcontent);	// 메일 내용
    	$("#toUser").html(result.touser);			// 받는 사람
    	$("#ccUser").html(result.ccuser);			// 참조
    	$("#mailFile").html(mailfile);				// 첨부 파일
    	$("#fromUser").html(fromuser);        		// 보낸 사람

    	$("#mailLayer").show();
    	$("#card-mail").draggable({						 	// 팝업창 드래그
			//containment: '#',				 	// 드래그 범위 지정
			opacity: 0.7,							 	// 드래그시 투명도
			cancel: '.card-body' 					 	// .card-body 클래스를 제외한 영역에서 드래그 가능
		});
	}
}

/*
 * 보낸 메일 리스트 조회
 */
function fnct_SetMailList(nowPage){
	if(nowPage == "" || nowPage == undefined) {
		nowPage = 1;
	}

	var params = {
			"nowPage" : nowPage
	};

	var data = fnct_CallPostAjax("/mail/setMailList.ajax", params);

	if(data.status == "success") {
		var resultList = data.resultList;
	   	var mailHtml   = "";
	   	var pagingHtml = "";
	   	var startPage  = data.paging.startPage;
	   	var endPage    = data.paging.endPage;
	   	$("#mailListSpace").empty();
	   	$("#paging").empty();

	   	for(var i = 0; i < resultList.length; i++){
	   	 	mailHtml += "<div class='row mt-2 pb-1 border-bottom' id='mailList'>";
	   	 	mailHtml += "	<div class='col-1 text-center'><div class='custom-control custom-checkbox pb-2'>";
	   	 	mailHtml += "	  <input type='checkbox' class='custom-control-input' id='" + resultList[i].mailno + "' name='mailId'>";
	   	 	mailHtml += "	     <label class='custom-control-label' for='" + resultList[i].mailno + "'></label>";
	   	 	mailHtml += "	</div></div>";
	   	 	mailHtml += "	<div class='col-1 text-center'><img src='/images/file_" + resultList[i].mailfile + ".png' class='w18-h18'></div>";
	   	 	mailHtml += "	<div class='col-2 text-center'>" + resultList[i].fromusername + "</div>";
	   		mailHtml += "	<div class='col-4'><a href='javascript:fnct_ShowSetMailContent(" + resultList[i].mailno + ")'>" + resultList[i].mailtitle + "</a></div>";
	   		mailHtml += "	<div class='col-2 text-center'>" + resultList[i].fromdate + "</div>";
	   		mailHtml += "	<div class='col-2 text-center'><img class='w18-h18' src='/images/read" + resultList[i].readdate + ".png'></div>";
	   		mailHtml += "</div>";
	    }

	   	// 페이징 처리
	   	if(data.paging.prev) {
	   		startPage = startPage - 1;
		   	pagingHtml += "<li class='page-item'>";
		   	pagingHtml += "	<a class='page-link' href='javascript:fnct_SetMailList(" + startPage + ");' tabindex='-1' aria-disabled='true'>이전</a>";
		   	pagingHtml += "</li>";
	   	}

	   	for(var i = startPage; i < endPage; i++){
	   		pagingHtml += "<li class='page-item'>";
	   		pagingHtml += "	<a class='page-link' href='javascript:fnct_SetMailList(" + i + ");'>" + i + "</a>";
	   		pagingHtml += "</li>";
	   	}

	   	if(data.paging.next && endPage > 0) {
	   		endPage = endPage + 1;
	   		pagingHtml += "<li class='page-item'>";
	   		pagingHtml += "	<a class='page-link' href='javascript:fnct_SetMailList(" + endPage + ");'>다음</a>";
			pagingHtml += "</li>";
	   	}

	   	$("#mailListSpace").append(mailHtml);
	   	$("#paging").append(pagingHtml);
	}
}

/*
 * 보낸 메일 내용 조회
 */
function fnct_ShowSetMailContent(mailNo) {
	var params = {
			"mailNo" : mailNo
	};

	var data = fnct_CallPostAjax("/mail/setMailContent.ajax", params);

	if(data.status == "success") {
		var result = data.result;
		var fromuser = "From. " + result.fromusername + "(" + result.fromuser + ")" + " - " + result.fromdate;

		var mailfile = "";
    	var fileArr = result.mailfile.split(",");

    	if(result.mailfile != "X") {
    		for(var i in fileArr) {
        		mailfile += "<a href='/file/download.do?filePath=mail&fileName=" + fileArr[i] + "'>" + fileArr[i] + "</a><br>";
        	}
    	}

    	$("#reply-content").empty();
    	$("#mailNo").val(result.mailno);
    	$("#mailTitle").html(result.mailtitle);		// 메일 제목
    	$("#mailContent").html(result.mailcontent);	// 메일 내용
    	$("#toUser").html(result.touser);			// 받는 사람
    	$("#ccUser").html(result.ccuser);			// 참조
    	$("#mailFile").html(mailfile);				// 첨부 파일
    	$("#fromUser").html(fromuser);        		// 보낸 사람

    	$("#mailLayer").show();
    	$("#card-mail").draggable({						 	// 팝업창 드래그
			//containment: '#',				 	// 드래그 범위 지정
			opacity: 0.7,							 	// 드래그시 투명도
			cancel: '.card-body' 					 	// .card-body 클래스를 제외한 영역에서 드래그 가능
		});
	}
}

/*
 * 메일 답장/전달
 */
function fnct_ReplyMail(replyOrF) {
	var replyContent = "<br><hr>" + $("#card-content").html();

	var params = {
			"mailTitle"   : $("#mailTitle").text(),
			"replyContent": replyContent,
			"toUser" 	  : $("#toUser").text(),
			"ccUser" 	  : $("#ccUser").text(),
			"mailFile"	  : $("#mailFile").text(),
			"replyOrF"    : replyOrF
	};

	$("#mailLayer").hide();
	$("#replyMailLayer").show();
	$("#card-reply").draggable({					// 팝업창 드래그
		//containment: '#',				 			// 드래그 범위 지정
		opacity: 0.7,							 	// 드래그시 투명도
		cancel: '.card-body' 					 	// .card-body 클래스를 제외한 영역에서 드래그 가능
	});

	Object.defineProperty(params, "${_csrf.parameterName}", {value : "${_csrf.token}", writable : true, enumerable : true});
	$("#reply-content").load("/mail/replyMail.do", params);
}
</script>
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />