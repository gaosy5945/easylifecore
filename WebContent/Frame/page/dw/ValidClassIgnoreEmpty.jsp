<%@ page language="java" import="java.util.*,com.amarsoft.awe.dw.ui.validator.ICustomerRule" pageEncoding="GBK"%><%@page import="java.sql.*"%><%@page import="com.amarsoft.are.ARE"%><%
String sClass = request.getParameter("ClassName");
String sValue = java.net.URLDecoder.decode(request.getParameter("Value"),"UTF-8").replaceAll("�ѡա�","&");
if(sValue.equals("")){
	out.print("true");
	return;
}
//ƴ�Ӳ���
Hashtable params = new Hashtable();
for(java.util.Enumeration enum1 = request.getParameterNames(); enum1.hasMoreElements();){
	String sKey = (String)enum1.nextElement();
	if(sKey.equals("ClassName"))continue;
	if(sKey.equals("Value"))continue;
	if(request.getParameter(sKey)!=null){
		String sParamValue = java.net.URLDecoder.decode(request.getParameter(sKey).toString(),"UTF-8");
		params.put(sKey,sParamValue.replaceAll("�ѡա�","&"));
	}
}
ARE.getLog().trace("��ʼClass��֤�����ղ�����sClass=" + sClass + "|value=" + sValue);
try{
	if(sClass!=null){
		ICustomerRule rule = (ICustomerRule)Class.forName(sClass).newInstance();
		String sResult = rule.valid(sValue,params);
		if(sResult.equals("")){
			out.print("true");
		}
		else{
			out.print(sResult);
		}
	}
	else{
		out.print("δ����У����");
	}
}
catch(Exception e){
	e.printStackTrace();
	ARE.getLog().error("classУ�顾���Կա������ˣ�"+e.toString());
	out.print("�����ˣ�"+e.toString());
}
%>