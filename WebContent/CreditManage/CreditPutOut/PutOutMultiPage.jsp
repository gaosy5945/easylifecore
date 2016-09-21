<%@page import="com.amarsoft.app.bizmethod.BizSort"%>
<%@ page contentType="text/html; charset=GBK"%><%@
 include file="/Frame/resources/include/include_begin_multi.jspf"%>
<iframe name="frame_info" width="100%" height="270" frameborder="0"></iframe>
<hr class="list_hr">
<iframe name="frame_list" width="100%" height="350" frameborder="0"></iframe>
<%@include file="/Frame/resources/include/ui/include_multi.jspf"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: gftang 2013/11/30
		Tester:
		Content:  出帐详情 上下分页
		Input Param:
		Output param:
		History Log:  
	 */
	%>
<%/*~END~*/%>
<%
//获得组件参数：对象类型和对象编号
	String sObjectType = CurPage.getParameter("ObjectType");
	String sObjectNo =  CurPage.getParameter("ObjectNo");
	String sApproveNeed =  CurConfig.getConfigure("ApproveNeed");
	//定义变量：SQL语句、出帐业务品种、出帐显示模版、对象主表、暂存标志
	String sSql = "",sBusinessType = "",sDisplayTemplet = "",sMainTable = "",sTempSaveFlag="";
	//定义变量：发生类型、合同起始日、合同到期日、合同业务品种
	String sBCOccurType = "",sBCPutOutDate = "",sBCMaturity = "",sBCBusinessType = "",sBCPaymentMode = "";
	String sContractSerialNo = "";
	//定义变量：合同金额
	double dBCBusinessSum = 0.0;	
	//定义变量：查询结果集
	ASResultSet rs = null;
	//根据对象类型从对象类型定义表中查询到相应对象的主表名
	sSql = 	" select ObjectTable from OBJECTTYPE_CATALOG "+
			" where ObjectType =:ObjectType ";
	sMainTable = Sqlca.getString(new SqlObject(sSql).setParameter("ObjectType",sObjectType));	
	
	//获取出帐业务品种
	sSql = 	" select BusinessType,ContractSerialNo from "+sMainTable+" "+
			" where SerialNo =:SerialNo ";
	rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
	if(rs.next()){
		sBusinessType = rs.getString("BusinessType");
		sContractSerialNo = rs.getString("ContractSerialNo");
	}
	rs.getStatement().close();

	//如果业务品种为空,则显示短期流动资金贷款
	if (sBusinessType.equals("")) sBusinessType = "1010010";
	if(sContractSerialNo.equals("")) sContractSerialNo="";
	
	//add by sjchuan 2009-10-21
	//当业务类型为银行承兑汇票：2010
	//           银行承兑汇票贴现：1020010
	//           银行承兑汇票贴现: 1020020
	//           协议付息票据贴现: 1020020
	//时，出账信息Tab页面为上下分页显示 
	String Flag = ""; //票据业务的标志，当Flag = "1"时为票据业务，否则不是票据业务
	if(sBusinessType.equals("1020010") ||sBusinessType.equals("1020020")||sBusinessType.equals("1020030")|| sBusinessType.equals("2010"))
	{
		Flag = "1";
	}
	
	//获取该出帐信息的发生类型
		sSql = 	" select BC.OccurType,BC.PutOutDate,BC.Maturity,BC.BusinessType,BC.BusinessSum,BC.PaymentMode "+
				" from BUSINESS_CONTRACT BC "+
				" where exists (select BP.ContractSerialNo from BUSINESS_PUTOUT BP "+
				" where BP.SerialNo =:SerialNo "+
				" and BP.ContractSerialNo = BC.SerialNo) ";
		rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo",sObjectNo));
		if(rs.next()){
			sBCOccurType = rs.getString("OccurType");
			sBCPutOutDate = rs.getString("PutOutDate");
			sBCMaturity = rs.getString("Maturity");
			sBCBusinessType = rs.getString("BusinessType");
			sBCPaymentMode = rs.getString("PaymentMode");
			dBCBusinessSum = rs.getDouble("BusinessSum");
			//将空值转化为空字符串
			if(sBCOccurType == null) sBCOccurType = "";
			if(sBCPutOutDate == null) sBCPutOutDate = "";
			if(sBCMaturity == null) sBCMaturity = "";
			if(sBCBusinessType == null) sBCBusinessType = "";
		}
		rs.getStatement().close();
	%>
<script>
//出账信息Tab页面上下分页显示 出账申请的业务类型为票据业务
if("<%=Flag%>" == "1" )
{
	var sUrl = "/CreditManage/CreditPutOut/PutOutInfo.jsp";
	AsControl.OpenView(sUrl,"ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&ApproveNeed=<%=sApproveNeed%>","frame_info","");
	if(<%=sBusinessType%>=="2010"){
		sUrl = "/CreditManage/CreditApply/BillList.jsp";
	}else{
		sUrl = "/CreditManage/CreditApply/RelativeBillList.jsp";
	}
	AsControl.OpenView(sUrl,"ObjectNo=<%=sObjectNo%>&ContractSerialNo=<%=sContractSerialNo%>&BusinessType=<%=sBusinessType%>","frame_list","");
}

//放贷详情页面上下页显示
else{
	var sUrl = "/CreditManage/CreditPutOut/PutOutInfo.jsp";
	AsControl.OpenView(sUrl,"ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&ApproveNeed=<%=sApproveNeed%>","_self","");
}

</script>
<%@include file="/Frame/resources/include/include_end.jspf"%>