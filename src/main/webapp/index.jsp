<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
//1.Dispatcher한테 요청을 보내 컨트롤러에서 /index랑 매핑된게 있는지 찾아
	javax.servlet.RequestDispatcher requestDispatcher = request.getRequestDispatcher("/index");

	requestDispatcher.forward(request, response);
%>