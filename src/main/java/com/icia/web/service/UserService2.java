package com.icia.web.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.icia.web.dao.UserDao2;
import com.icia.web.model.User2;

@Service("userService2")
public class UserService2 
{
	private static Logger logger = LoggerFactory.getLogger(UserService.class);
	
	@Autowired
	private UserDao2 userDao;
	
	//사용자 조회
	public User2 userSelect2(String userId) 
	{
		User2 user = null;
		
		try 
		{
			user = userDao.userSelect2(userId);
		}
		catch (Exception e) 
		{
			logger.error("[UserService2] userSelect2 Exception", e);
		}
		
		return user;
	}
	
	//사용자 등록
	public int userInsert2(User2 user) 
	{
		int count = 0;
		
		try 
		{
			count = userDao.userInsert2(user);
		}
		catch (Exception e) 
		{
			logger.error("[UserService2] userInsert2 Exception", e);
		}
		
		return count;
	}
	
	//회원정보 업데이트
}
