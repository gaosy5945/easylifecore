<%@ page contentType="text/html; charset=GBK"%>
<%@page import="java.io.File"%>
<%@page import="com.amarsoft.app.als.finance.report.FSSpreadSheetPOI"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//��ȡ����
	String recordNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("recordNo"));
	String objectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("objectNo"));
	String reportDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("reportDate"));
	String objectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("objectType"));
	String reportScope = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("reportScope"));

	//upload data
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 
	
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //�ļ�����
	sFileName = StringFunction.getFileName(sFileName);  //�õ�����·�����ļ���
	String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
	String sFullPath = "";
	
	if(sFileSaveMode.equals("Disk")){ //��ŵ��ļ���������
		String randomFileName = UUID.randomUUID().toString();
		
		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
		File file = new File(sFileSavePath);
		if(!file.exists()) file.mkdirs();
		
		sFullPath = sFileSavePath + "/" +randomFileName + "_" + sFileName;
		myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
	}
	
	//�ѱ������ݵ������ݿ�
	FSSpreadSheetPOI spreadSheet = new FSSpreadSheetPOI(recordNo, objectNo, objectType, reportDate, reportScope, sFullPath);
	String resultStatus = spreadSheet.loadAndImportFSFile(Sqlca);
	if(resultStatus.equals(FSSpreadSheetPOI.SUCCESS_STATUS)){
%>
	<script type="text/javascript">
    	alert("�����ļ��ɹ���");//�����ļ��ɹ���
    	parent.openComponentInMe();
	</script>
<%		
	}
	else{
%>
	<script type="text/javascript">
	    alert("�����ļ�ʧ�ܣ�");//�ϴ��ļ�ʧ�ܣ�
	    parent.openComponentInMe();
	</script>
<%
	}
%><%@ include file="/IncludeEnd.jsp"%>