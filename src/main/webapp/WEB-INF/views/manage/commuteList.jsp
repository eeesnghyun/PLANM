<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
$(document).ready(function() {
	
	
});
</script>

<c:forEach var="map" items="${resultList}" varStatus="status">	
	<ul class="list-group list-group-horizontal" >
	<c:choose>
	
		<c:when test="${status.index eq '0'}">
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.usercd}" /></strong></li>						
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday01}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday02}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday03}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday04}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday05}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday06}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday07}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday08}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday09}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday10}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday11}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday12}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday13}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday14}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday15}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday16}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday17}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday18}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday19}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday20}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday21}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday22}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday23}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday24}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday25}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday26}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday27}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday28}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday29}" escapeXml="false"/></strong></li>		
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday30}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme1"><strong><c:out value="${map.workday31}" escapeXml="false"/></strong></li>
		</c:when>
		<c:otherwise>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.usercd}" /></strong></li>						
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday01}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday02}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday03}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday04}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday05}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday06}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday07}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday08}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday09}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday10}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday11}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday12}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday13}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday14}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday15}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday16}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday17}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday18}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday19}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday20}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday21}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday22}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday23}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday24}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday25}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday26}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday27}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday28}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday29}" escapeXml="false"/></strong></li>		
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday30}" escapeXml="false"/></strong></li>
			<li class="list-group-item2 bg-theme3"><strong><c:out value="${map.workday31}" escapeXml="false"/></strong></li>
		</c:otherwise>
		
	</c:choose>	
	</ul>
</c:forEach>
