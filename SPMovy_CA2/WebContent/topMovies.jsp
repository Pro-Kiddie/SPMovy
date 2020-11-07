<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@ page import="service.DisplayService,java.util.ArrayList,dto.TopMovies, dto.User,java.text.SimpleDateFormat,java.util.Date,java.util.Calendar,java.text.DateFormatSymbols" %>
<%

User user = (User) session.getAttribute("user");
if (user == null || !user.getRole().equals("admin")) {
	response.sendRedirect("error.html");
	// use return keyword to return _jspService()
	// prevent the Java code and HTML code below from being rendered 
	return;
}

String monthName,year;
DisplayService display = new DisplayService();
monthName = request.getParameter("chosenDate");
year = request.getParameter("chosenYear");
%>
<html>
<head>
<jsp:include page="css/BootstrapLinks.jsp"/>
<title>Top Movies</title>
<style>
#adminLink {
	color: #ffffff;
}
#reportLink {
	color: #00b0ff;
}
label
{
	font-size: 120%;
}
</style>
</head>
<body>
<jsp:include page="adminNavigationBar.jsp" />
<div class="container">

<form action="topMovies.jsp" method="post" class="mt-4 font-weight-bold">
<div class="form-group">
    <label for="exampleFormControlSelect1">Select a date:</label>
    <select class="form-control" id="exampleFormControlSelect1" name="chosenDate">
    <%if(monthName != null){ %>
       <option selected="selected" id="setDefaultValue"><%=monthName%></option>
     <%}else{%>
     	<option selected="selected" id="setDefaultValue">No Month Selected</option>
     	<%}%>
    <%for(int i =1; i <= 12; i++){%>
      <option><%=getMonthname(i)%></option>
     <%}%>
    </select>
  </div>
   <div class="form-group">
    <label for="exampleFormControlSelect1">Select a year:</label>
    <select class="form-control" id="exampleFormControlSelect1" name="chosenYear">
      <%if(year != null){ %>
       <option selected="selected" id="setDefaultValue"><%=year%></option>
     <%}else{%>
     	<option selected="selected" id="setDefaultValue">No Year Selected</option>
     	<%}%>
     	<%for(int i =2000; i <= Calendar.getInstance().get(Calendar.YEAR); i++){%>
      <option><%=i%></option>
     <%}%>
    </select>
  </div>
  <button type="submit" class="btn btn-primary mt-2">View Month Record</button>
</form>
<%
	
	if((monthName != null && monthName != "") &&(year != null && year != ""))
	{
		int monthNum = getConvertedMonthNameIntoNum(monthName);
		ArrayList<TopMovies> topMovies= display.displayAllTopMovies(monthNum, year);
		if(topMovies.size() != 0){%>
		<h1>Top selling movies for the month of <%=monthName%> <%=year%></h1>
		<table class="table table-striped table-dark mt-4">
 <thead>
  <tr>
  	  <th scope="col">Rank</th>
      <th scope="col">Movie Name</th>
      <th scope="col">No. of Tickets Sold</th>
  </tr>
  </thead>
  <tbody>
		
		
<% 
	for (int i = 0; i < topMovies.size(); i++) 
	{%>
		 <tr>
		 <th><%=i + 1 %></th>
		<td><%=topMovies.get(i).getMovieName()%></td>
		<td><%=topMovies.get(i).getTicketBought()%></td>
		</tr>
	<%}%>

</tbody>
</table>
		
		<%}else{%>
		<h1>No record show for the month of <%=monthName%> <%=year%></h1>
		<% } display.close();
	}
	else
	{
	 	;
	}
%>
</div>
<jsp:include page="adminFooter.jsp" />
<jsp:include page="js/BootstrapScriptLinks.jsp"></jsp:include>


</body>
</html>
<%!
private String getMonthname(int month)
{
	String monthString;
	switch (month) {
	    case 1:  monthString = "January";
	             break;
	    case 2:  monthString = "February";
	    		 break;
	    case 3:  monthString = "March";
	    		 break;
	    case 4:  monthString = "April";
	    		 break;
	    case 5:  monthString = "May";
	    		 break;
	    case 6:  monthString = "June";
	    		 break;
	    case 7:  monthString = "July";
	    		 break;
	    case 8:  monthString = "August";
	    		 break;
	    case 9:  monthString = "September";
	    		 break;
	    case 10: monthString = "October";
	    		 break;
	    case 11: monthString = "November";
	    		 break;
	    case 12: monthString = "December";
	    		 break;
	    default: monthString = "Invalid month";
	    		 break;
	};
return monthString;
}
private int getConvertedMonthNameIntoNum(String monthName)throws Exception
{
	Date date = new SimpleDateFormat("MMMM").parse(monthName);
	Calendar cal = Calendar.getInstance();
	cal.setTime(date);

	return cal.get(Calendar.MONTH) + 1;	

} 
%>