package com.icia.web.model;

import java.io.Serializable;

public class HiBoard implements Serializable
{
	private static final long serialVersionUID = 1L;

	private long hiBbsSeq;			//게시물 번호
	private String userId;			//사용자 아이디
	private long hiBbsGroup;		//게시물 그룹 번호
	private int hiBbsOrder;			//게시물 그룹 내 순서
	private int hiBbsIndent;		//게시물 들여쓰기
	private String hiBbsTitle;		//게시물 제목
	private String hiBbsContent;	//게시물 내용
	private int hiBbsReadCnt;		//게시물 조회수
	private long hiBbsParent;		//부모 게시물 번호
	private String regDate;			//등록일
	
	//첨부파일 화면에 보여줄때 사용자 이름과 이메일 같이 가져갈 것임
	private String userName;
	private String userEmail;
	
	private long startRow;			//시작 rownum
	private long endRow;			//끝 rownum
	
	private String searchType;		//검색타입(1:이름, 2:제목, 3:내용)
	private String searchValue;		//검색값
	
	//HiBoardFile 객체 선언할 것임
	private HiBoardFile hiBoardFile; //첨부파일
	
	public HiBoard() 
	{
		hiBbsSeq = 0;
		userId = "";
		hiBbsGroup = 0;
		hiBbsOrder = 0;
		hiBbsIndent = 0;
		hiBbsTitle = "";
		hiBbsContent = "";
		hiBbsReadCnt = 0;
		hiBbsParent = 0;
		regDate = "";
		
		userName = "";
		userEmail = "";
		
		startRow = 0;
		endRow = 0;
		
		searchType = "";
		searchValue = "";
		
		//객체이기 때문에 default로 null
		hiBoardFile = null;
	}

	public long getHiBbsSeq() {
		return hiBbsSeq;
	}

	public void setHiBbsSeq(long hiBbsSeq) {
		this.hiBbsSeq = hiBbsSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getHiBbsGroup() {
		return hiBbsGroup;
	}

	public void setHiBbsGroup(long hiBbsGroup) {
		this.hiBbsGroup = hiBbsGroup;
	}

	public int getHiBbsOrder() {
		return hiBbsOrder;
	}

	public void setHiBbsOrder(int hiBbsOrder) {
		this.hiBbsOrder = hiBbsOrder;
	}

	public int getHiBbsIndent() {
		return hiBbsIndent;
	}

	public void setHiBbsIndent(int hiBbsIndent) {
		this.hiBbsIndent = hiBbsIndent;
	}

	public String getHiBbsTitle() {
		return hiBbsTitle;
	}

	public void setHiBbsTitle(String hiBbsTitle) {
		this.hiBbsTitle = hiBbsTitle;
	}

	public String getHiBbsContent() {
		return hiBbsContent;
	}

	public void setHiBbsContent(String hiBbsContent) {
		this.hiBbsContent = hiBbsContent;
	}

	public int getHiBbsReadCnt() {
		return hiBbsReadCnt;
	}

	public void setHiBbsReadCnt(int hiBbsReadCnt) {
		this.hiBbsReadCnt = hiBbsReadCnt;
	}

	public long getHiBbsParent() {
		return hiBbsParent;
	}

	public void setHiBbsParent(long hiBbsParent) {
		this.hiBbsParent = hiBbsParent;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public HiBoardFile getHiBoardFile() {
		return hiBoardFile;
	}

	public void setHiBoardFile(HiBoardFile hiBoardFile) {
		this.hiBoardFile = hiBoardFile;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}
}
