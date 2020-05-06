/* *******************
 *  일정 수정 및 삭제
 * ******************* */
var editEvent = function (event, element, view) {	
    $(".popover.fade.top").remove();
    $(element).popover("hide");      
    
    // 일정 클릭시 allDay는 true값이 넘어옴
    if (event.allDay == true) {
        $("#allDayEvent").prop("checked", true);
    } else {
        $("#allDayEvent").prop("checked", false);
    }

    if (event.end == null) {
        event.end = event.start;
    }
    
    if (event.allDay == true && event.end != event.start) {    	
    	$("#end-day").val(moment(event.end.format("YYYY-MM-DD HH:mm")).subtract(1, "d").format("YYYY-MM-DD HH:mm").substr(0,10));     
    	$("#end-h").val(moment(event.end.format("YYYY-MM-DD HH:mm")).subtract(1, "d").format("YYYY-MM-DD HH:mm").substr(11,2));
    	$("#end-m").val(moment(event.end.format("YYYY-MM-DD HH:mm")).subtract(1, "d").format("YYYY-MM-DD HH:mm").substr(14,2));
    } else {
    	$("#end-day").val(event.end.format("YYYY-MM-DD HH:mm").substr(0,10));     
    	$("#end-h").val(event.end.format("YYYY-MM-DD HH:mm").substr(11,2));
    	$("#end-m").val(event.end.format("YYYY-MM-DD HH:mm").substr(14,2));           
    }
    
    $("#start-day").val(event.start.format("YYYY-MM-DD HH:mm").substr(0,10));     
	$("#start-h").val(event.start.format("YYYY-MM-DD HH:mm").substr(11,2));
	$("#start-m").val(event.start.format("YYYY-MM-DD HH:mm").substr(14,2));              
        
    $(".eventName").text("수정 및 삭제");
    $("#title").val(event.title);      
    $("#schType").val(event.schType);    
    $("#schContent").val(event.schContent);   
    $("#bgColor").val(event.backgroundColor);           
    $("#eventModal").modal("show");

    $("#saveEvent").hide();
    $("#updateEvent").show();
    $("#deleteEvent").show();       
    
    // 수정 버튼 클릭시
    $("#updateEvent").unbind();
    $("#updateEvent").on("click", function () {        
        var schno	  = event.schno;
        var title    = $("#title").val();
        var startdt  = $("#start-day").val() + $("#start-h").val() + ":" + $("#start-m").val();	// 시작일
        var enddt    = $("#end-day").val() + $("#end-h").val() + ":" + $("#end-m").val();       	// 종료일           
        var schContent  = $("#schContent").val();
        var schType  = $("#schType").val();        
        var bgColor  = $("#bgColor").val();
        var allDay   = "N";
        
        if (startdt > enddt) {
            alert("종료일이 앞설 수 없습니다.");
            return false;
        }

        if (title == "") {
            alert("일정명은 필수입니다.");
            return false;
        }
                 
        if ($("#allDayEvent").is(":checked")) {        	               	        
        	allDay = "Y";                                  
        }                        
        
        event.title 		  = title;
        event.start 		  = startdt;
        event.end 			  = enddt;
        event.schType 		  = schType;
        event.schContent 	  = schContent;
        event.allDay 		  = allDay;        
        event.backgroundColor = bgColor;        

        $("#calendar").fullCalendar("updateEvent", event);
      
        if(confirm ("수정하시겠습니까?") == true){
        	var eventData = {
        			userid   : event.userid,
                    schno    : schno,                      
                    title    : title,
                    schContent  : schContent,
                    schType  : schType,
                    startdt  : startdt,
                    enddt    : enddt,                                   
                    bgColor  : bgColor,
                    txtColor : "#ffffff",
                    allDay   : allDay,          
                    gubun    : "none"
            };
        	
        	/* csrf 토큰 설정 */
            var token = $("input[name='_csrf']").val();
            var header = "X-CSRF-TOKEN";     
        	
            $.ajax({        	
            	type: "POST",            
                url: "/schedule/editSchedule.ajax",
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
                    	alert("수정되었습니다.");
                    	
                    	location.reload();
                    } else {
                    	alert("일정 수정에 실패하였습니다.");
                    }
                },	
    			error : function(request, status, error) {
    				alert(request.status + ", " + request.responseText + ", " + error);
    			}
            });                    
        }                               
    });

    // 삭제 버튼 클릭시
    $("#deleteEvent").on("click", function () {  
    	$("#deleteEvent").unbind();               
        
        if(confirm ("삭제하시겠습니까?") == true){
        	var eventData = {
        			userid   : event.userid,
        			schno    : event.schno                 
            };
        	
        	/* csrf 토큰 설정 */
            var token = $("input[name='_csrf']").val();
            var header = "X-CSRF-TOKEN";     
        	
            $.ajax({        	
            	type: "POST",            
                url: "/schedule/deleteSchedule.ajax",
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
                    	alert("일정이 삭제되었습니다.");
                    	
                    	$("#calendar").fullCalendar("removeEvents", [event.schno]);	// 캘린더 내 이벤트 제거
                    	
                    	location.reload();
                    } else {
                    	alert("일정 삭제에 실패하였습니다.");
                    }      
                },	
    			error : function(request, status, error) {
    				alert(request.status + ", " + request.responseText + ", " + error);
    			}
            });                                               
        }      
    });
};