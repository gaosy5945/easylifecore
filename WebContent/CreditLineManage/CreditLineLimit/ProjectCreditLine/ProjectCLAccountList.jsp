<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("ProjectCLAccountList");
	doTemp.setJboWhereWhenNoFilter(" and 1=2 ");

	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","合作项目详情","合作项目详情","view()","","","","",""},
			{"true","All","Button","项下业务明细","项下业务明细","projectBusinessDetail()","","","","",""},
			{"true","All","Button","项目变更历史","项目变更历史","projectAlterHistory()","","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">

	function view(){
		var ProjectSerialNo = getItemValue(0,getRow(0),"SERIALNO");
		var CustomerID = getItemValue(0,getRow(0),"CUSTOMERID");
		var RightType = "ReadOnly";
		if(typeof(ProjectSerialNo)=="undefined" || ProjectSerialNo.length==0 ){
			 alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		 }
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.project.SelectFlowSerialNo", "selectFlowSerialNo", "ObjectNo="+ProjectSerialNo);
		AsCredit.openFunction("ProjectCLViewMainInfo","ProjectSerialNo="+ProjectSerialNo+"&CustomerID="+CustomerID+"&RightType="+RightType+"&FlowSerialNo="+flowSerialNo);
	}
	function projectBusinessDetail(){
		var serialNo =  getItemValue(0,getRow(0),"SERIALNO");
		var projectType =  getItemValue(0,getRow(0),"PROJECTTYPE");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectQuery/ProjectBusinessDetail.jsp","SerialNo="+serialNo+"&ProjectType="+projectType,"resizable=yes;dialogWidth=880px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	}
	function projectAlterHistory(){
		var serialNo =  getItemValue(0,getRow(0),"AGREEMENTNO");
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		AsControl.PopPage("/ProjectManage/ProjectAlterNewApply/PrjAlterHistory.jsp","SerialNo="+serialNo,"resizable=yes;dialogWidth=680px;dialogHeight=450px;center:yes;status:no;statusbar:no");
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
