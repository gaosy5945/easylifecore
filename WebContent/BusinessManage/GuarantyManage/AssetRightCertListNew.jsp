 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
 <%@page import="com.amarsoft.app.base.util.ObjectWindowHelper"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
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
	String mode = CurPage.getParameter("Mode");
	if(mode == null)mode = "";
	
	BusinessObject inputParameter = BusinessObject.createBusinessObject();
	inputParameter.setAttributeValue("ObjectType", objectType);
	inputParameter.setAttributeValue("ObjectNo", objectNo);
	inputParameter.setAttributeValue("AssetSerialNo", assetSerialNo);
	inputParameter.setAttributeValue("DocFlag", docFlag);
	
	ASObjectModel doTemp = ObjectWindowHelper.createObjectModel("AssetRightCertList1Temp", inputParameter,CurPage);
	
	ASObjectWindow dwTemp = ObjectWindowHelper.createObjectWindow_List(doTemp, CurPage, request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","新增","新增","add()","","","","btn_icon_add",""},
			{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
			{"true","All","Button","删除","删除","del()","","","","btn_icon_delete",""},
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
		var clrSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.dwhandler.QueryAssetSerialNo", "queryAssetSerialNo", "AssetSerialNo="+"<%=assetSerialNo%>");
		if(clrSerialNo == "No"){
			alert("请先保存押品信息！");
			return;
		}
		AsControl.OpenView("/BusinessManage/GuarantyManage/AssetRightCertInfoNew.jsp","SerialNo=&AssetSerialNo=<%=assetSerialNo%>&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
	}
	function edit(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("请选择一条押品信息！");
			return;
		}
		AsControl.OpenView("/BusinessManage/GuarantyManage/AssetRightCertInfoNew.jsp","SerialNo="+SerialNo+"&AssetSerialNo=<%=assetSerialNo%>&ObjectType=<%=objectType%>&ObjectNo=<%=objectNo%>","_self","");
	}
	function del(){
		var serialno = getItemValue(0,0,"SerialNo");
		if(typeof(serialno)=="undefined" || serialno.length == 0){
			alert("请选择一条记录！");
			return;
		}
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
