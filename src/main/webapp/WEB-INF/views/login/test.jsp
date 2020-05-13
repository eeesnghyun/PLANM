<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ include file="/WEB-INF/views/common/sources.jsp" %>

<!DOCTYPE html>
<html>
<head>
<title>Test WEB</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">

<link href="/resources/ax5/ax5calendar.css"  rel="stylesheet">
<link href="/resources/ax5/ax5formatter.css"  rel="stylesheet">
<link href="/resources/ax5/ax5picker.css"  rel="stylesheet">

<script type="text/javascript" src="/resources/ax5/ax5core.min.js"></script>
<script type="text/javascript" src="/resources/ax5/ax5calendar.min.js"></script>
<script type="text/javascript" src="/resources/ax5/ax5formatter.min.js"></script>
<script type="text/javascript" src="/resources/ax5/ax5picker.min.js"></script>

<script>
/* 시큐리티 토큰 */
var token = $("input[name='_csrf']").val();
var header = "X-CSRF-TOKEN"; 


function fcnt_Login(){
	$("#frm_header")[0].reset();
	$("#testDiv").modal("show");
	
}

var picker = new ax5.ui.picker();

$(document.body).ready(function () {

    picker.bind({
        target: $('[data-ax5picker="basic"]'),
        direction: "top",
        content: {
            width: 270,
            margin: 10,
            type: 'date',
            config: {
                control: {
                    left: '<i class="fa fa-chevron-left"></i>',
                    yearTmpl: '%s',
                    monthTmpl: '%s',
                    right: '<i class="fa fa-chevron-right"></i>'
                },
                lang: {
                    yearTmpl: "%s년",
                    months: ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'],
                    dayTmpl: "%s"
                }
            }
        },
        onStateChanged: function () {

        },
        btns: {
            today: {
                label: "Today", onClick: function () {
                    var today = new Date();
                    this.self
                            .setContentValue(this.item.id, 0, ax5.util.date(today, {"return": "yyyy-mm-dd"}))
                            .setContentValue(this.item.id, 1, ax5.util.date(today, {"return": "yyyy-mm-dd"}))
                            .close()
                    ;
                }
            },
            thisMonth: {
                label: "This Month", onClick: function () {
                    var today = new Date();
                    this.self
                            .setContentValue(this.item.id, 0, ax5.util.date(today, {"return": "yyyy-mm-01"}))
                            .setContentValue(this.item.id, 1, ax5.util.date(today, {"return": "yyyy-mm"})
                                    + '-'
                                    + ax5.util.daysOfMonth(today.getFullYear(), today.getMonth()))
                            .close();
                }
            },
            ok: {label: "Close", theme: "default"}
        }
    });

});
</script>
</head>
<body class="text-center mt-5">
<form:form id="frm_header" action="/login/testEnter.ajax" method="POST">
	<button type="button" class="btn btn-outline-secondary" onclick="fcnt_Login()">접속</button>
	<div class="modal fade" id="testDiv">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<input type="text" class="form-control mb-2" id="ipt-id" name="ipt-id" placeholder="아이디">
					<input type="password" class="form-control mb-2" id="ipt-pass" name="ipt-pass" placeholder="패스워드">
				</div>
				<div class="modal-footer">
					<div style="margin: 0px auto">
						<button type="submit" class="btn btn-outline-secondary" onclick="fcnt_Enter()">접속</button>
					</div>				
				</div>
			</div>
		</div>
	</div>
</form:form>

<div class="row">
    <div class="col-md-6">
        <label>Multi Date</label>
        <div class="input-group" data-ax5picker="basic">
            <input type="text" class="form-control" placeholder="yyyy/mm/dd">
            <span class="input-group-addon">~</span>
            <input type="text" class="form-control" placeholder="yyyy/mm/dd">
            <span class="input-group-addon"><i class="fa fa-calendar-o"></i></span>
        </div>
    </div>
</div>

</body>