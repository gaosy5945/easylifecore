<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String customerType = CurPage.getParameter("CustomerType");
	String multiSelect = CurPage.getParameter("MultiSelect");
	String customer = CurPage.getParameter("CustomerIDs");
	if(customerType == null) customerType = "";
	if(multiSelect == null) multiSelect = "";
		
	ASObjectModel doTemp = new ASObjectModel("UnionImpMemberList");
	if(customer != null && !"".equals(customer)){
		String sTempSql = "";
		String[] sTempCustomerID = customer.split("@");
		if(sTempCustomerID.length>0){
			for(int i=0;i<sTempCustomerID.length;i++){
				if(sTempCustomerID[i] != null && !"".equals(sTempCustomerID[i])){
					sTempSql += "'"+sTempCustomerID[i]+"',";
				}
			}
			sTempSql = sTempSql.substring(0,sTempSql.length()-1);
			doTemp.appendJboWhere(" and O.CustomerID not in ("+sTempSql+")");
		}
	}

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	if("true".equals(multiSelect)){
		dwTemp.MultiSelect = true;
	}
	
	String param = "";
	if(customerType.equals("0110")){//�Թ�������
		param = "01%,01%";
	}else if(customerType.equals("0120")){//����������
		param = "03%,03%";
	}else{//�����ͻ�Ⱥ
		param = "01%,03%";
	}
	dwTemp.genHTMLObjectWindow(param+","+CurUser.getUserID());
	
	String sButtons[][] = {
			{"true","","Button","ȷ��","ȷ��","doSure()","","","","",""},
			{"true","","Button","ȡ��","ȡ��","cancel()","","","","",""}
		};
	//sButtonPosition = "south";
%> 
<script type="text/javascript">
	/*~[Describe=ȷ��;InputParam=��;OutPutParam=��;]~*/
	function doSure(){
		if(<%="true".equals(multiSelect)%>){
			var recordArray = getCheckedRows("myiframe0");
			var vCustomerId = "";
			var vCustomerName = "";
			var vCustomer = "";
			if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
				for(var i=1;i<=recordArray.length;i++){
						vCustomerId = getItemValue(0,recordArray[i-1],"CustomerID");
						vCustomerName = getItemValue(0,recordArray[i-1],"CustomerName");
					if(i != recordArray.length){
						vCustomer += vCustomerId+"~"+vCustomerName+"@";
					}else{
						vCustomer += vCustomerId+"~"+vCustomerName;
					}
				}
				top.returnValue = vCustomer+'$<%=customer%>';
				top.close();
			}else{
				alert("������ѡ��һ���ͻ���¼��");
				return;
			}	
		}else{
			var customerID = getItemValue(0,getRow(),"CustomerID");
			var customerName = getItemValue(0,getRow(),"CustomerName");
			if(typeof(customerID) == "undefined" || customerID.length == 0){
				alert("������ѡ��һ���ͻ���¼��");
				return;
			}
			top.returnValue = customerID+"@"+customerName;
			top.close();
		}
	}
	
	/*~[Describe=ȡ��;InputParam=��;OutPutParam=��;]~*/
	function cancel(){
		top.close();
	}
	
	/*ʹ�ð�ť����*/
	$(document).ready(function(){
	  //$("#ButtonTR").attr("align","center");
	  //$("#ListButtonArea").attr("align","center");
	});
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
