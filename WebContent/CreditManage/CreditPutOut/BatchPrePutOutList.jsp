<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	//����ƥ�������
	String batchSerialNo = CurPage.getParameter("BatchSerialNo");
	String putOutStatus = CurPage.getParameter("PutOutStatus");
	
	ASObjectModel doTemp = new ASObjectModel("BatchPrePutOutList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.setPageSize(10);
	dwTemp.setParameter("BatchSerialNo", batchSerialNo);
	dwTemp.setParameter("PutOutStatus", putOutStatus);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"02".equals(putOutStatus) ? "true" : "false","","Button","����ƥ��","����ƥ��","match1()","","","",""},
			{"03".equals(putOutStatus) ? "true" : "false","","Button","ƥ��","ƥ��","match2()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function match1(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var certID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			certID = "%"+certID.replace(" ","%")+"%";
			var returnValue =  AsDialog.SelectGridValue('SelectYSContract','<%=CurUser.getOrgID()%>,'+certID,'SerialNo',null,false);
			if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;

			modify(returnValue,serialNo);
		}
	}
	
	function match2(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else{
			var returnValue =  AsDialog.SelectGridValue('SelectUEQContract','<%=CurUser.getOrgID()%>','SerialNo',null,false);
			if(typeof(returnValue)=="undefined" || returnValue.length==0 || returnValue == "_CLEAR_") return;
			
			modify(returnValue,serialNo);
		}
	}
	
	function modify(contractSerialNo,putoutSerialNo){
		var returnValue = AsControl.RunJavaMethodTrans("com.amarsoft.app.als.credit.putout.action.ModifyPutOut","modify","ContractSerialNo="+contractSerialNo+",PutOutSerialNo="+putoutSerialNo);
		AsControl.OpenPage("/CreditManage/CreditPutOut/BatchPrePutOutList.jsp","","_self")
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
