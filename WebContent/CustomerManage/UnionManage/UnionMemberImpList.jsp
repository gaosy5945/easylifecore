<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
 	String sCustomerIDs = CurPage.getParameter("CustomerIDs");//引入的成员编号集合
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
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(100);
	//dwTemp.ReadOnly = "1";//只读模式
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//引入成员   移出成员   成员详情
 	 String sButtons[][] = {
          {"true","All","Button","引入成员","引入成员","newRecord(0)","","","",""},
          {"true","All","Button","移出成员","移出成员","remove()","","","",""},
          {"true","","Button","成员详情","成员详情","viewCustomer()","","","",""}
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
	
	/*~[Describe=引入成员;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{	
		//如果是“对公客户群”则引入客户列表中只显示对公客户
		//如果是“个人客户群”则引入客户列表中只显示个人客户
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
			//先判断该客户是否存在其他的有效的客户群中，有的话则要提示用户
			var sResult = RunJavaMethod("com.amarsoft.app.als.customer.union.action.UnionCustomerAction","checkMemberExist","customerID="+customerID);
			if(sResult == 'true'){//存在
				if(confirm("客户："+customerName+"，已存在于有效的客户群中，是否继续引入？")){
					vCustomerIDs += customerID+"@";
				}else{
					continue;
				}
			}else{//不存在
				vCustomerIDs += customerID+"@";
			}
		} 
		vCustomers = vCustomerIDs+vCustomers;
		AsControl.OpenPage("/CustomerManage/UnionManage/UnionMemberImpList.jsp", "CustomerIDs="+vCustomers, "_self");
 	}

	/*~[Describe=移除成员;InputParam=无;OutPutParam=无;]~*/
 	function remove()
 	{	
 		var vCustomers = '<%=sCustomerIDs%>';
		var vCustomerId = "";
		var recordArray = getCheckedRows("myiframe0");
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm("是否确定移出成员?")){
				for(var i=1;i<=recordArray.length;i++){
					vCustomerId = getItemValue(0,recordArray[i-1],"CustomerID");
					vCustomers = vCustomers.replace(vCustomerId, "").replace("@@", "@");
				}
				//设置客户群成员个数(临时)
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
			alert("请选择需移出的客户！");
			return;
		}
 	}
 	
 	/*~[Describe=查看成员详情;InputParam=无;OutPutParam=无;]~*/
 	function viewCustomer()
 	{
 		var sCustomerID = getItemValue(0,getRow(),"CustomerID");
 		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0) 
 		{
 			alert("请选择一位客户！");
 			return;
 		} 
 		AsControl.OpenObject('Customer',sCustomerID);
 	}
 	//供父页面调用
 	var vParaCust = "<%=sCustomerIDs%>";
 
//-->
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
