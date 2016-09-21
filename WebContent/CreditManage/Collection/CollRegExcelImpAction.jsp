<%@page import="com.amarsoft.app.als.dataimport.xlsimport.ExcelImportManager"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>
<%@page import="com.amarsoft.awe.common.attachment.AmarsoftUpload"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="com.amarsoft.are.jbo.*"%>

<%
    File file = null;
    FileInputStream inputStream = null;
    String sMessage="";
    String sHtml=""; 
    String sPathTemp="";
    try{
        AmarsoftUpload myAmarsoftUpload = new AmarsoftUpload();
        myAmarsoftUpload.initialize(pageContext);
        myAmarsoftUpload.upload();
        Vector<Parameter> vlst=CurPage.parameterList;
		String sParmameName="",sParmameValue="";
        Enumeration  em=   myAmarsoftUpload.getRequest().getParameterNames();
        while(em.hasMoreElements())
        {
        	sParmameName=(String)em.nextElement(); 
        	sParmameValue= (String)myAmarsoftUpload.getRequest().getParameter(sParmameName);
        	
        	
        	Parameter p=new Parameter();
        	p.setName(sParmameName); 
        	p.setValue(sParmameValue);
        	vlst.add(p);
        	CurPage.setAttribute(sParmameName,sParmameValue);
        }
    	
        String clazz = (String)myAmarsoftUpload.getRequest().getParameter("clazz");
        if(clazz==null||"".equals(clazz))throw new Exception("参数clazz丢失，请检查是否传入此参数");

        BizObjectManager manager0 = JBOFactory.getFactory().getManager(clazz);
        ExcelImportManager manager = (ExcelImportManager)manager0;
        
        String filePathName = myAmarsoftUpload.getFiles().getFile(0).getFilePathName();
        String fileName = myAmarsoftUpload.getFiles().getFile(0).getFileName();
        CurPage.setAttribute("FileName",fileName);
        
        String sFileSavePath = CurConfig.getConfigure("FileSavePath");
        if(sFileSavePath==null)throw new Exception("请在als7.xml中配置文件存放路径FileSavePath");
        
        //创建存放目录
        String excelSaveDirectory = sFileSavePath+"/excelimport";
        File saveDic = new File(excelSaveDirectory);//如果没有该目录，则创建
        sPathTemp=saveDic.getAbsolutePath();
        if(!saveDic.exists())saveDic.mkdirs();
        //存文件
       // out.println("document.writeln('文件上传中...<br/>');");
        out.flush();
        String sFileFullPath = excelSaveDirectory+"/"+System.currentTimeMillis()+fileName;
        myAmarsoftUpload.getFiles().getFile(0).saveAs(sFileFullPath);
        file = new File(sFileFullPath);
        
        //解析文件
        //out.println("document.writeln('文件上传完成，正在解析...<br/>');");
        out.flush();
        inputStream = new FileInputStream(file);
        manager.setCurPage(CurPage);
        manager.setCurUser(CurUser);
        manager.setInputStream(inputStream);
        manager.setSheetIndex(0);
        manager.executeImport();
       // out.println("document.writeln('文件解析完成!<br/>');");
        //out.println("alert(getMessageText('AWEW1013'));");//上传文件成功！
      //  out.println("top.returnValue=true;");
        sMessage=manager.getLog();
    }catch(Exception e){
    	ARE.getLog().error("上传并解析文件发生错误",e);
        //out.println("top.returnValue=false;");
        sMessage="导入文件格式不正确:"+e.getMessage()+"<br>"+sPathTemp; 
        //out.println("alert(getMessageText('AWEW1010'));");//上传文件失败！
    }finally{
    	if(inputStream!=null){
            inputStream.close();
            inputStream = null;
    	}
    	if(file!=null){
    		if(file.exists()&&file.isFile()){
    			boolean deleteSucess = file.delete();//完成后，删除文件
    			if(!deleteSucess){
    				ARE.getLog().debug("删除文件["+file.getAbsolutePath()+"]失败，该文件已不再使用，请定期清除");
    			}else{
    				ARE.getLog().trace("删除文件["+file.getAbsolutePath()+"]成功");
    			}
    		}
    	}
       // out.println("top.close();");//上传文件成功！
    }
    String[][] sButtons = {
            {"true","All","Button","返回","","top.close()","","","",""}, 
    };
%>
<table align="left">
   
  <tr>
    <td><%=sMessage %></td> 
  </tr>
  <tr>
    <td><%@ include file="/Frame/resources/include/ui/include_buttonset.jspf" %></td> 
  </tr>
  
</table>

<script type="text/javascript">
	if(!parent.hideMessage) parent.hideMessage();
</script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>