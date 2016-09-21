 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "押品保险信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String objectNo = CurPage.getParameter("AssetSerialNo");
	if(objectNo == null) objectNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("AssetInsuranceList");
	String docFlag = CurPage.getParameter("DocFlag");if(docFlag == null)docFlag = "";
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow(objectNo);
	
	String sButtons[][] = {
			{"true","All","Button","新增","新增","newInsurance()","","","",""},
			{"true","","Button","详情","详情","viewInsurance()","","","",""},
			{"true","All","Button","删除","删除","deleteInsurance()","","","",""}
	};
	//如果是一类资料出入库管理中查看押品详情不可新增、删除押品保险信息
	String sDocRightType = "";
	if("DocType".equals(docFlag)){
		sButtons[0][0] = "false";
		sButtons[2][0] = "false";
		sDocRightType = "&RightType=ReadOnly";//modify by lzq 2010330
	}
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function newInsurance(){
		var clrSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.dwhandler.QueryAssetSerialNo", "queryAssetSerialNo", "AssetSerialNo="+"<%=objectNo%>");
		if(clrSerialNo == "No"){
			alert("请先保存押品信息！");
			return;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/InsuranceGuarantyInfo.jsp", "SerialNo=&ObjectType=jbo.app.ASSET_INFO&ObjectNo=<%=objectNo%>"+"<%=sDocRightType%>", "resizable:no;dialogWidth:850px;dialogHeight:450px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	function viewInsurance(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsControl.PopComp("/BusinessManage/GuarantyManage/InsuranceGuarantyInfo.jsp", "SerialNo="+serialNo+"<%=sDocRightType%>", "resizable:no;dialogWidth:850px;dialogHeight:400px;center:yes;status:no;statusbar:no");
	}

	function deleteInsurance(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		if(confirm("确定删除该信息吗？")){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.DeleteInsuranceInfo", "deleteInsurance",  "SerialNo="+serialNo);
			//as_delete("0");
			if(sReturn == "true"){
				alert("删除成功！");
				self.reloadSelf();
			}else{
				alert(sReturn);
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 