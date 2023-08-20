<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
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
	
	.card-margin {
		margin-bottom: 1.875rem;
	}

	.card {
	   border: 0;
	   box-shadow: 0px 0px 10px 0px rgba(82, 63, 105, 0.1);
	   -webkit-box-shadow: 0px 0px 10px 0px rgba(82, 63, 105, 0.1);
	   -moz-box-shadow: 0px 0px 10px 0px rgba(82, 63, 105, 0.1);
	   -ms-box-shadow: 0px 0px 10px 0px rgba(82, 63, 105, 0.1);
	}
	
	.card {
	   position: relative;
	   display: flex;
	   flex-direction: column;
	   min-width: 0;
	   word-wrap: break-word;
	   background-color: #ffffff;
	   background-clip: border-box;
	   border: 1px solid #e6e4e9;
	   border-radius: 8px;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {

		$("#btnUpdate").on("click", function() {

			// 모든 공백 체크 정규식
			var emptCheck = /\s/g;
			// 영문 대소문자, 숫자로만 이루어진 4~12자리 정규식
			var idPwCheck = /^[a-zA-Z0-9]{4,12}$/;
			
			if($.trim($("#userPwd1").val()).length <= 0)
			{
				alert("비밀번호를 입력하세요.");
				$("#userPwd1").val();
				$("#userPwd1").focus();
				return;
			}
			
			if(emptCheck.test($("#userPwd1").val()))
			{
				alert("비밀번호는 공백을 포함할 수 없습니다.");
				$("#userPwd1").focus();
				return;
			}
			
			if(!idPwCheck.test($("#userPwd1").val()))
			{
				alert("비밀번호는 영문 대소문자, 숫자로만 이루어진 4~12자리입니다.");
				$("#userPwd1").focus();
				return;
			}
			
			if($("#userPwd1").val() != $("#userPwd2").val())
			{
				alert("비밀번호가 일치하지 않습니다.");
				$("#userPwd2").focus();
				return;
			}
			
			$("#userPwd").val($("#userPwd1").val());
			
			if($.trim($("#userName").val()).length <= 0)
			{
				alert("이름을 입력하세요.");
				$("#userName").val();
				$("#userName").focus();
				return;
			}
			
			if(emptCheck.test($("#userName").val()))
			{
				alert("이름은 공백을 포함할 수 없습니다.");
				$("#userName").focus();
				return;
			}
			
			if($.trim($("#userEmail").val()).length <= 0)
			{
				alert("이메일을 입력하세요.");
				$("#userEmail").val();
				$("#userEmail").focus();
				return;
			}
			
			if(emptCheck.test($("#userEmail").val()))
			{
				alert("이메일은 공백을 포함할 수 없습니다.");
				$("#userEmail").focus();
				return;
			}
			
			if(!fn_validateEmail($("#userEmail").val()))
			{
				alert("이메일 형식이 올바르지 않습니다.");
				$("#userEmail").focus();
				return;
			}

			$.ajax({
				type:"POST",
				url:"/user/updateProc",
				data:{
					userPwd:$("#userPwd").val(),
					userName:$("#userName").val(),
					userEmail:$("#userEmail").val()
				},
				datatype:"JSON",
				beforeSend:function(xhr)
				{
					xhr.setRequestHeader("AJAX", "true");
				},
				success:function(response)
				{
					if(response.code == 0)
					{
						alert("회원 정보 수정이 완료되었습니다.");
						location.href = "/user/updateForm";
					}
					else if(response.code == 400)
					{
						alert("파라미터 값이 올바르지 않습니다.");
						$("#userPwd1").focus();
					}
					else if(response.code == 404)
					{
						alert("회원 정보가 존재하지 않습니다.");
						location.href = "/";
					}
					else if(response.code == 500)
					{
						alert("회원 정보 수정 중 오류가 발생했습니다.");
						$("#userPwd1").focus();
					}
					else
					{
						alert("기타 다른 오류 발생");
						location.href = "/";
					}
				},
				error:function(xhr, status, error)
				{
					icia.common.error(error);
				}
			});
		});
	});

	function fn_validateEmail(value) {
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

		return emailReg.test(value);
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation2.jsp"%>
	<div class="container">
	<div class="col-12 mt-5">
    <div class="card card-margin">
    <div class="card-body">
		<div class="row mt-1 ml-1">
			<h3>회원정보수정</h3>
		</div>
		<div class="row mt-2">
			<div class="col-12">
				<form>
					<div class="form-group">
						<label for="username">사용자 아이디</label>
						${user.userId}
					</div>
					<div class="form-group">
						<label for="username">비밀번호</label> 
						<input type="password" class="form-control" id="userPwd1" name="userPwd1" value="${user.userPwd}" placeholder="비밀번호" maxlength="12" />
					</div>
					<div class="form-group">
						<label for="username">비밀번호 확인</label> 
						<input type="password" class="form-control" id="userPwd2" name="userPwd2" value="${user.userPwd}" placeholder="비밀번호 확인" maxlength="12" />
					</div>
					<div class="form-group">
						<label for="username">사용자 이름</label> 
						<input type="text" class="form-control" id="userName" name="userName" value="${user.userName}" placeholder="사용자 이름" maxlength="15" />
					</div>
					<div class="form-group">
						<label for="username">사용자 이메일</label> 
						<input type="text" class="form-control" id="userEmail" name="userEmail" value="${user.userEmail}" placeholder="사용자 이메일" maxlength="30" />
					</div>
					<br>
					
					<input type="hidden" id="userId" name="userId" value="${user.userId}" /> 
					<input type="hidden" id="userPwd" name="userPwd" value="" />
					<button type="button" id="btnUpdate" class="btn btn-primary btn-lg btn-block">수정</button>
				</form>
			</div>
		</div>
	</div>
	</div>
	</div>
	</div>
</body>
</html>
