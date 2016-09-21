<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/Frame/resources/include/include_begin_list.jspf"%>
<%@ page import="com.amarsoft.app.als.assetTransfer.util.AssetProjectCodeConstant"%>

<%
	//接收参数
	String tempNo = DataConvert.toString(CurPage.getParameter("TempNo"));//模板号
	String ObjectType = DataConvert.toString(CurPage.getParameter("ObjectType"));//对象类型
	if(ObjectType==null) ObjectType="";
	String  ObjectNo= DataConvert.toString(CurPage.getParameter("ObjectNo"));//对象编号
	if(ObjectNo==null) ObjectNo="";
	String RightType=DataConvert.toString(CurPage.getParameter("RightType"));//对象权限
	if(RightType==null) RightType="All";
	tempNo="LoanBillCheckReport";
	String sColString="";
	String sql=" SELECT CR.OBJECTNO FROM CONTRACT_RELATIVE CR "+
			" where CR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' AND CR.CONTRACTSERIALNO ='"+ObjectNo+"' "+
			" and CR.RELATIVETYPE in('07') UNION SELECT CR.CONTRACTSERIALNO  "+
			" FROM CONTRACT_RELATIVE CR  "+
			" where CR.OBJECTTYPE='jbo.app.BUSINESS_CONTRACT' AND CR.OBJECTNO ='"+ObjectNo+"' "+
			" and CR.RELATIVETYPE in('07') ";
	ASResultSet rs=Sqlca.getASResultSet(sql);
	while(rs.next()){
		sColString+="'"+rs.getString(1)+"',";
	}
	rs.getStatement().close();
	sColString="".equals(sColString)?"''":sColString.substring(0, sColString.length()-1);

	ASObjectModel doTemp = new ASObjectModel(tempNo);
	String sWhereSql="";
	if("jbo.app.CONTRACT_RELATIVE".equals(ObjectType)){
		sWhereSql=" and BC.SERIALNO IN ( "+sColString+") ";
		doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=1 ");//	
	}else{
		doTemp.getCustomProperties().setProperty("JboWhereWhenNoFilter"," and 1=2 ");//	
		//doTemp.setJboWhereWhenNoFilter(" and 1=2 ");//	
	}
	doTemp.setDataQueryClass("com.amarsoft.app.als.awe.ow.processor.impl.html.ALSListHtmlGenerator");
	doTemp.setJboWhere(doTemp.getJboWhere() + sWhereSql );
	ASObjectWindow dwTemp = new ASObjectWindow(CurPage,doTemp,request);
	dwTemp.Style="1";      	     //设置为Grid风格
	dwTemp.setParameter("OrgID", CurUser.getOrgID());
	dwTemp.setPageSize(15);
	dwTemp.genHTMLObjectWindow("");
	
	String sButtons[][] = {
			//0、是否展示 1、	权限控制  2、 展示类型 3、按钮显示名称 4、按钮解释文字 5、按钮触发事件代码	6、	7、	8、	9、图标，CSS层叠样式 10、风格
			{"true","All","Button","详情","详情","view()","","","","",""},
			{"true","","Button","导出","导出Excel","Export()","","","",""},
			//{"true","","Button","历史签署意见","历史签署意见","opinionLast()","","","","",""},
		};
%> 

<script type="text/javascript">
<%-- function opinionLast(){
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
} --%>

function Export(){
	if(s_r_c[0] > 1000){
		alert("导出数据量过大，请控制在1000笔内。");
		return;
	}
	as_defaultExport();
}

function view(){
	 var serialNo = getItemValue(0,getRow(0),'SERIALNO');
	 if(typeof(serialNo)=="undefined" || serialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return ;
	 }
	 var ApplySerialNo = getItemValue(0,getRow(0),'ApplySerialNo');
	 AsCredit.openFunction("LoanCheckInfoTab","SerialNo="+serialNo+"&ApplySerialNo="+ApplySerialNo,"");
}

</script>
<%@include file="/Frame/resources/include/ui/include_list.jspf"%>
<%@include file="/Frame/resources/include/include_end.jspf"%>
