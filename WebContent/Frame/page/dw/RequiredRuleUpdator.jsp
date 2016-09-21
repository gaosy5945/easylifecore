<%@ page language="java" import="java.util.*,com.amarsoft.awe.control.model.*,com.amarsoft.awe.dw.*,com.amarsoft.awe.util.*,com.amarsoft.awe.dw.ui.validator.*" pageEncoding="GBK"%><%@page import="java.sql.*"%><%@page import="com.amarsoft.are.ARE"%><%
/*
本类用于更新必输项验证
*/
String sDataObject = request.getParameter("DataObject");
String sColName = request.getParameter("ColName");
String sRequired = request.getParameter("Required");
boolean bRequired = "1".equals(sRequired);
try{
	ASDataObject asObj = Component.getDataObject(sDataObject);//(ASDataObject)ObjectConverts.getObject(sDataObject);	
	asObj.setRequired(sColName, bRequired);
	//刷新验证规则
	IValidateRulesFactory factory = new DefaultValidateRulesFactory(asObj);
	asObj.validateRules = factory.getValidateRules();
	//重新序列化dataobject
	ObjectConverts.saveObject(new java.io.File(Component.getDWTmpPath(asObj.getSerializableName())), asObj);
	sDataObject = sDataObject;//ObjectConverts.getString(asObj);
	out.print(sDataObject);
}
catch(Exception e){
	e.printStackTrace();
	out.print("fail:"+ e.toString());
}
%>