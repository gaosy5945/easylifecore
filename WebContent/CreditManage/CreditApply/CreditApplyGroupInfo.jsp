<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_info.jspf"%>
<%
	String PG_TITLE = "�ؼ���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	//����������	��������ˮ�š��������͡������š�ҵ�����͡��ͻ����͡��ͻ�ID
	String serialNo = CurPage.getParameter("SerialNo");
	
	String templateNo = CurPage.getParameter("TemplateNo");
	String orgID = CurUser.getOrgID();
	String orgLevel = "";
	String orgName = "";
	ASResultSet rs = Sqlca.getASResultSet("Select OrgLevel,OrgName from ORG_INFO where OrgID = '"+orgID+"'");
	if(rs.next()){
		orgLevel = rs.getStringValue("OrgLevel");
		orgName = rs.getStringValue("OrgName");
	}
	//����ֵת���ɿ��ַ���
	if(templateNo == null) templateNo = "";	
	

	ASObjectModel doTemp = new ASObjectModel(templateNo,"");
	
	doTemp.setDefaultValue("INPUTUSERID", CurUser.getUserID());
	doTemp.setDefaultValue("INPUTORGID", CurUser.getOrgID());
	doTemp.setDefaultValue("INPUTDATE", com.amarsoft.app.base.util.DateHelper.getBusinessDate());
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	dwTemp.setParameter("SerialNo", serialNo);
	dwTemp.genHTMLObjectWindow("");
	dwTemp.replaceColumn("GroupList", "<iframe type='iframe' id=\"GroupList\" name=\"GroupList\" width=\"100%\" height=\"250\" frameborder=\"0\" src=\""+sWebRootPath+"/Blank.jsp\"></iframe>", CurPage.getObjectWindowOutput());
	
	String sButtons[][] = {
		{"true","","Button","����","����","saveRecord()","","","",""},	
	};
	
	
%><%@include file="/Frame/resources/include/ui/include_info.jspf" %>
<script type="text/javascript">
	initAccountingOrgID();
	function initAccountingOrgID(){
		var orgLevel = "<%=orgLevel%>";
		if(orgLevel == "1" || orgLevel == "2"){
			setItemValue(0, getRow(0), "OrgID", "<%=orgID%>");
		}else{
			setItemValue(0, getRow(0), "OrgID", "<%=orgID%>");
			setItemValue(0, getRow(0), "AccountingOrgID", "<%=orgID%>");
			setItemValue(0, getRow(0), "AccountingOrgName", "<%=orgName%>");
		}
		
	}
	function selectAccountingOrgID()
	{
		var returnValue = setObjectValue("SelectAccountBelongOrg","OrgID,<%=orgID%>&FolderSelectFlag=Y","");
		if(typeof(returnValue)=="undefined"||returnValue=="_CANCEL_"
			||returnValue==""||returnValue=="null")
		{
			return;
		}else if(returnValue=="_CLEAR_")
		{
			setItemValue(0, getRow(0), "AccountingOrgID", "");
			setItemValue(0, getRow(0), "AccountingOrgName", "");
		}
		
		var values = returnValue.split("@");
		var orgLevel = RunJavaMethodTrans("com.amarsoft.app.bizmethod.SystemManage","selectOrgLevel","paras=orgID@@"+values[0]);

		if("1"==orgLevel||"2"==orgLevel)
		{
			alert("���к�һ�����в�������Ϊ���˻�����������ѡ��");
			return;
		}else
		{
			setItemValue(0, getRow(0), "AccountingOrgID", values[0]);
			setItemValue(0, getRow(0), "AccountingOrgName", values[1]);
		}
	}
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(){
		var cnt = getItemValue(0,getRow(),"CNT");
		if(parseInt(cnt) <= 1){
			alert("�����������1");
			return;
		}
		
		try{
			if(window.frames["GroupList"].getRowCount(0) != parseInt(cnt))
			{
				alert("��Ա������ʵ��¼���Ա������ͬ��");
				return;
			}
		}catch(e){}
		as_save("myiframe0","afterEvent();");
	}
	
	function afterEvent()
	{
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var businessPriority = getItemValue(0,getRow(),"BusinessPriority");
		var nonstdIndicator = getItemValue(0,getRow(),"NonstdIndicator");
		var accountingOrgID = getItemValue(0,getRow(),"AccountingOrgID");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0) return;
		if(typeof(businessPriority) == "undefined" || businessPriority.length == 0) return;
		if(typeof(nonstdIndicator) == "undefined" || nonstdIndicator.length == 0) return;
		if(typeof(accountingOrgID) == "undefined" || accountingOrgID.length == 0) return;
		
		AsControl.OpenPage("/CreditManage/CreditApply/CreditApplyGroupList.jsp","TemplateNo=ApplyGroupList&GroupSerialNo="+serialNo+"&BusinessPriority="+businessPriority+"&NonstdIndicator="+nonstdIndicator+"&AccountingOrgID="+accountingOrgID,"GroupList");
	}
	
	
	//ѡ��ͻ������Ϣ
	function selectGroup()
	{
		var listType = getItemValue(0,getRow(),"ListType");
		var returnValue = setGridValuePretreat('SelectGroupList',listType+',<%=CurUser.getUserID()%>','SerialNo=SerialNo@ListType=ListType@CustomerName=CustomerName@INPUTORGID=INPUTORGID@INPUTUSERID=INPUTUSERID@INPUTDATE=INPUTDATE','');
		if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
		
		var serialNo = returnValue.split("@")[0];
		
		AsControl.OpenPage("/CreditManage/CreditApply/CreditApplyGroupInfo.jsp","TemplateNo=<%=templateNo%>&SerialNo="+serialNo,"_self");
	}
	
	var businessPriority = getItemValue(0,getRow(),"BusinessPriority");
	if(typeof(businessPriority) == "undefined" || businessPriority.length == 0)
	{
		setItemValue(0,getRow(),"BusinessPriority","01");
	}
	
	var nonstdIndicator = getItemValue(0,getRow(),"NonstdIndicator");
	if(typeof(nonstdIndicator) == "undefined" || nonstdIndicator.length == 0)
	{
		setItemValue(0,getRow(),"NonstdIndicator","01");
	}
	
	afterEvent();
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>