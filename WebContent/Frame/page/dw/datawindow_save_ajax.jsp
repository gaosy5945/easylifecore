<%@page contentType="text/html; charset=GBK"%><%@
include file="/Frame/resources/include/IncludeBeginDWAJAX.jspf"%><%
	int curSuccess=0; //如果保存失败，则返回0
	String sMessage="";
	String myIndex="";

	ASDataWindow dwTemp = Component.getDW(sSessionID);
	try{
		dwTemp.update(request,Sqlca);
	}catch(Exception ex){
		ARE.getLog().debug(ex);
		curSuccess = 0;
		sMessage="保存出错!";
		if ("Development".equals(sCurRunMode)) {
			sMessage = ex.getMessage();
		}
	}
	
	myIndex=(String)request.getParameter("myIndex");
	try{
	   Integer.parseInt(myIndex);
	}catch(NumberFormatException ex){
		myIndex = "0";
	}

	if (sMessage.equals(""))
		curSuccess=1;
	else{
		curSuccess=0;
		sMessage = sMessage.replace('"','^');
		sMessage = sMessage.replace('(','（');
		sMessage = sMessage.replace(')','）');
		sMessage = sMessage.replace('\n',' ');
		sMessage = sMessage.replace('\r',' ');
		sMessage = StringFunction.replace(sMessage,"<br>","\\\\n");
	}
   out.print("{success:"+curSuccess+",index:\""+myIndex+"\",message:\""+SpecialTools.amarsoft2Real(sMessage)+"\"}");
%><%@ include file="/IncludeEndAJAX.jsp"%>