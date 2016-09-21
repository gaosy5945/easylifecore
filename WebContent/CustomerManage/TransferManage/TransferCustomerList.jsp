<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String transferType = CurPage.getParameter("TransferType"); 
	String rightType = CurPage.getParameter("RightType");  
	String customerId = CurPage.getParameter("CustomerID"); 
	if(rightType == null) rightType = "10";
	if(customerId==null) customerId="";
	ASObjectModel doTemp = new ASObjectModel("TransferCustomerList");
	String userID = CurUser.getUserID();
	String orgID = CurUser.getOrgID();
	
	if("10".equals(transferType)){//ת��ʱ,��ʾ��ǰ�û������йܻ��Ŀͻ�
		doTemp.setVisible("UserName", false);
		doTemp.setVisible("OrgName", false);
		doTemp.appendJboWhere(" and cb.UserID='"+userID+"' and Cb.BelongAttribute='1'");
	}else if("20".equals(transferType)){//ת��ʱ,��ʾ��ǰ���������з��Լ��ܻ��Ŀͻ�
		//��Ҫת��ܻ�Ȩʱ,�����Լ�ӵ�йܻ�Ȩ�Ŀͻ�
		if(!customerId.equals("")){//ָ���ͻ�����ʱ
			doTemp.appendJboWhere(" and cb.CustomerID='"+customerId+"' and cb.UserID='"+userID+"'");
		}else{ 
			//ת��ά��Ȩʱ,�����Լ���ӵ�йܻ�Ȩ��ά��Ȩ�Ŀͻ�
			doTemp.appendJboWhere("and cb.BelongAttribute='1' and cb.CustomerID not in "+
				"(select cb2.CustomerID from jbo.app.CUSTOMER_BELONG cb2 where cb2.UserID='"+userID+"' and cb2.BelongAttribute='1')");
			doTemp.appendJboWhere(" and cb.OrgID like '"+orgID+"%'");

		}
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(15);
	dwTemp.MultiSelect = true;
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	};
%> 
<script type="text/javascript">

	/*~[Describe=��ȡѡ�пͻ����(���ϼ�ҳ�����);InputParam=��;OutPutParam=��;]~*/
	function returnCustomers(){
		var returnValue = "";
		var recordArray = getCheckedRows("myiframe0");
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			for(var i=1;i<=recordArray.length;i++){
				vCustomerId = getItemValue(0,recordArray[i-1],"CustomerID");
				vCustomerName = getItemValue(0,recordArray[i-1],"CustomerName");
				//���ͻ��Ƿ����δ�������;ҵ������
				var sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessApply","customerID="+vCustomerId);
				if(sReturn == "true"){
					alert("�ͻ� "+vCustomerName+" ������;��ҵ�����룬������ѡ��");
					return "error";
				}
		     	//���ͻ��Ƿ��δ������ɵ�����
				sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessApprove","customerID="+vCustomerId);
				if(sReturn == "true"){
					alert("�ͻ� "+vCustomerName+" ����δ������ɵ�������������ѡ��");
					return "error";
				}
		     	//���ͻ��Ƿ����δ���Ǽ���ɡ��ĺ�ͬ
				sReturn = RunJavaMethod("com.amarsoft.app.als.customer.common.action.CustomerBusinessCheck","checkBusinessContract","customerID="+vCustomerId);
				if(sReturn == "true"){
					alert("�ͻ� "+vCustomerName+" ����δ���Ǽ���ɡ��ĺ�ͬ��������ѡ��");
					return "error";
				}
				returnValue += vCustomerId+"@";
			}
		}
		return returnValue;
	}

	function reformat(rightType){
		AsControl.OpenPage("/CustomerManage/TransferManage/TransferCustomerList.jsp","TransferType=<%=transferType%>&RightType="+rightType, "_self");
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
