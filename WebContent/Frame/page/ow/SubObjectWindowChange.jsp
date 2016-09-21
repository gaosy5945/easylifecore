<%@ page language="java" pageEncoding="GBK"%><%@
page import="com.amarsoft.are.ARE,com.amarsoft.awe.dw.ASObjectWindow,com.amarsoft.app.als.awe.ow.creator.ObjectWindowCreator,com.amarsoft.are.lang.StringX,com.amarsoft.are.util.json.JSONDecoder,com.amarsoft.app.base.businessobject.BusinessObjectHelper,com.amarsoft.are.util.json.JSONObject"%><%@
page import="com.amarsoft.app.als.awe.ow.processor.impl.html.SubObjectWindowInfoHtmlGenerator,com.amarsoft.app.base.util.StringHelper,com.amarsoft.app.base.businessobject.BusinessObject,com.amarsoft.app.base.util.ObjectWindowHelper,com.amarsoft.app.base.util.SystemHelper,com.amarsoft.context.ASOrg,com.amarsoft.context.ASUser,com.amarsoft.awe.control.model.ComponentSession"%><%@
page import="com.amarsoft.awe.control.model.Component,com.amarsoft.awe.control.model.Page,com.amarsoft.awe.RuntimeContext"%><%
	RuntimeContext CurARC = (RuntimeContext)session.getAttribute("CurARC");
	if(CurARC == null) throw new Exception("------Timeout------");
	ASUser CurUser = CurARC.getUser();
	ASOrg CurOrg = CurUser.getBelongOrg();
	
	String compClientID = request.getParameter("CompClientID");
	if(compClientID==null) compClientID="";
	
	ComponentSession CurCompSession = CurARC.getCompSession();
	Component CurComp = CurCompSession.lookUp(compClientID);
	Page CurPage = new Page(CurComp);
	CurPage.setRequestAttribute((HttpServletRequest)request);
	
	try{
		String parameterString=CurPage.getAttribute("SYS_DATA");
		JSONObject parameterJSONObject=JSONDecoder.decode(parameterString);
		BusinessObject parameterObject = BusinessObject.createBusinessObject(parameterJSONObject);
		String subObjectInputParameterString=parameterObject.getString("OWParameterString");
		BusinessObject subObjectInputParameters=StringHelper.stringToBusinessObject(subObjectInputParameterString, "&", "=");
		String[] attributes=subObjectInputParameters.getAttributeIDArray();
		for(String attributeID:attributes){
			if(parameterObject.containsAttribute(attributeID)){
				subObjectInputParameters.setAttributeValue(attributeID, parameterObject.getObject(attributeID));
			}
		}
		subObjectInputParameters.setAttributeValue("DWName", parameterObject.getString("DWName"));
		String className = subObjectInputParameters.getString("OWCreator");
		if(StringX.isEmpty(className))className="com.amarsoft.app.als.awe.ow.creator.BasicObjectWindowCreator";
		Class<?> c = Class.forName(className);
		ObjectWindowCreator objectWindowCreator = (ObjectWindowCreator)c.newInstance();
		ASObjectWindow subDataWindow = objectWindowCreator.createObjectWindow(subObjectInputParameters, CurPage, request);
		subDataWindow.getDataObject().getCustomProperties().setProperty("ParentColName", parameterObject.getString("ColName"));
		
		SubObjectWindowInfoHtmlGenerator subHTMLGenerator = new SubObjectWindowInfoHtmlGenerator();
		subHTMLGenerator.setASDataWindow(subDataWindow);

		subHTMLGenerator.getHtmlResult("");
		String javascript =subHTMLGenerator.getJavaScript();
		javascript+="var result ={status:'success'};";
		String html =com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(subHTMLGenerator.getHTML());
		html="var htmlstring='"+html+"';";
		javascript+=html;
		out.println(javascript);
	}
	catch(Exception e){
		e.printStackTrace();
		out.println("var result ={status:'fail',errors:'"+ com.amarsoft.awe.dw.ui.util.WordConvertor.convertJava2Js(e.toString()) +"'}");
		ARE.getLog().error(e.getMessage(),e);
	}
%>
