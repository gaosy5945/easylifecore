<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//������ƷΪ���������ô����018���Ĵ������֮��
	//Double Balance = Sqlca.getDouble(new SqlObject("select sum(bd.balance) from business_contract bc,business_duebill bd where bc.contractartificialno=bd.contractserialno and bd.businesstype='018'"));
	//������ƷΪ �����������Ŷ�ȡ���666���ҵ�����ʽΪ������δ����� ��ͬ���֮��
	//Double BusinessSum = Sqlca.getDouble(new SqlObject("select sum(bd.businessSum) from business_contract bc,business_duebill bd where bc.vouchtype = 'D' and bc.businesstype = '666' and bc.contractartificialno = bd.contractserialno and bd.businessstatus in ('L0', 'L11', 'L12', 'L13')"));
	//����N���ڷ��������������ô������
	//Double NBusinessBalance = Balance + BusinessSum;

	ASObjectModel doTemp = new ASObjectModel("CustomerApprovalList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","newCustomerApprove()","","","","btn_icon_add",""},
			{"true","","Button","����","����","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","","Button","Ԥ������������","Ԥ������������","approvalView()","","","","",""},
			{"true","All","Button","��������","��������","importData()","","","","",""},
	};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
function newCustomerApprove(){
	AsControl.PopComp("/ActiveCreditManage/CustomerAppoveManage/CustomerApproveInfo.jsp","","resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
function viewAndEdit(){
	var BatchNo = getItemValue(0,getRow(),"BatchNo");
	if (typeof(BatchNo)=="undefined" || BatchNo.length==0){
		alert("��ѡ��һ����Ϣ��");
		return;
	}
	AsControl.PopComp("/ActiveCreditManage/CustomerAppoveManage/CustomerApproveInfo.jsp","BatchNo="+BatchNo,"resizable=yes;dialogWidth=450px;dialogHeight=300px;center:yes;status:no;statusbar:no");
	reloadSelf();
}
function approvalView(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	var BatchNo = getItemValue(0,getRow(),"BatchNo");
	if (typeof(BatchNo)=="undefined" || BatchNo.length==0){
		alert("��ѡ��һ����Ϣ��");
		return;
	}
	var CustomerBaseType = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerBaseType", "CustomerBaseID="+CustomerBaseID);
	if(CustomerBaseType == "101"){
		templeteNo = "CustomerApprovalInfo_House";
	}else if(CustomerBaseType == "102"){
		templeteNo = "CustomerApprovalInfo_Finance";
	}else if(CustomerBaseType == "103"){
		templeteNo = "CustomerApprovalInfo_Income";
	}
	AsControl.PopPage("/ActiveCreditManage/CustomerAppoveManage/CustomerApproveTableList.jsp","BatchNo="+BatchNo+"&TempleteNo="+templeteNo,"resizable=yes;dialogWidth=1000px;dialogHeight=500px;center:yes;status:no;statusbar:no");
}
function importData(){
	var CustomerBaseID = getItemValue(0,getRow(),"CustomerBaseID");
	var CustomerBaseLevel = getItemValue(0,getRow(),"CustomerBaseLevel");
	var BatchNo = getItemValue(0,getRow(),"BatchNo");
	var ApproveOrgID = getItemValue(0,getRow(),"ApprovalOrgID");
	if (typeof(BatchNo)=="undefined" || BatchNo.length==0){
		alert("��ѡ��һ����Ϣ��");
		return;
	}
	var CustomerBaseType = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.activeCredit.customerBase.SelectCustomerBase", "selectCustomerBaseType", "CustomerBaseID="+CustomerBaseID);
	var pageURL = "/AppConfig/FileImport/FileSelector.jsp";
	if(CustomerBaseType == "101"){
		var parameter = "BATCHNO="+BatchNo+"&CUSTOMERBASEID="+CustomerBaseID+"&APPROVEORGID="+ApproveOrgID+"&CUSTOMERBASELEVEL="+CustomerBaseLevel+"&clazz=jbo.import.excel.CUSTOMERAPPROVALINFO_HOUSE"; 
	}else if(CustomerBaseType == "102"){
		var parameter = "BATCHNO="+BatchNo+"&CUSTOMERBASEID="+CustomerBaseID+"&APPROVEORGID="+ApproveOrgID+"&CUSTOMERBASELEVEL="+CustomerBaseLevel+"&clazz=jbo.import.excel.CUSTOMERAPPROVALINFO_FINANCE";
	}else if(CustomerBaseType == "103"){
		var parameter = "BATCHNO="+BatchNo+"&CUSTOMERBASEID="+CustomerBaseID+"&APPROVEORGID="+ApproveOrgID+"&CUSTOMERBASELEVEL="+CustomerBaseLevel+"&clazz=jbo.import.excel.CUSTOMERAPPROVALINFO_INCOME";
	}
	var dialogStyle = "dialogWidth=650px;dialogHeight=350px;resizable=1;scrollbars=0;status:y;maximize:0;help:0;";
	var sReturn = AsControl.PopComp(pageURL, parameter, dialogStyle);
    reloadSelf();
}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
