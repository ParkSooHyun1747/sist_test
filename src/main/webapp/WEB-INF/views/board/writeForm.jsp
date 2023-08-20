<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {

		$("#hiBbsTitle").focus();

		$("#btnWrite").on("click", function() {
			//ajax 통신 끝나기 전까지 글쓰기 버튼 비활성화 처리
			$("#btnWrite").prop("disabled", true);
			
			if($.trim($("#hiBbsTitle").val()).length <= 0)
			{
				alert("제목을 입력하세요.");
				$("#hiBbsTitle").val("");
				$("#hiBbsTitle").focus();
				
				//글쓰기 버튼 활성화 처리
				$("#btnWrite").prop("disabled", false);
				
				return;
			}
			
			if($.trim($("#hiBbsContent").val()).length <= 0)
			{
				alert("내용을 입력하세요.");
				$("#hiBbsContent").val("");
				$("#hiBbsContent").focus();
				
				//글쓰기 버튼 활성화 처리
				$("#btnWrite").prop("disabled", false);
				
				return;
			}
			
			//제목과 내용이 정상적으로 입력됐다면
			var form = $("#writeForm")[0]; //writeForm의 0번째를 받아서 form에 담고
			var formData = new FormData(form); //담은 것은 formData에 저장
			
			$.ajax({
				type : "POST",
				enctype : "multipart/form-data", //폼 데이터(form data)가 서버로 전송될 때 multipart/form-data를 사용하도록 지정함. 이는 파일 업로드와 같이 바이너리 데이터를 전송할 때 사용
				url : "/board/writeProc", //데이터를 보낼 URL을 지정
				data : formData, //서버로 보낼 데이터를 지정
				processData : false, //formData를 string으로 변환하지 않음, 첨부파일 사용할 때 넣어야 함
				//데이터를 처리할 방법을 지정함. 이 경우 false로 설정하여 formData를 string으로 변환하지 않음
				contentType : false, //content-Type 헤더가 multipart/form-data로 전송
				cache : false, //AJAX 요청이 캐시되는 것을 방지하기 위해 false로 설정
				timeout : 600000, //요청이 중단되기 전 대기할 시간(밀리초)을 설정
				beforeSend : function(xhr) 
				{ // AJAX 요청이 전송되기 전에 실행. 이 경우 AJAX 헤더를 설정
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response)
				{
					if(response.code == 0)
					{
						alert("게시물이 등록되었습니다.");
						location.href = "/board/list";
						
						/*
						폼을 날리고 싶다면 
						document.bbsForm.action = "/board/list";
						document.bbsForm.submit();
						*/
					}
					else if(response.code == 400)
					{
						alert("파라미터 값이 올바르지 않습니다.");
						$("#hiBbsTitle").focus();
						//글쓰기 버튼 활성화
						$("#btnWrite").prop("disabled", false);
					}
					else //500번 포함 다른 오류들
					{
						alert("게시물 등록 중 오류 발생");
						$("#hiBbsTitle").focus();
						//글쓰기 버튼 활성화
						$("#btnWrite").prop("disabled", false);
					}
				},
				error : function(error)
				{
					icia.common.error(error);
					alert("게시물 등록 중 오류가 발생하였습니다.");
					$("#btnWrite").prop("disabled", false);
				},
			});
		});
		
		$("#btnWrite2").on("click", function(){
			$("#btnWrite2").prop("disabled", true)
			
			if($.trim($("#hiBbsTitle").val()).length <= 0)
			{
				alert("제목을 입력하세요");
				$("#hiBbsTitle").val("");
				$("#hiBbsTitle").focus();
				
				$("#btnWrite2").prop("disabled", false);
				
				return;
			}
			
			if($.trim($("#hiBbsContent").val()).length <= 0)
			{
				alert("내용을 입력하세요.");
				$("#hiBbsContent").val("");
				$("#hiBbsContent").focus();
				
				$("#btnWrite2").prop("disabled", false);
				
				return;
			}
			
			
			var form = $("#writeForm")[0];
			var formData = new FormData(form);
			
			$.ajax({
				type:"POST",
				enctype:"multipart/form-data",
				url:"/board/writeProc2",
				data:formData,
				processData:false,
				contentType:false,
				cache:false,
				timeout:6000,
				success:function(response){
					if(response.code == 0)
					{
						alert("게시물 등록 성공");
						location.href = "/board/list";
					}
					else if(response.code == 400)
					{
						alert("게시물 입력이 잘못됐습니다.");
						$("#hiBbsTitle").focus();
						
						$("#btnWrite2").prop("disabled", false);
					}
					else
					{
						alert("게시물 등록 중 오류 발생했습니다.");
						$("#hiBbsTitle").focus();
						
						$("#btnWrite2").prop("disabled", false);
					}
				},
				error:function(error){
					icia.common.error(error);
					alert("게시물 등록 중 오류가 발생했다리.");
					$("#btnWrite2").prop("disabled", false);
				}
			});
		});

		$("#btnList").on("click", function() {
			document.bbsForm.action = "/board/list";
			document.bbsForm.submit();
		});
	});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<div class="container">
		<h2>게시물 쓰기</h2>
		<!-- 모든 문자를 인코딩하지 않음을 명시함. 이 방식은 <form> 요소가 파일이나 이미지를 서버로 전송할 때 주로 사용 -->
		<form name="writeForm" id="writeForm" method="post" enctype="multipart/form-data">
			<input type="text" name="userName" id="userName" maxlength="20" value="${user.userName}" style="ime-mode: active;" class="form-control mt-4 mb-2" placeholder="이름을 입력해주세요." readonly /> 
			<input type="text" name="userEmail" id="userEmail" maxlength="30" value="${user.userEmail}" style="ime-mode: inactive;" class="form-control mb-2" placeholder="이메일을 입력해주세요." readonly /> 
			<input type="text" name="hiBbsTitle" id="hiBbsTitle" maxlength="100" style="ime-mode: active;" class="form-control mb-2" placeholder="제목을 입력해주세요." required />
			<div class="form-group">
				<textarea class="form-control" rows="10" name="hiBbsContent" id="hiBbsContent" style="ime-mode: active;" placeholder="내용을 입력해주세요" required></textarea>
			</div>
			<input type="file" id="hiBbsFile" name="hiBbsFile" class="form-control mb-2" placeholder="파일을 선택하세요." required />
			<div class="form-group row">
				<div class="col-sm-12">
					<button type="button" id="btnWrite" class="btn btn-primary" title="저장">저장</button>
					<button type="button" id="btnList" class="btn btn-secondary" title="리스트">리스트</button>
					<button type="button" id="btnWrite2" class="btn btn-primary" title="저장">저장2</button>
				</div>
			</div>
		</form>
		<form name="bbsForm" id="bbsForm" method="post">
			<input type="hidden" name="searchType" value="${searchType}" /> 
			<input type="hidden" name="searchValue" value="${searchValue}" /> 
			<input type="hidden" name="curPage" value="${curPage}" />
		</form>
	</div>
</body>
</html>