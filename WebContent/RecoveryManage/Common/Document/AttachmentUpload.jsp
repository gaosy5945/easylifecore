<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 

	//定义数据库操作变量
	SqlObject so = null;
	String sNewSql = "";
	
	String sDocNo = (String)myAmarsoftUpload.getRequest().getParameter("DocNo"); //文档编号
	String sFileName = (String)myAmarsoftUpload.getRequest().getParameter("FileName"); //文件名称
	//得到不带路径的文件名
	sFileName = StringFunction.getFileName(sFileName);
	String sAttachmentNo = DBKeyHelp.getSerialNo("DOC_ATTACHMENT","AttachmentNo");   
	sNewSql = "insert into DOC_ATTACHMENT(DocNo,AttachmentNo) values(:DocNo,:AttachmentNo)";
	so = new SqlObject(sNewSql).setParameter("DocNo",sDocNo).setParameter("AttachmentNo",sAttachmentNo);
	Sqlca.executeSQL(so);
	
	ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT.* FROM DOC_ATTACHMENT WHERE DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
	if(rs.next()){
      	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
     		try {
        		java.util.Date dateNow = new java.util.Date();
        		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
        		String sBeginTime=sdfTemp.format(dateNow);

        		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
             	if(sFileSaveMode.equals("Disk")){ //存放文件服务器中
             		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
             		String sFileNameType = CurConfig.getConfigure("FileNameType");
             		String sFullPath = FileNameHelper.getFullPath(sDocNo, sAttachmentNo,sFileName, sFileSavePath, sFileNameType, application);
					myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
              		//得到带相对路径的文件名
             		String sFilePath = FileNameHelper.getFilePath(sDocNo,sAttachmentNo,sFileName,sFileNameType);
					rs.updateString("FilePath",sFilePath); 
					rs.updateString("FullPath",sFullPath);
				}
				dateNow = new java.util.Date();
				String sEndTime=sdfTemp.format(dateNow);
	
				rs.updateString("FileSaveMode",sFileSaveMode);  
				rs.updateString("FileName",sFileName);  
				rs.updateString("ContentType",DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
				rs.updateString("ContentLength",DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
				rs.updateString("BeginTime",sBeginTime);
				rs.updateString("EndTime",sEndTime);
				rs.updateString("InputUser",CurUser.getUserID());
				rs.updateString("InputOrg",CurUser.getOrgID());
				rs.updateRow();
				rs.getStatement().close();

				if(sFileSaveMode.equals("Table")){ //存放数据表中
					myAmarsoftUpload.getFiles().getFile(0).fileToField(Sqlca,"update DOC_ATTACHMENT set DocContent=? where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
				}
				myAmarsoftUpload = null;
			}catch(Exception e){
           	out.println("An error occurs : " + e.toString());
           	sNewSql = "delete FROM doc_attachment WHERE DocNo=:DocNo and AttachmentNo=:AttachmentNo";
           	so = new SqlObject(sNewSql).setParameter("DocNo",sDocNo).setParameter("AttachmentNo",sAttachmentNo);
           	Sqlca.executeSQL(so);
           	rs.getStatement().close();
           	myAmarsoftUpload = null;
%>          
	          <script type="text/javascript">
	              alert(getHtmlMessage(10));//上传文件失败！
	              parent.reloadSelf();
	          </script>
<%
     		}
       	}
   	}
%>
<script type="text/javascript">
    alert(getHtmlMessage(13));//上传文件成功！
    parent.reloadSelf();
</script>
<%@ include file="/IncludeEnd.jsp"%>