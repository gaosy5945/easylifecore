<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="com.amarsoft.xquery.*,org.w3c.dom.*"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Content: --���ͳ�Ʋ�ѯ��ҳ��
		Input Param:
		     type:��ѯ����
		Output param:
		History Log: 
		     ��ҳ���������������ѯѡ���Ҫ�ڱ�ҳ���޸�һЩ�������ݣ�
		         1�������������Ĭ��ֵ��
		         2������е�������ѡ���Ҫ����ѡ���е����ݡ�

	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ͳ�Ʋ�ѯ��ҳ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql="";//--���sql���  
	String environmentOrgID   = CurOrg.getOrgID();//--��ǰ����
	String environmentUserID  = CurUser.getUserID();//--��ǰ�û�
	String environmentOrgName = CurOrg.getOrgName();//--��ǰ��������
	//����������
	String sQueryType  =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));if(sQueryType==null) sQueryType="";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String temp[][] ={
			{"Group","���������б�","none"},{"Display","�����Ϣ��ѡ��",""},{"Summary","�ϼ��ֶ��б�","none"},{"Order","�����ֶ��б�",""}
	};
	String defaultScheme = "default";//-xml�Ŀ��Ʒ�ʽΪdefault
	String defaultStatResult = "2";//--��ѯ��ʽ

	session.putValue("queryType",sQueryType);
	XQuery query = new XQuery(request.getRealPath("")+"/InfoManage/QueryManage/",sQueryType);
	int schemeSize = query.schemes.size();
%>		 	
<script language="JavaScript">
	schemeList = new Array;
	groupColumnList = new Array;
	groupColumnNameList = new Array;
	summaryColumnList = new Array;
	summaryColumnNameList = new Array;
	displayColumnList =  new Array;
	displayColumnNameList = new Array;
	orderColumnList =  new Array;
	orderColumnNameList = new Array;
<%
	for(int i=0; i<schemeSize; i++){
		XScheme currentScheme = (XScheme)query.schemes.get(i);
		out.println("schemeList["+i+"]='"+XAttribute.getAttributeValue(currentScheme.attributes,"name")+"';"+"\r");
		out.println("groupColumnList["+i+"]='"+XAttribute.getAttributeValue(currentScheme.attributes,"groupColumns")+"';"+"\r");
		out.println("summaryColumnList["+i+"]='"+XAttribute.getAttributeValue(currentScheme.attributes,"summaryColumns")+"';"+"\r");
		out.println("displayColumnList["+i+"]='"+XAttribute.getAttributeValue(currentScheme.attributes,"displayColumns")+"';"+"\r");
		out.println("orderColumnList["+i+"]='"+XAttribute.getAttributeValue(currentScheme.attributes,"orderColumns")+"';"+"\r");
		out.println("groupColumnNameList["+i+"]='"+query.getHeaders(XAttribute.getAttributeValue(currentScheme.attributes,"groupColumns"))+"';"+"\r");
		out.println("summaryColumnNameList["+i+"]='"+query.getHeaders(XAttribute.getAttributeValue(currentScheme.attributes,"summaryColumns"))+"';"+"\r");
		out.println("displayColumnNameList["+i+"]='"+query.getHeaders(XAttribute.getAttributeValue(currentScheme.attributes,"displayColumns"))+"';"+"\r");
		out.println("orderColumnNameList["+i+"]='"+query.getHeaders(XAttribute.getAttributeValue(currentScheme.attributes,"orderColumns"))+"';"+"\r");
	}
%>
</script>		 	 			 
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����html��;]~*/%>
<html>
<head>
	<title><%=XAttribute.getAttributeValue(query.attributes,"caption")%>��ѯ</title>
	<style>select {overflow:scroll;overflow-x:scroll;width:165 px}</style>
</head>

