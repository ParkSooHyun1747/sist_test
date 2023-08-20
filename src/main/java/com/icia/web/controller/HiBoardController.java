package com.icia.web.controller;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.icia.common.model.FileData;
import com.icia.common.util.FileUtil;
import com.icia.common.util.StringUtil;
import com.icia.web.model.HiBoard;
import com.icia.web.model.HiBoardFile;
import com.icia.web.model.Paging;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.service.HiBoardService;
import com.icia.web.service.UserService;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;

//컨트롤러는 비즈니스 로직 구현 전에 알고리즘 구현

@Controller("hiBoardController")
public class HiBoardController 
{
	private static Logger logger = LoggerFactory.getLogger(HiBoardController.class);
	
	//쿠키명 정의, auth.cookie.name이 env.xml의 auth.cookie.name과 동일해야 함
	@Value("#{env['auth.cookie.name']}") //값 가져와서
	private String AUTH_COOKIE_NAME; //여기에 대입
	
	//파일 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private HiBoardService hiBoardService;
	
	private static final int LIST_COUNT = 5; //한 페이지에 게시물 수
	private static final int PAGE_COUNT = 5; //페이징 수
	
	//게시판 리스트 매핑(리스트, 조회, 페이지번호)
	@RequestMapping(value = "/board/list")
	public String list(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		//조회항목(1:작성자, 2:제목, 3:내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		//페이지 번호 클릭했을때도 리스트 가져와야함
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//게시물 조회했을 때도 리스트 가져와야 함
		//게시물 리스트
		List<HiBoard> list = null;
		//리스트에서 하나씩 가져와서 객체에 담아줘여 함
		//조회 객체(HiBoard안에는 서치타입과 서치벨류가 있음)
		HiBoard search = new HiBoard();
		//총 게시물 수
		long totalCount = 0;
		//페이징 객체
		Paging paging = null;
		
		if(!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) 
		{
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}
		
//		//하드코딩 페이징 처리 아직 안해서(23.8.9)
//		search.setStartRow(1);
//		search.setEndRow(5);
		
		totalCount = hiBoardService.boadListCount(search);
		
		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");
		
		//토탈 카운트 0보다 클 때 조회
		if(totalCount > 0) 
		{
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			
			list = hiBoardService.boardList(search);
		}
		
		//리스트 먼저 조회
		list = hiBoardService.boardList(search);
		
		//다 담아주면 됨 그리고 페이징에 보낼거임
		model.addAttribute("list", list);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("paging", paging);
		
		return "/board/list";
	}
	
	//게시판 리스트2
	@RequestMapping(value = "/board/list2")
	public String list2(HttpServletRequest request, HttpServletResponse response) 
	{
		return "/board/list2";
	}
	
