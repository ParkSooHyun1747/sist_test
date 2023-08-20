/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.icia.web.util.CookieUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * 설명       : 인덱스 컨트롤러
 * </pre>
 */
@Controller("indexController")
public class IndexController
{
	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	/**
	 * <pre>
	 * 메소드명   : index
	 * 작성일     : 2021. 1. 21.
	 * 작성자     : daekk
	 * 설명       : 인덱스 페이지 
	 * </pre>
	 * @param request  HttpServletRequest
	 * @param response HttpServletResponse
	 * @return String
	 */
	@RequestMapping(value = "/index", method=RequestMethod.GET)
	//리턴 타입 스트링이면 View Resolver 호출 servlet-context.xml의 View Resolver 시작 부분 보기
	public String index(HttpServletRequest request, HttpServletResponse response)
	{
		return "/index";
	}
	
	@RequestMapping(value = "/index2", method=RequestMethod.GET)
	//리턴 타입 스트링이면 View Resolver 호출 servlet-context.xml의 View Resolver 시작 부분 보기
	public String index2(HttpServletRequest request, HttpServletResponse response)
	{
		logger.debug("111111111111111");
		return "/index2";
	}
}
