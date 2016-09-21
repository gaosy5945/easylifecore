<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<html>
<body>
<iframe name="MyAtt" src="<%=sWebRootPath%>/Blank.jsp?TextToShow=正在下载电子合同，请稍候" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"> </iframe>
</body>
</html>
<%
	
	String sSerialNo = DataConvert.toString((String)CurComp.getParameter("SerialNo"));
	
 	String sContentType = "";
 	String sFullPath = "",sPrintCount = "";
 	
 	
  	ASResultSet rs =  Sqlca.getASResultSet("select FullPath,copynum,ContentType from pub_EDOC_PRINT where SerialNo='"+sSerialNo+"'");
	 if(rs.next()){
	   sFullPath = rs.getString("FullPath");
	   sPrintCount = rs.getString("copynum");
	   sContentType = rs.getString("ContentType");
	  }
  	 rs.getStatement().close();
   	 if(sPrintCount==null)sPrintCount = "1";
   	//完整电子合同路径<!------要改------>   	
	if(CurConfig ==null) throw new Exception("读取配置文件错误！请检查配置文件");
	String realPrepath = CurConfig.getParameter("WorkDocOfflineSavePath");		
   	sFullPath = realPrepath+sFullPath;
   	//sFullPath = "D:"+sFullPath;
	java.io.File dFile=new java.io.File(sFullPath);
	String sFileData = "";
 
	try {
		if(!dFile.exists()) {
			ARE.getLog().trace("[EDocViewNew-ERR]文件不存在:"+sFullPath+"!");
			%>
			<script language=javascript>
				alert("电子合同丢失，请重新生成！");
				self.close();
			</script>
			<%		
		}
		else
		{
			java.io.InputStream inStream = new FileInputStream(sFullPath);		
			int iContentLength = (int)dFile.length();
			//修正死循环问题 xjzhao 2010/11/24
			if(iContentLength<=0 || iContentLength>204800)
				iContentLength = 204800;
			byte abyte0[] = new byte[iContentLength];
			int k = -1;
			while ((k = inStream.read(abyte0, 0, iContentLength)) != -1) {
				//sFileData = sFileData + new String(abyte0, "GBK");
				sFileData = sFileData + new String(abyte0, "UTF-8");
			}
			inStream.close();

			sFileData = sFileData.replaceAll("\r\n","");
			sFileData = sFileData.replaceAll("encoding=\"UTF-8\"","encoding=\"GBK\"");
			%>
			

			<script language=vbscript>
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
			<script language=javascript>
				var mydata='<%=sFileData%>';
				var iCopies = '<%=sPrintCount%>';
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
						
						//var wdApp = new ActiveXObject('Word.Application');   
						//var wdBook = wdApp.Documents.open(fileName);	
						
						//--preview,还是使用之前的servlet						
						//wdApp.Application.Visible = true;
						//wdApp.Application.ActiveDocument.PrintPreview();

						//--print
						//wdApp.Application.ActiveDocument.PrintOut();
						//wdBook.Close();
						//wdApp.Quit();
						OpenWord2_vbs(fileName,iCopies)
					}
					catch(e) { 
					}
					finally { 
						self.close(); 
					}
				}	
				
				OpenWord2();
			</script>
			<%			
		}
	}
	catch (Exception e1) 
	{
		ARE.getLog().error("[EDocViewNew-ERR]" + e1.toString());
		%>
		<script language=javascript>
			alert("打印电子合同出错，请联系系统管理员 ！");
			self.close();
		</script>
		<%		
	}	
	
%>

<%@ include file="/IncludeEnd.jsp"%>