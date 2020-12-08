<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- jQuery 최신 버전 -->
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>

<!-- jQuery UI -->
<script src="/resources/jquery-ui/jquery-ui.js"></script>  
<link rel="stylesheet" href="/resources/jquery-ui/jquery-ui.css">

<!-- Common JS -->
<script type="text/javascript" src="/include/common.js"></script>

<!-- Common CSS -->
<link href="/include/common.css"  rel="stylesheet">

<link rel="stylesheet" href="/resources/calendar/css/fullcalendar.min.css" />
<link rel="stylesheet" href="/resources/calendar/css/bootstrap.min.css"> <!-- Bootstrap 3.3.7 -->
<link rel="stylesheet" href='/resources/calendar/css/select2.min.css' />
<link rel="stylesheet" href='/resources/calendar/css/bootstrap-datetimepicker.min.css' />
<link rel="stylesheet" href="/resources/calendar/css/main.css">
<script>
//하루종일 선택시 날짜 변환
function fnct_Allday() {		
    if($("#allDayEvent").is(":checked")){
    	
    	$("#start-h").val("00");
        $("#start-m").val("00");
        $("#end-h").val("00");
        $("#end-m").val("00");	
    }    		   
}

$(document).ready(function() {
	
});
</script>
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
<div class="container-fluid">
	
	<!-- 스케줄 검색 레이어창 -->
	<div class="panel panel-info" id="searchLayer" style="display: none">
        <div class="panel-heading">
        	<label for="calendar_view">일정구분</label>
        	
        	<span style="float: right">
        		<button type="button" class="btn-img" onclick="fnct_CloseLayer('searchLayer')"><img src="/images/close.png" class="w10-h10"></button>
        	</span>
        </div>

        <div class="panel-body">
            <div class="col-lg-12">                
                <div class="input-group">
                    <select class="filter" id="type_filter" multiple="multiple">
                        <option value="카테고리1">카테고리1</option>
                        <option value="카테고리2">카테고리2</option>
                        <option value="카테고리3">카테고리3</option>
                        <option value="카테고리4">카테고리4</option>
                    </select>
                </div>
            </div>              
        </div>                
    </div>
    <!-- /.filter panel -->
	
    <!-- 일자 클릭시 메뉴오픈 -->
    <div id="contextMenu" class="dropdown clearfix">            
    	<button type="button" class="btn btn-primary" id="addSchedule">등록</button>
	</div>

    <div id="wrapper">
        <div id="loading"></div>
          
        <div>
        	<ul class="nav nav-pills">        		        		
        		<li>        			
        			<h4><strong><c:out value="${loginVO.username }" /></strong>님의 일정</h4>
        		</li>
        		<li>
        			<button type="button" class="btn-img" id="searchBtn" style="margin-top: 8px" onclick="fnct_OpenLayer('searchBtn', 'searchLayer', 300, 100)">
        				<img src="/images/search.png" class="w18-h18">
        			</button>
        		</li>
        	</ul>          	          
        </div>
        
        <div id="calendar"></div>
    </div>


    <!-- 일정 추가 MODAL -->
    <div class="modal fade" tabindex="-1" role="dialog" id="eventModal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">                        
                 <h4 class="modal-title">일정 <span class="eventName"></span></h4>
                 <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
             </div>
                <div class="modal-body">
                	<div class="table-responsive">
					<table class="table table-hover" style="font-size: 12px">
						<colgroup>
							<col width="20%" />
							<col width="20%" />
							<col width="10%" />								
							<col width="10%" />
							<col width="" />							
						</colgroup>
						<tbody>
						<tr>
							<th class="th-basic">일정명</th>
							<td colspan="4">								
								<input class="form-control" type="text" name="title" id="title" required="required">								
							</td>
						</tr>
						<tr>
							<th class="th-basic">시작일</th>
							<td><input class="form-control" type="text" name="start-day" id="start-day" onclick="fnct_DatePicker('start-day')" onchange="fnct_Allday()" maxlength="10"></td>																																												
							<td><input class="form-control" type="text" name="start-h" id="start-h" onchange="fnct_Allday()" maxlength="2"></td>								
							<td><input class="form-control" type="text" name="start-m" id="start-m" onchange="fnct_Allday()" maxlength="2"></td>
							<td>	
						    	<div>					    	
						      		<div class="custom-control custom-checkbox">
									  <input type="checkbox" class="custom-control-input" name="allDayEvent" id="allDayEvent" onclick="fnct_Allday()">
									  <label class="custom-control-label" for="allDayEvent">하루종일<a title="체크시 하루 전체 일정으로 등록됩니다."><span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span></a></label>
									</div>					      							  
						    	</div>
							</td>							
						</tr>
						<tr>
							<th class="th-basic">종료일</th>
							<td><input class="form-control" type="text" name="end-day" id="end-day" onclick="fnct_DatePicker('end-day')" onchange="fnct_Allday()" maxlength="10"></td>								
							<td><input class="form-control" type="text" name="end-h" id="end-h" onchange="fnct_Allday()" maxlength="2"></td>																					
							<td><input class="form-control" type="text" name="end-m" id="end-m" onchange="fnct_Allday()" maxlength="2"></td>								
							<td>	
						    	<div>					    	
						      		<div class="custom-control custom-checkbox">
									  <input type="checkbox" class="custom-control-input" name="everyMonth" id="everyMonth" onclick="fncEveryMonth()">
									  <label class="custom-control-label" for="everyMonth">매달등록<a title="체크시 매월 일정으로 자동 등록됩니다."><span class="glyphicon glyphicon-question-sign" aria-hidden="true"></span></a></label>
									</div>					      							  
						    	</div>
							</td>	
						</tr>
						<tr>
							<th class="th-basic">구분</th>
							<td colspan="4">
								<select class="form-control" name="schType" id="schType">
	                              	<option value="카테고리1" selected="selected">카테고리1</option>
	 	                            <option value="카테고리2">카테고리2</option>
	     	                        <option value="카테고리3">카테고리3</option>
	         	                    <option value="카테고리4">카테고리4</option>
	             	            </select>
							</td>
						</tr>						
						<tr>
							<th class="th-basic">색상</th>
							<td colspan="4">
								<select class="form-control" name="bgColor" id="bgColor">
	                              	<option value="#D25565" style="color:#D25565;">빨간색</option>
	 	                            <option value="#9775fa" style="color:#9775fa;">보라색</option>
	     	                        <option value="#ffa94d" style="color:#ffa94d;">주황색</option>
	         	                    <option value="#74c0fc" style="color:#74c0fc;">파란색</option>
	             	                <option value="#f06595" style="color:#f06595;">핑크색</option>
	                 	            <option value="#63e6be" style="color:#63e6be;">연두색</option>
	                     	        <option value="#a9e34b" style="color:#a9e34b;">초록색</option>
	                         	    <option value="#4d638c" style="color:#4d638c;">남색</option>
	                             	<option value="#495057" style="color:#495057;">검정색</option>
	                         	</select>
							</td>
						</tr>
						<tr>
							<th class="th-basic">내용</th>
							<td colspan="4">
								<textarea rows="4" cols="50" class="form-control" name="schContent" id="schContent" maxlength="500"></textarea>					      		
							</td>
						</tr>
						</tbody>
					</table>
					</div>						
                </div>
                <div class="modal-footer">                    
                 <button type="button" class="btn btn-primary" id="saveEvent"   style="display: none;">저장</button>
                 <button type="button" class="btn btn-danger"  id="deleteEvent" style="display: none;">삭제</button>
                 <button type="button" class="btn btn-primary" id="updateEvent" style="display: none;">수정</button>
             </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
</div>
<!-- /.container -->


<script src="/resources/calendar/js/moment.min.js"></script>
<script src="/resources/calendar/js/fullcalendar.min.js" ></script>
<script src="/resources/calendar/js/ko.js"></script>
<script src="/resources/calendar/js/select2.min.js"></script>
<script src="/resources/calendar/js/bootstrap.min.js"></script>

<script src="/resources/calendar/js/main.js" charset="UTF-8"></script>
<script src="/resources/calendar/js/addEvent.js"></script>
<script src="/resources/calendar/js/editEvent.js"></script>
<script src="/resources/calendar/js/etcSetting.js"></script>