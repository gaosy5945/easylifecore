<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Content: 安全信息汇总
		Output param:
			sListType 11 当日登陆总次数、总人数，注销总次数、总人数
			          12 当日登陆失败次数
			          13 当前在线总人数
			          14 当日页面访问总次数
			          15 当日数据库增删改操作总次数
	 */
	List<String> sAuditInfo = getAuditInfo(Sqlca,StringFunction.getToday());
%>
<%!
	List<String> getAuditInfo(Transaction Sqlca,String sDay) throws Exception {
		List<String> sArray = new ArrayList<String>();
		String sSql="";

		sSql = "select count(UserID) from USER_LIST where BeginTime like :Day";
		sArray.add("当日........登陆总次数:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16));
		sSql = "select count(distinct UserID) from USER_LIST where BeginTime like :Day";
		sArray.add("当日........登陆总人数:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16));
		sSql = "select count(UserID) from USER_LIST where BeginTime like :Day and EndTime is not null ";
		sArray.add("当日........注销总次数:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16));
		sSql = "select count(distinct UserID) from USER_LIST where BeginTime like :Day and EndTime is not null ";
		sArray.add("当日........注销总人数:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16));
		sSql = "select count(UserID) from USER_RUNTIME where BeginTime like :Day";
		sArray.add("当日....页面访问总次数:"+getSpace(Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%")),16));
		sSql = "select count(UserID) from USER_FAILEDLIST where LOGONTIME like :Day";
		sArray.add(changeRed("当日....登陆失败总次数:　　　　"+Sqlca.getString(new SqlObject(sSql).setParameter("Day",sDay+"%"))));

		return sArray;
	}

	String changeRed(String s) {
		return "<span style=\"font-size: 11pt; color: #ff0000;\">"+s+"</span>";
	}

	String getSpace(String s, int len) {
		if (s.length() > 5 && len > 40)
			s = s.substring(0,s.length()-3);
		if (s.length() > len)
			return s;
		for (int i=s.length(); i < len; i ++)
			s = "&nbsp;"+s;
		s="<span style=\"font-size: 12pt; color: #0066cc;\"><b>"+s+"</b></span>";
		return s;
	}
%>
<html>
<head>
<title>安全信息汇总</title>
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody">
	<div style="width:100%; height:100%; z-index:1; overflow: auto;margin-top: 60px;margin-left: 100px">
		<table style="border: 0; width: 100%;text-align: left;">
			<tr>
				<td><b>安全信息汇总统计&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="javascript:self.location.reload();">刷新</a></b></td>
			</tr>
		<%for (int i=0; i < sAuditInfo.size(); i ++) { %>
			<tr><td ><%=sAuditInfo.get(i)%></td></tr>
		<%}%>
		</table>
	</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>