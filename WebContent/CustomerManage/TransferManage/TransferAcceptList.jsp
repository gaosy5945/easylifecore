<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TransferApproveList");
	doTemp.setVisible("AFFIRMDATE", true);
	doTemp.appendJboWhere(" and TransferType='20'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
	        {"true","","Button","ά��Ȩ�ջ�","�ջ�ά��Ȩ","recover()","","","",""},
			{"true","","Button","�ͻ�����","�鿴�ͻ�����","view()","","","",""}
		};
%> 
<script type="text/javascript">
	/*~[Describe=ά��Ȩ����;InputParam=��;OutPutParam=��;]~*/
	function recover(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		
		var operateType = getItemValue(0,getRow(),"UnOperateType");//��������
		var rightType = getItemValue(0,getRow(),"RightType");//Ȩ������
		if(operateType == "10"){//ת��ʱ�޷��ջ�ά��Ȩ
			alert("��ѡ���������Ϊ\"ת��\"�ļ�¼�����ջ�!");
			return;
		}
		if(rightType == "10"){//�ܻ�Ȩʱ
			alert("��ѡ������Ϊ\"ά��Ȩ\"�ļ�¼�����ջ�!");
			return;
		}
		var customerID = getItemValue(0,getRow(),"CustomerID");
		var param = "userID=<%=CurUser.getUserID()%>,customerID="+customerID+",serialNo="+serialNo+",transferType=20";
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","recover",param);
		if(result == "true"){
			alert("ά��Ȩ�ջسɹ�!");
			reloadSelf();
		}else{
			alert("ά��Ȩ�ջ�ʧ�ܣ�");
		}
	}
	/*~[Describe=�鿴�ͻ���Ϣ;InputParam=��;OutPutParam=��;]~*/
	function view(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
		//AsControl.OpenObject("Customer",customerID,"001");
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
