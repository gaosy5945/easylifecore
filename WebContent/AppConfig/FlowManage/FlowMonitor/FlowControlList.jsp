<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/IncludeBegin.jsp"%><%
	/*
		Describe: ���̼���б�
	 */
	String PG_TITLE = "<font color=red>��ҳ���������ϴ���ͨ����ѯ������ѯ</font>@PageTitle";
	String sApproveNeed = CurConfig.getConfigure("ApproveNeed");//��ȡҵ���Ƿ�Ҫ������������������̵ı�־
	
	//���ҳ�����: FlowStatus��01�ڰ�ҵ�� 02���ҵ��
  	String sFlowStatus =  CurPage.getParameter("FlowStatus");  
	if(sFlowStatus == null) sFlowStatus = "";

	ASDataObject doTemp = new ASDataObject("FlowControlList",Sqlca);
	doTemp.WhereClause += " and OrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.getSortNo()+"%') ";
	if(sFlowStatus.equals("01"))
		doTemp.WhereClause += " and PhaseNo not in ('1000','8000') " ;
	else
		doTemp.WhereClause += " and PhaseNo in ('1000','8000') " ;
	//����Filter		
	doTemp.setFilter(Sqlca,"1","FlowName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"2","PhaseName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"3","ObjectNo","Operators=EqualsString,Contains,BeginsWith,EndWith;");
	doTemp.setFilter(Sqlca,"4","UserName","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","OrgName","Operators=EqualsString;HtmlTemplate=PopSelect");
	doTemp.setFilter(Sqlca,"6","InputDate","HtmlTemplate=Date;Operators=BeginsWith,EndWith,BetweenString;");
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sButtons[][] = {
		{"true","","Button","����","����","ViewDetail()","","","",""},
		{"true","","Button","�鿴���","�鿴���","ViewOpinion()","","","",""},
		{"true","","Button","��ת��¼","��ת��¼","ChangeFlow()","","","",""},
		{"false","","Button","ҵ���ƽ�","ҵ���ƽ�","BizTransfer()","","","",""}
	};
	
	if(sFlowStatus.equals("01")){
		sButtons[3][0] = "true";
	}
%><%@include file="/Resources/CodeParts/List05.jsp"%>
<script type="text/javascript">
	function ViewDetail(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			paraString = RunMethod("WorkFlowEngine","GetFlowParaString",sObjectType+","+sObjectNo+",FlowDetailPara");
			paraList = paraString.split("@");
			popComp(paraList[1],paraList[0],paraList[2],"");
		}
	}

	function ViewOpinion(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			paraString = RunMethod("WorkFlowEngine","GetFlowParaString",sObjectType+","+sObjectNo+",FlowOpinionPara");
			paraList = paraString.split("@");
			popComp(paraList[1],paraList[0],paraList[2],"");
		}
	}
	
	<%/*~[Describe=��ת��¼;]~*/%>
	function ChangeFlow(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			popComp("FlowChangeList","/AppConfig/FlowManage/FlowMonitor/FlowChangeList.jsp","ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&FlowStatus="+"<%=sFlowStatus%>","");
			reloadSelf();
		}
	}

	<%/*~[Describe=ҵ���ƽ�;]~*/%>
	function BizTransfer(){
		var sObjectNo   = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType   = getItemValue(0,getRow(),"ObjectType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else{
			sParaStr = "SortNo,"+"<%=CurOrg.getSortNo()%>";
			sReturn= setObjectValue("SelectUserInOrg",sParaStr,"",0,0);	
			if(typeof(sReturn) != "undefined" && sReturn.length != 0 ){
				sReturn = sReturn.split('@');
				sUserID = sReturn[0];
				RunMethod("WorkFlowEngine","ChangeFlowOperator",sObjectNo+","+sObjectType+","+sUserID);
				alert("��ǰҵ�����ƽ����û� "+sUserID);
				reloadSelf();
			}
		}  
	}

	<%/*~[Describe=��ѯ���������Ի���;]~*/%>
	function filterAction(sObjectID,sFilterID,sObjectID2){
		var oMyObj2 = document.getElementById(sObjectID);
		var oMyObj = document.getElementById(sObjectID2);
		if(sFilterID=="1"){
			var sApproveNeed = "<%=sApproveNeed%>";
			if("true" == sApproveNeed){//�жϸñ�ҵ���Ƿ�Ҫ�������������������
				sParaString = "CodeNo"+","+"FlowObject";
				sReturn =setObjectValue("SelectCode",sParaString,"",0,0,"");
			}else{
				sParaString = "CodeNo"+","+"FlowObject"+","+"Attribute1"+","+"SWITapprove";
				sReturn =setObjectValue("SelectCodeFlowObject",sParaString,"",0,0,"");
			}
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				oMyObj2.value=sReturns[1];
				oMyObj.value=sReturns[1];
			}
		}else if(sFilterID=="2"){		
			obj = document.getElementById("1_1_INPUT");
			if(obj.value == ""){
				alert('����ѡ���������ƣ�');
				return;
			}
			sParaString = "FlowName"+","+obj.value;
			sReturn =setObjectValue("SelectPhaseByFlowName",sParaString,"",0,0,"");
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				oMyObj2.value=sReturns[1];
				oMyObj.value=sReturns[1];
			}
		}else if(sFilterID=="5"){		
			sParaString = "OrgID,<%=CurOrg.getOrgID()%>";
			sReturn =setObjectValue("SelectBelongOrg",sParaString,"",0,0,"");
			alert(sReturn);
			if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_"){
				return;
			}else if(sReturn == "_CLEAR_"){
				oMyObj.value = "";
				oMyObj2.value = "";
			}else{				
				sReturns = sReturn.split("@");
				oMyObj2.value=sReturns[1];
				oMyObj.value=sReturns[1];
			}
		}
	}
	
	$(document).ready(function(){
		AsOne.AsInit();
		init();
		my_load(2,0,'myiframe0');
		//showFilterArea();
	});
</script>	
<%@ include file="/IncludeEnd.jsp"%>