<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" style ="overflow-x:scroll;overflow-y:scroll">
	<table align='center' border="0" cellpadding="0" cellspacing="0" width="100%" height="99%" bgcolor='#FFFFFF'>
		<tr valign='top'>
			<td width="750">
				<table align='center' width='100%' border="1" cellspacing="2" cellpadding="0" bgcolor="#FFFFFF" bordercolor="#FFFFFF">
				<form name="Main" method="post" action="<%=sWebRootPath%>/InfoManage/QueryManage/XResult.jsp?CompClientID=<%=CurComp.getClientID()%>" target="Result" >
					<input type=hidden name=CompClientID value="<%=CurComp.getClientID()%>">
					<tr bordercolor="#FFFFFF"><td colspan=2>&nbsp;</td></tr>
					<!-- <tr bordercolor="#FFFFFF">
						<td valign='middle'>&nbsp;<img alt='��ѯ��ǰ����' border='0' src='<%=sWebRootPath%>/InfoManage/QueryManage/xquery.jpg' onclick="javascript:DataSubmit();" style='cursor:hand'>&nbsp;&nbsp;<img alt='�����ǰ����' border='0' src='<%=sWebRootPath%>/InfoManage/QueryManage/xclear.jpg' onclick="javascript:Reset();changeResult(Main.elements['StatResult;;Other;'].value);" style='cursor:hand'>&nbsp;</td>
						<td align='right'bgcolor='#FFFFFF' valign='top'>
							<table border='0'>
								<tr>
									<td nowrap align='right' width=15%>ͳ�Ʒ�ʽ��</td>
									<td width=10% align='left'>
										<select name='StatResult;;Other;'  onchange='javascript:changeResult(this.value)'>
											<option value='2'<%if(defaultStatResult=="2"){out.println("selected");}%>>��ϸ��ѯ</option>
											<option value='1'<%if(defaultStatResult=="1"){out.println("selected");}%>>���ܲ�ѯ</option>
										</select>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					 -->
					<tr bordercolor='#FFFFFF'><td colspan=2 height='20px' bgcolor='#FFFFFF'>&nbsp;</td></tr>
					<%=query.getConditionString(Sqlca,environmentUserID,environmentOrgID)%>
					<tr bordercolor='#FFFFFF'><td colspan=2 height='20px' bgcolor='#FFFFFF'>&nbsp;</td></tr>
<%
	for(int i=0; i<temp.length; i++){
%>
					<tr id=<%=temp[i][0]%>Box style='display:<%=temp[i][2]%>' bordercolor="#CCCCCC">
						<td valign='top' width='25%' bgcolor='#00659C'>
							<table border=0 cellPadding=0 cellSpacing=0  style="CURSOR: hand" width="100%" >
								<TBODY>
								<TR bgColor=#EEEEEE id=<%=temp[i][0]%>SelectTab vAlign=center >
									<TD  align=right valign="middle"><IMG alt="" border=0 id=<%=temp[i][0]%>SelectTab3 onclick="javascript:showHideContent('<%=temp[i][0]%>Select');"  src="<%=sWebRootPath%>/InfoManage/QueryManage/expand.gif" style="CURSOR: hand" width="15" height="15"></TD>
									<TD  align=left height=20 width="100%" valign="middle" onclick="javascript:<%=temp[i][0]%>SelectTab3.click();"><FONT color=#000000 id=<%=temp[i][0]%>SelectTab2 ><span>&nbsp;<%=temp[i][1]%>...</span></TD>
								</TR>
								</TBODY>
    					</TABLE>
						</td>
						<td width='75%' bgcolor='#FFFFFF' valign='top'>
							<span id='<%=temp[i][0]%>SelectEmptyTag' >&nbsp;</span>
							<DIV id=<%=temp[i][0]%>SelectContent style="BORDER-TOP: #cccccc 0px solid;BORDER-BOTTOM: #cccccc 0px solid; BORDER-LEFT: #cccccc 0px solid; BORDER-RIGHT: #cccccc 0px solid; WIDTH: 100%;display:none">
								<TABLE border=0 cellPadding=0 cellSpacing=0 width="100% bgcolor="#FFFFFF">
									<TBODY>
									<TR valign='top'>
										<TD colSpan=3 align="right" bgcolor='#FFFFFF'>
											<textarea  onclick="javascript:do<%=temp[i][0]%>Select();" rows="6" cols="70" name="<%=temp[i][0]%>NameList;;Other;" readonly  value="" ></textarea><input type="hidden" name="<%=temp[i][0]%>List;;Other;"value="">
										</TD>
									</TR>
									</TBODY>
								</TABLE>
							</DIV>
						</td>
					</tr>
<%
	}
