/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.controller
 * 파일명     : UserController.java
 * 작성일     : 2021. 1. 20.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.controller;

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

import com.google.gson.JsonObject;
import com.icia.common.util.StringUtil;
import com.icia.web.model.Response;
import com.icia.web.model.User;
import com.icia.web.model.User2;
import com.icia.web.service.UserService;
import com.icia.web.service.UserService2;
import com.icia.web.util.CookieUtil;
import com.icia.web.util.HttpUtil;
import com.icia.web.util.JsonUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.controller
 * 파일명     : UserController.java
 * 작성일     : 2021. 1. 20.
 * 작성자     : daekk
 * 설명       : 사용자 컨트롤러
 * </pre>
 */
@Controller("userController")
public class UserController
{
	private static Logger logger = LoggerFactory.getLogger(UserController.class);
	
	// 쿠키명
	//@Value는 스프링에 대한 값을 가져오는 것
	@Value("#{env['auth.cookie.name']}") //1.auth.cookie.name값을 세팅해서
	private String AUTH_COOKIE_NAME; //2.세팅한 값 읽어와?
	
	//@Autowired는 new
	@Autowired
	private UserService userService;
	@Autowired
	private UserService2 userService2;
	
	/**
	 * <pre>
	 * 메소드명   : login
	 * 작성일     : 2021. 1. 21.
	 * 작성자     : daekk
	 * 설명       : 로그인 
	 * </pre>
	 * @param request  HttpServletRequest
	 * @param response HttpServletResponse
	 * @return Response<Object>
	 */
	//로그인
	@RequestMapping(value="/user/login", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> login(HttpServletRequest request, HttpServletResponse response)
	{
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		Response<Object> ajaxResponse = new Response<Object>();
		
		//아이디나 비번이 공백으로 들어옴
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
		{
			User user = userService.userSelect(userId);
			
			if(user != null)
			{
				//비밀번호 같을 때
				if(StringUtil.equals(user.getUserPwd(), userPwd))
				{
					CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
					
					ajaxResponse.setResponse(0, "Success"); // 로그인 성공
				}
				//비밀번호 다름
				else
				{
					ajaxResponse.setResponse(-1, "Passwords do not match"); // 비밀번호 불일치
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found"); // 사용자 정보 없음 (Not Found)
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request"); // 파라미터가 올바르지 않음 (Bad Request)
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/login response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//로그인2
	@RequestMapping(value="/user/login2", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> login2(HttpServletRequest request, HttpServletResponse response)
	{
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		Response<Object> ajaxResponse = new Response<Object>();
		
		//아이디나 비번이 공백으로 들어옴
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd))
		{
			User2 user = userService2.userSelect2(userId);
			
			if(user != null)
			{
				//비밀번호 같을 때
				if(StringUtil.equals(user.getUserPwd(), userPwd))
				{
					CookieUtil.addCookie(response, "/", -1, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
					
					ajaxResponse.setResponse(0, "Success"); // 로그인 성공
				}
				//비밀번호 다름
				else
				{
					ajaxResponse.setResponse(-1, "Passwords do not match"); // 비밀번호 불일치
				}
			}
			else
			{
				ajaxResponse.setResponse(404, "Not Found"); // 사용자 정보 없음 (Not Found)
			}
		}
		else
		{
			ajaxResponse.setResponse(400, "Bad Request"); // 파라미터가 올바르지 않음 (Bad Request)
		}
		
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/login response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//로그아웃
	@RequestMapping(value="/user/loginOut", method=RequestMethod.GET)
	public String loginOut(HttpServletRequest request, HttpServletResponse response) 
	{
		//리퀘스트 객체에 쿠키가 있는지 여부 판단 후 있으면 쿠키 삭제
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) 
		{
			//값이 있으면 쿠키를 삭제
			CookieUtil.deleteCookie(request, response, "/" , AUTH_COOKIE_NAME);
		}
		
		//서버에서 재접속하라는 명령(URL을 다시 가리킴)
		//리턴타입이 스트링이라서 뷰리졸버를 호출해야 하지만 그러지 말고 다시 재접속하라는 의미
		//클라이언트로 안가고 서버단에서 메인페이지로 다시 접속하라는 의미
		return "redirect:/";
	}
	
	//로그아웃2
	@RequestMapping(value="/user/loginOut2", method=RequestMethod.GET)
	public String loginOut2(HttpServletRequest request, HttpServletResponse response) 
	{
		//리퀘스트 객체에 쿠키가 있는지 여부 판단 후 있으면 쿠키 삭제
		if(CookieUtil.getCookie(request, AUTH_COOKIE_NAME) != null) 
		{
			//값이 있으면 쿠키를 삭제
			CookieUtil.deleteCookie(request, response, "/" , AUTH_COOKIE_NAME);
		}
		
		//서버에서 재접속하라는 명령(URL을 다시 가리킴)
		//리턴타입이 스트링이라서 뷰리졸버를 호출해야 하지만 그러지 말고 다시 재접속하라는 의미
		//클라이언트로 안가고 서버단에서 메인페이지로 다시 접속하라는 의미
		return "redirect:/index2";
	}
	
	//회원가입(리턴은 jsp 파일이어야 해서 리턴 타입이 스트링임)
	@RequestMapping(value="/user/regForm", method=RequestMethod.GET)
	public String regForm(HttpServletRequest request, HttpServletResponse response) 
	{
		String cookieUserId = CookieUtil.getHexValue(request, "/" ,AUTH_COOKIE_NAME);
		
		//다이렉트 대비
		//쿠키가 있다면(로그인 되어있음) 쿠키를 날리고 인덱스 페이지로 넘김(메인페이지)
		if(!StringUtil.isEmpty(cookieUserId))
		{
			CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
			return "redirect:/";
		}
		//쿠키가 없다면 회원가입 페이지로
		else 
		{
			return "/user/regForm"; //views파일 밑에 user 생성(뷰 리졸버에서 확인 가능)
		}
	}
	
	//회원가입2
	@RequestMapping(value="/user/regForm2", method=RequestMethod.GET)
	public String regForm2(HttpServletRequest request, HttpServletResponse response) 
	{
		String cookieUserId = CookieUtil.getHexValue(request, "/", AUTH_COOKIE_NAME);
		
		if(!StringUtil.isEmpty(cookieUserId)) 
		{
			CookieUtil.deleteCookie(request, response, AUTH_COOKIE_NAME);
			return "redirect:/index2";
		}
		else 
		{
			return "/user/regForm2";
		}
	}
	
	//아이디 중복 체크
	//뷰를 띄울 필요가 없다면 리턴타입은 Response 객체로, 뷰를 띄울것이라면 String으로!
	@RequestMapping(value="/user/idCheck", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response) 
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String userId = HttpUtil.get(request, "userId");
		
		//아이디값 넘어옴 그러면 서비스 호출해야 함
		if(!StringUtil.isEmpty(userId)) 
		{
			//중복 아이디 발생 안했다면 사용가능한 아이디
			if(userService.userSelect(userId) == null) 
			{
				ajaxResponse.setResponse(0, "아이디 사용 가능");
			}
			//중복 아이디 발생
			else 
			{
				ajaxResponse.setResponse(100, "100번 오류: 중복 아이디 발생");
			}
		}
		else 
		{
			ajaxResponse.setResponse(400, "400번 오류:매개변수 잘못됨");
		}
		
		//디버깅용
		if(logger.isErrorEnabled()) 
		{
			logger.debug("[UserDao]/user/idCheck response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		
		return ajaxResponse;
	}
	
	//회원등록(가입)(ajax통신 통해서 진행)
	@RequestMapping(value="/user/regProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> regProc(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		//사용자 페이지에서 넘겨준 값을 받아야함
		//userId부터 이메일까지 쭉 받음
		String userId = HttpUtil.get(request, "userId");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		
		//필수입력에 대한 값은 이미 화면에서 다 확인하지만 다시 확인
		//다 입력받았다면
		if(!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) 
		{
			//다이렉트 대비하여 중복 아이디가 있는지 확인
			//중복아이디가 없을 경우 정상적으로 등록
			if(userService.userSelect(userId) == null) 
			{
				//인서트할 때 유저 객체 넘겨야 함
				//user 객체 선언
				User user = new User();
				
				//매개변수 받은거 다 세팅해야 함
				user.setUserId(userId);
				user.setUserPwd(userPwd);
				user.setUserName(userName);
				user.setUserEmail(userEmail);
				user.setStatus("Y");
				
				//서비스 메서드 호출
				if(userService.userInsert(user) > 0) 
				{
					ajaxResponse.setResponse(0, "정상, 성공");
				}
				else 
				{
					ajaxResponse.setResponse(500, "insert 오류");
				}
			}
			//중복 아이디가 있는 경우
			else 
			{
				ajaxResponse.setResponse(100, "중복 아이디 발생");
			}
		}
		//null값이 하나라도 있으면 파라미터 오류
		else 
		{
			ajaxResponse.setResponse(400, "파라미터 오류"); //써먹고 있지는 않지만 콘솔에 찍는 용도
		}
		
		//디버깅용
		if(logger.isErrorEnabled()) 
		{
			logger.debug("[UserDao]/user/regProc response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
	//아이디 중복 체크
	@RequestMapping(value="/user/idCheck2", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> idCheck2(HttpServletRequest request, HttpServletResponse response)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		String userId = HttpUtil.get(request, "userId");
		
		if(!StringUtil.isEmpty(userId)) 
		{
			if(userService2.userSelect2(userId) == null) 
			{
				ajaxResponse.setResponse(0, "아이디 사용 가능");
			}
			else 
			{
				ajaxResponse.setResponse(400, "아이디 중복 발생");
			}
		}
		else 
		{
			ajaxResponse.setResponse(500, "아이디 안넘어옴");
		}
		
		return ajaxResponse;
	}
	
	//회원 정보 수정 화면
	@RequestMapping(value="/user/updateForm", method=RequestMethod.GET)
	public String updateForm(ModelMap model, HttpServletRequest request, HttpServletResponse response) 
	{
		//바로 쿠키 읽어와서 id값 가지고 유저 테이블 셀렉트해서 modelmap으로 데이터 가져와서 user객체로 접근
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		
		User user = userService.userSelect(cookieUserId);
		
		//첫번째 인수는 jsp에서 사용할 이름
		model.addAttribute("user", user);
		
		return "/user/updateForm";
	}
	
	//ajax 통신용, 실제 회원 정보 수정이 일어남4
	@RequestMapping(value="/user/updateProc", method=RequestMethod.POST)
	@ResponseBody
	public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response)
	{
		//헥사코드로 변환해서 담는 이유는 최소한의 보안성 유지이기 때문
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userPwd = HttpUtil.get(request, "userPwd"); //JSON방식을 보낼 때 userPwd라는 이름을 변수로 사용해서 보내라
		String userName = HttpUtil.get(request, "userName");
		String userEmail = HttpUtil.get(request, "userEmail");
		
		Response<Object> ajaxResponse = new Response<Object>();
		
		//쿠키아이디가 넘어와있음(로그인 진행됨)
		if(!StringUtil.isEmpty(cookieUserId)) 
		{
			User user = userService.userSelect(cookieUserId);
			
			//사용자 정보 있을 때 정상적으로 처리
			if(user != null) 
			{
				//값들이 제대로 넘어 왔는지 다시 확인
				if(!StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail)) 
				{
					//아이디는 별도로 필요하지 않음
					user.setUserPwd(userPwd);
					user.setUserName(userName);
					user.setUserEmail(userEmail);
					
					if(userService.userUpdate(user) > 0) 
					{
						ajaxResponse.setResponse(0, "회원정보수정 성공");
					}
					else 
					{
						ajaxResponse.setResponse(500, "회원정보수정 중 실패");
					}
				}
				//하나라도 오류날 경우(입력 파라미터가 올바르지 않을 경우)
				else 
				{
					ajaxResponse.setResponse(400, "파라미터 오류");
				}
			}
			//사용자 정보 없을 때 쿠키 날림
			else 
			{
				CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
				ajaxResponse.setResponse(404, "사용자 정보 찾을 수 없음");
			}
		}
		//로그인이 안돼있음
		else 
		{
			ajaxResponse.setResponse(400, "로그인 진행 안됨");
		}
		
		//디버깅용
		if(logger.isDebugEnabled())
		{
			logger.debug("[UserController] /user/updateProc response\n" + JsonUtil.toJsonPretty(ajaxResponse));
		}
		
		return ajaxResponse;
	}
	
}
