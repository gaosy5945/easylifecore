<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
    String CLASSIFYSTATUS = CurPage.getParameter("Itemno");
	
	ASObjectModel doTemp = new ASObjectModel("DUEBILL_RISK_APPLY");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	
	dwTemp.genHTMLObjectWindow(CLASSIFYSTATUS);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","��������","��������","add()","","","","",""},
			{"true","All","Button","���෽ʽ����","���෽ʽ����","adjust()","","","","",""},
			{"true","All","Button","����������","����������","resultadjust()","","","","",""},
			{"true","All","Button","ȡ������","ȡ������","del()","","","","",""},
			{"true","All","Button","�ύ","�ύ","submit()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function add(){
	var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
    var returnValue = AsDialog.SelectGridValue('ALInspectSelectList',"<%=CurUser.getOrgID()%>,<%=CurUser.getUserID()%>",'SERIALNO','',true,sStyle);
    if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
		return ;
	returnValue = returnValue.split("~");
	for(var i in returnValue){
		if(typeof returnValue[i] ==  "string" && returnValue[i].length > 0 ){
			var parameter = returnValue[i];
    AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertClassifyRecord", "insertClassifyRecord", "SerialNo="+parameter+",ObjectType=jbo.app.BUSINESS_DUEBILL"+",OperateUserID=<%=CurUser.getUserID()%>,OperateOrgID=<%=CurUser.getOrgID()%>");
		}
	}
    reloadSelf();
}

function adjust(){
	var sUrl = "/RiskClassify/DuebillQuery.jsp";
	 var serialNo = getItemValue(0,getRow(0),"SerialNo");
	 OpenPage(sUrl+"?SerialNo="+serialNo,'_self','');
	
	 }
	  
function resultadjust(){
	 var sUrl = "/RiskClassify/DuebillQuery.jsp";
	 var serialNo = getItemValue(0,getRow(0),"SerialNo");
	 OpenPage(sUrl+"?SerialNo="+serialNo,'_self','');
	 }
	 
function del(){
	var serialNo = getItemValue(0,getRow(0),'SerialNo');
	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert("��������Ϊ�գ�");
		return ;
	}
	if(!confirm("ȷ��ȡ��������?")) return;
	as_delete(0);
}

function submit(){
	var serialNo = getItemValue(0,getRow(0),'SerialNo');
	var classifyStatus = getItemValue(0,getRow(0),'ClassifyStatus');
	var userID = "<%=CurUser.getUserID()%>";
	var orgID = "<%=CurOrg.getOrgID()%>";
	if(typeof(serialNo)=="undefined" || serialNo.length==0 )
	{
		alert("��������Ϊ�գ�");
		return ;
	}
	if(!confirm('ȷʵҪ�ύ��?'))return;
	var returnValue = AsControl.RunASMethod("AfterBusiness","RiskAdjustConfirm",serialNo+","+userID+","+orgID);
	if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue.indexOf("@") == -1){
		return;
	}else{
		if(returnValue.split("@")[0] == "true"){
			var serialNo = returnValue.split("@")[1];
			var functionID = returnValue.split("@")[2];
			var flowSerialNo = returnValue.split("@")[3];
			var taskSerialNo = returnValue.split("@")[4];
			var phaseNo = returnValue.split("@")[5];
			var msg = returnValue.split("@")[6];
		}
	}
	var returnValue = PopPage("/Common/WorkFlow/SubmitDialog.jsp?PhaseNo="+phaseNo+"&TaskSerialNo="+taskSerialNo+"&FlowSerialNo="+flowSerialNo,"","dialogWidth:450px;dialogHeight:340px;resizable:yes;scrollbars:no;status:no;help:no");
	if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "_NONE_" || returnValue == "_CLEAR_" || returnValue == "_CANCEL_") 
	{
		return;
	}
	else
	{
		if(returnValue.split("@")[0] == "true")
		{
			AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.afterloan.action.InsertClassifyRecord","finishInspectRecord","SerialNo="+serialNo+",ClassifyStatus="+classifyStatus);
		}
	}
	reloadSelf();
}
	 
	 
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
