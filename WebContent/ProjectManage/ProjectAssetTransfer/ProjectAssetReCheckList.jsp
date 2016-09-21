<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//接收参数
	String projectStatus = DataConvert.toString(CurPage.getParameter("ProjectStatus"));//项目状态
	String periodStatus = DataConvert.toString(CurPage.getParameter("PeriodStatus"));//过程状态
	String isCal = DataConvert.toString(CurPage.getParameter("isCal"));//是否为测算
	
	String isReCheck = DataConvert.toString(CurPage.getParameter("isReCheck"));//是否为筛选复核
	String projectAssetStatus = DataConvert.toString(CurPage.getParameter("ProjectAssetStatus"));//是否为筛选待复核
	 
	ASObjectModel doTemp = null;
	doTemp = new ASObjectModel("ProjectAssetReCheckList");

	//doTemp.setJboWhere("PROJECTTYPE='010' and status='"+projectStatus+"'");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	//dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.MultiSelect = true;
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(projectAssetStatus);
	
	String sButtons[][] = {
		{"true".equals(isReCheck)?"true":"false","","Button","资产详情","资产详情","assetDetail()","","","","",""},
		{(AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus))&&(("01".equals(projectAssetStatus)))?"true":"false","","Button","签署意见","签署意见","signAdvice()","","","","",""},
		{(AssetProjectCodeConstant.AssetProjectStatus_020.equals(projectStatus))&&(("01".equals(projectAssetStatus)))?"true":"false","","Button","复核通过","复核通过","checkSubmit()","","","","",""},
		{"true".equals(isCal)?"true":"false","","Button","项目测算","项目测算","projectCal()","","","","",""},
	};
%> 
<script type="text/javascript">
	
	//提交
	function submit(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_020%>';
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
			AsControl.PopView("/ProjectManage/ProjectAssetTransfer/SubmitProjectDialog.jsp","SerialNo="+sProjectNo,"resizable=yes;dialogWidth=25;dialogHeight=15;center:yes;status:no;statusbar:no");
			//RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status+",assetProjectType="+sProjectType);
			reloadSelf();
	}
	
	
	//签署意见
	function signAdvice(){
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		AsControl.PopView("/ProjectManage/ProjectAssetTransfer/ProjectReCheckSignAdviceInfo.jsp","SerialNo="+sSerialNo,"resizable=yes;dialogWidth=25;dialogHeight=25;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	//复核通过
	function checkSubmit(){
		var sProjectNo = getItemValue(0,getRow(),"SERIALNO");
		var sProjectType = getItemValue(0,getRow(),"PROJECTTYPE");
		var status = '<%=AssetProjectCodeConstant.AssetProjectStatus_030%>';
		var approveOpinion = getItemValue(0,getRow(),"APPROVEOPINION");
		if(typeof(approveOpinion) == 'undefined' || approveOpinion.length == 0){
			alert("该笔业务尚未签署意见，不允许提交！");
			return;
		}
		if(typeof(sProjectNo) == 'undefined' || sProjectNo.length == 0){
			alert("请先选择一条记录");
			return;
		}
		if(confirm('确定要进行此操作吗?')){
			RunJavaMethodTrans("com.amarsoft.app.als.assetTransfer.action.AssetTransferAction","changeProjectStatus","projectNo="+sProjectNo+",status="+status+",assetProjectType="+sProjectType);
			reloadSelf();
		}
	}

	//资产详情
	function assetDetail(){
		sSerialNo=getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("请选择一条记录！");
			return;
		}
		AsControl.OpenView("/ProjectManage/ProjectAssetTransfer/AssetDebtDetailInfo.jsp","SerialNo="+sSerialNo,"_blank");
		reloadSelf();
	}
	
</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%><%@
 include file="/Frame/resources/include/include_end.jspf"%>
