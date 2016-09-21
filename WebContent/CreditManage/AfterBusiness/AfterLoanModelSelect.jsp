<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin.jspf"%>
<%@ page import="com.amarsoft.app.als.sys.tools.SYSNameManager"%>
<%@ page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page import="com.amarsoft.dict.als.cache.CodeCache"%>
<%@ page import="com.amarsoft.awe.Configure"%>
<%
//<%=HTMLControls.generateDropDownSelect(sValues, sNames, sDefault)
	//String sFilePath="D:/spdc_workspace/web/WebContent/CreditManage/AfterBusiness/doc/";
    //String sFilePath=ARE.getProperty("AfterLoanFilePath");
    //初始化模板路径
	CurConfig = Configure.getInstance();
	if(CurConfig ==null) throw new Exception("读取配置文件错误！请检查配置文件");
	String realPrepath = CurConfig.getParameter("FileSavePath")+"/AfterLoanReport/";
    int i=0;
    
    List<BizObject> list = JBOFactory.getFactory()
    		.getManager("jbo.sys.CODE_LIBRARY")
    		.createQuery("codeno = :CodeNo")
    		.setParameter("CodeNo", "AfterLoanReportType").getResultList();
    String sValues[]=new String[list.size()];
    String sNames[]=new String[list.size()];
    for(BizObject biz: list){
    	sValues[i]=biz.getAttribute("itemno").toString();
    	sNames[i]=biz.getAttribute("itemName").toString();
    	i++;
    }
%>
<style>
#table td{ border-right:none; border-bottom:none;}
#table{ border-left:none; border-top:none; border-right:none;} 
.td{border-right:none; border-bottom:none;}
</style>
<body>
<table class=table align="center"  valign="middle" width="380" border="1"  bordercolor = "#999999" borderdackcolor="#FFFFFF" cellspacing = "0" id="table">
  <tr height="20px" >
  	<td hight=10px colspan=2></td>
  </tr>
  <tr align="center" valign="middle">
    <td nowarp  align="center" width="160px" bgcolor="#F0F1DE">请选择贷后检查报告模板:</td>
    <td nowarp  bgcolor="#F0F1DE"><select id="stemid",name="stemid">
    	<%=HTMLControls.generateDropDownSelect(sValues, sNames, "") %>
    </select></td>
  </tr>
 
</table>
<table align="center"  valign="middle" width="380" border="0"  bordercolor = "none" borderdackcolor="none" cellspacing = "0" id="table">
<tr height="20px" bordercolor="none">
  	<td hight=10px bordercolor="none" colspan=2></td>
  </tr>
  <tr align="center" >
    <td nowarp align="center" ><%=HTMLControls.generateButton("下载", "下载选中的模板", "download()", "") %></td>
    <td nowarp align="center" ><%=HTMLControls.generateButton("取消", "取消下载模板", "returnBack()", "") %></td>
    </td>
    </tr>
</table>
<p>&nbsp; </p>    
</body>


<script>
	function printPaper(){
		var print = document.getElementById("print");
		 
		if(window.confirm("是否确定要打印？")){
			//打印	  
			//print.style.display = "none";
			window.print();			  
		}
	}
	
	$("#print").mouseenter(function(){
		$("#print").css("backgroundColor","red");
	}).mouseleave(function(){
		$("#print").css("backgroundColor","blue");
	});
	 
	function download(){
		as_fileDownload("<%=realPrepath%>"); 
	}
	function returnBack(){
		self.close();
	}
   
	function as_fileDownload(fileName){
		var filedefine=document.getElementById("stemid");
		var theName=filedefine.options[filedefine.selectedIndex].value;
	  	var sReturn = fileName+theName+".docx";
	  	if(sReturn && sReturn!=""){
	  		var sFormName="form"+AsControl.randomNumber();
	  		var form = document.createElement("form");
	  		form.setAttribute("method", "post");
	  		form.setAttribute("name", sFormName);
	  		form.setAttribute("id", sFormName);
	  		form.setAttribute("action", sWebRootPath + "/servlet/view/file?CompClientID=<%=sCompClientID%>");
			document.body.appendChild(form);
			var sHTML = "";
			//sHTML+="<form method='post' name='"+sFormName+"' id='"+sFormName+"' target='"+targetFrameName+"' action="+sWebRootPath+"/servlet/view/file > ";
			sHTML+="<div style='display:none'>";
			sHTML+="<input name=filename value='"+sReturn+"' >";
			sHTML+="<input name=contenttype value='unknown'>";
			sHTML+="<input name=viewtype value='unkown'>";
			sHTML+="</div>";
			//sHTML+="</form>";
			form.innerHTML=sHTML;
			form.submit();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
