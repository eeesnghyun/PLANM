/* ****************
 *  새로운 일정 생성
 * ************** */
var newEvent = function (start, end, eventType) {
	var schno = start.substr(0,10).split("-");		// 일정 PK 설정
		schno = schno[0] + schno[1] + schno[2];
	
	$(".eventName").text("추가");
    $("#contextMenu").hide();            
    
    /* 일정 내용 초기화 */
    $("#title").val("");
    
    $("#start-day").val(start.substr(0,10));    
    $("#start-h").val(start.substr(11,2));
    $("#start-m").val(start.substr(14,2));
    
    $("#end-day").val(end.substr(0,10));
    $("#end-h").val(end.substr(11,2));
    $("#end-m").val(end.substr(14,2));
   
    $("#allDayEvent").prop("checked", false);      
    $("#schType option:eq(0)").prop("selected", true);    
    $("#bgColor option:eq(0)").prop("selected", true);   
    $("#schContent").val("");
        
    $("#eventModal").modal("show");	// 모달 오픈        
    $("#saveEvent").show();			// 저장 버튼 보이기
    $("#updateEvent").hide();		// 수정 버튼 숨김
    $("#deleteEvent").hide();		// 삭제 버튼 숨김   
	
    /* 새로운 일정 저장버튼 클릭 */
    $("#saveEvent").unbind();
    $("#saveEvent").on("click", function () {
    	var title         = $("#title").val();				// 일정명
        var schContent    = $("#schContent").val();			// 설명
        var schType       = $("#schType").val();			// 구분
        var startdt       = $("#start-day").val() + $("#start-h").val() + ":" + $("#start-m").val();	// 시작일
        var enddt         = $("#end-day").val() + $("#end-h").val() + ":" + $("#end-m").val();       	// 종료일                        
        var bgColor       = $("#bgColor").val();			// 색상
        var statusAllDay  = "N";		    	
    	
        if (startdt > enddt) {
            alert("종료일이 앞설 수 없습니다.");
            return false;
        }

        if (title === "") {
            alert("일정명은 필수입니다.");
            return false;
        } 
        
        if($("#allDayEvent").is(":checked")){        	
            statusAllDay = "Y";
        }
        
        var eventData = {
        	schno   : schno,
            title   : title,
            startdt : startdt,
            enddt   : enddt,            
            schType : schType,            
            bgColor : bgColor,
            txtColor: "#ffffff",
            schContent : schContent,
            allDay  : statusAllDay
        };
                     
        $("#calendar").fullCalendar("renderEvent", eventData, true);               
        $("#eventModal").modal("hide");
        
        /* csrf 토큰 설정 */
        var token = $("input[name='_csrf']").val();
        var header = "X-CSRF-TOKEN";      
        
        $.ajax({        	
            type: "POST",            
            url: "/schedule/addSchedule.ajax",
            cache: false,  
            dataType: "json",
            data: JSON.stringify(eventData),            
            contentType: "application/json; charset=utf-8",     
            beforeSend : function(xhr)
    	    {   
    	        xhr.setRequestHeader(header, token);
    	    },
            success: function(data) {
                if(data.result == "OK"){
                	alert("일정이 등록되었습니다.");
                	
                	location.reload();
                }
            },	
			error : function(request, status, error) {
				alert("code : " + request.status + "\n" + "message : " + request.responseText + "\n" + "error : " + error);
			}
        });                 
    });
};