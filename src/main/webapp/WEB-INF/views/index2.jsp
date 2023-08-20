<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@include file = "/WEB-INF/views/include/head2.jsp" %>
<style>
	body {
		text-align: center;
		min-height: 100vh;
		background: -webkit-gradient(linear, left bottom, right top, from(#92b5db),
			to(#1d466c));
		background: -webkit-linear-gradient(bottom left, #92b5db 0%, #1d466c 100%);
		background: -moz-linear-gradient(bottom left, #92b5db 0%, #1d466c 100%);
		background: -o-linear-gradient(bottom left, #92b5db 0%, #1d466c 100%);
		background: linear-gradient(to top right, #92b5db 0%, #1d466c 100%);
	}
	
	.input-form {
		max-width: 680px;
		margin-top: 80px;
		padding: 32px;
		background: #fff;
		-webkit-border-radius: 10px;
		-moz-border-radius: 10px;
		border-radius: 10px;
		-webkit-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
		-moz-box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15);
		box-shadow: 0 8px 20px 0 rgba(0, 0, 0, 0.15)
	}
	
	.form-signin {
	    max-width: 330px;
	    padding: 15px;
	}
	
	.mb-4 {
	    margin-top: 100px;
	}
	
	.bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
        -webkit-user-select: none;
        -moz-user-select: none;
        user-select: none;
       }

	@media (min-width: 768px) {
		.bd-placeholder-img-lg {
         		font-size: 3.5rem;
		}
	}
	
	.b-example-divider {
        height: 3rem;
        background-color: rgba(0, 0, 0, .1);
        border: solid rgba(0, 0, 0, .15);
        border-width: 1px 0;
        box-shadow: inset 0 .5em 1.5em rgba(0, 0, 0, .1), inset 0 .125em .5em rgba(0, 0, 0, .15);
       }
       
	.b-example-vr {
        flex-shrink: 0;
        width: 1.5rem;
        height: 100vh;
	}
       
       .bi {
        vertical-align: -.125em;
        fill: currentColor;
       }
       
	.nav-scroller {
        position: relative;
        z-index: 2;
        height: 2.75rem;
        overflow-y: hidden;
       }

	.nav-scroller .nav {
        display: flex;
        flex-wrap: nowrap;
        padding-bottom: 1rem;
        margin-top: -1px;
        overflow-x: auto;
        text-align: center;
        white-space: nowrap;
        -webkit-overflow-scrolling: touch;
	}
	.link-secondary {
	    color: white !important;
	}
</style>
<script>
	$(document).ready(function(){
		$("#userId").focus();
		
		$("#btnLogin").on("click", function(){
			if($.trim($("#userId").val()).length <= 0)
			{
				alert("아이디를 입력하세요.");
				$("#userId").focus();
				return;
			}
			
			if($.trim($("#userPwd").val()).length <= 0)
			{
				alert("비밀번호를 입력하세요.");
				$("#userPwd").focus();
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "user/login2",
				data:{
					userId:$("#userId").val(),
					userPwd:$("#userPwd").val()
				},
				datatype:"JSON",
				beforeSend:function(xhr){
					xhr.setRequestHeader("AJAX", "true");
				},
				success:function(response){
					//응답이 있음
					if(!icia.common.isEmpty(response))
					{
						//var data = JSON.parse(response);
						var code = icia.common.objectValue(response, "code", -500);
						
						if(code == 0)
						{
							alert("로그인 성공");
							location.href = "/board/list2"; //추후 게시판으로 변경
						}
						else
						{
							//비번 다름
							if(code == -1)
							{
								alert("비밀번호가 올바르지 않습니다.");
								$("#userPwd").focus();
							}
							else if(code == 404)
							{
								alert("아이디와 일치하는 사용자 정보가 없습니다.");
								$("#userId").focus();
							}
							else if(code == 400)
							{
								alert("파라미터 값이 올바르지 않습니다.");
								$("#userId").focus();
							}
							else
							{
								alert("오류가 발생하였습니다.");
								$("#userId").focus();
							}
						}
					}
					//응답이 비어있음
					else
					{
						alert("오류가 발생하였습니다.");
						$("#userId").focus();
					}
				},
				complete:function(data){
					//응답이 종료되면 실행 잘 사용하지 않음
					icia.common.log(data);
				},
				error:function(xhr, status, error){
					icia.common.error(error);
				}
				
			});
			
		});
		
		$("#btnReg").on("click", function(){
			location.href="/user/regForm2";
		});
		
		$("#btnLoginOut").on("click", function(){
			location.href="/user/loginOut2";
		});
	});
</script>
</head>
<body>
<%@include file = "/WEB-INF/views/include/navigation2.jsp" %>
<div class="container">
<div class="input-form-backgroud row">
<div class="input-form col-md-12 mx-auto">
	<form name="loginForm" id="loginForm" method="post" action="/loginProc0719.jsp" class="form-signin w-100 m-auto">
	    <img class="mb-4" src="/resources/images/summer.ico" alt="" width="72" height="57">
	    <h1 class="h3 mb-3 fw-normal">Please sign in</h1>
	
	    <div class="form-floating">
	      <input type="text" id="userId" name="userId" class="form-control" placeholder="name@example.com">
	      <label for="userId">ID</label>
	    </div>
	    <div class="form-floating">
	      <input type="password" id="userPwd" name="userPwd" class="form-control" placeholder="Password">
	      <label for="userPwd">Password</label>
	    </div>
		<br/>
	    
	    <%
		if(com.icia.web.util.CookieUtil.getCookie(request,(String)request.getAttribute("AUTH_COOKIE_NAME")) != null)
		{
		%>      
		       <button type="button" id="btnLogin" class="w-100 mb-2 btn btn-lg btn-outline-primary" style="display:none">Sign in</button>
		       <button type="button" id="btnLoginOut" class="w-100 mb-2 btn btn-lg btn-outline-primary" style="display:block">Sign out</button>
		       <button type="button" id="btnReg" class="w-100 btn btn-lg btn-outline-primary" style="display:none">Sign up</button>
		 <%
		}
		else
		{
		%>  
		       <button type="button" id="btnLogin" class="w-100 mb-2 btn btn-lg btn-outline-primary" style="display:block">Sign in</button>
		       <button type="button" id="btnLoginOut" class="w-100 mb-2 btn btn-lg btn-outline-primary" style="display:none">Sign out</button>
		       <button type="button" id="btnReg" class="w-100 btn btn-lg btn-outline-primary" style="display:block">Sign up</button>
		<%
		}
		%> 
		
	    <p class="mt-5 mb-3 text-muted">&copy; 2023-08-04</p>
	</form>
</div>
</div>
</div>
</body>
</html>