<%@page import="java.io.File"%>
<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 
	
	String edocNo = CurPage.getParameter("EdocNo");
	if(edocNo == null) edocNo = "";
	
	//定义数据库操作变量
	SqlObject so = null;
	
	String fileNameFMT =  java.net.URLDecoder.decode((String )myAmarsoftUpload.getRequest().getParameter("FileName"), "UTF-8"); //文件名称
	//得到不带路径的文件名
	fileNameFMT = StringFunction.getFileName(fileNameFMT);
	
	ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT * FROM PUB_EDOC_CONFIG WHERE EdocNo='"+edocNo+"'");
     	   try {String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
             	String sFileSavePath = CurConfig.getConfigure("WorkDocOfflineSavePath");
             	String fileNameType = CurConfig.getConfigure("FileNameType");
             	String fullPathFMT = sFileSavePath+"/"+fileNameFMT;
				myAmarsoftUpload.getFiles().getFile(0).saveAs(fullPathFMT);
              	//得到带相对路径的文件名
			 	String contentTypeFMT = DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType());
			 	String contentLengthFMT = DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize()));
				so = new SqlObject("update PUB_EDOC_CONFIG set FileNameFMT=:FileNameFMT,ContentTypeFMT=:ContentTypeFMT,ContentLengthFMT=:ContentLengthFMT,FullPathFMT=:FullPathFMT where EdocNo=:EdocNo")
				.setParameter("FileNameFMT",fileNameFMT).setParameter("ContentTypeFMT",contentTypeFMT).setParameter("ContentLengthFMT", contentLengthFMT).setParameter("FullPathFMT", fullPathFMT.replaceAll(sFileSavePath, "")).setParameter("EdocNo", edocNo);
				Sqlca.executeSQL(so);
				myAmarsoftUpload = null;
				}catch(Exception e){
				e.printStackTrace();
           		out.println("An error occurs : " + e.toString());
%>          
	          <script type="text/javascript">
	              alert(getHtmlMessage(10));//上传文件失败！
	              parent.openComponentInMe();
	          </script>
<%
     		}
%>
<script type="text/javascript">
    alert(getHtmlMessage(13));//上传文件成功！
    parent.openComponentInMe();
</script>
<%@ include file="/IncludeEnd.jsp"%>