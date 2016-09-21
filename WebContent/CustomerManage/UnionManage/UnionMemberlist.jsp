<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@page import="com.amarsoft.are.lang.StringX"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String packageNo = CurPage.getParameter("ObjectNo");//��������
	if(StringX.isSpace(packageNo)) packageNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(StringX.isSpace(objectType)) objectType = "";
	String unionID = CurPage.getParameter("CustomerID");
	if(unionID == null) unionID = "";
	String sourceType = CurPage.getParameter("SourceType");
	if(sourceType == null) sourceType = "";
	BizObject bo = null;
	String applyType = "";
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(objectType)){
		CreditObjectAction coa=new CreditObjectAction(packageNo,objectType);
		bo = coa.getCreditObjectBO();//.amarsoft.app.als.process.action.GetApplyParams.getApplyParams(packageNo);
		applyType = bo.getAttribute("ApplyType").getString();
	}
	if(StringX.isSpace(applyType)) applyType = "";
	
	ASObjectModel doTemp = new ASObjectModel("UnionMemberList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(50);
	dwTemp.genHTMLObjectWindow(unionID);
	
	String sButtons[][] = {
		{"true","","Button","��Ա����","��Ա����","viewInfo()","","","","",""},
		{"true","All","Button","�����Ա","�����Ա","imports()","","","","",""},
		{"true","All","Button","�Ƴ���Ա","�Ƴ���Ա","remove()","","","","",""},
		{"false","All","Button","��������","��������","newApply()","","","","",""},
	};
	if(CreditConst.CREDITOBJECT_APPLY_REAL.equals(objectType) && "APPLY".equalsIgnoreCase(sourceType)){
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "true";
	}else if(CreditConst.CREDITOBJECT_APPROVE_REAL.equals(objectType)){
		sButtons[1][0] = "false";
		sButtons[2][0] = "false";
		sButtons[3][0] = "false";
	}
%> 
<script type="text/javascript">	
	/*~[Describe=��Ա����;InputParam=��;OutPutParam=��;]~*/
	function viewInfo(){
		var customerID = getItemValue(0,getRow(),"MemberCustomerID");
		if (typeof(customerID)=="undefined" || customerID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		if("<%=sourceType%>" == "APPLY"){
			var customerName = getItemValue(0,getRow(),"CustomerName");
			var paramString = "ObjectType=Customer&ObjectNo="+customerID+"&ViewID=001";
			if(typeof(parent.parent.parent.addViewTabItem)=="function"){
				parent.parent.parent.addViewTabItem("mCustomerDetail"+customerID,customerName+"�Ŀͻ�����","/Frame/ObjectViewer.jsp",paramString);
				parent.parent.parent.selectTab("mCustomerDetail"+customerID);	
			}else if(typeof(parent.parent.addTabItem)=="function"){
				parent.parent.addTabItem(customerName+"�Ŀͻ�����@"+customerID,"/Frame/ObjectViewer.jsp",paramString);
			}
		}else{
	    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
			//openObject("Customer",customerID,"001");
			reloadSelf();	
		}
	}	
	/*~[Describe=�����Ա;InputParam=��;OutPutParam=��;]~*/
	function imports(){
		//����ǡ��Թ������塱������ͻ��б���ֻ��ʾ�Թ��ͻ�
		//����ǡ����������塱������ͻ��б���ֻ��ʾ���˿ͻ�
		//var sCustomerType = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","getUnionType","unionID=<%=unionID%>");
		//var sReturn = AsControl.PopComp("/CustomerManage/UnionManage/UnionMemberSelList.jsp", "CustomerType="+sCustomerType+"&MultiSelect=false","resizable=yes;dialogWidth=600px;dialogHeight=500px;center:yes;status:no;statusbar:no");
		var customerType = window.parent.getItemValue(0,getRow(),"GroupType1");
		var ct1 = "",ct2 = "";
		if(customerType=="0110"){//�Թ�������
			ct1 = "01";
			ct2 = "01";
		}else if(customerType=="0120"){//����������
			ct1 = "03";
			ct2 = "03";
		}else{//�����ͻ�Ⱥ
			ct1 = "01";
			ct2 = "03";
		}
		var param = "CustomerType1,"+ct1+",CustomerType2,"+ct2+",UserID,<%=CurUser.getUserID()%>";
		var sReturn = setObjectValue("SelectUnionMember",param,"",0,0,"");
		if(typeof(sReturn) == "undefined" || sReturn == "_CLEAR_") return;
		var customerID = sReturn.split("@");
		//����Ƿ��Ѵ����ڱ��ͻ�Ⱥ��
		var sResult = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkInner","unionID=<%=unionID%>,customerID="+customerID);
		if(sResult == "true"){
			alert("�ÿͻ��Ѵ����ڱ��ͻ�Ⱥ�ڣ������ظ����룡");
			return;
		}
		//����Ƿ��Ѵ�����������Ч�ͻ�Ⱥ��
		sResult = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkMemberExist","customerID="+customerID);
		if(sResult == "true" && !confirm("�ÿͻ��Ѵ�������Ч�Ŀͻ�Ⱥ�У��Ƿ�������룿")){
			return;
		}
		sResult = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","importMember","unionID=<%=unionID%>,customerID="+customerID+",userID=<%=CurUser.getUserID()%>,orgID=<%=CurUser.getOrgID()%>");
		if(sResult == "true"){
			alert("����ɹ���");
			reloadSelf();
			setRowCount();
		}else{
			alert("����ʧ��");
		}
	}
	/*~[Describe=�Ƴ���Ա;InputParam=��;OutPutParam=��;]~*/
	function remove(){
		var customerID = getItemValue(0,getRow(),"MemberCustomerID");
		if (typeof(customerID)=="undefined" || customerID.length==0){
			alert("��ѡ��һ����¼��");
			return;
		}
		//��;����������
		var sResult = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkMemberApply","unionID=<%=unionID%>,customerID="+customerID);
		if(sResult == "true"){
			alert("�ó�Ա�´�����;�����������룬�޷��Ƴ���");
			return;
		}
		if(!confirm("ȷ��Ҫ�Ƴ��ó�Ա��")) return;
		sResult = RunJavaMethodTrans("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","removeMember","unionID=<%=unionID%>,customerID="+customerID);
		if(sResult == "true"){
			alert("�Ƴ���Ա�ɹ���");
			reloadSelf();
			setRowCount();
		}else{
			alert("�Ƴ���Աʧ�ܣ�");
		}
	}
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newApply(){
		var applyType = "<%=applyType%>";	
		var packageNo = "<%=packageNo%>";
		var customerID = getItemValue(0,getRow(),"MemberCustomerID");
		var style = "dialogWidth=550px;dialogHeight=480px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;";
		var compID = "NewApply";
		var compURL = "/CreditManage/CreditApply/NewApplyInfo.jsp";
		var returnMessage = popComp(compID,compURL,"ApplyType="+applyType+"&PackageNo="+packageNo+"&MCustomerID="+customerID,style);
		if(!returnMessage|| returnMessage=="_CANCEL_") return;
		returnMessage = returnMessage.split("@");
		var objectNo=returnMessage[0];
		var objectType=returnMessage[1];
        //���������������ˮ�ţ��������������
		var paramString = "ObjectType="+objectType+"&ObjectNo="+objectNo+"&ViewID=001";
		var customerName = getItemValue(0,getRow(),"CustomerName");
		if(typeof(parent.parent.parent.addViewTabItem)=="function"){
			parent.parent.parent.addViewTabItem("memberDetail"+objectNo,customerName+"��ҵ������","/Frame/ObjectViewer.jsp",paramString);
			parent.parent.parent.selectTab("memberDetail"+objectNo);	
		}else if(typeof(parent.parent.addTabItem)=="function"){
			parent.parent.addTabItem(customerName+"��ҵ������@"+objectNo,"/Frame/ObjectViewer.jsp",paramString);
		}
		AsControl.OpenView("/CreditManage/CreditApply/UGMemberApplyList.jsp","PackageNo=<%=packageNo%>&ObjectType=<%=objectType%>","rightdown","");
	}
	function setRowCount(){
		var vCount = getRowCount(0);
		window.parent.setItemValue(0,getRow(),"att01",vCount);
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
