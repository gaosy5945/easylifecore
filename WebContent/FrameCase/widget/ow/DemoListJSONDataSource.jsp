<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%
	//此种模式不支持导出
	//String sTempletNo = "TestCustomerInfo";//模板号
	String jsonASObject="{\"columns\":[{\"colName\":\"NAME\",\"colHeader\":\"姓名\"}"
		+ ",{\"colName\":\"SEX\",\"colHeader\":\"性别\",\"colEditSourceType\":\"Code\",\"colEditSource\":\"Sex\"}"
		+ ",{\"colName\":\"IMCOME\",\"colCheckFormat\":\"2\",\"colHeader\":\"年收入\",\"colUnit\":\"(元)\"}]}";
	String jsonData = "[{\"NAME\":\"FLIAN\",\"SEX\":\"1\",\"IMCOME\":\"120000\"},{\"NAME\":\"lf\",\"SEX\":\"1\",\"IMCOME\":\"100000\"}]";
	ASObjectModel doTemp = ASObjectModel.createASObjectModelfromJSON(jsonASObject);
	doTemp.setDataQueryClass("com.amarsoft.awe.dw.ui.htmlfactory.imp.JsonListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "1";//freeform
	dwTemp.ReadOnly = "1";//只读模式
	dwTemp.genHTMLObjectWindow(jsonData);
	
	String sButtons[][] = {
			
	};
	sButtonPosition = "south";
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
