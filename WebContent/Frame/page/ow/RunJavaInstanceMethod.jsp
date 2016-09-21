<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.are.util.json.*"%>
<%@ page language="java" import="java.util.*,java.lang.reflect.*,java.net.URLDecoder" pageEncoding="GBK"%><%
String sClassName = request.getParameter("className");
String sMethodName = request.getParameter("methodName");
String sParamValues = request.getParameter("paramValues");
JSONObject jsonobject=null;
if(sParamValues!=null){
	sParamValues = URLDecoder.decode(sParamValues,"UTF-8");
	sParamValues = URLDecoder.decode(sParamValues,"UTF-8"); 
	sParamValues = URLDecoder.decode(sParamValues,"UTF-8"); 
	jsonobject = JSONDecoder.decode(sParamValues);
}

try{
	Class c = Class.forName(sClassName);
	Object obj = c.newInstance();
	Method m = c.getMethod(sMethodName,null);
	//设置参数值
	if(jsonobject!=null){
		for(int i=0;i<jsonobject.size();i++){
			String sKey = jsonobject.get(i).getName();
			String sMethod = "set"  +sKey.substring(0, 1).toUpperCase() + sKey.substring(1);
			try{
				Method m2 = c.getMethod(sMethod,String.class);
				ARE.getLog().debug("run Method=" + sClassName+"."+sMethod + ",value=" + jsonobject.getValue(sKey).toString());
				m2.invoke(obj, jsonobject.getValue(sKey).toString());
			}catch(Exception e){
				e.printStackTrace();
				ARE.getLog().warn(sClassName + "的"+sMethod+"方法调用失败");
			}
		}
	}
	String result = (String)m.invoke(obj, null);
	out.print(result);
}catch(Exception e){
	e.printStackTrace();
	out.print("undefined");
}
%>