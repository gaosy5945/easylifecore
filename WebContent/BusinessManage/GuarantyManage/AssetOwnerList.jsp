 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "押品所有权人信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(assetSerialNo == null) assetSerialNo = "";
	String mode = CurPage.getParameter("Mode");
	if(mode == null) mode = "";
	String grSerialNo = CurPage.getParameter("GRSerialNo");
	if(grSerialNo == null) grSerialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("AssetOwnerList");
	String docFlag = CurPage.getParameter("DocFlag");if(docFlag == null)docFlag = "";
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	
	//如果是一类资料出入库管理中查看押品详情不可新增,不可删除 所有权人
	String sDocRightType = "";
	if("DocType".equals(docFlag)){
		 dwTemp.ReadOnly="true";
		 sDocRightType = "&RightType=ReadOnly";
	}
	
	dwTemp.setParameter("AssetSerialNo", assetSerialNo);
	dwTemp.genHTMLObjectWindow(assetSerialNo);
	
	String sButtons[][] = {
			{"true","All","Button","新增","新增所有权人","addOwner()","","","",""},
			{"true","","Button","详情","详情","viewOwn()","","","",""},
			{"true","All","Button","删除","删除所有权人","deleteOwner()","","","",""},
			{"true","","Button","所有权人信息","所有权人详情","view()","","","",""}
	};
	
	//如果是一类资料出入库管理中查看押品详情不可新增,不可删除 所有权人
	if("DocType".equals(docFlag)){
			 sButtons[0][0] = "false";
			 sButtons[1][0] = "false";
			 sButtons[2][0] = "false";
	} 
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function addOwner(){
		var clrSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.dwhandler.QueryAssetSerialNo", "queryAssetSerialNo", "AssetSerialNo="+"<%=assetSerialNo%>");
		if(clrSerialNo == "No"){
			alert("请先保存押品信息！");
			return;
		}
		PopPage("/BusinessManage/GuarantyManage/AddAssetOwner.jsp", "AssetSerialNo=<%=assetSerialNo%>&GRSerialNo=<%=grSerialNo%>"+"<%=sDocRightType%>", "dialogHeight=300px;dialogWidth=400px;");
		reloadSelf();
	}
	
	function view(){
		var serialNo = getItemValue(0,getRow(),"SerialNo"); 
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var customerID=getItemValue(0,getRow(),"CustomerID");
		if(customerID == null || customerID.length == 0 || typeof(customerID) == "undefined"){
			alert("该权属人无额外详细信息！");
			return;
		}
		var returnValue = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.customer.action.GetCustInfoFunction", "getFunction", "CustomerID="+customerID);
		returnValue = returnValue.split("@");
		if(returnValue[0] == "false"){
			alert("缺乏此担保人必要信息！");
			return;
		}
		AsCredit.openFunction(returnValue[1],"CustomerID="+customerID+"&RightType=ReadOnly","");
	}

	function viewOwn(){
		var aoSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(aoSerialNo)=="undefined" || aoSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		PopPage("/BusinessManage/GuarantyManage/AddAssetOwner.jsp?AssetOwnerSerialNo="+aoSerialNo+"&AssetSerialNo=<%=assetSerialNo%>&GRSerialNo=<%=grSerialNo%>"+"<%=sDocRightType%>&RightType=<%=CurPage.getParameter("RightType")%>","","dialogHeight=300px;dialogWidth=400px;");
		self.reloadSelf();
	}
	
	function deleteOwner(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(confirm("确定删除该信息吗？")){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.DeletePersonInfo", "deletePerson",  "SerialNo="+serialNo);
			if(sReturn=="true"){
				alert("删除成功！");
				self.reloadSelf();
			}else{
				alert(sReturn);
			}
			//as_delete('0','');
		}
	}
	
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 