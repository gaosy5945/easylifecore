<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String PG_TITLE = "押品估值信息"; // 浏览器窗口标题 <title> PG_TITLE </title>

	String AssetSerialNo = CurPage.getParameter("AssetSerialNo");
	if(AssetSerialNo == null) AssetSerialNo = "";
	String rightType = CurPage.getParameter("RightType");
	if(rightType == null) rightType = "";
	
	ASObjectModel doTemp = new ASObjectModel("EvaluateHistory");
	
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.ReadOnly = "1";	 //编辑模式
	dwTemp.setPageSize(20);
	dwTemp.genHTMLObjectWindow(AssetSerialNo);
	
	String sButtons[][] = {
			{"false","","Button","详情","查看详情","viewAndEdit()","","","",""},
	};
	
%> 
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	
	function viewAndEdit(){
		var CMISApplyNo = getItemValue(0,getRow(),"CMISApplyNo");
		var serialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(serialNo)=="undefined" || serialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		
		var assetEvaParams = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.guaranty.model.CollateralEva", "viewEvaMethod","SerialNo="+serialNo);
		
		if(assetEvaParams == "4") {
			alert("该押品为直接认定估值，不能查询评估信息！");
			return ;
		}
		<%-- window.showModalDialog("<%=com.amarsoft.app.oci.OCIConfig.getProperty("GuarantyURL","")%>/RatingManage/PublicService/EvalRedirector.jsp?cmisApplyId="+CMISApplyNo+"&pstnType=3&viewMode=1&userId=<%=CurUser.getUserID()%>&orgId=<%=CurUser.getOrgID()%>","","dialogWidth="+screen.availWidth+"px;dialogHeight="+screen.availHeight+"px;resizable=yes;maximize:yes;help:no;status:no;"); --%>
	}
	
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
 