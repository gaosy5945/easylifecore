<%@page import="com.amarsoft.app.als.common.util.JBOHelper"%>
<%@page import="com.amarsoft.app.als.edoc.EdocConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载电子合同，请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%
	//获取参数
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";

 	BizObject print = JBOHelper.querySingle(EdocConst.JBO_EDOC_PRINT, "SerialNo=:SerialNo", serialNo);
 	String fullPath = JBOHelper.getAttribute(print, "FullPath").toString();
 	String printCount = JBOHelper.getAttribute(print, "PrintCount").toString();
 	String contentType = JBOHelper.getAttribute(print, "ContentType").toString();
   	if(printCount == null) printCount = "1";
   	 
	java.io.File dFile = new java.io.File(fullPath);
	String fileData = "";
 
	try {
		if(!dFile.exists()) {
%>
			<script type="text/javascript">
				alert("电子合同丢失，请重新生成！");
				self.close();
			</script>
<%		
		} else {
			java.io.InputStream inStream = new FileInputStream(fullPath);		
			int contentLength = (int)dFile.length();
			//修正死循环问题 xjzhao 2010/11/24
			if(contentLength <= 0 || contentLength > 102400)
				contentLength = 102400;
			byte abyte0[] = new byte[contentLength];
			int k = -1;
			while ((k = inStream.read(abyte0, 0, contentLength)) != -1) {
				fileData = fileData + new String(abyte0, "GBK");
				//sFileData = sFileData + new String(abyte0, "UTF-8");
			}
			inStream.close();

			fileData = fileData.replaceAll("\r\n","");
			fileData = fileData.replaceAll("encoding=\"UTF-8\"","encoding=\"GBK\"");
			fileData = fileData.replace("\"","'");
%>
			<script type="text/vbscript">
				function OpenWord2_vbs(myfilename,iCopies)
					On Error Resume Next
					dim wdApp,wdBook
						
					Set wdApp = CreateObject("Word.Application")
					set wdBook = wdApp.Documents.open(myfilename)
					wdApp.Application.ActiveDocument.PrintOut _
								true,_
								false,_
								,_
								,_
								,_
								,_
								,_
								iCopies,_
								,_
								0,_
								,_
								true

					wdBook.close
					wdApp.Quit
				end function
			</script>				
			<script type="text/javascript">
				var mydata = "<%=fileData%>";
				var iCopies = "<%=printCount%>";
				function OpenWord2()
				{
					try {
						var TemporaryFolder = 2;
						var fso = new ActiveXObject("Scripting.FileSystemObject");	
						var tfolder = fso.GetSpecialFolder(TemporaryFolder);
						var fileName = tfolder+"\\"+fso.GetTempName()+".xml";    
						var tfile = fso.CreateTextFile(fileName);	
						tfile.write(mydata);
						tfile.close();	
						OpenWord2_vbs(fileName,iCopies);
					} catch(e) { 
					} finally { 
						self.close(); 
					}
				}
				
				OpenWord2();
			</script>
<%			
		}
	} catch (Exception e1) {
%>
		<script type="text/javascript">
			alert("打印电子合同出错，请联系系统管理员 ！");
			self.close();
		</script>
<%		
	}	
%>

<%@ include file="/IncludeEnd.jsp"%>