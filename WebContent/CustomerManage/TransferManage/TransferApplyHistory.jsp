<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("TransferApplyHistoryList");
	doTemp.setJboWhereWhenNoFilter("TRANSFERTYPE='10'");//Ĭ��չʾδȷ�ϵ�����

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","����ת������","����ת������","transferOut()","","","","",""},
			{"true","","Button","����ת������","����ת������","transferIn()","","","","",""},
			{"true","","Button","�ͻ�����","�ͻ�����","view()","","","","",""},
			{"true","","Button","ȡ��ת��","ȡ��ת��","cancel()","","","","",""},
			{"true","","Button","ά��Ȩ����","ά��Ȩ����","recover()","","","","",""}
		};
%> 
<script type="text/javascript">

	/*~[Describe=����ת������;InputParam=��;OutPutParam=��;]~*/
	function transferOut(){
		AsControl.PopComp("/CustomerManage/TransferManage/TransferOutApply.jsp","","resizable=yes;dialogWidth=850px;dialogHeight=680px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}

	/*~[Describe=����ת������;InputParam=��;OutPutParam=��;]~*/
	function transferIn(){
		AsControl.PopComp("/CustomerManage/TransferManage/TransferInApply.jsp","","resizable=yes;dialogWidth=850px;dialogHeight=680px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	/*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function view(){
		var customerID = getItemValue(0,getRow(),"CustomerID");
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
    	AsCredit.openFunction("CustomerDetail","CustomerID="+customerID,"");
		//OpenObject("Customer",customerID,"001");
	}
	/*~[Describe=ȡ��ת��;InputParam=��;OutPutParam=��;]~*/
	function cancel(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		var transferType = getItemValue(0,getRow(),"TransferType");//ת��״̬
		if(transferType != "10"){
			alert("��������ȷ�ϻ��ѱ��ܾ�,�޷�ȡ����");
			return;
		}
		if(confirm("�Ƿ�ȷ��ȡ��ת�����룿")){
			as_delete(0);
		}
	}
	/*~[Describe=ά��Ȩ����;InputParam=��;OutPutParam=��;]~*/
	function recover(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));
			return;
		}
		
		var operateType = getItemValue(0,getRow(),"OperateType");//��������
		var transferType = getItemValue(0,getRow(),"TransferType");//ת��״̬
		var rightType = getItemValue(0,getRow(),"RightType");//Ȩ������
		if(rightType == "10"){//�ܻ�Ȩʱ
			alert("��ѡ������Ϊ\"ά��Ȩ\"�ļ�¼�����ջ�!");
			return;
		}
		if(operateType == "10"){//ת��ʱ�޷��ջ�ά��Ȩ
			alert("��ѡ���������Ϊ\"ת��\"�ļ�¼�����ջ�!");
			return;
		}
		if(transferType != "20"){
			alert("�ü�¼δȷ�ϻ��ѱ��ܾ�,����Ҫ�ջ�ά��Ȩ");
			return;
		}
		var customerID = getItemValue(0,getRow(),"CustomerID");
		var param = "userID=<%=CurUser.getUserID()%>,customerID="+customerID+",serialNo="+serialNo+",transferType="+transferType;
		var result = RunJavaMethodTrans("com.amarsoft.app.als.customer.transfer.action.TransferAction","recover",param);
		if(result == "true"){
			alert("ά��Ȩ�ջسɹ�!");
			reloadSelf();
		}else{
			alert("ά��Ȩ�ջ�ʧ�ܣ�");
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
