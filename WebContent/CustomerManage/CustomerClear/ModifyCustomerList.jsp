 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("CustomerList");
	doTemp.setJboWhere("O.CustomerID=CB.CustomerID");
	doTemp.appendJboWhere(" and CB.UserID=:userID");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //����ΪGrid���
	//dwTemp.ReadOnly = "1";	 //�༭ģʽ
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	//  
 
 

	String sButtons[][] = {
			{"true","","Button","�޸Ŀͻ���Ϣ ","�޸Ŀͻ���Ϣ ","modifyCustomer()","","","","btn_icon_add",""},
			{"true","","Button","����֤������","����֤������","modifyCustomer()","","","","btn_icon_detail",""}, 
			{"true","","Button","�޸Ļ�������","�޸Ļ�������","modifyCustomer()","","","","btn_icon_detail",""}, 
		};
%> 
<script type="text/javascript">
	function add(){
		 var sUrl = "";
		 OpenPage(sUrl,'_self','');
	}
	function edit(){
		 var sUrl = "";
		 OpenPage(sUrl+'?SerialNo=' + getItemValue(0,getRow(0),'SerialNo'),'_self','');
	}

	function modifyCustomer(){
		var customerID=getItemValue(0,getRow(),"CustomerID");
		sPara="CustomerID="+customerID;
		alert(sPara);
		popComp("CustomerChangeInfo","/CustomerManage/CustomerClear/CustomerChangeInfo.jsp",sPara,"");
	}	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>