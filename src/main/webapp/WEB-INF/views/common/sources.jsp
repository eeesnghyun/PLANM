<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- jQuery 최신 버전 -->
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="http://code.jquery.com/jquery-latest.js"></script>

<!-- Spring -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!-- Tiles -->
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>

<!-- JSTL -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:useBean id="today" class="java.util.Date" />
<fmt:formatDate value="${today}" pattern="yyyyMMdd" var="updateTime" />

<!-- jQuery UI -->
<script src="/resources/jquery-ui/jquery-ui.js" type="text/javascript"></script>
<link href="/resources/jquery-ui/jquery-ui.css"  rel="stylesheet">

<!-- Bootstrap 4.4.1 -->
<script src="/resources/bootstrap/bootstrap.min.js" type="text/javascript"></script>
<link href="/resources/bootstrap/bootstrap.css"  rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">

<!-- 공통 CSS -->
<link href='<c:url value="/include/common.css"><c:param name="date" value="${updateTime}"/></c:url>' rel="stylesheet" type="text/css" />

<!-- 공통 JS -->
<script type="text/javascript" src='<c:url value="/include/common.js"><c:param name="date" value="${updateTime}"/></c:url>"/>'></script>

<!-- Moment.js 날짜,시간 관련 -->
<script src="/resources/calendar/js/moment.min.js" type="text/javascript"></script>

<!-- Jquery MultiFile -->
<script src="/resources/jquery.MultiFile/jquery.MultiFile.js" type="text/javascript"></script>

<!-- ax5ui -->
<script type="text/javascript" src="/resources/ax5ui/ax5core.min.js"></script>
<script type="text/javascript" src="/resources/ax5ui/ax5formatter.min.js"></script>
<script type="text/javascript" src="/resources/ax5ui/ax5grid.min.js"></script>		<!-- Grid -->
<script type="text/javascript" src="/resources/ax5ui/ax5calendar.min.js"></script>	<!-- Calendar -->
<script type="text/javascript" src="/resources/ax5ui/ax5picker.min.js"></script>	<!-- Picker -->
<link rel="stylesheet" type="text/css" href="/resources/ax5ui/ax5grid.css">
<link rel="stylesheet" type="text/css" href="/resources/ax5ui/ax5calendar.css">
<link rel="stylesheet" type="text/css" href="/resources/ax5ui/ax5picker.css">

<!-- CKEditor -->
<script type="text/javascript" src="/resources/ckeditor/ckeditor.js"></script>