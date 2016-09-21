<%@page import="com.amarsoft.app.als.awe.ow.ALSMultipleObjectWindowAction"%>
<%@page import="com.amarsoft.are.util.json.JSONObject"%>
<%@page import="com.amarsoft.are.util.json.JSONDecoder"%>
<%@ page language="java" import="com.amarsoft.are.*,java.util.*,com.amarsoft.awe.dw.handler.BusinessProcessData,com.amarsoft.awe.dw.ui.util.PublicFuns,com.amarsoft.are.jbo.*,com.amarsoft.awe.dw.ASDataObjectFilter,com.amarsoft.awe.dw.ui.list.ListAction,com.amarsoft.awe.dw.ui.util.ConvertXmlAndJava,com.amarsoft.awe.dw.ASDataObject,com.amarsoft.awe.dw.ui.util.Request,com.amarsoft.awe.dw.ui.actions.IDataAction,com.amarsoft.awe.dw.ui.htmlfactory.*,com.amarsoft.awe.dw.ui.htmlfactory.imp.*" pageEncoding="GBK"%><%@page import="java.net.URLDecoder"%><%
	String sCurPage = Request.GBKSingleRequest("curpage",request);
	int iCurPage = 0;
	if(sCurPage.matches("[0-9]+"))
		iCurPage = Integer.parseInt(sCurPage);
	
	String action = Request.GBKSingleRequest("SYS_ACTION",request);//获得动作名称
	String data = Request.GBKSingleRequest("SYS_DATA",request);//获得保存过的字段
	if(data==null)data = "";// data= URLDecoder.decode(data,"UTF-8");
	ALSMultipleObjectWindowAction businessProcess = new ALSMultipleObjectWindowAction(request,action);
	try{
		boolean result = businessProcess.run(data);
		if(result){
			out.println("result = {status:'success',resultInfo:'"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(businessProcess.getResultInfo()) +"'};");
			out.println(businessProcess.getClientUpdateScript());
		}
		else{
			out.println("result = {status:'fail',errors:'"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(businessProcess.getErrors()) +"'};");
		}
	}
	catch(Exception e){
		e.printStackTrace();
		out.println("{status:'fail',errors:'"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(e.toString()) +"'}");
		ARE.getLog().error("系统错误" + e.toString());
	}
%>
