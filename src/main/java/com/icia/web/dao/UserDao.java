/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.dao
 * 파일명     : UserDao.java
 * 작성일     : 2021. 1. 19.
 * 작성자     : daekk
 * </pre>
 */
package com.icia.web.dao;

import org.springframework.stereotype.Repository;

import com.icia.web.model.User;

/**
 * <pre>
 * 패키지명   : com.icia.web.dao
 * 파일명     : UserDao.java
 * 작성일     : 2021. 1. 19.
 * 작성자     : daekk
 * 설명       : 사용자 DAO
 * </pre>
 */
@Repository("userDao")
public interface UserDao //인터페이스는 MyBatis와 함께 사용되며, MyBatis가 해당 메서드를 구현하여 데이터베이스 연동을 수행
{
	
	/**
	 * <pre>
	 * 메소드명   : userSelect
	 * 작성일     : 2021. 1. 12.
	 * 작성자     : daekk
	 * 설명       : 사용자 조회
	 * </pre>
	 * @param userId 사용자 아이디
	 * @return  com.icia.web.model.User
	 */
	//추상메서드
	//사용자 아이디를 파라미터로 받아와 해당 사용자 정보를 조회하는 추상 메서드
	public User userSelect(String userId);
	
	//사용자 등록
	//User 객체를 파라미터로 받아와 사용자 정보를 등록하는 추상 메서드
	public int userInsert(User user);
	
	//회원정보수정(업데이트)2
	public int userUpdate(User user);
}