	//게시판 등록 폼(등록 폼을 가져가는 것이기 때문에 get, post 상관 없음)
	@RequestMapping(value = "/board/writeForm")
	public String writeForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		//쿠키값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//글쓰기 페이지에서 저장 버튼을 누르면 첫 페이지로 이동하고 리스트 페이지를 눌렀을 때는 전에 있던 해당 페이지로 이동해야 함
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		//사용자 정보 조회
		User user = userService.userSelect(cookieUserId);
		//뒤에 있는 유저는 현재 내가 사용할 객체를 가리킴(윗줄에 유저를 가리킴)
		model.addAttribute("user", user);
		//writeForm.jsp에서 써줘여 해서 modelMap에 세팅해야 함
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/writeForm";
	}
	
	//게시판 등록 폼(등록 폼을 가져가는 것이기 때문에 get, post 상관 없음)
	@RequestMapping(value = "/board/writeForm2")
	public String writeForm2(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		
		return "/board/writeForm2";
	}
	
	//게시물 등록
	@RequestMapping(value = "/board/writeProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc(MultipartHttpServletRequest request, HttpServletResponse response) //멀티파트폼데이터 때문에 매개변수도 달라짐
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String hiBbsTitle = HttpUtil.get(request, "hiBbsTitle", ""); //hiBbsTitle 없을 때 ""처리
		String hiBbsContent = HttpUtil.get(request, "hiBbsContent", "");
		FileData fileData = HttpUtil.getFile(request, "hiBbsFile", UPLOAD_SAVE_DIR);//hiBbsFile로 첨부파일 받아서(오리지널 파일 네임) 파일 업로드 경로에 UPLOAD_SAVE_DIR 찾아서...
		//getFile은 첨부파일이 있을 때 업로드 시키는 것, 테이블에 저장은 안된 상태
		
		//첨부파일은 필수 입력 아님, 제목과 내용만 필수 입력임
		if(!StringUtil.isEmpty(hiBbsTitle) && !StringUtil.isEmpty(hiBbsContent)) 
		{
			HiBoard hiBoard = new HiBoard();
			
			hiBoard.setUserId(cookieUserId);
			hiBoard.setHiBbsTitle(hiBbsTitle);
			hiBoard.setHiBbsContent(hiBbsContent);
			
			//첨부파일이 있는지 여부 확인, 첨부파일이 있는데 사이즈가 0인 경우가 있기 때문에 확인
			if(fileData != null && fileData.getFileSize() > 0) 
			{
				//첨부파일 있다면 생성
				HiBoardFile hiBoardFile = new HiBoardFile();
				
				hiBoardFile.setFileName(fileData.getFileName());
				hiBoardFile.setFileOrgName(fileData.getFileOrgName());
				hiBoardFile.setFileExt(fileData.getFileExt());
				hiBoardFile.setFileSize(fileData.getFileSize());
				
				hiBoard.setHiBoardFile(hiBoardFile); //hiBoardFile시작 주소값 세팅
			}
			
			//서비스 호출(try~catch로 감싸야 함)
			try 
			{
				// boardInsert가 throws Exception이고 나를 호출하는 쪽에서 try~catch문을 써야함
				if(hiBoardService.boardInsert(hiBoard) > 0) 
				{
					ajaxResponse.setResponse(0, "성공");
				}
				else 
				{
					ajaxResponse.setResponse(500, "insert 중 오류");
				}
			}
			catch (Exception e) 
			{
				logger.error("[HiBbsController] writeProc Exception", e);
				ajaxResponse.setResponse(500, "insert 중 오류");
			}
		}
		else 
		{
			ajaxResponse.setResponse(400, "입력값 잘못됨");
		}
		
		return ajaxResponse;
	}
	
	//게시물 등록2
	@RequestMapping(value="/board/writeProc2", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProc2(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String hiBbsTitle = HttpUtil.get(request, "hiBbsTitle");
		String hiBbsContent = HttpUtil.get(request, "hiBbsContent");
		FileData fileData = HttpUtil.getFile(request, hiBbsTitle, UPLOAD_SAVE_DIR);
		
		if(!StringUtil.isEmpty(hiBbsTitle) && !StringUtil.isEmpty(hiBbsContent)) 
		{
			HiBoard hiBoard = new HiBoard();
			
			hiBoard.setUserId(cookieUserId);
			hiBoard.setHiBbsTitle(hiBbsTitle);
			hiBoard.setHiBbsContent(hiBbsContent);
			
			if(fileData != null && fileData.getFileSize() > 0) 
			{
				HiBoardFile hiBoardFile = new HiBoardFile();
				
				hiBoardFile.setFileName(fileData.getFileName());
				hiBoardFile.setFileOrgName(fileData.getFileOrgName());
				hiBoardFile.setFileExt(fileData.getFileExt());
				hiBoardFile.setFileSize(fileData.getFileSize());
				
				hiBoard.setHiBoardFile(hiBoardFile);
			}
			
			try 
			{
				if(hiBoardService.boardInsert2(hiBoard) > 0) 
				{
					ajaxResponse.setResponse(0, "성공");
				}
				else 
				{
					ajaxResponse.setResponse(500, "인서트 중 오류");
				}
			}
			catch(Exception e) 
			{
				logger.error("[HiBbsController] writeProc2 Exception", e);
				ajaxResponse.setResponse(500, "인서트 중 오류");
			}
		}
		else 
		{
			ajaxResponse.setResponse(400, "입력 잘못됨");
		}
		
		return ajaxResponse;
	}
	
	//게시물 조회
	@RequestMapping(value="/board/view")
	public String view(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		//쿠키값 받음
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME); //AUTH_COOKIE_NAME라는 변수명 그대로 가져오기
		//게시물 번호 가져옴
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", (long)0); 
		//조회항목(1:작성자 ,2:제목 ,3:내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		//본인글 여부에 대한 변수명 별도로 두어서 이걸 써먹을 거임
		//본인글 여부
		String boardMe = "N"; //우리가 기존에 했던 jsp 파일은 하나로 통합되어 있고 이번에는  컨트롤러와 jsp가 분리되어 있기 때문에 변수를 생성해서 사용해야 함
		
		HiBoard hiBoard = null;
		
		//상세페이지 조회
		if(hiBbsSeq > 0) 
		{
			hiBoard = hiBoardService.boardView(hiBbsSeq);
			
			//보드가 존재하고 하이보드에서 받은 USER_ID와 cookieUserId를 비교 해야 내글인지 알 수 있음
			if(hiBoard != null && StringUtil.equals(hiBoard.getUserId(), cookieUserId)) 
			{
				boardMe = "Y";
			}
		}
		
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("hiBbsSeq", hiBbsSeq); //현재 게시글이 몇번인지에 대해 알아야 함
		model.addAttribute("hiBoard", hiBoard);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		
		return "/board/view";
	}
	
	//게시물 답변 화면
	@RequestMapping(value="/board/replyForm", method=RequestMethod.POST)
	public String replyForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//답변 화면에는 부모글에 대한 bbsSeq가 무조건 필요함
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", (long)0); //내 부모에 대한 메인글을 알아야 해서
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		//메인글에 대한 정보를 가져올 것임 답글은 메인글에 종속되는 관계이기 때문
		//따로 가져오는 이유
		HiBoard hiBoard = null;
		User user = null; //답글을 로그인한 사용자를 가져와야 해서 별도로 가져옴
		
		//다이렉트 대비
		if(hiBbsSeq > 0) 
		{
			hiBoard = hiBoardService.boardSelect(hiBbsSeq); //메인글에 대한 정보(네임, 이메일)
			
			if(hiBoard != null) 
			{
				user = userService.userSelect(cookieUserId); //답글은 로그인한 사용자 정보를 가져옴
			}
		}
		
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage); 
		model.addAttribute("hiBoard", hiBoard); //부모글에 대한 네임과 이메일
		model.addAttribute("user", user); //현재 로그인한 사용자 정보에 대한 네임과 이메일
		
		return "/board/replyForm";
	}
	
	//게시물 답변
	@RequestMapping(value = "/board/replyProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", (long)0);
		String hiBbsTitle = HttpUtil.get(request, "hiBbsTitle", "");
		String hiBbsContent = HttpUtil.get(request, "hiBbsContent", "");
		FileData fileData = HttpUtil.getFile(request, "hiBbsFile", UPLOAD_SAVE_DIR);
		
		if(hiBbsSeq > 0 && !StringUtil.isEmpty(hiBbsTitle) && !StringUtil.isEmpty(hiBbsContent)) 
		{
			//답변을 달기 위해 현재 부모글이 있는지 다시 한 번 확인
			//부모 글 가져옴
			HiBoard parentHiBoard = hiBoardService.boardSelect(hiBbsSeq);
			
			if(parentHiBoard != null) 
			{
				//부모 말고 답변 인서트 시킬 내 정보 가져옴                             
				HiBoard hiBoard = new HiBoard();
				
				hiBoard.setUserId(cookieUserId);
				hiBoard.setHiBbsTitle(hiBbsTitle);
				hiBoard.setHiBbsContent(hiBbsContent);
				hiBoard.setHiBbsGroup(parentHiBoard.getHiBbsGroup());
				hiBoard.setHiBbsOrder(parentHiBoard.getHiBbsOrder() + 1);
				hiBoard.setHiBbsIndent(parentHiBoard.getHiBbsIndent() + 1);
				hiBoard.setHiBbsParent(hiBbsSeq); //나의 부모에는 hiBbsSeq 들어와야 함
				
				//첨부파일 있으면
				if(fileData != null && fileData.getFileSize() > 0) 
				{
					HiBoardFile hiBoardFile = new HiBoardFile();
					
					hiBoardFile.setFileName(fileData.getFileName());
					hiBoardFile.setFileOrgName(fileData.getFileOrgName());
					hiBoardFile.setFileExt(fileData.getFileExt());
					hiBoardFile.setFileSize(fileData.getFileSize());
					
					hiBoard.setHiBoardFile(hiBoardFile);
				}
				
				//트랜잭션을 걸기 위해서(특정 범위내에서 다 끝내면 commit)
				try 
				{
					if(hiBoardService.boardReplyInsert(hiBoard) > 0)
					{
						ajaxResponse.setResponse(0, "성공");
					}
					else 
					{
						ajaxResponse.setResponse(500, "서버 오류222222");
					}
				}
				catch (Exception e) 
				{
					logger.error("[HiBoardController] replyProc Exception", e);
					ajaxResponse.setResponse(500, "서버 오류");
				}
			}
			else 
			{
				//부모글이 없을 때
				ajaxResponse.setResponse(404, "부모글 없네");
			}
		}
		//파라미터 값이 널로 들어왔을 때
		else 
		{
			ajaxResponse.setResponse(400, "파라미터 오류");
		}
		
		return ajaxResponse;
	}
	
	//수정페이지
	@RequestMapping(value="/board/updateForm")
	public String updateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		//쿠키값
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		//게시물 번호
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", (long)0);
		//조회항목
		String searchType = HttpUtil.get(request, "searchType", "");
		//조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		//현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long)1);
		
		HiBoard hiBoard = null;
		User user = null;
		
		//컨트롤러에서 서비스 하나를 호출하고 db에서 2개를 조인해서 조회
		
		//다이렉트 대비(hiBbsSeq의 디폴트가 0이기 때문에 아래 if절은 값이 넘어왔다는 의미)
		if(hiBbsSeq > 0) 
		{
			hiBoard = hiBoardService.boardViewUpdate(hiBbsSeq);
			
			if(hiBoard != null) 
			{
				//내 게시글인지 확인
				if(StringUtil.equals(hiBoard.getUserId(), cookieUserId)) 
				{
					//다시
					user = userService.userSelect(cookieUserId);
				}
				else 
				{
					//내 글이 아니면 업데이트 폼 안보여 줄거임
					hiBoard = null;
				}
			}
		}
		
		//jsp에 뿌려줘야 해서 modelMap에 담아야 함
		//jsp에서 사용할 이름, object라서 객체든 변수명이든 들어와도 됨
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage); 
		model.addAttribute("hiBoard", hiBoard);
		model.addAttribute("user", user);
		
		return "/board/updateForm";
	}
	
	//게시물 수정
	@RequestMapping(value="/board/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(MultipartHttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", (long)0);
		String hiBbsTitle = HttpUtil.get(request, "hiBbsTitle", "");
		String hiBbsContent = HttpUtil.get(request, "hiBbsContent", "");
		FileData fileData = HttpUtil.getFile(request, "hiBbsFile", UPLOAD_SAVE_DIR); //유효명 검사해서 업데이트해서 첨부파일 잇는지 확인하고 있다면 파일네임 존해하면 해당 경로에 가서 현재 파일 테이블에 들어있는 신규로 다른 이름으로 업로드
		
		//넘어온게 있냐
		if(hiBbsSeq > 0 && !StringUtil.isEmpty(hiBbsTitle) && !StringUtil.isEmpty(hiBbsContent)) 
		{
			//bbsseq값이 해당 글의 번호가 맞는지 확인
			HiBoard hiBoard = hiBoardService.boardSelect(hiBbsSeq);
			
			//게시글이 있냐
			if(hiBoard != null) 
			{
				//수정할려면 글이 내글인지 다시 확인, 다이렉트 대비
				if(StringUtil.equals(hiBoard.getUserId(), cookieUserId)) 
				{
					//db에 있던 값(기존에 입력되어 있던 게시판 내용)을 새로 입력한 값으로 바꿀거임
					hiBoard.setHiBbsTitle(hiBbsTitle);
					hiBoard.setHiBbsContent(hiBbsContent);
					
					//제목과 내용을 집어 넣었다면 첨부파일 확인
					if(fileData != null && fileData.getFileSize() > 0) 
					{
						//참일때만 객체 생성
						HiBoardFile hiBoardFile = new HiBoardFile();
						//업데이트 하기 위한 작업
						hiBoardFile.setFileName(fileData.getFileName());
						hiBoardFile.setFileOrgName(fileData.getFileOrgName());
						hiBoardFile.setFileExt(fileData.getFileExt());
						hiBoardFile.setFileSize(fileData.getFileSize());
						
						//주소값을 바라보게 함
						hiBoard.setHiBoardFile(hiBoardFile);
					}
					
					//컨트롤러에서 try~catch문이 있다는 것은 서비스에서 트랜잭션 처리가 되었다는 의미
					try 
					{
						if(hiBoardService.boardUpdate(hiBoard) > 0) 
						{
							ajaxResponse.setResponse(0, "성공");
						}
						else 
						{
							ajaxResponse.setResponse(500, "서버 오류222");
						}
					}
					catch(Exception e) 
					{
						logger.error("[HiBoardController] updateProc Exception", e);
						ajaxResponse.setResponse(500, "서버 오류111");
					}
				}
				else 
				{
					ajaxResponse.setResponse(403, "아이디가 다름");
				}
			}
			else 
			{
				ajaxResponse.setResponse(404, "찾을 수 없음");
			}
		}
		else 
		{
			ajaxResponse.setResponse(400, "파리미터(매개변수) 잘못됨");
		}
		
		return ajaxResponse;
	}
	
	//게시물 삭제
	@RequestMapping(value="/board/delete", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", (long)0);
		
		if(hiBbsSeq > 0) 
		{
			HiBoard hiBoard = hiBoardService.boardSelect(hiBbsSeq);
			
			//게시물 존재하냐
			if(hiBoard != null) 
			{
				//다시 한 번 해당 게시글이 내글인지 다시 확인
				if(StringUtil.equals(hiBoard.getUserId(), cookieUserId)) 
				{
					//하이보드 테이블과 하이보드파일 테이블 같이 삭제해줘야 하는데 둘 중 하나라도 삭제 안되면 롤백 둘 다 성고하면 커밋, 때문에 트랜잭션 처리가 됨
					try 
					{
						//답글 여부를 확인
						if(hiBoardService.boardAnswersCount(hiBoard.getHiBbsSeq()) > 0) 
						{
							//답글이 있으면 삭제 못하도록
							ajaxResponse.setResponse(-999, "답글이 달려있는 메인글은 삭제가 되지 못하게 막을거임");
						}
						//메인글에 답변이 없다면
						else
						{
							//서비스에서 두가지를 묶음
							//보드 딜리트 메서드 호출
							if(hiBoardService.boardDelete(hiBbsSeq) > 0) 
							{
								ajaxResponse.setResponse(0, "삭제 성공");
							}
							else 
							{
								ajaxResponse.setResponse(500, "서버 오류222");
							}
						}
					}
					catch(Exception e) 
					{
						logger.error("[HiBoardController] delete Exception", e);
						ajaxResponse.setResponse(500, "서버 오류111");
					}
				}
				//내 게시글 아님
				else 
				{
					ajaxResponse.setResponse(403, "내 게시물 아님");
				}
			}
			//게시물이 존재하지 않음
			else 
			{
				ajaxResponse.setResponse(404, "게시물 없음");
			}
		}
		//response가 안넘어오면 
		else 
		{
			ajaxResponse.setResponse(400, "매개변수 잘못됨");
		}
		
		return ajaxResponse;
	}
	
	//첨부파일 다운로드
	@RequestMapping(value = "/board/download")
	public ModelAndView download(HttpServletRequest request, HttpServletResponse response) 
	{
		ModelAndView modelAndView = null;
		
		long hiBbsSeq = HttpUtil.get(request, "hiBbsSeq", (long)0);
		
		//넘어옴
		if(hiBbsSeq > 0) 
		{
			//첨부파일이라서 파일만 받으면 됨
			HiBoardFile hiBoardFile = hiBoardService.boardFileSelect(hiBbsSeq);
			
			//첨부파일 있다면
			if(hiBoardFile != null) 
			{
				File file = new File(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + hiBoardFile.getFileName());
				
				//디버깅용
				logger.debug("================================================");
				logger.debug("UPLOAD_SAVE_DIR : " + UPLOAD_SAVE_DIR);
				logger.debug("FileUtil.getFileSeparator() : " + FileUtil.getFileSeparator());
				logger.debug("hiBoardFile.getFileName() : " + hiBoardFile.getFileName());
				logger.debug("hiBoardFile.getFileOrgName() : " + hiBoardFile.getFileOrgName());				logger.debug("================================================");
				
				//해당 파일 존재하는지 확인
				if(FileUtil.isFile(file)) 
				{
					modelAndView = new ModelAndView();
					
					//응답할 뷰 설정(servlet-context.xml에 정의한 FileDownloadView id)
					//뷰 네임 정의
					modelAndView.setViewName("fileDownloadView");
					//필요한거 세팅
					modelAndView.addObject("file", file);
					modelAndView.addObject("fileName", hiBoardFile.getFileOrgName());
					
					return modelAndView;
				}
			}
		}
		
		return modelAndView;
	}
}
