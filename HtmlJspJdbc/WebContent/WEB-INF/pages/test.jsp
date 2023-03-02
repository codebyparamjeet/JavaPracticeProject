<%@ page language="java" import="java.sql.* "%>


<%!Connection conn = null;
	PreparedStatement pstm1 = null;
	PreparedStatement pstm2 = null;


	public void jspInit() {
		System.out.println("Bootstrapping the environment....");
		ServletConfig config = getServletConfig();
		String url = config.getInitParameter("url");
		String user = config.getInitParameter("username");
		String password = config.getInitParameter("password");
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			conn= DriverManager.getConnection(url, user, password);
			pstm1 = conn.prepareStatement("insert into employee(name,age,salary) values (?,?,?)");
			pstm2 = conn.prepareStatement("select name, age, salary from employee");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException se) {
			se.printStackTrace();
		}

	}%>


<%
String action = request.getParameter("s1");
if (action.equalsIgnoreCase("register")) {
	//take the data and perform insert operation
	String eName = request.getParameter("empName");
	String eAge = request.getParameter("empAge");
	String eSalary = request.getParameter("empSalary");

	pstm1.setString(1, eName);
	pstm1.setInt(2, Integer.parseInt(eAge));
	pstm1.setInt(3, Integer.parseInt(eSalary));

	int rowCount = pstm1.executeUpdate();
	if (rowCount == 1) {
%>
<h1 style='color: green; text-align: center;'>Employee registered</h1>
<%
} else {
%>
<h1 style='color: red; text-align: center;'>Employee not registered</h1>
<%
}
%>

<%
} else {
// Get the data from the database using select operation ResultSet
ResultSet resultSet = pstm2.executeQuery();
%>
<table bgcolor='pink' align='center' border='1'>
	<tr>
		<th>NAME</th>
		<th>AGE</th>
		<th>SALARY</th>
	</tr>

	<%
	while (resultSet.next()) {
	%>
	<tr>
		<td><%=resultSet.getString(1)%></td>
		<td><%=resultSet.getInt(2)%></td>
		<td><%=resultSet.getInt(3)%></td>
	</tr>
	<%
	}
	%>
</table>
<%
}
%>
	


<%!public void jspDestroy() {
		System.out.println("Cleaning the environment....");
		try {
			if (pstm1 != null)
				pstm1.close();

		} catch (SQLException se) {
			se.printStackTrace();
		}
		
		try {
			if (pstm2 != null)
				pstm2.close();

		} catch (SQLException se) {
			se.printStackTrace();
		}
		
		try {
			if (conn != null)
				conn.close();

		} catch (SQLException se) {
			se.printStackTrace();
		}

	}%>