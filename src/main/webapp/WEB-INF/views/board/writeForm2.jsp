<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
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

@media ( min-width : 768px) and (max-width: 991.98px) {
	.search-body .search-filters {
		display: flex;
	}
	.search-body .search-filters .filter-list {
		margin-right: 1rem;
	}
}

.card-margin {
	margin-bottom: 1.875rem;
}

@media ( min-width : 992px) {
	.col-lg-2 {
		flex: 0 0 16.66667%;
		max-width: 16.66667%;
	}
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

		$("#hiBbsTitle").focus();

		$("#btnWrite").on("click", function() {
			//ajax 통신 끝나기 전까지 글쓰기 버튼 비활성화 처리
			$("#btnWrite").prop("disabled", true);

			if ($.trim($("#hiBbsTitle").val()).length <= 0) {
				alert("제목을 입력하세요.");
				$("#hiBbsTitle").val("");
				$("#hiBbsTitle").focus();

				//글쓰기 버튼 활성화 처리
				$("#btnWrite").prop("disabled", false);

				return;
			}

			if ($.trim($("#hiBbsContent").val()).length <= 0) {
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
				beforeSend : function(xhr) { // AJAX 요청이 전송되기 전에 실행. 이 경우 AJAX 헤더를 설정
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					if (response.code == 0) {
						alert("게시물이 등록되었습니다.");
						location.href = "/board/list";

						/*
						폼을 날리고 싶다면 
						document.bbsForm.action = "/board/list";
						document.bbsForm.submit();
						 */
					} else if (response.code == 400) {
						alert("파라미터 값이 올바르지 않습니다.");
						$("#hiBbsTitle").focus();
						//글쓰기 버튼 활성화
						$("#btnWrite").prop("disabled", false);
					} else //500번 포함 다른 오류들
					{
						alert("게시물 등록 중 오류 발생");
						$("#hiBbsTitle").focus();
						//글쓰기 버튼 활성화
						$("#btnWrite").prop("disabled", false);
					}
				},
				error : function(error) {
					icia.common.error(error);
					alert("게시물 등록 중 오류가 발생하였습니다.");
					$("#btnWrite").prop("disabled", false);
				},
			});
		});

		$("#btnWrite2").on("click", function() {
			$("#btnWrite2").prop("disabled", true)

			if ($.trim($("#hiBbsTitle").val()).length <= 0) {
				alert("제목을 입력하세요");
				$("#hiBbsTitle").val("");
				$("#hiBbsTitle").focus();

				$("#btnWrite2").prop("disabled", false);

				return;
			}

			if ($.trim($("#hiBbsContent").val()).length <= 0) {
				alert("내용을 입력하세요.");
				$("#hiBbsContent").val("");
				$("#hiBbsContent").focus();

				$("#btnWrite2").prop("disabled", false);

				return;
			}

			var form = $("#writeForm")[0];
			var formData = new FormData(form);

			$.ajax({
				type : "POST",
				enctype : "multipart/form-data",
				url : "/board/writeProc2",
				data : formData,
				processData : false,
				contentType : false,
				cache : false,
				timeout : 6000,
				success : function(response) {
					if (response.code == 0) {
						alert("게시물 등록 성공");
						location.href = "/board/list";
					} else if (response.code == 400) {
						alert("게시물 입력이 잘못됐습니다.");
						$("#hiBbsTitle").focus();

						$("#btnWrite2").prop("disabled", false);
					} else {
						alert("게시물 등록 중 오류 발생했습니다.");
						$("#hiBbsTitle").focus();

						$("#btnWrite2").prop("disabled", false);
					}
				},
				error : function(error) {
					icia.common.error(error);
					alert("게시물 등록 중 오류가 발생했다리.");
					$("#btnWrite2").prop("disabled", false);
				}
			});
		});

		$("#btnList").on("click", function() {

		});
	});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<div class="container">
		<div class="row">
			<div class="col-12">
				<div class="card card-margin">
					<div class="card-body">
						<h2>게시물 쓰기</h2>
						<form name="writeForm" id="writeForm"
							action="/board/writeProc0724.jsp" method="post">
							<input type="text" name="bbsId" id="bbsId" maxlength="20"
								value="" style="ime-mode: active;"
								class="form-control mt-4 mb-2" placeholder="아이디를 입력해주세요."
								readonly /> <input type="text" name="bbsTitle" id="bbsTitle"
								maxlength="100" style="ime-mode: active;"
								class="form-control mb-2" placeholder="제목을 입력해주세요." required />
							<div class="form-group">
								<select name="writeCategory" id="writeCategory"
									class="custom-select" style="width: 100%;">
									<option value="">카테고리</option>
									<option value="1">상품문의</option>
									<option value="2">배송문의</option>
									<option value="3">교환문의</option>
									<option value="4">환불문의</option>
								</select>
							</div>
							<div class="form-group">
								<textarea class="form-control" rows="10" name="bbsContent"
									id="bbsContent" style="ime-mode: active;"
									placeholder="내용을 입력해주세요" required></textarea>
							</div>
							<div class="form-group row">
								<div class="col-sm-12">
									<button type="button" id="btnWrite" class="btn btn-primary"
										title="저장">저장</button>
									<button type="button" id="btnList" class="btn btn-secondary"
										title="리스트">리스트</button>
								</div>
							</div>
						</form>
						<!-- 화면에 보이지 않으면서 해당 페이지에 결과값을 보여줌, 리스트 버튼을 눌렀을 때 적용되어 있어야 하는 것들 -->
						<form name="bbsForm" id="bbsForm" method="post">
							<input type="hidden" name="searchType" value="" /> <input
								type="hidden" name="searchValue" value="" /> <input
								type="hidden" name="curPage" value="" />
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>