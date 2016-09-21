 <%@page import="com.amarsoft.app.als.guaranty.model.GuarantyFunctions"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "占用最高额担保合同的申请"; // 浏览器窗口标题 <title> PG_TITLE </title>
	String serialNo = CurPage.getParameter("SerialNo");
	if(serialNo == null) serialNo = "";
	
	ASObjectModel doTemp = new ASObjectModel("CeilingGCRelaApplyList");
	doTemp.appendJboWhere(" and O.ApproveStatus in ('01','02','06') ");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.ShowSummary = "1";
	dwTemp.setPageSize(10);
	dwTemp.setParameter("GCSerialNo", serialNo);
	dwTemp.genHTMLObjectWindow(serialNo);
	
	String sButtons[][] = {
			{"true","","Button","详情","查看担保信息详情","viewAndEdit()","","","",""}
	};

%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function viewAndEdit(){
		var serialNo=getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		AsCredit.openFunction("ApplyInfo", "RightType=ReadOnly&ObjectType=jbo.app.BUSINESS_APPLY&ObjectNo="+serialNo, "", "");
	}

</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 