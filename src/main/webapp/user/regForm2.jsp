<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jsp 쓸려면 무조건 사용해야 함 -->
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<!-- 확인용용요요용 -->
<!-- 제이쿼리 사용하려면 무조건 써야 함 -->
<%@ include file="/WEB-INF/views/include/head2_2.jsp"%>
<style>
	body {
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
	
	.btn-group-sm>.btn, .btn-sm {
		margin-top: 10px;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {

		$("#userId").focus();

		$("#btnReg").on("click", function() {
			//공백체크
			var emptCheck = /\s/g;
			//영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
			var idPwdCheck = /^[a-zA-Z0-9]{4,12}$/;

			if ($.trim($("#userId").val()).length <= 0) 
			{
				alert("사용자 아이디를 입력하세요.");
				$("#userId").val("");
				$("#userId").focus();
				return;
			}

			if (emptCheck.test($("#userId").val())) 
			{
				alert("사용자 아이디는 공백을 포함할 수 없습니다.");
				$("#userId").focus();
				return;
			}

			if (!idPwdCheck.test($("userId").val())) 
			{
				alert("아이디는 영문 대소문자, 숫자로만 이루어진 4~12자리로 입력해주세요.");
				$("#userId").focus();
				return;
			}

			if ($.trim($("#userPwd1").val()).length <= 0) 
			{
				alert("비밀번호를 입력하세요.");
				$("#userPwd1").val("");
				$("#userPwd1").focus();
				return;
			}

			if (emptCheck.test($("#userPwd1").val())) 
			{
				alert("비밀번호는 공백을 포함할 수 없습니다.");
				$("#userPwd1").focus();
				return;
			}

			if (!idPwdCheck.test($("userPwd1").val())) 
			{
				alert("비밀번호는 영문 대소문자, 숫자로만 이루어진 4~12자리로 입력해주세요.");
				$("#userPwd1").focus();
				return;
			}

			if ($("#userPwd1").val() != $("#userPwd2").val()) 
			{
				alert("비밀번호가 일치하지 않습니다.");
				$("#userPwd2").focus();
				return;
			}

			$("#userPwd").val($("#userPwd1").val());

			if ($.trim($("#userName").val()).length <= 0) 
			{
				alert("사용자 이름을 입력하세요.");
				$("#userName").val("");
				$("#userName").focus();
				return;
			}

			if ($.trim($("#userEmail").val()).length <= 0) 
			{
				alert("이메일을 입력하세요.");
				$("#userEmail").val("");
				$("#userEmail").focus();
				return;
			}

			if (!fn_validateEmail($("#userEmail").val())) 
			{
				alert("이메일 형식이 올바르지 않습니다.");
				$("#userEmail").focus();
				return;
			}

			//아이디 중복체크 ajax
			$.ajax({
				type : "POST",
				url : "/user/idCheck",
				data : {
					//중복아이디 체크라서 id만 보내면 됨
					userId : $("#userId").val()
				},
				datatype : "JSON",
				beforeSend : function(xhr) {
					//ajax 통신이라는 requestHeader 정보에 삽입(없어도 됨, 오류 안남)
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					//정상
					if (response.code == 0) 
					{
						//alert("아이디 중복 없음, 가입 가능");
						//실질적인 일은 fn_userReg() 함수에서 진행하기 때문에 호출
						fn_userReg();
					} 
					else if (response.code == 100) 
					{
						alert("중복된 아이디입니다.");
						$("#userId").focus();
					} 
					else if (response.code == 400) 
					{
						alert("파라미터 값이 올바르지 않습니다.");
						$("#userId").focus();
					} 
					else 
					{
						alert("오류가 발생했습니다.");
						$("#userId").focus();
					}
				},
				error : function(xhr, status, error) {
					icia.common.error(error);
				}
			});
		});
	});

	function fn_userReg() {
		$.ajax({
			type : "POST",
			url : "/user/regProc",
			data : {
				userId:$("#userId").val(),
				userPwd:$("#userPwd").val(),
				userName:$("#userName").val(),
				userEmail:$("#userEmail").val()
			},
			datatype : "JSON",
			boforeSend : function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response)
			{
				if(response.code == 0)
				{
					alert("회원가입 완료");
					location.href = "/"; //로그인 페이지로 이동
				}
				else if(response.code == 100)
				{
					alert("아이디 중복");
					$("#userId").focus();
				}
				else if(response.code == 400)
				{
					alert("파라미터 값 오류");
					$("#userId").focus();
				}
				else if(response.code == 500)
				{
					alert("회원가입 중 오류 발생");
					$("#userId").focus();
				}
				else
				{
					alert("회원가입 중 오류 발생했습니다.");
					$("#userId").focus();
				}
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
			}
		});
	}

	function fn_validateEmail(value) {
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

		return emailReg.test(value);
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation2.jsp"%>
	<div class="container">
		<div class="input-form-backgroud row">
			<div class="input-form col-md-12 mx-auto">
				<h4 class="mb-3">회원가입</h4>
				<form class="validation-form" name="form1" action = "/user/userProc0719.jsp" method="POST">
					<div class="row form-group">
						<div class="col-md-8 mb-3">
							<label for="userId">아이디</label>
              				<input type="text" class="form-control" id="userId" name="userId">
						</div>
						
						<div class="col-md-4 mb-3">
							<label></label>
							<button class="btn btn-outline-secondary btn-sm btn-block" type="button" onclick="idCk()">중복확인</button>
						</div>
					</div>
					
					<div class="form-group mb-3">
						<label for="userPwd1">비밀번호</label>
            			<input type="password" class="form-control" id="userPwd1" name="userPwd1">
					</div>
					
					<div class="form-group mb-3">
						<label for="userPwd2">비밀번호 확인</label>
            			<input type="password" class="form-control" id="userPwd2" name="userPwd2">
					</div>
					
					<div class="form-group mb-3">
						<label for="userName">이름</label>
           				<input type="text" class="form-control" id="userName" name="userName">
					</div>

					<div class="form-group mb-3">
						<label for="userEmail">이메일</label>
            			<input type="text" class="form-control" id="userEmail" name="userEmail" placeholder="you@example.com">
					</div>

					<div class="form-group mb-3">
						<label for="userHbd">생년월일</label>
            			<input type="date" class="form-control" id="userHbd" name="userHbd">
					</div>
					
					<div class="form-group mb-3">
						<label for="userPhone">전화번호</label>
            			<input type="text" class="form-control" id="userPhone" name="userPhone" placeholder="'-'포함하여 입력하세요.">
					</div>

					<hr class="form-group mb-4">
					<div class="custom-control custom-checkbox">
						<input type="checkbox" class="custom-control-input" id="aggrement"> 
						<label class="custom-control-label" for="aggrement">개인정보 수집 및 이용에 동의합니다.</label>
					</div>
					<div class="mb-4"></div>
					<!-- 타입이 히든이라면 개발자가 사용하는 부분임, 화면에 보여지지 않음, 클라이언트에서 서버로 갔을 때 사용하는 것은 name(변수명)임 -->
	                <input type="hidden" id="userPwd" name="userPwd" value="" />
	                <input type="hidden" id="userCk" name="userCk" value="" />
					<button type="button" id=btnReg class="btn btn-primary btn-lg btn-block">회원가입</button>
				</form>
			</div>
		</div>
		<footer class="my-3 text-center text-small">
			<p class="mb-1">&copy; 2023-08-04</p>
		</footer>
	</div>
</body>
</html>