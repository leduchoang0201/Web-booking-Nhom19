<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<jsp:include page="Header.jsp"/>
<div class="container">
        <h1>PHÒNG</h1>
        <div class="row">
            <c:forEach var="room" items="${rooms}">
                <div class="card">
                    <img src="<c:url value='/images/${room.image}'/>" alt="${room.name}">
                    <div class="card-body">
                        <h3>${room.name}</h3>
                        <p>${room.price} VNĐ mỗi đêm</p>
                        <p>Cơ sở: ${room.facilities}</p>
                        <p>Tiện nghi & Trang thiết bị: ${room.amenities}</p>
                        <p>Khách hàng: ${room.guests}</p>
                        <a href="#" class="btn">Đặt Ngay</a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    <jsp:include page="Footer.jsp "/>
</body>
</html>