 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
 <%@page import="com.amarsoft.app.als.guaranty.model.CollateralAction"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_Info.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow_List.js"></script>
<script type="text/javascript" src="<%=sWebRootPath%>/Common/FunctionPage/js/MultipleObjectWindow.js"></script>
<%	
	String PG_TITLE = "押品权证列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String assetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(assetSerialNo == null) assetSerialNo = "";
	String objectType = CurPage.getParameter("ObjectType");
	if(objectType == null) objectType = "";
	String objectNo = CurPage.getParameter("ObjectNo");
	if(objectNo == null) objectNo = "";
	String docFlag = CurPage.getParameter("DocFlag");
	if(docFlag == null)docFlag = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("AssetSerialNo", assetSerialNo);
	inputParameter.setAttributeValue("DocFlag", docFlag);
	
	//ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List("AssetRightCertList1", inputParameter, CurPage, request);
	//ASDataObject doTemp=dwTemp.getDataObject();
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("AssetRightCertList1", inputParameter,CurPage);
	
	String editSource = CollateralAction.getRightCertSet(assetSerialNo);
	doTemp.setColumnAttribute("CertType", "ColEditSource", editSource);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	dwTemp.ReadOnly = "0";	 //编辑模式
	
	//如果是一类资料出入库管理中查看押品详情不可新增,不可删除 所有权人
	if("DocType".equals(docFlag)){
		 dwTemp.ReadOnly="true";
	}
	
	dwTemp.setParameter("AssetSerialNo", assetSerialNo);
	dwTemp.setParameter("ObjectType", objectType);
	dwTemp.setParameter("ObjectNo", objectNo);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","新增","新增权证","add()","","","",""},
			{"true","All","Button","保存","保存","saveRecord()","","","","",""},
			{"true","All","Button","删除","删除权证","deleteCert()","","","",""}
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
	function add(){
		if("<%=objectNo%>" == ""){
			alert("请先保存押品信息！");
			return;
		}
		ALSObjectWindowFunctions.addRow(0, "", "");
	}
	
	function saveRecord(){
		setItemValue(0,getRow(),"InputUserID","<%=CurUser.getUserID()%>");
		setItemValue(0,getRow(),"InputOrgID","<%=CurUser.getOrgID()%>");
		setItemValue(0,getRow(),"InputDate","<%=com.amarsoft.app.base.util.DateHelper.getToday()%>");
		as_save("");
	}
	
	function deleteCert(){
		var serialno = getItemValue(0,0,"SerialNo");
		if(typeof(serialno)=="undefined" || serialno.length == 0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm('确实要删除吗?')){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.contract.action.DeleteCertInfo", "deleteCert",  "SerialNo="+serialno);
			//ALSObjectWindowFunctions.deleteSelectRow(0);
			if(sReturn == "true"){
				alert("删除成功！");
				reloadSelf();
				return;
			}else{
				alert("删除失败！");
				return;
			}
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 