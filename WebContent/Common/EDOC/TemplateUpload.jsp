<%@page import="com.amarsoft.awe.common.attachment.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
	myAmarsoftUpload.initialize(pageContext);
	myAmarsoftUpload.upload(); 

	String sDocNo = (String) myAmarsoftUpload.getRequest().getParameter("EDocNo");
	String sDocType = (String) myAmarsoftUpload.getRequest().getParameter("DocType");
	String sFileName = java.net.URLDecoder.decode((String)myAmarsoftUpload.getRequest().getParameter("FileName"), "UTF-8"); //�ļ�����
	
	//�õ�����·�����ļ���
	sFileName = StringFunction.getFileName(sFileName);
	
	String sAttachmentNo = "";
	ASResultSet rs = null;
	rs = Sqlca.getASResultSetForUpdate("SELECT EDOC_DEFINE.* FROM EDOC_DEFINE WHERE EDocNo='" + sDocNo + "'");
	if (rs.next()) {
		if (!myAmarsoftUpload.getFiles().getFile(0).isMissing()) {
			try {
				java.util.Date dateNow = new java.util.Date();
				SimpleDateFormat sdfTemp = new SimpleDateFormat("yyyy/MM/dd hh:mm:ss");
				String sUpdateTime = sdfTemp.format(dateNow);

				String sFileSavePath = CurConfig.getConfigure("FileSavePath");
				String sFullPath = getFullPath(sDocNo, sFileName, sFileSavePath, application);
				myAmarsoftUpload.getFiles().getFile(0).saveAs(sFullPath);
				try{
					java.io.File file = new java.io.File(sFullPath);
					if(file.exists()){
						file.setReadable(true);
						file.setWritable(true);
						file.setExecutable(true);
					}
					java.lang.Runtime.getRuntime().exec("chmod 777 "+sFullPath);
				}catch(Exception e){
					e.printStackTrace();
				}
				rs.updateString("FullPath"+sDocType, sFullPath);
				rs.updateString("FileName"+sDocType, sFileName);
				rs.updateString("ContentType"+sDocType, DataConvert.toString(myAmarsoftUpload.getFiles().getFile(0).getContentType()));
				rs.updateString("ContentLength"+sDocType, DataConvert.toString(String.valueOf(myAmarsoftUpload.getFiles().getFile(0).getSize())));
				rs.updateString("UpdateUser", CurUser.getUserID());
				rs.updateString("UpdateOrg", CurUser.getOrgID());
				rs.updateString("UpdateTime", sUpdateTime);
				rs.updateRow();
				rs.getStatement().close();

				myAmarsoftUpload = null;
			} catch (Exception e) {
				out.println("An error occurs : " + e.toString());
				rs.getStatement().close();
				myAmarsoftUpload = null;
				%>
				<script type="text/javascript">
					alert(getHtmlMessage(10));//�ϴ��ļ�ʧ�ܣ�
					self.close();
				</script>
				<%
			}
		}
	}
%>

<script type="text/javascript">
alert(getHtmlMessage(13));//�ϴ��ļ��ɹ���
top.close();
</script>


<%!//������ز����õ������ļ���ʵ��·��
	String getFullPath(String sDocNo, String sFileName, String sFileSavePath, ServletContext sc) {
		java.io.File dFile = null;
		String sBasePath = sFileSavePath;
		if (!sFileSavePath.equals("")) {
			try {
				dFile = new java.io.File(sBasePath);
				if (!dFile.exists()) {
					dFile.mkdirs();
					ARE.getLog().trace("�������渽���ļ�·��[" + sFileSavePath + "]�����ɹ�����");
					try{
						java.lang.Runtime.getRuntime().exec("chmod 777 "+sBasePath);
					}catch(Exception e){
						e.printStackTrace();
					}
				}
			} catch (Exception e) {
				sBasePath = sc.getRealPath("/WEB-INF/Upload");
				ARE.getLog().trace("�������渽���ļ�·��[" + sFileSavePath + "]�޷�����,�ļ�������ȱʡĿ¼[" + sBasePath + "]��");
			}
		} else {
			sBasePath = sc.getRealPath("/WEB-INF/Upload");
			ARE.getLog().trace("�������渽���ļ�·��û�ж���,�ļ�������ȱʡĿ¼[" + sBasePath + "]��");
		}

		String sFullPath = sBasePath + getMidPath(sDocNo);
		try {
			dFile = new java.io.File(sFullPath);
			if (!dFile.exists()) {
				dFile.mkdirs();
				try{
					java.lang.Runtime.getRuntime().exec("chmod 777 "+sFullPath);
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		} catch (Exception e) {   
			ARE.getLog().trace("�������渽���ļ�����·��[" + sFullPath + "]�޷�������");
		}

		String sFullName = sBasePath + getFilePath(sDocNo, sFileName);
		return sFullName;
	}

	//������ز����õ��м䲿�ֵ�·��
	String getMidPath(String sDocNo) {
		return "";
	}

	//������ز����õ������ļ���
	String getFilePath(String sDocNo, String sShortFileName) {
		String sFileName;
		sFileName = getMidPath(sDocNo);
		sFileName = sFileName + "/" + sShortFileName;
		return sFileName;
	}
%>
<%@ include file="/IncludeEnd.jsp"%>