%>

					<TR><TD colpsan="2">&nbsp;ָ������</TD><TD colSpan=1><INPUT style="CURSOR: pointer" class=platinputbox onclick="javascript:selectDate('NOTCONDITION_SelectDate')" value="<%=StringFunction.getToday() %>" readOnly name="NOTCONDITION_SelectDate"></TD></TR>
					
					<tr bordercolor="#FFFFFF"><td valign='middle'>&nbsp;<img alt='��ѯ��ǰ����' border='0' src='<%=sWebRootPath%>/InfoManage/QueryManage/xquery.jpg' onclick="javascript:DataSubmit();" style='cursor:hand'>&nbsp;&nbsp;<img alt='�����ǰ����' border='0' src='<%=sWebRootPath%>/InfoManage/QueryManage/xclear.jpg' onclick="javascript:Reset();" style='cursor:hand'>&nbsp;</td></tr>
					<tr bordercolor='#FFFFFF'><td colspan=2 height='20px' bgcolor='#FFFFFF'>&nbsp;</td></tr>
					<tr bordercolor='#FFFFFF'><td colspan=2 height='200px' bgcolor='#FFFFFF'>&nbsp;</td></tr>
				</table>
			</td>
		</tr>
		<form name="ChangeScheme" method="post" action="<%=sWebRootPath%>/InfoManage/QueryManage/XQuery.jsp?CompClientID=<%=CurComp.getClientID()%>" target="_right"></form>
		<IFRAME style="DISPLAY: none" name=Result src="" frameBorder=0 width=100% height=100> </IFRAME>
	</table>
