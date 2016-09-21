 <%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("CustomerList");
	doTemp.setJboWhere("O.CustomerID=CB.CustomerID");
	doTemp.appendJboWhere(" and CB.UserID=:userID");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(CurUser.getUserID());
	//  
 
 

	String sButtons[][] = {
			{"true","","Button","修改客户信息 ","修改客户信息 ","modifyCustomer()","","","","btn_icon_add",""},
			{"true","","Button","纠正证件号码","纠正证件号码","modifyCustomer()","","","","btn_icon_detail",""}, 
			{"true","","Button","修改机构性质","修改机构性质","modifyCustomer()","","","","btn_icon_detail",""}, 
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