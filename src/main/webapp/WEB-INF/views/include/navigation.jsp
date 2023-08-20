<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<%
//request.getAttribute() 메서드는 이전 다른 JSP나 servlet에서 설정된 매개변수 값을 가져옴
if (com.icia.web.util.CookieUtil.getCookie(request, (String) request.getAttribute("AUTH_COOKIE_NAME")) != null) 
{
%>
<nav class="navbar navbar-expand-sm bg-secondary navbar-dark mb-3">
	<ul class="navbar-nav">
		<li class="nav-item">
			<!-- 디스패처 서블릿한테 컨트롤러와 매핑된거 검색 --> 
			<a class="nav-link" href="/user/loginOut"> 로그아웃</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="/user/updateForm">회원정보수정</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="/board/list">게시판</a>
		</li>
	</ul>
</nav>
<%
} 
else 
{
%>
<nav class="navbar navbar-expand-sm bg-secondary navbar-dark mb-3">
	<ul class="navbar-nav">
		<li class="nav-item">
			<a class="nav-link" href="/"> 로그인</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="/user/regForm">회원가입</a>
		</li>
		<li class="nav-item">
			<a class="nav-link" href="/index2"> 로그인2</a>
		</li>
	</ul>
</nav>
<%
}
%>