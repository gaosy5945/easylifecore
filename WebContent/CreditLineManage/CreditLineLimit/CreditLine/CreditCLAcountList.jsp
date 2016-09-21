<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%	
	ASObjectModel doTemp = new ASObjectModel("CLAcountList");
	
	//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");
	doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	
	dwTemp.Style="1";      	     //--设置为Grid风格--
	dwTemp.ReadOnly = "1";	 //只读模式
	dwTemp.setPageSize(20);
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.genHTMLObjectWindow("");

	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","额度详情","额度详情","view()","","","","",""},
			{"false","","Button","消贷易/融资易额度查询","消贷易/融资易额度查询","QueryCoreCL()","","","","",""},
			{"false","","Button","历史签署意见","历史签署意见","opinionLast()","","","","",""},
			{"true","","Button","导出","导出Excel","Export()","","","",""},
		};
%>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<script type="text/javascript" src="<%=sWebRootPath%>/CreditLineManage/CreditLineLimit/js/CreditLineManage.js"></script>
<script type="text/javascript">
	function view(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		if(typeof(SerialNo)=="undefined" || SerialNo.length==0)  {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
		}
		var clSerialNo = getItemValue(0,getRow(0),"SerialNo");
		var BusinessType = getItemValue(0,getRow(0),"BusinessType");
		var RightType = "ReadOnly";
		var ApplySerialNo = getItemValue(0,getRow(0),"ApplySerialNo");
		AsCredit.openFunction("CLViewMainInfo","SerialNo="+SerialNo+"&CLSerialNo="+clSerialNo+"&BusinessType="+BusinessType+"&ObjectNo="+ApplySerialNo+"&ObjectType=jbo.app.BUSINESS_APPLY"+"&RightType="+RightType);
	}
	function opinionLast(){
		var serialNo = getItemValue(0,getRow(0),'SerialNo');
		if(typeof(serialNo) == "undefined" || serialNo.length == 0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		} 
		var BusinessType = getItemValue(0,getRow(0),'BusinessType');
		var ApplySerialNo = getItemValue(0,getRow(0),'ApplySerialNo');
		var flowSerialNo = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.QueryFlowSerialNo","queryFlowSerialNo","ApplySerialNo="+ApplySerialNo);
		var returnValue = AsControl.RunASMethod("BusinessManage","QueryBusinessInfo","<%=CurUser.getUserID()%>");
		var productType3 = AsCredit.RunJavaMethodTrans("com.amarsoft.app.als.apply.action.ProductIDtoProductType","getRalativeProductType","ProductID="+BusinessType);
		if(productType3 == '02' && returnValue == "false"){
			alert("您没有权限查看经营类贷款的历史签署意见！");
			return;
		}else{
			AsControl.PopView("/CreditManage/CreditApprove/CreditApproveList.jsp", "FlowSerialNo="+flowSerialNo);
		}
	}
	function QueryCoreCL(){
		var SerialNo = getItemValue(0,getRow(0),"SerialNo");
		var BusinessType = getItemValue(0,getRow(0),"BusinessType");
		
		if(typeof(SerialNo) == "undefined" || SerialNo.length == 0){
			alert("请选择一条信息！");
			return;
		}
		AsControl.PopPage("/CreditLineManage/CreditLineLimit/CreditLine/CreditCLJump.jsp","SerialNo="+SerialNo+"&BusinessType="+BusinessType,"resizable=yes;dialogWidth=1000px;dialogHeight=550px;center:yes;status:no;statusbar:no");
	}
	
	function Export(){
		if(s_r_c[0] > 1000){
			alert("导出数据量过大，请控制在1000笔内。");
			return;
		}
		as_defaultExport();
	}
</script>
<%@ include file="/Frame/resources/include/include_end.jspf"%>
