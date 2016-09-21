<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	
	String sObjectNo = CurPage.getParameter("ObjectNo");//关联流水号：案件信息、抵债资产信息、已核销资产信息
	if(sObjectNo == null) sObjectNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//关联类型：LIChangeManager、DAChangeManager、PDAChangeManager
	if(sObjectType == null) sObjectType = "";
	String sGoBackType = CurPage.getParameter("GoBackType");//返回页面：1、2、3
	if(sGoBackType == null) sGoBackType = "";

	ASObjectModel doTemp = new ASObjectModel("ChangeManagerList");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.genHTMLObjectWindow(sObjectType+","+sObjectNo);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","返回","返回","goBack()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		self.close();
		<%-- var sGoBackType = "<%=sGoBackType%>";
		
		if(sGoBackType == "1"){ //案件管理人
			self.close();
			//OpenPage("/RecoveryManage/LawCaseManage/LawCaseManagerChangeList.jsp","right","");
		} else if(sGoBackType == "2"){//抵债资产
			OpenPage("/RecoveryManage/PDAManage/PDAManagerChange/RepayAssetList.jsp","right","");
		} else if(sGoBackType == "3"){//已核销资产
			OpenPage("/RecoveryManage/NPAManage/NPADailyManage/VerifitionAssetChangeList.jsp","right","");
		} --%>
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