</body>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//	style="DISPLAY: none"
	//---------------------���尴ť�¼�------------------------------------
	//�ַ����滻
	function replace(a,b,c){
		var result="";
		var t = a.split(b);
		for(var i=0; i<t.length; i++){
			if(i==0){
				result = t[i];
			}
			else{
				result = result + c + t[i];
			}
		}
		return result;
	}

	//�ı��ѯ��ʽ
	function changeResult(sValue){
		if (sValue=="2") {
			GroupBox.style.display="none";
			SummaryBox.style.display="none";
			DisplayBox.style.display="none";
			OrderBox.style.display="none";
		}
		else{
			GroupBox.style.display="none";
			SummaryBox.style.display="none";
			DisplayBox.style.display="none";
			OrderBox.style.display="none";
		}
	}

	function showLayer(sLayer){
		if(Main.item(sLayer).style.display=="none") Main.item(sLayer).style.display="";
		else Main.item(sLayer).style.display="none";
	}

	//��ʾ�����ֶ�ѡ���
	function doGroupSelect(){
		sReturn ="";
		iniString=Main.elements["GroupList;;Other;"].value;

		sReturn = PopPage("/InfoManage/QueryManage/XSelect.jsp?Type=GroupBy&selectedString="+Main.elements["GroupList;;Other;"].value+"&rand="+randomNumber(),"","dialogWidth=45;dialogheight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if (sReturn!="" && sReturn != "undefined" ){
			if(sReturn=="@"){
				Main.elements["GroupList;;Other;"].value="";
				Main.elements["GroupNameList;;Other;"].value="";
			}
			else{
				pos = sReturn.indexOf("@");
				if (pos>0){
					Main.elements["GroupNameList;;Other;"].value=sReturn.substring(0,pos);
					Main.elements["GroupList;;Other;"].value=sReturn.substring(pos+1,sReturn.length);
				}
			}
		}
	}

	//��ʾ�ϼ��ֶ�ѡ���
	function doSummarySelect(){
		sReturn ="";
		sReturn = PopPage("/InfoManage/QueryManage/XSelect.jsp?Type=Sum&selectedString="+Main.elements["SummaryList;;Other;"].value+"&rand="+randomNumber(),"","dialogWidth=45;dialogheight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if (sReturn!="" && sReturn != "undefined" ){
			if(sReturn=="@"){
				Main.elements["SummaryList;;Other;"].value="";
				Main.elements["SummaryNameList;;Other;"].value="";

			}
			else{
				pos = sReturn.indexOf("@");
				if (pos>0){
					Main.elements["SummaryNameList;;Other;"].value=sReturn.substring(0,pos);
					Main.elements["SummaryList;;Other;"].value=sReturn.substring(pos+1,sReturn.length);
				}
			}
		}
	}

	//��ʾ��ʾ�ֶ�ѡ���
	function doDisplaySelect(){
		//OpenPage("/InfoManage/QueryManage/XSelect.jsp?selectedString="+Main.elements["DisplayList;;Other;"].value+"&Type=Display&rand="+randomNumber(),"","_blank");
		var sReturn = PopPage("/InfoManage/QueryManage/XSelect.jsp?selectedString="+Main.elements["DisplayList;;Other;"].value+"&Type=Display&rand="+randomNumber(),"","dialogWidth=45;dialogheight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		
		if (sReturn!="" && sReturn != "undefined" ){
			if(sReturn=="@"){
				Main.elements["DisplayList;;Other;"].value="";
				Main.elements["DisplayNameList;;Other;"].value="";
				Main.elements["OrderNameList;;Other;"].value="";
				Main.elements["OrderList;;Other;"].value="";
			}
			else{
				pos = sReturn.indexOf("@");
				if (pos>0){
					Main.elements["DisplayNameList;;Other;"].value=sReturn.substring(0,pos);
					Main.elements["DisplayList;;Other;"].value=sReturn.substring(pos+1,sReturn.length);
					Main.elements["OrderNameList;;Other;"].value="";
					Main.elements["OrderList;;Other;"].value="";
				}
			}
		}
	}

	//��ʾ�����ֶ�ѡ���
	function doOrderSelect(){
		sReturn =PopPage("/InfoManage/QueryManage/XSelect.jsp?VarSelectString="+Main.elements["DisplayList;;Other;"].value+"&selectedString="+Main.elements["OrderList;;Other;"].value+"&Type=OrderBy&rand="+randomNumber(),"","dialogWidth=45;dialogheight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if (sReturn!="" && sReturn != "undefined" ){
			if(sReturn=="@"){
				Main.elements["OrderList;;Other;"].value="";
				Main.elements["OrderNameList;;Other;"].value="";
			}
			else{
				pos = sReturn.indexOf("@");
				if (pos>0){
					Main.elements["OrderNameList;;Other;"].value=sReturn.substring(0,pos);
					Main.elements["OrderList;;Other;"].value=sReturn.substring(pos+1,sReturn.length);
				}
			}
		}
	}

	//�ı��ѯ����
	function changeScheme(name){
		var a11 = document.all.item("GroupSelect"+"Content");
		var a12 = document.all.item("GroupSelect"+"Tab3");
		var a21 = document.all.item("SummarySelect"+"Content");
		var a22 = document.all.item("SummarySelect"+"Tab3");
		var a31 = document.all.item("DisplaySelect"+"Content");
		var a32 = document.all.item("DisplaySelect"+"Tab3");
		var a41 = document.all.item("OrderSelect"+"Content");
		var a42 = document.all.item("OrderSelect"+"Tab3");
		for(var i=0; i<schemeList.length; i++){
			if(schemeList[i]==name){
   			Main.elements["DisplayList;;Other;"].value=displayColumnList[i];
   			Main.elements["DisplayNameList;;Other;"].value=replace(displayColumnNameList[i],"|","\r");
   			if((displayColumnList[i].length>0)&&(a31.style.display == "none")){
   				a32.click();
   			}
   			if((displayColumnList[i].length==0)&&(a31.style.display != "none")){
   				a32.click();
   			}
   			Main.elements["OrderList;;Other;"].value=orderColumnList[i];
   			Main.elements["OrderNameList;;Other;"].value=replace(orderColumnNameList[i],"|","\r");
   			if((a41.style.display == "none")&&(orderColumnList[i].length>0)){
   				a42.click();
   			}
   			if((a41.style.display != "none")&&(orderColumnList[i].length==0)){
   				a42.click();
   			}
   			Main.elements["SummaryList;;Other;"].value=summaryColumnList[i];
   			Main.elements["SummaryNameList;;Other;"].value=replace(summaryColumnNameList[i],"|","\r");
   			if((summaryColumnList[i].length>0)&&(a21.style.display == "none")){
   					a22.click();
   				}
   				if((summaryColumnList[i].length==0)&&(a21.style.display != "none")){
   					a22.click();
   				}
   				Main.elements["GroupList;;Other;"].value=groupColumnList[i];
   				Main.elements["GroupNameList;;Other;"].value=replace(groupColumnNameList[i],"|","\r");
   				if((groupColumnList[i].length>0)&&(a11.style.display == "none")){
   					a12.click();
   				}
   				if((groupColumnList[i].length==0)&&(a11.style.display != "none")){
   					a12.click();
   				}
   				return;
   			}
   		}
	}

	function selectDate(name){
		var date = Main.elements[name].value;
		sReturn ="";
		sReturn = PopPage("/Common/ToolsA/SelectDate.jsp?d="+date,"","dialogWidth=20;dialogheight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sReturn)!="undefined") Main.elements[name].value=sReturn;
	}
	
	function selectMonth(name){
		var date = Main.elements[name].value;
		sReturn ="";
		sReturn = PopPage("/Common/ToolsA/SelectMonth.jsp?d="+date,"","dialogWidth=20;dialogheight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sReturn)!="undefined") Main.elements[name].value=sReturn;
	}
	
	//ѡȡ�е�����
	function DataSubmit(){
		var selectDate = Main.elements["NOTCONDITION_SelectDate"].value;
		if(typeof(selectDate) == "undefined" || selectDate.length == 0)
		{
			alert("����ָ������");
			return;
		}
		if(selectDate < "<%=StringFunction.getToday()%>")
		{
			alert("���ڲ���ѡ���ǹ�ȥ�����޸ġ�");
			return;
		}
		
		if(!confirm("ȷ���������ݶ��Ʋ�ѯ��")) return;
		
		Main.submit();
	}

	//���Կ��Ƽ�������������ʾ������
	function showHideContent(event,id){
		var bMO = false;
		var bOn = false;
		var oTab      = document.all.item(id+"Tab");
		var oTab2     = document.all.item(id+"Tab2");
		var oImage    = document.all.item(id+"Tab3");
		var oContent  = document.all.item(id+"Content");
		var oEmptyTag = document.all.item(id+"EmptyTag");

		if (!oTab || !oTab2 || !oImage || !oContent)
		return;

		if (event.srcElement)
		{
			//bMO = (event.srcElement.src.toLowerCase().indexOf("_mo.gif") != -1);
			bOn = (oContent.style.display.toLowerCase() == "none");
		}

		if (bOn == false)
		{
			oTab.bgColor = "#EEEEEE";
			oTab2.color  = "#000000";
			oContent.style.display = "none";
			if(oEmptyTag)
			{
				oEmptyTag.style.display = "";
			}

			oImage.src = "<%=sWebRootPath%>/InfoManage/QueryManage/expand" + (bMO? ".gif" : ".gif");
		}else
		{
			oTab2.color  = "#ffffff";
			oTab.bgColor = "#00659C";
			oContent.style.display = "";
			if(oEmptyTag)
			{
				oEmptyTag.style.display = "none";
			}
			oImage.src = "<%=sWebRootPath%>/InfoManage/QueryManage/collapse" + (bMO? "_mo.gif" : "_mo.gif");
		}
	}

	//release in 2008/04/10,2008/02/15 for xquery
	//�����б��ѡ��
	function ShowSelect(id,sName){
		var sSelectedCol=Main.elements[id].value+"@@"+Main.elements["NOTCONDITION_"+sName].value;
		
		var sReturn = PopPage("/InfoManage/QueryManage/XSelectX.jsp?ColName="+sName+"&SelectedCol="+sSelectedCol+"","",
					"dialogWidth=25;dialogheight=26;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");		

		if(typeof(sReturn)!= "undefined" && sReturn.length!=0 && sReturn!=""&&sReturn!="XXXXXXXXXXXXXXX"){
			var sTemp1=sReturn.split("@@");
			Main.elements[id].value=sTemp1[0];
			Main.elements["NOTCONDITION_"+sName].value=replace(sTemp1[1],"@",",");
		}else if(typeof(sReturn)== "undefined" || sReturn.length==0 || sReturn=="" ){
			Main.elements[id].value="";
			Main.elements["NOTCONDITION_"+sName].value="";
		}
	}
	
	function Reset(){
		Main.reset();
		for(var k=0;k<Main.elements.length;k++){
			try{
				if(Main.elements[k].name!="StatResult;;Other;")
					Main.elements[k].item(0).text="";
			}
			catch(e){
				var a=1;
			}
		}
		changeScheme('<%=defaultScheme%>');
		changeResult('<%=defaultStatResult%>');
	}
	
	changeScheme('<%=defaultScheme%>');
	changeResult('<%=defaultStatResult%>');

</script>

</html>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>