package com.icia.web.dao;

import org.springframework.stereotype.Repository;

import com.icia.web.model.User2;

@Repository("userDao2")
public interface UserDao2 
{
	//사용자 조회
	public User2 userSelect2(String userId);
	
	//사용자 등록
	public int userInsert2(User2 user);
	
	//사용자 수정
	public int userUpdate2(User2 user);
}
