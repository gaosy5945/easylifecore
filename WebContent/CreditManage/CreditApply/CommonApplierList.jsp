<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>

<%
	String PG_TITLE = "共同申请人列表"; // 浏览器窗口标题 <title> PG_TITLE </title>

	String objectType = CurPage.getParameter("ObjectType");
	String objectNo = CurPage.getParameter("ObjectNo");
	String customerID = CurPage.getParameter("CustomerID");
	String changeFlag = CurPage.getParameter("ChangeFlag");
	String status = CurPage.getParameter("Status");
	String applicantType = CurPage.getParameter("ApplicantType");
	if("".equals(applicantType) || applicantType== null){
		applicantType = "03";
	}
	String sTempletNo= "";
	if("03".equals(applicantType)){
		sTempletNo="CommonApplierList";
	}else if("05".equals(applicantType)){
		sTempletNo="ShareApplyList";
	}
	ASObjectModel doTemp = new ASObjectModel(sTempletNo);
	
	if(status != null && !"".equals(status))
		doTemp.appendJboWhere(" and Status in('"+status.replaceAll("@", "','")+"')");
	
	if("Y".equals(changeFlag))
		doTemp.setVisible( "ChangeFlag", true);
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读

	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.setParameter("CustomerID", customerID);
	dwTemp.setParameter("ApplicantType", applicantType);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = 
		{
		{"true","All","Button","新增","新增共同申请人","newRecord()","","","",""},
		{"true","","Button","共同还款人详情","共同还款人详情","view()","","","",""},
		{"true","All","Button","删除","删除共同申请人","deleteRecord()","","","",""},
		};
%>

<%@include file="/Frame/resources/include/ui/include_list.jspf" %>

<script type="text/javascript">

	function newRecord(){
		AsControl.PopView("/CreditManage/CreditApply/NewCommonApplier.jsp", "ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&CustomerID=<%=customerID%>&ChangeFlag=<%=changeFlag%>&TransCode=006001&ApplicantType=<%=applicantType%>",
				 "dialogWidth:420px;dialogHeight:300px;resizable:yes;scrollbars:no;status:no;help:no");
		reload();
	}

	function deleteRecord(){
		if(!confirm('确实要删除吗?')) return;
		var serialNo = getItemValue(0,getRow(0),"SerialNo");
		if(serialNo != null && serialNo.length != 0)
		{
			if("<%=changeFlag%>" == "Y")
			{
				var changeFlag = getItemValue(0,getRow(),"ChangeFlag");
				if(changeFlag == "原纪录")
				{
					var para = "ObjectType=<%=objectType%>,ObjectNo=<%=objectNo%>,DocumentObjectType=jbo.app.BUSINESS_APPLICANT,DocumentObjectNo="+serialNo+",TransSerialNo=<%=CurPage.getParameter("TransSerialNo")%>,TransCode=006002,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>,Flag=Y";	
					AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.CreateTransaction","create",para);
					reload();
				}
				else if(changeFlag.indexOf("新增") >=0)
				{
					var para = "ObjectType=<%=objectType%>,ObjectNo=<%=objectNo%>,DocumentObjectType=jbo.app.BUSINESS_APPLICANT,DocumentObjectNo="+serialNo+",TransSerialNo=<%=CurPage.getParameter("TransSerialNo")%>,TransCode=006001,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
					var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
					alert(result);
					reload();
				}
				else if(changeFlag.indexOf("减少") >=0)
				{
					var para = "ObjectType=<%=objectType%>,ObjectNo=<%=objectNo%>,DocumentObjectType=jbo.app.BUSINESS_APPLICANT,DocumentObjectNo="+serialNo+",TransSerialNo=<%=CurPage.getParameter("TransSerialNo")%>,TransCode=006002,UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>";
					var result = AsCredit.RunJavaMethodTrans("com.amarsoft.app.lending.bizlets.DeleteTransaction","delete",para);
					alert(result);
					reload();
				}
			}
			else
			{
				as_delete(0,'reload()');
			}
		}
	}

	function reload(){
		self.reloadSelf();
		//AsControl.OpenPage("/CreditManage/CreditApply/CommonApplierList.jsp","ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>&CustomerID=<%=customerID%>&ChangeFlag=<%=changeFlag%>","_self");
	}
	
	function view(){
		var serialNo = getItemValue(0,getRow(),"SerialNo"); 
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var customerID=getItemValue(0,getRow(),"ApplicantID");
		if(customerID == null || customerID.length == 0 || typeof(customerID) == "undefined"){
			alert("该共同还款人无额外详细信息！");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.GetCustInfoFunction", "getFunction", "CustomerID="+customerID);
		returnValue = returnValue.split("@");
		if(returnValue[0] == "false"){
			alert("缺乏此担保人必要信息！");
			return;
		}
		AsCredit.openFunction(returnValue[1],"CustomerID="+customerID,"");
	}
	
 	function mySelectRow(){
 		if("<%=applicantType%>" == "05"){
			var ApplicantID = getItemValue(0,getRow(),"ApplicantID");
			if(typeof(ApplicantID)=="undefined" || ApplicantID.length==0) {
				AsControl.OpenView("/Blank.jsp","TextToShow=请先选择相应的信息!","rightdown","");
			}else{
				AsControl.OpenView("/CreditManage/CreditApply/ShareApplyInfo.jsp","CustomerID="+ApplicantID,"rightdown","");
			}
 		}
	}
 	mySelectRow();
</script>

<%@ include file="/Frame/resources/include/include_end.jspf"%>
