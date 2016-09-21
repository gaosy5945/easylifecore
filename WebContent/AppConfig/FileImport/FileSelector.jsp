<%@page import="com.amarsoft.app.als.dataimport.xlsimport.ExcelImportManager"%>
<%@ page import="com.amarsoft.are.lang.DataElement"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.are.jbo.*"%>
<%@ include file="/Frame/resources/include/include_begin.jspf" %>
<%
    String clazz = CurPage.getParameter("clazz"); 
    String AreaID = CurPage.getParameter("AreaID"); //城市编号
    String AreaName = CurPage.getParameter("AreaName"); //城市名称
    String specialCustomerType = CurPage.getParameter("SpecialCustomerType");

    String sObjectNo = CurPage.getParameter("ObjectNo");
    String sObjectType = CurPage.getParameter("ObjectType");
	Vector<Parameter> FileVlst=CurComp.getParentComponent().getParameterList();
    String sHtml=""; 
    for (int i =FileVlst.size() - 1; i >= 0; --i)
    {
    	Parameter pa=(Parameter)FileVlst.get(i);
    	String sName=pa.paraName;
    	String sValue=pa.paraValue;
    	sHtml+="  <input type='hidden' name='"+sName+"' value='"+sValue+"'></br>";
    } 
    if(clazz==null||"".equals(clazz))throw new Exception("参数clazz丢失，请检查参数");
    
    
    String[][] sButtons = {
            {"true","All","Button","确定","","executeUpload()","","","",""},
            {"true","","Button","取消","","doCancel()","","","",""}, 
            {"true","","Button","模板下载","","downExcel()","","","",""},
    };
    BizObjectManager manager0 = JBOFactory.getFactory().getManager(clazz);
    ExcelImportManager manager = (ExcelImportManager)manager0;
  	String excelPath=manager.getExcelPath();
  	if(!excelPath.equals(""))
  	{
  	 	excelPath=request.getRealPath(excelPath);
  	    excelPath=StringFunction.replace(excelPath,"\\","/");
  	}else{
  	  		sButtons[2][0]="false"; 
  	}
 
  	
%>
<body style="overflow:hidden;" onload="javascript:ready();" onresize="javascript:changeStyle();">
<form name="Attachment" style="margin-bottom:0px;" enctype="multipart/form-data" action="<%=sWebRootPath%>/AppConfig/FileImport/ExecuteImport.jsp?CompClientID=<%=CurComp.getClientID()%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&SpecialCustomerType=<%=specialCustomerType %>" method="post">
	 <div id='div_tips'></div>
	<div id="ButtonsDiv" style="margin-left:5px;">
		<table>
		<tr>
	    <td> <input type="file" name="File" />
	            <input type="hidden" name="ObjectNo" value='<%=sObjectNo%>' />
                <input type="hidden" name="ObjectType" value='<%=sObjectType%>' />
                <input type="hidden" name="SpecialCustomerType" value='<%=specialCustomerType%>' />
	        </td>
	     <td> <%@ include file="/Frame/resources/include/ui/include_buttonset.jspf" %> 
	     </td>
		</tr>
	</table>
	<ol>
	<li>请按照下载的模板进行数据的导入
	</ol>
		<input type="hidden" name="FileName" />
      <input type='hidden' name='clazz' value='<%=clazz%>'>
      <%=sHtml%>
	</div>
    </form>
<div id='divTips' style='display:none'>正在处理中......</div>
<iframe name="AttachmentList" id="AttachmentList" style="width:100%;" frameborder="0"></iframe>

</body>
<script type="text/javascript">
<!--
    var clazz = "<%=clazz%>";
    function executeUpload(){
    	$("#div_tips").html("");
        var o = document.forms["Attachment"];
        var sFileName = o.File.value;
        o.clazz.value = clazz;
        o.ObjectNo.value = "<%=sObjectNo%>";
        o.ObjectType.value = "<%=sObjectType%>";
        if (typeof(sFileName) == "undefined" || sFileName==""){
        	$("#div_tips").html("<font color=red>"+getBusinessMessage('212')+"</font>");//请选择一个文件名!
            return false;
        }
        var sFormat = ".xls";
		 
		if(sFormat.indexOf(sFileName.substring(sFileName.length,sFileName.length-4))<0){
				//alert("文件类型只能是'.xls'格式,请重新选择...");
				$("#div_tips").html("<font color=red>文件类型只能是'Excel'格式,请重新选择...</font>");
				return;
		}
        var fileSize,divTips;
     	$("#ButtonsDiv").hide();
     	$("#divTips").show();
     //	parent.showMessage("</br></br><font color=red>数据处理中，这需要一段时间,请不要关闭窗口.....</font>");
        return o.submit();
    }
    function downExcel()
    {
    	as_fileDownload("<%=excelPath%>"); 
    }
    function as_fileDownload(fileName){
    	var sReturn = fileName;
    	if(sReturn && sReturn!=""){
    		//alert("sReturn=" + sReturn);
    		var sFormName="form"+AsControl.randomNumber();
    		var targetFrameName=generateIframe();
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
    
    function generateIframe(){
    	var iframeName = "frame"+AsControl.randomNumber();
    	var iframe = document.createElement("iframe");
    	iframe.setAttribute("name", iframeName);
    	iframe.style.display = "none";
    	document.body.appendChild(iframe);
    	return iframeName;
    }
    
    function doCancel(){
    	top.close();
    }

    function ready(){
        changeStyle();
    }
    
    function changeStyle(){
        document.getElementById("AttachmentList").style.height = document.body.clientHeight - document.getElementById("ButtonsDiv").offsetHeight;
    }
    setDialogTitle("导入数据");
//-->
</script>
<%@ include file="/Frame/resources/include/include_end.jspf" %>