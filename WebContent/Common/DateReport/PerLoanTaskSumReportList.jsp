<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//���ղ���
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//ģ���
	ASObjectModel doTemp = null;
	//doTemp = new ASObjectModel("CLInfoList");
	doTemp = new ASObjectModel(tempNo);
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//dwTemp.setParameter(name, value)
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","view()","","","","",""},
		};
%> 

<script type="text/javascript">
function view(){
	 var serialNo = getItemValue(0,getRow(0),'SERIALNO');
	 var duebillSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
	 var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
	 var putOutDate = getItemValue(0,getRow(0),'PUTOUTDATE');
	 var creditInspectType = getItemValue(0,getRow(0),'INSPECTTYPE');
	 var customerID = getItemValue(0, getRow(0), 'CUSTOMERID');
	 if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert("��������Ϊ�գ�");
		return ;
	 }
	 if(creditInspectType == "01" || creditInspectType == "02"){
		AsCredit.openFunction("FundDirectionInfo","CreditInspectType="+creditInspectType+"&PutOutDate="+putOutDate+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo);
		reloadSelf();
		return;
	 }else if(creditInspectType == "03"){
		 AsCredit.openFunction("RunDirectionInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo);
		 reloadSelf();
		 return;
	 }else {
		 AsCredit.openFunction("ConsumeDirectionInfo","CreditInspectType="+creditInspectType+"&CustomerID="+customerID+"&SerialNo="+serialNo+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo);
		 reloadSelf();
		 return;
	 }
}
</script>

<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
