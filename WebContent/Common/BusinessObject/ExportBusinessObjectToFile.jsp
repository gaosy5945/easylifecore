<%@page import="com.amarsoft.app.base.util.StringHelper"%>
<%@page import="com.amarsoft.app.als.businessobject.action.BusinessObjectFactory"%>
<%@page import="com.amarsoft.are.util.xml.Document"%>
<%@page import="com.amarsoft.app.base.businessobject.BusinessObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@page import="java.io.File"%>
<%@include file="/Frame/resources/include/include_begin.jspf"%>

<%
	String objectType = CurPage.getParameter("ObjectType");
	String objectNoString = CurPage.getParameter("ObjectNo");
	String fileFormat = CurPage.getParameter("FileFormat");
	objectNoString=StringHelper.replaceAllIgnoreCase(objectNoString, "@", ",");
	BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager();
	List<BusinessObject> businessObjectList = BusinessObjectFactory.load(objectType, objectNoString, bomanager);
	
	String filePath = CurConfig.getConfigure("FileSavePath");
	String fileName = objectType+"-"+objectNoString+".xml";
	if(StringX.isEmpty(filePath)){
		filePath = request.getRealPath("") + "/TempFile/download/temp";
	}
	File file = new File(filePath);
	if(!file.exists())
		file.mkdirs();
	filePath = filePath + "/" + fileName;
	file = new File(filePath);
	file.delete();
	file.createNewFile();
	
	FileOutputStream fileOutputStream= new FileOutputStream(file);
	BusinessObjectFactory.exportBusinessObject(fileFormat,businessObjectList,fileOutputStream);
	fileOutputStream.close();
%>
<form name=form1 method=post target=aa action="<%=sWebRootPath%>/servlet/view/file?CompClientID=<%=sCompClientID%>">
	<div style="display:none">
		<input name=filename value="<%=filePath%>">
		<input name=contenttype value="unknown">
		<input name=viewtype value="unknown">		
	</div>
</form>
<script type="text/javascript">
	form1.submit();self.close();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>