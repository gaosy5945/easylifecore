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
	//设置允许用户上传文件大小,单位:字节
	fu.setSizeMax(10000000);
	//设置最多只允许在内存中存储的数据,单位:字节
	fu.setSizeThreshold(4096);
	
	// 设置一旦文件大小超过getSizeThreshold()的值时数据存放在硬盘的目录
	fu.setRepositoryPath(filePath);
	
	String fileEncoding = CurPage.getAttribute("FileEncoding");
	if(StringX.isEmpty(fileEncoding)) fileEncoding="UTF-8";
	fu.setHeaderEncoding(fileEncoding);
	
	File diskTmpFile = new File(filePath);
	if(!diskTmpFile.exists()) diskTmpFile.mkdirs();

	// 开始读取上传信息
	List fileItems = fu.parseRequest(request);
	// 依次处理每个上传的文件
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
alert("导入完成");
self.close();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>