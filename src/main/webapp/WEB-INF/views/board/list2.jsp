<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
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
	
	.search-form {
		width: 80%;
		margin: 0 auto;
		margin-top: 1rem;
	}
	
	.search-form input {
		height: 100%;
		background: transparent;
		border: 0;
		display: block;
		width: 100%;
		padding: 1rem;
		height: 100%;
		font-size: 1rem;
	}
	
	.search-form select {
		background: transparent;
		border: 0;
		padding: 1rem;
		height: 100%;
		font-size: 1rem;
	}
	
	.search-form select:focus {
		border: 0;
	}
	
	.search-form button {
		height: 100%;
		width: 100%;
		font-size: 1rem;
	}
	
	.search-form button svg {
		width: 24px;
		height: 24px;
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
	.link-secondary {
		color: white !important;
	}
</style>
<script type="text/javascript">
	$(document).ready(function() {

		$("#btnWrite").on("click", function() {
			document.bbsForm.hiBbsSeq.value = ""; //1.값을 가지고
			document.bbsForm.action = "/board/writeForm" //2.서버에 가져감, 컨트롤러
			document.bbsForm.submit();
		});

		$("#btnSearch").on("click", function() {

		});
	});

	function fn_view(bbsSeq) {

	}

	function fn_list(curPage) {

	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation2.jsp"%>
	<div class="container">
		<div class="row">
			<!--  -->
			<div class="col-lg-12 card-margin">
				<div class="card search-form">
					<div class="card-body p-0">
						<!---->
						<form id="search-form">
							<div class="row">
								<div class="col-12">
									<div class="row no-gutters">
										<div class="col-lg-3 col-md-3 col-sm-12 p-0">
											<select class="form-control" name="_searchType"
												id="_searchType">
												<option value="">조회 항목</option>
												<option value="1">아이디</option>
												<option value="2">제목</option>
												<option value="3">내용</option>
											</select>
										</div>
										<div class="col-lg-8 col-md-6 col-sm-12 p-0">
											<input type="text" placeholder="Search..." class="form-control" name="_searchValue" id="_searchValue" value="">
										</div>
										<div class="col-lg-1 col-md-3 col-sm-12 p-0">
											<button type="button" id="btnSearch" class="btn btn-base">
												<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-search">
                                       				<circle cx="11" cy="11" r="8"></circle>
                                       				<line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                                       			</svg>
											</button>
										</div>
									</div>
								</div>
							</div>
						</form>
						<!-- -->
					</div>
				</div>
			</div>
			<!-- -->
		</div>
		<!---->
		<div class="row">
			<div class="col-12">
				<div class="card card-margin">
					<div class="card-body">
						<!--  -->
						<table class="table table-hover">
							<thead>
								<tr>
									<th scope="col" class="text-center" style="width: 10%">번호</th>
									<th scope="col" class="text-center" style="width: 45%">제목</th>
									<th scope="col" class="text-center" style="width: 10%">작성자</th>
									<th scope="col" class="text-center" style="width: 25%">날짜</th>
									<th scope="col" class="text-center" style="width: 10%">조회수</th>
								</tr>
							</thead>
							<tbody>

								<tr>
									<td class="text-center">1</td>

									<td><a href="javascript:void(0)" onclick="fn_view(1)">
											게시판 제목 </a></td>
									<td class="text-center">작성자</td>
									<td class="text-center">2023.08.04 09:52:22</td>
									<td class="text-center">0</td>
								</tr>

							</tbody>
							<tfoot>
								<tr>
									<td colspan="5"></td>
								</tr>
							</tfoot>
						</table>
						<nav>
							<ul class="pagination justify-content-center">
								<li class="page-item"><a class="page-link"
									href="javascript:void(0)" onclick="fn_list(1)">이전블럭</a></li>
								<li class="page-item"><a class="page-link"
									href="javascript:void(0)" onclick="fn_list(1)">1</a></li>
								<li class="page-item active"><a class="page-link"
									href="javascript:void(0)" style="cursor: default;">2</a></li>
								<li class="page-item"><a class="page-link"
									href="javascript:void(0)" onclick="fn_list(3)">다음블럭</a></li>
							</ul>
						</nav>

						<button type="button" id="btnWrite" class="btn btn-secondary mb-3">글쓰기</button>

						<form name="bbsForm" id="bbsForm" method="post">
							<input type="hidden" name="hiBbsSeq" value="" /> <input
								type="hidden" name="searchType" value="" /> <input
								type="hidden" name="searchValue" value="" /> <input
								type="hidden" name="curPage" value="" />
						</form>
					</div>
					<!--  -->
  				</div>
   			</div>
   		</div>
   </div>
  <!-- -->
</body>
</html>