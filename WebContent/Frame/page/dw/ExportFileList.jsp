<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%><%@
 page import="com.amarsoft.are.jbo.JBOFactory" %><%@
 page import="com.amarsoft.are.jbo.BizObjectManager" %>
<%
	//获取jbo的list
	BizObjectManager bomOne = JBOFactory.getFactory().getManager("jbo.awe.TASK_INFO");
	ASDataObject doTemp = new ASDataObject(bomOne);
	doTemp.setVisible("",false);
	//doTemp.setVisible("SERIALNO,TASKTITLE,STARTUSERID,DOUSERID,STARTTIME,PREENDTIME,TRUEENDTIME,FINISHFLAG,ACTIONTYPE,ACTIONPARAM",true);
	doTemp.setVisible("SERIALNO,TASKTITLE,STARTTIME,TRUEENDTIME,FINISHFLAG",true);//,ACTIONPARAM 不展现具体地址
	doTemp.setJboWhere("DOUSERID=:DOUSERID and CATALOGID='FileDownLoad'");
	doTemp.setJboOrder("SERIALNO DESC");
	doTemp.setDDDWCodeTable("FINISHFLAG","0,否,1,是");
	//doTemp.setDDDWCode("FINISHFLAG","TrueFalse");
	doTemp.setColumnFilter("SERIALNO,FINISHFLAG",true);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.setPageSize(20);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1";//只读模式
	Vector vTemp = dwTemp.genHTMLDataWindow(CurUser.getUserID());
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
			{"true","","Button","下载","下载","download()","","","",""}
	};
%>
<script>
function download(){
	var sFileName = getItemValue(0,getRow(0),"ACTIONPARAM")	;
	as_fileDownload(sFileName);
}

function generateIframe(){
	var iframeName = "frame"+AsControl.randomNumber();
	var iframe = document.createElement("iframe");
	iframe.setAttribute("name", iframeName);
	iframe.style.display = "none";
	document.body.appendChild(iframe);
	return iframeName;
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
		form.setAttribute("target", targetFrameName);
		form.setAttribute("action", sWebRootPath + "/servlet/view/file");
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
<%@
include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
