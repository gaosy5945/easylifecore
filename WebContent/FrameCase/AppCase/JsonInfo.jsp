
<%@ page contentType="text/html; charset=GBK"%>
<%@
 include file="/IncludeBegin.jsp"%>

<%@page import="com.amarsoft.awe.dw.ASObjectModel"%>
<%@page import="com.amarsoft.awe.dw.ASObjectWindow"%>
<%@page import="com.amarsoft.app.als.sys.widget.DoNoObject"%><script type="text/javascript" src="<%=sWebRootPath%>/FrameCase/AppCase/dono.js"></script>
<div id='donoInfo'>ģ�������....</div>
<%
//ProdParaMAInfo  EnterpriseInfo01X
	String dNo = "ApplyInfo1380";
	ASObjectModel doTemp = new ASObjectModel(dNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.genHTMLObjectWindow("00008");
	DoNoObject dono=new DoNoObject(dwTemp);

%>
<a onclick="check()">�鿴JSON</a>
<br/>
<a onclick="save()">����</a>
<div id='tips'></div>
<script type="text/javascript">
/* var doData=[];
	temp1 = {colHeader:"���2",colIndex:"0010",colName:"id",colValue:"1",colEditType:"radio",colEditSource:[{value:"1",text:"��"},{value:"2",text:"��"}]};
	doData.push(temp1);
	temp1 = {colHeader:"���3",colIndex:"0020",colName:"id",colValue:"1",colEditType:"text",colEditSource:[]};
	doData.push(temp1);
	temp1 = {colHeader:"���5",colIndex:"0030",colName:"id",colValue:"1",colEditType:"text",colEditSource:[]};
	doData.push(temp1);
	temp1 = {colHeader:"���6",colIndex:"0040",colName:"id",colValue:"1",colEditType:"text",colEditSource:[]};
	doData.push(temp1); */
	var data=<%=dono.toJSONString()%>;
	//console.log(data);
	
	$("#donoInfo").doinfo("",data);
	
	function check(){
		//console.log(data);
		$("#tips").html(JSON.stringify(data));
	}
	
	function save(){
		AsControl.RunJavaMethodTrans("com.amarsoft.app.als.sys.widget.DoNoObjectAction","doSave",JSON.stringify({"data":data,"dono":"<%=dNo%>"}));
	}
</script>
 <%@ include file="/IncludeEnd.jsp"%>