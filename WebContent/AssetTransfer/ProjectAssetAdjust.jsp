<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>
<%
	//资产调整，资产追加
	//接收参数
	String sObjectNo = DataConvert.toString(CurComp.getParameter("ObjectNo"));//项目流水号
	String sAssetProjectType = DataConvert.toString(CurPage.getParameter("AssetProjectType"));//项目类型
	String sIsAppend = DataConvert.toString(CurPage.getParameter("isAppend"));//是否资产追加
	
	ASObjectModel doTemp = new ASObjectModel("ProjectAssetRelaList");
	doTemp.setJboWhere("PROJECTNO='"+sObjectNo+"' and status = '010'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.MultiSelect = true;
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
	{"true","All","Button","资产导入","资产导入","assetImport()","","","","",""},
	{"true","All","Button","资产筛选","资产筛选","assetFilter()","","","","",""},
	{"true".equals(sIsAppend)?"false":"true","All","Button","删除","删除","del()","","","","",""},
	{"true".equals(sIsAppend)?"false":"true","All","Button","赎回","赎回","ransom()","","","","",""},
	{"true".equals(sIsAppend)?"false":"true","All","Button","资产赎回测算","资产赎回测算","ransomCal()","","","","",""},
	
	
		};
%> 
<script type="text/javascript">
	//资产导入
	function assetImport(){
		alert("需求未明确，暂未实现");
	}
	
	//资产筛选
	function assetFilter(){
		//TODO 此处查询条件需采取“快速查询”模块，待优化
		var sProjectNo = "<%=sObjectNo%>";
		var sReturn = AsDialog.OpenSelector("SelectUnfinishBD","","");//查询未结清的借据，返回借据流水号
		if(typeof(sReturn) == "undefined" || sReturn == "_CANCEL_") return ;
		
		var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetFilterAction";
		var sJavaMethod = "filter";
		var sParams = "projectNo="+sProjectNo+",serialNos="+sReturn;
		
		var sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
		
		if(sResult.length != 0){
			alert(sResult);
		}
		
		reloadSelf();
	}
	
	//删除
	function del(){
		var recordArray = getCheckedRows(0);//获取勾选的行
		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			if(confirm('确实要删除吗?')){
				for(var i = 1;i <= recordArray.length;i++){
					var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
					relaSerialNos += serialNo+"@";
				}
				alert(relaSerialNos);
				var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetFilterAction";
				var sJavaMethod = "del";
				var sParams = "serialNos="+relaSerialNos;
				
				var sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
				if('true' == sResult){
					alert("删除成功");
					reloadSelf();
				}else{
					alert("删除失败");
				}
			}
		}else{
			alert("请先选择一条记录");
		}
	}
	
	//转出利率设置
	function setOutRate(){
		var recordArray = getCheckedRows(0);//获取勾选的行
		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			for(var i = 1;i <= recordArray.length;i++){
				var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
				relaSerialNos += serialNo+"@";
			}
		}else{
			alert("请先选择一条记录");
			return;
		}
		
		var sReturn = PopPage("/AssetTransfer/SetRateInfo.jsp?relaSerialNos="+relaSerialNos,"","resizable=yes;dialogWidth=400px;dialogHeight=110px;center:yes;status:no;statusbar:no");
		if('true' == sReturn){
			alert("设置成功");
			reloadSelf();
		}
	}
	
	//转出利率批量设置
	function batchSetOutRate(){
		if(confirm('批量设置将对当前项目下的所有资产进行设置,是否确认此操作?')){
			var sProjectNo = '<%=sObjectNo%>';
			var sReturn = PopPage("/AssetTransfer/SetRateInfo.jsp?isBatch=true&ProjectNo="+sProjectNo,"","resizable=yes;dialogWidth=400px;dialogHeight=110px;center:yes;status:no;statusbar:no");
			if('true' == sReturn){
				alert("设置成功");
				reloadSelf();
			}
		}
	}
	
	//资产赎回
	function ransom(){
		var recordArray = getCheckedRows(0);//获取勾选的行
		var projectNo = '<%=sObjectNo%>';
		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			for(var i = 1;i <= recordArray.length;i++){
				var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
				relaSerialNos += serialNo+"@";
			}
		}else{
			alert("请先选择一条记录");
			return;
		}
		//打开 资产赎回信息界面
		var serialNo = getSerialNo("ASSET_RANSOM","SERIALNO");
		AsControl.PopComp("/AssetTransfer/AssetRansomInfo.jsp","relaSerialNos="+relaSerialNos+"&SerialNo="+serialNo+"&ProjectNo="+projectNo,"","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
	}
	
	//资产赎回测算
	function ransomCal(){
		AsControl.OpenView("/AssetTransfer/AssetRansomCalInfo.jsp","","","resizable=yes;dialogWidth=800px;dialogHeight=600px;center:yes;status:no;statusbar:no");
	}
	
	//资产分发
	function assetDistribute(){
		var recordArray = getCheckedRows(0);//获取勾选的行
		var sProjectNo = '<%=sObjectNo%>';
		var relaSerialNos = '';
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1) {
			for(var i = 1;i <= recordArray.length;i++){
				var serialNo = getItemValue(0,recordArray[i-1],"serialNo");
				relaSerialNos += serialNo+"@";
			}
		}else{
			alert("请先选择一条记录");
			return;
		}
		
		//打开 资产分发界面
		var sReturn = PopPage("/AssetTransfer/AssetDistributeInfo.jsp?isBatch=true&ProjectNo="+sProjectNo,"","resizable=yes;dialogWidth=400px;dialogHeight=110px;center:yes;status:no;statusbar:no");
		
		if(typeof(sReturn) != 'undefined' && sReturn.length >= 1){
			var sManageOrgId = sReturn.split("@")[0];
			var sManageUserId = sReturn.split("@")[1];
			
			var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetTransferAction";
			var sJavaMethod = "assetDistribute";
			var sParams = "serialNos="+relaSerialNos+",manageOrgId="+sManageOrgId+",manageUserId="+sManageUserId;
			
			var sResult = RunJavaMethodTrans(sJavaClass,sJavaMethod,sParams);
			if('true' == sResult){
				alert("资产分发成功");
				reloadSelf();
			}else{
				alert("资产分发失败");
			}
		}
		
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
