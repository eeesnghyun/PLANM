<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>

<script>
function fcnt_GoMenuPage(menuUrl, menuCd){
	var menuUrl = menuUrl;
	
	$("#ifrmMenu").attr("src", menuUrl);	
} 

function fcnt_MenuList(){
	var params = {};	

	var data = fnct_CallPostAjax("/menu/getMenuList.ajax", params);	
	if(data.status == "success") {
		var menuList = data.result;
       	var menuHtml = "";
    	var menuUrl = "";
    	var menuCd = "";
       	
    	for(var i = 0; i < menuList.length; i++){
    		menuUrl = menuList[i].menuurl;
    		menuCd = menuList[i].menucd;
    		
    		if(i % 2 == 0) {
    			menuHtml += "<ul class='nav justify-content-left' style='min-width: 280px;'>";
    		}        		        		
    		
    		menuHtml += "	<li class='nav-item'>";
    		menuHtml += "		<button type='button' class='btn-img' id='" + menuList[i].menucd + "' style='width: 120px' onclick=fcnt_GoMenuPage('"+menuUrl+"'"+","+"'"+menuCd+"')>";
    		menuHtml += "			<img src='/images/" + menuList[i].menuimg +"' class='w64-h64'>";
    		menuHtml += "			<div class='menu-div'><h5><strong>" + menuList[i].menunm + "</strong></h5></div>";
    		menuHtml += "		</button>";
    		menuHtml += "	</li>";
    		
    		if(i % 2 != 0) {
    			menuHtml += "</ul>";	
    		}        		
    	}
    	
    	$("#leftMenu").append(menuHtml);
	}
	
}

$(document).ready(function() {	
	
	/* 메뉴 조회 */
	fcnt_MenuList();	
	
});
</script>
<div class="container-fluid" id="leftMenu"></div>