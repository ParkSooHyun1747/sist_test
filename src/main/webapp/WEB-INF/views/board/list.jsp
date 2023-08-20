<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {

		//글쓰기 버튼
		$("#btnWrite").on("click", function() {
			document.bbsForm.hiBbsSeq.value = ""; //1.값을 가지고
			document.bbsForm.action = "/board/writeForm" //2.서버에 가져감, 컨트롤러
			document.bbsForm.submit();
		});

		//조회 버튼
		$("#btnSearch").on("click", function() {
			document.bbsForm.hiBbsSeq.vlaue = "";
			document.bbsForm.searchType.value = $("#_searchType").val();
			document.bbsForm.searchValue.value = $("#_searchValue").val();
			document.bbsForm.curPage.value = "1";
			document.bbsForm.action = "/board/list";
			document.bbsForm.submit();
		});
	});

	function fn_view(bbsSeq) 
	{
		document.bbsForm.hiBbsSeq.value = bbsSeq;
		document.bbsForm.action = "/board/view";
		document.bbsForm.submit();
	}

	function fn_list(curPage) //2.페이지 버튼 클릭 이동
	{
		document.bbsForm.hiBbsSeq.value = "";
		document.bbsForm.curPage.value = curPage;
		document.bbsForm.action = "/board/list";
		document.bbsForm.submit();
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<div class="container">
		<div class="d-flex">
			<div style="width: 50%;">
				<h2>게시판</h2>
			</div>
			<div class="ml-auto input-group" style="width: 50%;">
				<select name="_searchType" id="_searchType" class="custom-select" style="width: auto;">
					<option value="">조회 항목</option>
					<option value="1" <c:if test='${searchType eq "1"}' >selected</c:if> >작성자</option>
					<option value="2" <c:if test='${searchType eq "2"}' >selected</c:if> >제목</option>
					<option value="3" <c:if test='${searchType eq "3"}' >selected</c:if> >내용</option>
				</select> 
				<input type="text" name="_searchValue" id="_searchValue" value="${searchValue}" class="form-control mx-1" maxlength="20" style="width: auto; ime-mode: active;" placeholder="조회값을 입력하세요." />
				<button type="button" id="btnSearch" class="btn btn-secondary mb-3 mx-1">조회</button>
			</div>
		</div>

		<table class="table table-hover">
			<thead>
				<tr style="background-color: #dee2e6;">
					<th scope="col" class="text-center" style="width: 10%">번호</th>
					<th scope="col" class="text-center" style="width: 55%">제목</th>
					<th scope="col" class="text-center" style="width: 10%">작성자</th>
					<th scope="col" class="text-center" style="width: 15%">날짜</th>
					<th scope="col" class="text-center" style="width: 10%">조회수</th>
				</tr>
			</thead>
			<tbody>
				<!-- 하나의 row -->
				<!-- 데이터가 있을 때만 보임 -->
				<c:if test="${!empty list}">
					<c:forEach var="hiBoard" items="${list}" varStatus="status">
						<tr>
							<c:choose>
								<c:when test = "${hiBoard.hiBbsIndent eq 0}">
									<td class="text-center">${hiBoard.hiBbsSeq}</td> <!-- 인덴트 0일때 -->
								</c:when>
								
								<c:otherwise>
									<td class="text-center"></td>
								</c:otherwise>
							</c:choose>
							<td>														
								<a href="javascript:void(0)" onclick="fn_view(${hiBoard.hiBbsSeq})"> 
									<c:if test="${hiBoard.hiBbsIndent > 0}">
										<img src="/resources/images/icon_reply.gif" style="margin-left:${hiBoard.hiBbsIndent}em"/>
									</c:if>
									<c:out value="${hiBoard.hiBbsTitle}"/> 
								</a>																
							</td>
							<td class="text-center">${hiBoard.userName}</td>
							<td class="text-center">${hiBoard.regDate}</td>
							<td class="text-center"> 
								<fmt:formatNumber type="number" maxFractionDigits="3" value="${hiBoard.hiBbsReadCnt}"/> 
							</td>
						</tr>
					</c:forEach>
				</c:if>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="5"></td>
				</tr>
			</tfoot>
		</table>
		<nav>
			<ul class="pagination justify-content-center">
				<c:if test="${!empty paging}">
				
					<!-- 0보다 크냐 -->
					<c:if test="${paging.prevBlockPage gt 0}">
						<li class="page-item">
							<a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.prevBlockPage})">이전블럭</a>
						</li>
					</c:if>
					
					<!-- c:forEach : for문 -->
					<!-- c:choose : switch문가 똑같음 -->
					<c:forEach var = "i" begin = "${paging.startPage}" end = "${paging.endPage}">
						<c:choose> 
							<c:when test="${i ne curPage}"> <!-- case와 같음 -->
							<!-- i가 현재 페이지와 같지 않을 때 -->
								<li class="page-item"> <!-- 현재 페이지가 아닐 때 -->
									<a class="page-link" href="javascript:void(0)" onclick="fn_list(${i})">${i}</a>
								</li>
							</c:when>
							<c:otherwise> <!-- switch문의 defalut와 같은 역할 -->
							<!-- otherwise는 초이스태그 안에 들어가면 default문 같은 역할을 하게 된다. -->
    						<!-- 그러니까 위의 초이스태그 안에 구문이 실행이되면 기본으로 나오게 되는 코드가 아래에 있다고 생각하면 된다. -->
								<li class="page-item active"> <!-- 현재 페이지일 때 -->
									<a class="page-link" href="javascript:void(0)" style="cursor: default;">${i}</a>
								</li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					
					<!-- 0보다 크냐 -->
					<c:if test="${paging.nextBlockPage gt 0}">
						<li class="page-item">
							<a class="page-link" href="javascript:void(0)" onclick="fn_list(${paging.nextBlockPage})">다음블럭</a>
						</li>
					</c:if>
				</c:if>
			</ul>
		</nav>

		<button type="button" id="btnWrite" class="btn btn-secondary mb-3">글쓰기</button>

		<form name="bbsForm" id="bbsForm" method="post">
			<input type="hidden" name="hiBbsSeq" value="" /> 
			<input type="hidden" name="searchType" value="${searchType}" /> 
			<input type="hidden" name="searchValue" value="${searchValue}" /> 
			<input type="hidden" name="curPage" value="${curPage}" />
			<!-- 1.여기서 현재 페이지 번호를 입력받음, 기본값은 1임 -->
		</form>
	</div>
</body>
</html>