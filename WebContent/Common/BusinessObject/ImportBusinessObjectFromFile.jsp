<%@page import="com.amarsoft.app.als.businessobject.action.BusinessObjectFactory"%>
<%@ page language="java" contentType="text/html;charset=GBK" pageEncoding="GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>
<%@ page import="java.io.*"%>
<%
	String objectType = CurPage.getParameter("ObjectType");
	String filePath = CurConfig.getConfigure("FileSavePath");
	DiskFileUpload fu = new DiskFileUpload();
	//���������û��ϴ��ļ���С,��λ:�ֽ�
	fu.setSizeMax(10000000);
	//�������ֻ�������ڴ��д洢������,��λ:�ֽ�
	fu.setSizeThreshold(4096);
	
	// ����һ���ļ���С����getSizeThreshold()��ֵʱ���ݴ����Ӳ�̵�Ŀ¼
	fu.setRepositoryPath(filePath);
	
	String fileEncoding = CurPage.getAttribute("FileEncoding");
	if(StringX.isEmpty(fileEncoding)) fileEncoding="UTF-8";
	fu.setHeaderEncoding(fileEncoding);
	
	File diskTmpFile = new File(filePath);
	if(!diskTmpFile.exists()) diskTmpFile.mkdirs();

	// ��ʼ��ȡ�ϴ���Ϣ
	List fileItems = fu.parseRequest(request);
	// ���δ���ÿ���ϴ����ļ�
	Iterator iter = fileItems.iterator();
	while (iter.hasNext()){
		FileItem item = (FileItem) iter.next();
		if (!item.isFormField()) {
			String name = item.getName();
			long size = item.getSize();
			if ((name == null || name.equals("")) && size == 0)
				continue;
			name = "" + System.currentTimeMillis();
			File savedFile = new File(filePath, name);
			item.write(savedFile);
			
			File serverfile = new File(filePath, name);
			FileInputStream fileInputStream= new FileInputStream(serverfile);
			BusinessObjectManager bomanager=BusinessObjectManager.createBusinessObjectManager();
			BusinessObjectFactory.importXMLBusinessObjects(objectType, fileInputStream, bomanager);
			serverfile.delete();
		}
	}
%>
<script type="text/javascript">
alert("�������");
self.close();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>