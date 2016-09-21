<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
 <%
	/*
		Content: 流程模型列表
	 */
	String PG_TITLE = "风险预警信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	//获得组件参数
	String sSerialNo  = DataConvert.toString(CurPage.getParameter("SerialNo"));
	if(sSerialNo==null||sSerialNo.length()==0)sSerialNo="";
	/* String sTempletNo = DataConvert.toString(CurPage.getParameter("TempletNo"));
	if(sTempletNo==null||sTempletNo.length()==0)sTempletNo=""; */
		
	 
	String sTempletNo = "RiskWarningManageHistList";
	ASObjectModel doTemp = new ASObjectModel(sTempletNo,"");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      //设置风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(100);
	
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	String sButtons[][] = {
		//{"true","","Button","预警详情","查看/修改预警详情","viewAndEdit()","","","",""},
	};
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
    
	
	
var bHighlightFirst = true;//自动选中第一条记录
</script>	
<%@ include file="/Frame/resources/include/include_end.jspf"%>