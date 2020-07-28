<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ include file ="ssi.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[geustList.jsp]</title>
<style type="text/css">
</style>
</head>
<body> <!-- 이 파일은 단독실행 가능 -->
<%
	//오늘 숙제 페이지갯수 32 나오게 하기
	msg="select count(*) as cnt from guest";
	ST=CN.createStatement();
	RS=ST.executeQuery(msg);
	RS.next();
	Gtotal = RS.getInt("cnt"); //Gtotal 은 지금 316을 가지고 있다. 레코드 갯수니까.
	
	//페이징, 검색, 댓글
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
	Date dt = new Date();
	//제목 옆에 60분 = 1시간 전에 올라온 글에 new 또는 깃발 또는 빨간색 글씨로 표시해주기
	
	
	int pageNUM, pagecount;
	//pageNUM = 숫자 13으로 변환을 해
	//pagecount = 32개야. 지금 데이터가 316개 인데 페이지 수가 32가 되어야하니까.
	
	int start, end; //시작행 261 끝행 270 [이전] [21] ~27 ~ [30] [다음]   이건 행이야.
	int startpage, endpage; //시작페이지 21, 끝페이지 30   이건 페이지야.
	int tmp; //임시 계산식 21 부터 30까지 밑에 뜨고 있을때 21과 30은 이동할때마다 10씩 더해주면 된다.

	String sqry="조건"; //Sub Query ?
	String skey="검색필드", sval="검색키워드";
	String returnpage="아직은 몰라요 검색할때 사용";
	
	String pnum = request.getParameter("pageNum"); 
	//request로 받았으니까 클릭하면 문자로 12을 기억한다
	//13이라는 숫자를 String 타입으로 받는다. <a href="guestList.jsp?pageNum=7">[7]</a>
	//<a href="guestList.jsp?pageNum=i">[i]</a>
	if (pnum==null||pnum==""){pnum="1";} //만약에 pnum 값이 없거나 비어있다면, 1페이지를 출력해라
	pageNUM = Integer.parseInt(pnum);
	System.out.println("[guestList] 클릭한 페이지 : " + pageNUM);
	
	start = (pageNUM-1)*10+1;	//121;  [13] 을 클릭했을때 	시작행
	end   = (pageNUM*10);  	 	//130;  [13] 을 클릭했을때 	끝행
	
	tmp 	  = (pageNUM-1)%10; //2; 	[13]을 클릭했을때 	임시 공간 13에서 1 빼고 10으로 나눈 나머지 (13-1)%10= 2
	startpage = pageNUM-tmp;	//11;
	endpage   = startpage+9;	//20;
	
	//내일은 총 페이지갯수를 구해야 이전, 다음 이동이 가능합니다.
	
	String a="select * from (";
	String b=" select rownum rn, sabun, name, title, wdate, pay, hit, email from guest ";
	String c=") where rn between " + start + " and "+end;
	System.out.println("[guestList] " + c);
	msg = a+b+c;
	ST=CN.createStatement();
	RS=ST.executeQuery(msg);
%>
<p id="Pline">

<table width=900 border="1" cellspacing="0">
<tr align="center">
	<td colspan="8">레코드 갯수 [<%= Gtotal %>]</td>
</tr>

<tr bgcolor="yellow">
<td>행번호</td> <td>사번</td> <td>이름</td> <td>제목</td> <td>이메일</td> <td>날짜</td> <td>조회수</td> <td>삭제</td>
</tr>

<%
	while(RS.next()){
		Gsabun=RS.getInt("sabun");
		Gtitle=RS.getString("title");
		Gemail=RS.getString("email");
%>
<tr onmouseover="style.backgroundColor='rgb(0,200,200)'" onmouseout="style.backgroundColor=''">
  <td><%= RS.getInt("rn") %></td>
  <td><%= RS.getInt("sabun") %></td>
  <td><%= RS.getString("name") %></td> 
  <td><a href="guestDetail.jsp?idx=<%=Gsabun%>"><%= RS.getString("title") %></a></td> 
  <td><%= RS.getString("email") %></td>
  <td><%= RS.getDate("wdate") %></td> 
  <td><%= RS.getInt("hit") %></td>
  <td align="center"><input type="button" value="삭제" onclick="location.href='guestDelete.jsp?idx=<%=Gsabun %>'"></td>
</tr>
<% } %>

	<tr>
		<td colspan="8" align="center">
		<%
		for (int i=1; i<11; i++){ //i 는 1부터고 11보다는 작다.
			out.println("<a href=guestList.jsp?pageNum="+i+">["+i+"]</a>");
		}
		%>
		</td>
	</tr>
</table>
<br>
 <a href="guestWriteCheck.jsp">[회원등록]</a>
 <a href="index.jsp">[index]</a>
 <a href="Login.jsp">[로그인]</a>
 <a href="guestList.jsp">[전체출력]</a>	
	<p><br>
</body>
</html>