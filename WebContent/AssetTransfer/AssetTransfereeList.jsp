<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//接收参数
	String projectStatus = DataConvert.toString(CurPage.getParameter("projectStatus"));//项目状态
	

	ASObjectModel doTemp = new ASObjectModel("AssetTransfereeList");
	doTemp.setJboWhere("PROJECTTYPE='020' and status='"+projectStatus+"'");
	
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow("SerialNo");
	
	String sButtons[][] = {
	{AssetProjectCodeConstant.AssetProjectStatus_010.equals(projectStatus)?"true":"false","","Button","新增","新增","add()","","","","btn_icon_add",""},
	{"true","","Button","详情","详情","edit()","","","","btn_icon_detail",""},
	{AssetProjectCodeConstant.AssetProjectStatus_010.equals(projectStatus)?"true":"false","","Button","删除","删除","del()","","","","btn_icon_delete",""},
	{AssetProjectCodeConstant.AssetProjectStatus_010.equals(projectStatus)?"true":"false","","Button","下账","下账","keepAccount()","","","","",""},
	
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","项目信息调整","项目信息调整","infoAdjust()","","","","",""},
	{"false","","Button","资产调整","资产调整","assetAdjust()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","资产追加","资产追加","append()","","","","",""},
	{"false","","Button","资产置换","资产置换","replacement()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","资产被赎回","资产被赎回","ransom()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","资产分发","资产分发","distribute()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","还款信息导入","还款信息导入","repaymentInfoImport()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","支出与费用登记","支出与费用登记","costRegister()","","","","",""},
	{AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus)?"true":"false","","Button","返售","返售","fanshou()","","","","",""},
	
	{AssetProjectCodeConstant.AssetProjectStatus_040.equals(projectStatus)?"true":"false","","Button","归档","归档","archive()","","","","",""},
	
	{AssetProjectCodeConstant.AssetProjectStatus_050.equals(projectStatus)?"true":"false","","Button","退档","退档","unarchive()","","","","",""},
	
		};
%> 
<script type="text/javascript">

	function add(){
		var sReturnValue = AsControl.PopComp("/AssetTransfer/AddAssetProjectDialog.jsp","AssetProjectType=020","resizable=yes;dialogWidth=550px;dialogHeight=210px;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	function edit(){
        var serialNo = getItemValue(0,getRow(),"serialNo");
		var sAssetProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
    	if(typeof(serialNo) == "undefined" || serialNo.length == 0){
   			alert("请先选择一条记录");
   			return ;
        }
        
    	var viewID = "001";
		if(!<%=AssetProjectCodeConstant.AssetProjectStatus_010.equals(projectStatus)%>){
			viewID="002";
		}
        paramString = "ObjectNo=" + serialNo + "&ObjectType=AssetProject&AssetProjectType="+sAssetProjectType+"&ViewID="+viewID; 
		AsControl.OpenView("/AssetTransfer/AssetTransferView.jsp",paramString,"_blank");
    	//AsControl.OpenObjectTab(paramString);
    	//AsControl.OpenObject("AssetProject", serialNo, viewID , "");
    	reloadSelf();
    	return ;
	}
	
	//删除
	function del(){
		if(confirm('确实要删除吗?')){
			as_delete(0);
		}
	}
	
	//下账
	function keepAccount(){
		//下账相关处理：生成BC，BP并把相关信息发送核心
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_020%>';
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		if(confirm('确定要进行此操作吗?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status+",assetProjectType=020");
			reloadSelf();
		}
	}
	
	//项目信息调整
	function infoAdjust(){
		var sObjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sAssetProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		if(typeof(sObjectNo) == 'undefined' || sObjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		AsControl.OpenView("/AssetTransfer/AssetTransferInfo.jsp","ObjectNo="+sObjectNo+"&AssetProjectType="+sAssetProjectType,"_blank");
	}
	
	//资产追加
	function append(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		AsControl.OpenView("/AssetTransfer/ProjectAssetAdjust.jsp","ObjectNo="+sProjectNo+"&isAppend=true","_blank");
	}
	
	//资产置换
	function replacement(){
		alert("待实现");
	}
	
	//资产赎回
	function ransom(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		
		AsControl.OpenView("/AssetTransfer/ProjectAssetRelaList.jsp","isRansom=true&ObjectNo="+sProjectNo+"&AssetProjectType=010","_blank");
	}
	
	//资产调整
	function assetAdjust(){
		var serialNo = getItemValue(0,getRow(),"serialNo");
		var sAssetProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
    	var sTransferMethod = getItemValue(0,getRow(),"TransferMethod");
		 
        if(typeof(serialNo) != "undefined" && serialNo.length != 0){
        	var sCompID = "AssetTransfer";
        	var sCompURL = "/AssetTransfer/ProjectAssetRelaList.jsp";
        	var sParamString = "AssetProjectType="+sAssetProjectType+"&TransferMethod="+sTransferMethod+"&SerialNo="+serialNo+"&ViewID=001";
        	
        	OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
        }else{
        	alert("请先选择一条记录");
        }
	}
	
	//资产分发
	function distribute(){
		
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sJavaClass = "com.amarsoft.app.als.assetTransfer.action.AssetTransferAction";
		var sJavaMethod = "getRalativeSerialNo";
		var relaSerialNos = RunJavaMethodTrans(sJavaClass,sJavaMethod,"projectNo=" + sProjectNo);
		if(typeof(relaSerialNos) == 'undefined' || relaSerialNos.length < 1){
			alert("该项目项下资产已经分发完毕！");
			return;
		}
		if(confirm('当前操作将对当前项目下的所有资产进行分发,是否确认此操作?')){
			//打开 资产分发界面
			var sReturn = PopPage("/AssetTransfer/AssetDistributeInfo.jsp?isBatch=true&ProjectNo="+sProjectNo,"","resizable=yes;dialogWidth=400px;dialogHeight=110px;center:yes;status:no;statusbar:no");
			
			if(typeof(sReturn) != 'undefined' && sReturn.length >= 1){
				var sManageOrgId = sReturn.split("@")[0];
				var sManageUserId = sReturn.split("@")[1];
				
				sJavaMethod = "assetDistribute";
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
	}
	
	//还款信息导入
	function repaymentInfoImport(){
		alert("待实现");
	}
	
	//支出与费用登记
	function costRegister(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		
		AsControl.OpenView("/AssetTransfer/AcctFeeLogList.jsp","ObjectNo="+sProjectNo,"_blank");
	}
	
	//返售
	function fanshou(){
		//对回购式的贷款受让项目按返售条件进行返售，完成后，项目阶段更新为已结清。
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sTransferMethod = getItemValue(0,getRow(),"TransferMethod");
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		
		if("010" == sTransferMethod){
			AsControl.OpenView("/AssetTransfer/FanShouInfo.jsp","ProjectNo="+sProjectNo,"","resizable=yes;dialogWidth=500px;dialogHeight=400px;center:yes;status:no;statusbar:no");
		}else{
			alert("只有受让方式为回购式的项目才能返售");
		}
	}
	
	//归档
	function archive(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_050%>';
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		if(confirm('确定要进行此操作吗?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status);
			reloadSelf();
		}
	}
	
	//退档
	function unarchive(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_040%>';
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		if(confirm('确定要进行此操作吗?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status);
			reloadSelf();
		}
	}
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
