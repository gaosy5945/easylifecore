 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "����Ѻ��Ϣ�Ǽ�"; // ��������ڱ��� <title> PG_TITLE </title>
	String status = CurPage.getParameter("Status");
	if(status == null) status = "";
	int statusNo = status.split(",").length;
	String statusStr = "";
	for(int i=0;i<statusNo;i++){
		statusStr += status.split(",")[i];
		statusStr += "','";
	}
	statusStr = statusStr.substring(0, statusStr.length()-3);
	
	ASObjectModel doTemp = new ASObjectModel("CollateralRegisterList");
	doTemp.appendJboWhere(" and O.Status in ('"+statusStr+"') ");
	
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");//
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","��Ѻ�Ǽ�","����","handle()","","","",""},
			{"true","All","Button","������ͬ����","�鿴������Ϣ����","viewAndEdit()","","","",""},
			{"false","All","Button","���ϲ�ɨ","���ϲ�ɨ","scan()","","","",""},
			{"false","All","Button","��Ѻ�Ǽ�����","����","view()","","","",""},
	};

	if(status.equals("06")){
		sButtons[2][0] = "false";
		sButtons[0][0] = "false";
		sButtons[3][0] = "true";
	}
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function handle(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		/* AsControl.OpenComp("/Common/FunctionPage/FunctionObjectWindow.jsp", "SYS_FUNCTIONID=CollateralRegister&"
				+"SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo, "", ""); */
		var assetType = getItemValue(0,getRow(),"AssetType");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("δ����ѺƷ����"+assetType+"��ģ�壡");
			return;
		}
		AsCredit.openFunction("CollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&TemplateNo="+templateNo[1]+"&Status=<%=status%>", "");
		reloadSelf();
	}
	
	function view(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetSerialNo = getItemValue(0,getRow(),"AssetSerialNo");
		/* AsControl.OpenComp("/Common/FunctionPage/FunctionObjectWindow.jsp", "SYS_FUNCTIONID=CollateralRegister&"
				+"SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo, "", ""); */
		var assetType = getItemValue(0,getRow(),"AssetType");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			 alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("δ����ѺƷ����"+assetType+"��ģ�壡");
			return;
		}
		AsCredit.openFunction("CollateralRegisterHandle", "SerialNo="+serialNo+"&AssetSerialNo="+assetSerialNo+"&TemplateNo="+templateNo[1]+"&Status=<%=status%>&RightType=ReadOnly", "");
		reloadSelf();
	}
	
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"GCSerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/NormalGCInfo.jsp", "SerialNo="+serialNo, "resizable:no;dialogWidth:850px;dialogHeight:400px;center:yes;status:no;statusbar:no");
		//AsCredit.openFunction("ContractInfo", "RightType=ReadOnly&ObjectType=jbo.app.BUSINESS_CONTRACT&ObjectNo="+serialNo, "", "");
	}
	
	function scan(){
		var gcSerialNo=getItemValue(0,getRow(),"GCSerialNo");
		var contractArtificialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.GuarantyContractAction", "getBCArtificialNo", "GCSerialNo="+gcSerialNo);
		OpenPage("/ImageManage/ImagePage.jsp?ImageCodeNo="+contractArtificialNo+"&QueryType=02","","");
		
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 