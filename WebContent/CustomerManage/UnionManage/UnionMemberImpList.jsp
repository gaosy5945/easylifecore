<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
 	String sCustomerIDs = CurPage.getParameter("CustomerIDs");//����ĳ�Ա��ż���
 	String sShowButron = CurPage.getParameter("Show");
 	String[] sCustomer;
 	String sJboWhere = "";
 	if(sCustomerIDs == null) sCustomerIDs = "";
 	
 	if(!"".equals(sCustomerIDs)){
 		sCustomer = sCustomerIDs.split("$")[0].split("@");
 		String sTempCustomerID;
 		for(int i=0 ; i<sCustomer.length ; i++){
 			sJboWhere += " or O.CustomerID='"+sCustomer[i].split("~")[0]+"'";
 		}
 		if(sCustomerIDs.split("$").length>1){
	 		sCustomer = sCustomerIDs.split("$")[1].split("@");
	 		for(int i=0 ; i<sCustomer.length ; i++){
	 			sJboWhere += " or O.CustomerID='"+sCustomer[i]+"'";
	 		}
 		}
 	}else{
 		sJboWhere = " and 1=2";
 	}
	ASDataObject doTemp = new ASDataObject("UnionTempMemberList");
	doTemp.appendJboWhere(sJboWhere);
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(100);
	//dwTemp.ReadOnly = "1";//ֻ��ģʽ
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//�����Ա   �Ƴ���Ա   ��Ա����
 	 String sButtons[][] = {
          {"true","All","Button","�����Ա","�����Ա","newRecord(0)","","","",""},
          {"true","All","Button","�Ƴ���Ա","�Ƴ���Ա","remove()","","","",""},
          {"true","","Button","��Ա����","��Ա����","viewCustomer()","","","",""}
      };
      
%><%@
include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
<!--
	$(function(){
		if("<%=sCustomerIDs%>" != ""){
			var vCount = getRowCount(0);
			window.parent.setItemValue(0,getRow(),"MemberCount",vCount);
		}
	});
	
	/*~[Describe=�����Ա;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{	
		//����ǡ��Թ��ͻ�Ⱥ��������ͻ��б���ֻ��ʾ�Թ��ͻ�
		//����ǡ����˿ͻ�Ⱥ��������ͻ��б���ֻ��ʾ���˿ͻ�
		var sCustomerType = window.parent.getItemValue(0,getRow(),"UnionType");
		var vCustomers = '';
		var vCustomerIDs = '';
		
		//sDoNo, sArgs, sFields, sSelected, isMulti
		var sReturn = AsControl.PopComp("/CustomerManage/UnionManage/UnionMemberSelList.jsp", "CustomerIDs=<%=sCustomerIDs%>&CustomerType="+sCustomerType+"&MultiSelect=true", "resizable=yes;dialogWidth=600px;dialogHeight=500px;center:yes;status:no;statusbar:no");
		if(typeof(sReturn) == "undefined" || sReturn.length == 0) return;
		members = sReturn.split("$")[0].split("@");
		vCustomers = sReturn.split("$")[1];
		for(var i = 0;i < members.length;i++){
			var customerID = members[i].split("~")[0];
			var customerName = members[i].split("~")[1];
			//���жϸÿͻ��Ƿ������������Ч�Ŀͻ�Ⱥ�У��еĻ���Ҫ��ʾ�û�
			var sResult = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkMemberExist","customerID="+customerID);
			if(sResult == 'true'){//����
				if(confirm("�ͻ���"+customerName+"���Ѵ�������Ч�Ŀͻ�Ⱥ�У��Ƿ�������룿")){
					vCustomerIDs += customerID+"@";
				}else{
					continue;
				}
			}else{//������
				vCustomerIDs += customerID+"@";
			}
		} 
		vCustomers = vCustomerIDs+vCustomers;
		AsControl.OpenPage("/CustomerManage/UnionManage/UnionMemberImpList.jsp", "CustomerIDs="+vCustomers, "_self");
 	}

	/*~[Describe=�Ƴ���Ա;InputParam=��;OutPutParam=��;]~*/
 	function remove()
 	{	
 		var vCustomers = '<%=sCustomerIDs%>';
		var vCustomerId = "";
		var recordArray = getCheckedRows("myiframe0");
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm("�Ƿ�ȷ���Ƴ���Ա?")){
				for(var i=1;i<=recordArray.length;i++){
					vCustomerId = getItemValue(0,recordArray[i-1],"CustomerID");
					vCustomers = vCustomers.replace(vCustomerId, "").replace("@@", "@");
				}
				//���ÿͻ�Ⱥ��Ա����(��ʱ)
				if(vCustomers.substring(0, 1) == "@") vCustomers = vCustomers.substring(1, vCustomers.length);
				if(vCustomers.substring(vCustomers.length, vCustomers.length-1) == "@") vCustomers = vCustomers.substring(0, vCustomers.length-1);
				var vMemberLength = 0;
				if(vCustomers != ""){
					vMemberLength = vCustomers.split("@").length;
				}
				window.parent.setItemValue(0,getRow(),"MemberCount",vMemberLength);
				AsControl.OpenPage("/CustomerManage/UnionManage/UnionMemberImpList.jsp", "CustomerIDs="+vCustomers, "_self");
			}
		}else{
			alert("��ѡ�����Ƴ��Ŀͻ���");
			return;
		}
 	}
 	
 	/*~[Describe=�鿴��Ա����;InputParam=��;OutPutParam=��;]~*/
 	function viewCustomer()
 	{
 		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
 		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
 		{
 			alert("��ѡ��һλ�ͻ���");
 			return;
 		} 
 		AsControl.OpenObject('Customer',sCustomerID);
 	}
 	//����ҳ�����
 	var vParaCust = "<%=sCustomerIDs%>";
 
//-->
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
