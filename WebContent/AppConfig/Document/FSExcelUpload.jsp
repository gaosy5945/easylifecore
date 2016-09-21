<%@ page contentType="text/html; charset=GBK"%>
<%@page import="java.io.File"%>
<%@page import="com.amarsoft.app.als.finance.report.FSSpreadSheetPOI"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//获取参数
	String recordNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("recordNo"));
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("objectNo"));
	String reportDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("reportDate"));
	String objectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("objectType"));
	String reportScope = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("reportScope"));

	//upload data
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 
	
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //文件名称
	sFileName = StringFunction.getFileName(sFileName);  //得到不带路径的文件名
	String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
	String sFullPath = "";
	
	if(sFileSaveMode.equals("Disk")){ //存放到文件服务器中
		String randomFileName = UUID.randomUUID().toString();
		
		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
		File file = new File(sFileSavePath);
		if(!file.exists()) file.mkdirs();
		
		sFullPath = sFileSavePath + "/" +randomFileName + "_" + sFileName;
		myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
	}
	
	//把报表数据导入数据库
	FSSpreadSheetPOI spreadSheet = new FSSpreadSheetPOI(recordNo, objectNo, objectType, reportDate, reportScope, sFullPath);
	String resultStatus = spreadSheet.loadAndImportFSFile(Sqlca);
	if(resultStatus.equals(FSSpreadSheetPOI.SUCCESS_STATUS)){
%>
	<script type="text/javascript">
    	alert("导入文件成功！");//导入文件成功！
    	parent.openComponentInMe();
	</script>
<%		
	}
	else{
%>
	<script type="text/javascript">
	    alert("导入文件失败！");//上传文件失败！
	    parent.openComponentInMe();
	</script>
<%
	}
%><%@ include file="/IncludeEnd.jsp"%>