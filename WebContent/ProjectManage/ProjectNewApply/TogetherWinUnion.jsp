<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String SerialNo = CurPage.getParameter("SerialNo");
	if(SerialNo == null) SerialNo = "";
	String RightType = CurPage.getParameter("RightType");
	if(RightType == null) RightType = "";

	ASObjectModel doTemp = new ASObjectModel("TogetherWinUnion");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(20);
   	dwTemp.setParameter("CustomerType", "03");
	dwTemp.genHTMLObjectWindow(SerialNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","引入客户","引入客户","importCustomer()","","","","",""},
			{"true","All","Button","新增","新增","newCustomer()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","viewAndEdit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","dealDelete()","","","","btn_icon_delete",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CustomerManage/js/CustomerManage.js"></script>
<script type="text/javascript">
	//引入客户
	function importCustomer(){
		 var sStyle = "dialogWidth:800px;dialogHeight:680px;resizable:yes;scrollbars:no;status:no;help:no";
	    var returnValue = AsDialog.SelectGridValue('MyImportCustomer',"<%=CurUser.getUserID()%>,<%=CurUser.getOrgID()%>,03",'CUSTOMERID','',true,sStyle,"","1");
	    if(!returnValue || returnValue == "_CANCEL_" || returnValue == "_CLEAR_")
			return ;
	    AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.CoWinUnionProject","dealCoWinUnionProject","CustomerID="+returnValue+",SerialNo=<%=SerialNo%>");
	   reloadSelf();
	}
	
	//客户信息新增
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
	//客户信息详情
	function viewAndEdit(){
		var customerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var customerType = getItemValue(0,getRow(0),"CUSTOMERTYPE");
		if(typeof(customerID)=="undefined" || customerID.length==0){
			alert("请选择一条信息！");
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
				alert("请选择一条信息！");
				return;
			}
			customerIDs += customerID+"@";
		} 
	    
		if(confirm('确实要删除吗?')){
			
		    AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.partner.action.CoWinUnionProject","deleteCoWinUnionMember","CustomerID="+customerIDs+",SerialNo=<%=SerialNo%>");
		    //as_delete(0);
		    reloadSelf();
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
