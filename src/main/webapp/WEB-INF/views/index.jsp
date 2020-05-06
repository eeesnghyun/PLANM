<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div style="min-width: 800px">
	<iframe class="ifrm-basic" id="ifrmMenu"></iframe>
	<!-- <div class="ifrm-basic" id="menuSpace"></div> -->
</div>

<script>
$(document).ready(function() {	
		
	$("#ifrmMenu").attr("src", "/schedule/main.do");	
	/* $("#menuSpace").load("/schedule/main.do"); */
	
});
</script>