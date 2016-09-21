<%@page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<head> 
<title></title>
<body bgcolor="#DCDCDC">
<%
	String sSqlContent = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SqlContent"));
	if(sSqlContent==null||sSqlContent.length()==0) 
	{
		sSqlContent = "";  
	}
	String sAuthPass = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AuthPass"));
	if(sAuthPass==null||sAuthPass.length()==0)
	{
		sAuthPass = "";  
	}
	sSqlContent = SpecialTools.amarsoft2Real(sSqlContent);
	String password = SHA1Tools.encryptMessage(sAuthPass);
	if("18C28604DD31094A8D69DAE60F1BCD347F1AFC5A".equals(password))
	{	
		double exeCount = 0.0;
		String sqlArr[] = sSqlContent.split(";");
		StringBuffer sb = new StringBuffer();
		for(int i=0;i<sqlArr.length;i++)
		{
			String sArr[] = sqlArr[i].split("\r\n");
			boolean flag = false;
			for(int j=0;j<sArr.length;j++)
			{
				if(sArr[j] == null || "".equals(sArr[j].trim()) || sArr[j].trim().startsWith("--"))
				{
					continue;
				}
				sb.append(sArr[j]+" ");
				flag = true;
			}
			if(flag)
			{
				sb.append(";");
			}
		}
		sSqlContent = sb.toString();
		while(sSqlContent.indexOf("/*") >= 0)
		{
			sSqlContent = StringFunction.replace(sSqlContent, sSqlContent.substring(sSqlContent.indexOf("/*"),sSqlContent.indexOf("*/")+2),"");
		}
		sqlArr = sSqlContent.split(";");
		for(int i=0;i<sqlArr.length;i++)
		{
			exeCount += Sqlca.executeSQL(sqlArr[i]);
		}
		out.println("共执行记录总计【  "+exeCount+" 】条！");
	}else 
	{
		out.println("授权码错误，你无权使用此功能！"); 
	}
%>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>