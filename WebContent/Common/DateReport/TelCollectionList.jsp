<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//���ղ���
	String tempNo = CurPage.getParameter("TempNo");//ģ���
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel(tempNo);
	//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	//dwTemp.setParameter(name, value)
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.setPageSize(20);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");
	
	
	
	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����","����","view()","","","","",""}
		};
%> 

<script type="text/javascript">

function view(){
	 //var sUrl = "/CreditManage/Collection/CollectionReport.jsp";
	// var varia=getItemValue(0,getRow(0),'SerialNo');
	 //AsControl.PopComp(sUrl,'','');
	var serialNo = getItemValue(0,getRow(0),'SERIALNO');
 	var duebillSerialNo = getItemValue(0,getRow(0),'OBJECTNO');
	var contractSerialNo = getItemValue(0,getRow(0),'CONTRACTSERIALNO');
 	var customerID = getItemValue(0, getRow(0), 'CUSTOMERID');
 	if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
		alert("��������Ϊ�գ�");
		return ;
 	}
	var returnValue = AsCredit.openFunction("CollTaskInfo","ObjcetNo="+duebillSerialNo+"&SerialNo="+serialNo+"&DoFlag=check&CustomerID="+customerID+"&DuebillSerialNo="+duebillSerialNo+"&ContractSerialNo="+contractSerialNo);
	if(returnValue == "true"){
		reloadSelf();
		edit();
	}else reloadSelf();

}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
