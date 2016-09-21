<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	String authorizeType = CurPage.getParameter("AuthorizeType");
	if(authorizeType == null || authorizeType == "undefined") authorizeType = "01";
	String orgID = CurUser.getOrgID();
	ASObjectModel doTemp = new ASObjectModel("RuleSceneGroupList");
	if("01".equals(authorizeType)){
		doTemp.setJboWhereWhenNoFilter("exists (select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = O.InputOrgID and OB.BelongOrgID = :BELONGORG) and STATUS='1' and AuthorizeType = '01'");
	}else{
		doTemp.setJboWhereWhenNoFilter("exists (select 1 from jbo.sys.ORG_BELONG OB where OB.OrgID = O.InputOrgID and OB.BelongOrgID = :BELONGORG) and STATUS='1' and AuthorizeType = '02'");
	}
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.MultiSelect = true; //允许多选
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(10);
	dwTemp.setParameter("AuthorizeType", authorizeType);
	dwTemp.setParameter("BELONGORG", orgID);
	dwTemp.genHTMLObjectWindow(authorizeType+","+orgID);

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","","Button","详情","详情","edit()","","","","",""},
			{"true","","Button","确定","确定","returnlist()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript">
	function edit(){
		var recordArray = getCheckedRows(0);//获取勾选的行
		if(typeof(recordArray) != 'undefined' && recordArray.length > 1){
			alert("查看详情时只能选择一条记录！（请用鼠标点击要查看的记录）");
			return;
		}
		var serialNo = getItemValue(0, getRow(0), "SerialNo");
		var authorizeType = "<%=authorizeType%>";
		if(typeof(serialNo)=="undefined" || serialNo.length==0 ){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		 }
		AsControl.PopView("/Common/Configurator/Authorization/RuleSceneInfo.jsp","AuthorizeType="+authorizeType+"&AuthSerialNo="+serialNo+"&RightType=ReadOnly","dialogWidth:800px;dialogHeight:620px;resizable:yes;scrollbars:no;status:no;help:no");
	}
	function returnlist(){
		var recordArray = getCheckedRows(0);//获取勾选的行
		if(typeof(recordArray) != 'undefined' && recordArray.length >= 1){
			if(!confirm('确实要复制吗?')) return;
			for(var i = 1;i <= recordArray.length;i++){
				var ID = getItemValue(0,recordArray[i-1],"SerialNo");
				AsCredit.RunJavaMethodTrans("com.amarsoft.app.flow.util.RuleDelete","RuleCopy","SerialNo="+ID+",UserID=<%=CurUser.getUserID()%>,OrgID=<%=CurUser.getOrgID()%>");
			}
		}else{
			alert("请选择要复制的模板！（请用鼠标点击要复制的记录前面的方框）");
			return;
		}
		self.close();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
