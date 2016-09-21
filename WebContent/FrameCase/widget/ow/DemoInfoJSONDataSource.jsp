<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_info.jspf"%><%
	String jsonASObject="{\"columns\":[{\"colName\":\"NAME\",\"colHeader\":\"姓名\"}"
		+ ",{\"colName\":\"SEX\",\"colHeader\":\"性别\",\"colEditSourceType\":\"Code\",\"colEditSource\":\"Sex\",\"colEditStyle\":\"Select\"}"
		+ ",{\"colName\":\"IMCOME\",\"colCheckFormat\":\"2\",\"colHeader\":\"年收入\",\"colUnit\":\"(元)\"}]}";
	String jsonData = "{\"NAME\":\"FLIAN\",\"SEX\":\"1\",\"IMCOME\":\"120000\"}";
	ASObjectModel doTemp = ASObjectModel.createASObjectModelfromJSON(jsonASObject);
	doTemp.setDataQueryClass("com.amarsoft.awe.dw.ui.htmlfactory.imp.JsonInfoHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage, doTemp,request);
	dwTemp.Style = "2";//freeform
	dwTemp.ReadOnly = "0"; //设置模式  1:只读 0:可写 -2:打印
	dwTemp.genHTMLObjectWindow(jsonData);
	
	String sButtons[][] = {
		{"true","All","Button","获取字段值","获取字段值","getValue()","","","",""}
	};
	sButtonPosition = "south";
%><%@ include file="/Frame/resources/include/ui/include_info.jspf"%>
<script>
	function getValue(){
		alert(getItemHeader(0,0,"NAME")+":"+getItemValue(0,0,"NAME")+" "+getItemHeader(0,0,"SEX")+":"+getItemValue(0,0,"SEX"));
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>