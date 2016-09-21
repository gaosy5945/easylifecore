<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String RightType = CurPage.getParameter("RightType");
	if(RightType == null) RightType = "";

	ASObjectModel doTemp = new ASObjectModel("TogetherWinUnion");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--����ΪGrid���--
	dwTemp.ReadOnly = "1";	 //ֻ��ģʽ
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(20);
   	dwTemp.setParameter("CustomerType", "03");
	dwTemp.genHTMLObjectWindow(SerialNo);

	String sButtons[][] = {
			//0���Ƿ�չʾ 1��	Ȩ�޿���  2�� չʾ���� 3����ť��ʾ���� 4����ť�������� 5����ť�����¼�����	6��	7��	8��	9��ͼ�꣬CSS�����ʽ 10�����
			{"true","All","Button","����ͻ�","����ͻ�","importCustomer()","","","","",""},
			{"true","All","Button","����","����","newCustomer()","","","","btn_icon_add",""},
			{"true","","Button","����","����","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","ɾ��","ɾ��","dealDelete()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	//����ͻ�
	function importCustomer(){
		 var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
	    var returnValue = AsDialog.SelectGridValue('MyImportCustomer',"<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,03",'CUSTOMERID','',true,sStyle,"","1");
	    if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
	    AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.CoWinUnionProject","dealCoWinUnionProject","CustomerID="+returnValue+",SerialNo=<%=SerialNo%>");
	   reloadSelf();
	}
	
	//�ͻ���Ϣ����
	function newCustomer(){
		var customerType = "03";
		var customerID = "";
		var result = CustomerManage.newCustomer1(customerType);
	 	if(result){
			result = result.split("@");
			if(result[0]=="true"){
				CustomerManage.editCustomer(result[1],result[3]);
				customerID = result[1];
			}
	 		AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.CoWinUnionProject","dealCoWinUnionProject","CustomerID="+customerID+",SerialNo=<%=SerialNo%>");
		}
	    reloadSelf();
	}
	//�ͻ���Ϣ����
	function viewAndEdit(){
		var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var customerType = getItemValue(0,getRow(0),"CUSTOMERTYPE");
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert("��ѡ��һ����Ϣ��");
			return;
		}
		 CustomerManage.editCustomer(customerID,"03");
	}
	
	function dealDelete(){
		var customerIDs = '';
		var recordArray = getCheckedRows(0);
	    for(var i = 1;i <= recordArray.length;i++){
		    var customerID = getItemValue(0,recordArray[i-1],"CUSTOMERID");
			if(typeof(customerID)=="undefined" || customerID.length==0){
				alert("��ѡ��һ����Ϣ��");
				return;
			}
			customerIDs += customerID+"@";
		} 
	    
		if(confirm('ȷʵҪɾ����?')){
			
		    AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.CoWinUnionProject","deleteCoWinUnionMember","CustomerID="+customerIDs+",SerialNo=<%=SerialNo%>");
		    //as_delete(0);
		    reloadSelf();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
