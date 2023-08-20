/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.service
 * 파일명     : UserService.java
 * 작성일     : 2021. 1. 20.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.icia.web.dao.UserDao;
import com.icia.web.model.User;

/**
 * <pre>
 * 패키지명   : com.icia.web.service
 * 파일명     : UserService.java
 * 작성일     : 2021. 1. 20.
 * 작성자     : daekk
 * 설명       : 사용자 서비스
 * </pre>
 */
//@Service는 스프링 올라올때 같이 올라와 이거 어디? 루트-컨텍스트에 있음
@Service("userService")
public class UserService
{
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	/**
	 * @Autowired : IoC컨테이너 안에 존재하는 Bean을 자동으로 주입한다.
	 */
	@Autowired
	private UserDao userDao;
	
	/**
	 * <pre>
	 * 메소드명   : userSelect
	 * 작성일     : 2021. 1. 20.
	 * 작성자     : daekk
	 * 설명       : 사용자 조회
	 * </pre>
	 * @param userId 사용자 아이디
	 * @return User
	 */
	public User userSelect(String userId)
	{
		User user = null;
		
		//다오.java에서 repository 때문에 예외처리가 발생할 수 있음 그래서 try~catch 사용함
		try
		{
			user = userDao.userSelect(userId);
		}
		catch(Exception e)
		{
			logger.error("[UserService] userSelect Exception", e);
		}
		
		return user;
	}
	
	
	//사용자 등록
	public int userInsert(User user) 
	{
		int count = 0;
		
		try 
		{
			count = userDao.userInsert(user);
		}
		catch (Exception e) 
		{
			logger.error("[UserService] userInsert Exception", e);
		}
		
		return count;
	}
	
	//사용자 회원정보수정3(다오 파일들과 메서드명이 일치할 필요는 없음)
	public int userUpdate(User user) 
	{
		int count = 0;
		
		try 
		{
			count = userDao.userUpdate(user);
		}
		catch (Exception e) 
		{
			logger.error("[UserService] userUpdate Exception", e);
		}
		
		return count;
	}
}
