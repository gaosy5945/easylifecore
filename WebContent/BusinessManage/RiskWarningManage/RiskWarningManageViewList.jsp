<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%
	/*
		Content: 流程模型列表
	 */
	String PG_TITLE = "风险预警提示信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
	String sSignalType  = DataConvert.toString(CurPage.getParameter("SignalType"));
	if(sSignalType==null||sSignalType.length()==0)sSignalType="";
	String sTempletNo  = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(sTempletNo==null||sTempletNo.length()==0)sTempletNo="";
	String sDoFlag  = DataConvert.toString(CurPage.getParameter("DoFlag"));
	if(sDoFlag==null||sDoFlag.length()==0)sDoFlag="";
		
	 
	//String sTempletNo = "RiskWarningManageViewList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(100);
	
	Vector vTemp = null;
	if("RiskWarningManageViewList".equals(sTempletNo))
	{
		vTemp = dwTemp.genHTMLDataWindow(sSignalType);	
	}else if("RiskWarningManageDoFlagList".equals(sTempletNo))
	{
		vTemp = dwTemp.genHTMLDataWindow(sSignalType+","+sDoFlag);
	}
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		{"true","","Button","预警详情","查看/修改预警详情","viewAndEdit()","","","",""},
		{"true","","Button","反馈完成","整改落实情况反馈结果","editResult()","","","",""},
		{"true","","Button","整改落实情况查看","查看/修改预警详情","viewResult()","","","",""},
	};
	if("RiskWarningManageDoFlagList".equals(sTempletNo)&&"2".equals(sDoFlag))
	{
		sButtons[1][0]="false";
	}
	
	if("RiskWarningManageViewList".equals(sTempletNo))
	{
		sButtons[1][0]="false";
		sButtons[2][0]="false";
	}
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
    /*~[Describe=查看及修改详情;]~*/
	function viewAndEdit(){
    	
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsCredit.openFunction("RiskWarningManageInfo","SerialNo="+sSerialNo+"&RightType=ReadOnly");
	}
    
	 /*~[Describe=修改反馈结果状态;]~*/
	function editResult(){
    	
		var sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var num = AsControl.RunASMethod("RiskWarningManage","UpdateSignalDoFlag",sSerialNo+",2");
       	if(num>0){
       		alert("执行反馈成功！");
       	}else
       	{
       		alert("执行反馈失败！");
       	}
       	reloadSelf();
	}
	 
	 /*~[Describe=查看及修改详情;]~*/
	function viewResult(){
		alert("还未实现此部分录入功能，后续工作请其他同事补充！谢谢！");
	}
	
var bHighlightFirst = true;//自动选中第一条记录
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>