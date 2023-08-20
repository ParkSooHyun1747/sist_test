<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>

<%
//request.getAttribute() 메서드는 이전 다른 JSP나 servlet에서 설정된 매개변수 값을 가져옴
if (com.icia.web.util.CookieUtil.getCookie(request, (String) request.getAttribute("AUTH_COOKIE_NAME")) != null) 
{
%>
<nav class="p-3 mb-3 border-bottom">
	<div class="container">
		<div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
			<a href="/board/list2" class="d-flex align-items-center mb-2 mb-lg-0 text-dark text-decoration-none">
				<img src="/resources/images/summer.png" alt="Bootstrap" width="40">
			</a>

			<ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0 navbar-light" style="font-weight:bold;">
				<li><a href="/board/list2" class="nav-link px-2 link-secondary">게시판</a></li>
			</ul>

			<div class="dropdown text-end">
				<a href="#" class="d-block link-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false"> 
					<img src="/resources/images/user.png" alt="mdo" width="32" height="32" class="rounded-circle">
				</a>
				<ul class="dropdown-menu text-small">
					<li><a class="dropdown-item" href="/user/updateForm2">회원정보수정</a></li>
					<li><a class="dropdown-item" href="/board/write2">글쓰기</a></li>
					<li><hr class="dropdown-divider"></li>
					<li><a class="dropdown-item" href="/user/loginOut2">로그아웃</a></li>
				</ul>
			</div>
		</div>
	</div>
</nav>
<%
} 
else 
{
%>
<nav class="p-3 mb-3 border-bottom">
	<div class="container">
		<div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">
			<a href="/" class="d-flex align-items-center mb-2 mb-lg-0 text-dark text-decoration-none">
				<img src="/resources/images/summer.png" alt="Bootstrap" width="40">
			</a>

			<ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0 navbar-light" style="font-weight:bold;">
				<li><a href="/board/list2" class="nav-link px-2 link-secondary" >게시판</a></li>
			</ul>
	        
	        <div class="dropdown text-end">
				<a href="#" class="d-block link-dark text-decoration-none dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false"> 
					<img src="/resources/images/sign-in.png" alt="mdo" width="32" height="32" class="rounded-circle">
				</a>
				<ul class="dropdown-menu text-small">
					<li><a class="dropdown-item" href="/index2">로그인</a></li>
					<li><a class="dropdown-item" href="/user/regForm2">회원가입</a></li>
				</ul>
			</div>
		</div>
	</div>
</nav>
<%
}
%>