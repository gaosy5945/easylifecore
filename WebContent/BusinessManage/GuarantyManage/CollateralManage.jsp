 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "押品台账"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String userID = CurUser.getUserID();
	
	
	ASObjectModel doTemp = new ASObjectModel("CollateralManage");
		
	//ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setParameter("InputOrgID", CurUser.getOrgID());
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			{"true","All","Button","押品详情","押品详情","view()","","","",""},
			{"true","All","Button","取消申请","取消申请","cancel()","","","",""},
	};

%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function view(){
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		var assetType = getItemValue(0,getRow(),"AssetType");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条押品信息！");
			return;
		}
		if(assetType.length==0){
			alert("数据信息不完整！");
			return;
		}
		
		var templateNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.credit.apply.action.CollateralTemplate", "getTemplate", "ItemNo="+assetType);
		templateNo = templateNo.split("@");
		if(templateNo[0]=="false"){
			alert("未配置押品类型"+assetType+"的模板！");
			return;
		}
		AsCredit.openFunction("CollateralManage", "AssetSerialNo="+serialNo+"&TemplateNo="+templateNo[1], "");
		reloadSelf();
	}
	
	/*~[Describe=取消任务;InputParam=无;OutPutParam=无;]~*/
	function cancel(){
		var assetSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(assetSerialNo)=="undefined" || assetSerialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var assetEvaInfo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "getEvaInfo","AssetSerialNo="+assetSerialNo);
		if(assetEvaInfo=="false") {
			alert("没有估值任务");
			return;
		}
		
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
				"getEvaFlow","SerialNo="+assetSerialNo);
		
		if(flowSerialNo == "false"){
			var sReturn = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva",
					"delEva","SerialNo="+assetSerialNo);
			
			alert("任务取消成功!");
			return;
		}
		
		if(!confirm("取消申请后不可恢复，请确认！")) return;
		var returnValue = AsControl.RunASMethod("WorkFlowEngine","DeleteBusiness",flowSerialNo);
	
		if(typeof(returnValue) == "undefined" || returnValue.length == 0 || returnValue == "Null") return;
		if(returnValue == "true")
		{
			alert("任务取消成功!");
			reloadSelf();
		}
		else
		{
			alert(returnValue.split("@")[1]);
		}
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 