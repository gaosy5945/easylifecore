<%@page import="java.io.File"%>
<%@page import="com.amarsoft.awe.util.DBKeyHelp"%>
<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 
	
	String inputTime = StringFunction.getToday();
	String inputUserID = CurUser.getUserID();
	String inputOrgID = CurOrg.getOrgID();

	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	//定义数据库操作变量
	SqlObject so = null;
	SqlObject so1 = null;
	SqlObject so2 = null;
	
	String fileName =  java.net.URLDecoder.decode((String )myAmarsoftUpload.getRequest().getParameter("FileName"), "UTF-8"); //文件名称
	//得到不带路径的文件名
	fileName = StringFunction.getFileName(fileName);
	
	String objectNo = DBKeyHelp.getSerialNo("DOC_RELATIVE", "OBJECTNO");
	String docNo = DBKeyHelp.getSerialNo("DOC_LIBRARY", "DOCNO");
	String sAttachmentNo = DBKeyHelp.getSerialNo("DOC_ATTACHMENT","AttachmentNo","DocNo='"+docNo+"'","","000",new java.util.Date(),Sqlca);
	
	so = new SqlObject("insert into DOC_RELATIVE(DocNo,ObjectType,ObjectNo) values(:DocNo,:ObjectType,:ObjectNo)").setParameter("DocNo",docNo).setParameter("ObjectType",objectType).setParameter("ObjectNo", objectNo);
	Sqlca.executeSQL(so);
	
	so1= new SqlObject("insert into DOC_LIBRARY(DocNo,DocTitle,InputTime,InputUserID,InputOrgID) values(:DocNo,:DocTitle,:InputTime,:InputUserID,:InputOrgID)").setParameter("DocNo",docNo).setParameter("DocTitle",fileName).setParameter("InputTime", inputTime).setParameter("InputUserID",inputUserID).setParameter("InputOrgID", inputOrgID);
	Sqlca.executeSQL(so1);
	
	String sNewSql = "insert into DOC_ATTACHMENT(DocNo,AttachmentNo,ContentStatus) values(:DocNo,:AttachmentNo,:ContentStatus)";
	so2 = new SqlObject(sNewSql).setParameter("DocNo",docNo).setParameter("AttachmentNo",sAttachmentNo).setParameter("ContentStatus","0");
	Sqlca.executeSQL(so2);
	
	ASResultSet rs = Sqlca.getASResultSetForUpdate("SELECT DOC_ATTACHMENT.* FROM DOC_ATTACHMENT WHERE DocNo='"+docNo+"' and AttachmentNo='"+sAttachmentNo+"'");
	if(rs.next()){
      	if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()){
     		try {
        		java.util.Date dateNow = new java.util.Date();
        		SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
        		String sBeginTime=sdfTemp.format(dateNow);

        		String sFileSaveMode = CurConfig.getConfigure("FileSaveMode");
             	if(sFileSaveMode.equals("Disk")){ //存放文件服务器中
             		String sFileSavePath = CurConfig.getConfigure("FileSavePath");
              		File file = new File(sFileSavePath);
             		if(!file.exists())
             			file.mkdirs(); 
             		String fileNameType = CurConfig.getConfigure("FileNameType");
             		String sFullPath = FileNameHelper.getFullPath(docNo, sAttachmentNo,fileName, sFileSavePath, fileNameType, application);
					myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
              		//得到带相对路径的文件名
             		String sFilePath = FileNameHelper.getFilePath(docNo,sAttachmentNo,fileName,fileNameType);
					rs.updateString("FilePath",sFilePath); 
					rs.updateString("FullPath",sFullPath);
				}
				dateNow = new java.util.Date();
				String sEndTime=sdfTemp.format(dateNow);
	
				rs.updateString("FileSaveMode",sFileSaveMode);  
				rs.updateString("FileName",fileName);  
				rs.updateString("ContentType",DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
				rs.updateString("ContentLength",DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
				rs.updateString("BeginTime",sBeginTime);
				rs.updateString("EndTime",sEndTime);
				rs.updateString("InputUser",CurUser.getUserID());
				rs.updateString("InputOrg",CurUser.getOrgID());
				rs.updateRow();
				rs.getStatement().close();

				if(sFileSaveMode.equals("Table")){ //存放数据表中
					myAmarsoftUpload.getFiles().getFile(0).fileToField(Sqlca,"update DOC_ATTACHMENT set DocContent=? where DocNo='"+docNo+"' and AttachmentNo='"+sAttachmentNo+"'");
				}
				myAmarsoftUpload = null;
			}catch(Exception e){
           	out.println("An error occurs : " + e.toString());
           	sNewSql = "delete FROM doc_attachment WHERE DocNo=:DocNo and AttachmentNo=:AttachmentNo";
           	so = new SqlObject(sNewSql).setParameter("DocNo",docNo).setParameter("AttachmentNo",sAttachmentNo);
           	Sqlca.executeSQL(so);
           	rs.getStatement().close();
           	myAmarsoftUpload = null;

%>          
	          <script type="text/javascript">
	              alert(getHtmlMessage(10));//上传文件失败！
	              parent.openComponentInMe();
	          </script>
<%
     		}
       	}
   	}
%>
<script type="text/javascript">
    alert(getHtmlMessage(13));//上传文件成功！
    parent.openComponentInMe();
</script>
<%@ include file="/IncludeEnd.jsp"%>