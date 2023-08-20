<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- jsp 쓸려면 무조건 사용해야 함 -->
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
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
	
	.link-secondary {
	    color: white !important;
	}
	
</style>
<script type="text/javascript">
	var idCkCnt = 0; //중복확인 변수
	
	$(document).ready(function() {

		$("#userId").focus();

		$("#btnReg").on("click", function() {
			//아이디, 비번
			var idPwdCk = /^[a-zA-Z0-9-_]{4,20}$/;
			//공백 체크
			var emptCk = /\s/g;
			//이름
			var nameCk = /^[a-zA-Z가-힣]*$/;
			//이메일
			var emailCk = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			//생년월일
			var HbdCk = /^(19[0-9][0-9]|20\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$/;
			//전화번호
			var phoneCk = /^01([0|1|6|7|9])-([0-9]{3,4})-([0-9]{4})$/;
			//주소
			var addrCk = /^[가-힣A-Za-z·\d~\-\.]+(로|길)$/;

			//아이디 입력 체크
			if($.trim($("#userId").val()).length <= 0)
			{
				alert("아이디를 입력해주세요.");
				$("#userId").val("");
				$("#userId").focus();
				return;
			}
			//아이디 공백 체크
			if(emptCk.test($("#userId").val()))
			{
				alert("아이디는 공백을 포함할 수 없습니다.");
				$("#userId").val("");
				$("#userId").focus();
				return;
			}
			//아이디 정규표현식 체크
			if(!idPwdCk.test($("#userId").val()))
			{
				alert("아이디는 ~20자로 영문 대소문자, 숫자, 특수기호(-,_)만 사용 가능합니다.");
				$("#userId").val("");
				$("#userId").focus();
				return;
			}
			
			//비밀번호 입력 체크
			if($.trim($("#userPwd1").val()).length <= 0)
			{
				alert("비밀번호를 입력하세요.");
				$("#userPwd1").val("");
				$("#userPwd1").focus();
				return;
			}
			//비밀번호 공백 체크
			if(emptCk.test($("#userPwd1").val()))
			{
				alert("비밀번호는 공백을 포함할 수 없습니다.");
				$("#userPwd1").val("");
				$("#userPwd1").focus();
				return;
			}
			
			//비밀번호 정규표현식 체크
			if(!idPwdCk.test($("#userPwd1").val()))
			{
				alert("비밀번호는 4~20자로 영문 대소문자, 숫자, 특수기호(-,_)만 사용 가능합니다.");
				$("#userPwd1").val("");
				$("#userPwd1").focus();
				return;
			}
			
			//비밀번호1, 2 값 비교
			if($("#userPwd1").val() != $("#userPwd2").val())
			{
				alert("비밀번호가 다릅니다.");
				$("#userPwd2").val("");
				$("#userPwd2").focus();
				return;
			}
			
			$("#userPwd").val($("#userPwd1").val());
			
			//이름 입력 체크
			if($.trim($("#userName").val()).length <= 0)
			{
				alert("이름을 입력해주세요.");
				$("#userName").val("");
				$("#userName").focus();
				return;
			}
			//이름 공백 체크
			if(emptCk.test($("#userName").val()))
			{
				alert("아이디는 공백을 포함할 수 없습니다.");
				$("#userName").val("");
				$("#userName").focus();
				return;
			}
			//이름 정규표현식 체크
			if(!nameCk.test($("#userName").val()))
			{
				alert("이름은 한글과 영문 대소문자만 가능합니다.");
				$("#userName").val("");
				$("#userName").focus();
				return;
			}
			
			//이메일 입력 체크
			if($.trim($("#userEmail").val()).length <= 0)
			{
				alert("이메일을 입력해주세요.");
				$("#userEmail").val("");
				$("#userEmail").focus();
				return;
			}
			//이메일 공백 체크
			if(emptCk.test($("#userEmail").val()))
			{
				alert("이메일은 공백을 포함할 수 없습니다.");
				$("#userEmail").val("");
				$("#userEmail").focus();
				return;
			}
			//이메일 정규표현식 체크
			if(!emailCk.test($("#userEmail").val()))
			{
				alert("이메일을 확인하세요.");
				$("#userEmail").val("");
				$("#userEmail").focus();
				return;
			}

			//전화번호 입력 체크
			if($.trim($("#userPhone").val()).length <= 0)
			{
				alert("전화번호를 입력해주세요.");
				$("#userPhone").val("");
				$("#userPhone").focus();
				return;
			}
			//전화번호 공백 체크
			if(emptCk.test($("#userPhone").val()))
			{
				alert("전화번호는 공백을 포함할 수 없습니다.");
				$("#userPhone").val("");
				$("#userPhone").focus();
				return;
			}
			//전화번호 정규표현식 체크
			if(!phoneCk.test($("#userPhone").val()))
			{fgf
				alert("전화번호를 확인하세요.");
				$("#userPhone").val("");
				$("#userPhone").focus();
				return;
			}
			
			//주소 입력 체크
			if($.trim($("#userAddress").val()).length <= 0)
			{
				alert("주소를 입력해주세요.");
				$("#userAddress").val("");
				$("#userAddress").focus();
				return;
			}
			
			//주소 정규표현식 체크
			if(!phoneCk.test($("#userAddress").val()))
			{
				alert("주소는 도로명으로 작성해주세요.");
				$("#userAddress").val("");
				$("#userAddress").focus();
				return;
			}
			
			//개인정보 필수 선택
	        if($('#aggrement').is(":checked") == false){
	        	alert("개인정보이용에 동의해주시기 바랍니다.");
	            return;
	        }

	        if($("#userCk").val() == "Y")
			{
	        	fn_userReg();
			}
			else
			{
				alert("아이디 중복 체크하세요.");
				$("#userId").focus();
			}
			
		});
	});

	function idCk()
	{
		idCkCnt++;
		
		//아이디 중복체크 ajax
		$.ajax({
			type : "POST",
			url : "/user/idCheck2",
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
					alert("아이디 사용 가능합니다.");
					$("#userCk").val("Y");
					//실질적인 일은 fn_userReg() 함수에서 진행하기 때문에 호출
				} 
				else if (response.code == 100) 
				{
					alert("중복된 아이디입니다.");
					$("#userCk").val("N");
					$("#userId").focus();
				} 
				else if (response.code == 400) 
				{
					alert("파라미터 값이 올바르지 않습니다.");
					$("#userCk").val("N");
					$("#userId").focus();
				} 
				else 
				{
					alert("오류가 발생했습니다.");
					$("#userCk").val("N");
					$("#userId").focus();
				}
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
			}
		});
	}
	
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
            			<input type="text" class="form-control" id="userPhone" name="userPhone" placeholder="'-'를 제외하고 입력하세요.">
					</div>
					
					<div class="form-group mb-3">
						<label for="userAddress">주소</label>
            			<input type="text" class="form-control" id="userAddress" name="userAddress" placeholder="도로명 주소로 입력하세요.">
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