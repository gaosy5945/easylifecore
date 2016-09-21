<%@page import="com.amarsoft.app.als.credit.model.CreditObjectAction"%>
<%@page import="com.amarsoft.app.als.credit.common.model.CreditConst"%>
<%@page import="com.amarsoft.are.jbo.BizObject"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%	
	//获得组件参数
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(StringX.isSpace(sObjectType)) sObjectType = "";
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	if(StringX.isSpace(sObjectNo)) sObjectNo = "";
	CreditObjectAction coa=new CreditObjectAction(sObjectNo,sObjectType);
	
	BizObject bo =coa.getCreditObjectBO();// GetApplyParams.getObjectParams(sObjectNo,sObjectType);
	String sApplyType = "";
	if(CreditConst.CREDITOBJECT_APPROVE_REAL.equals(sObjectType) && bo != null){
		sApplyType = bo.getAttribute("ApplyType").getString();
		if(StringX.isSpace(sApplyType)) sApplyType = "";
	}
%>


<script type="text/javascript">
	var sUrl = "/CreditManage/CreditApply/CreditView.jsp";
	if("<%=sApplyType%>" == "UGBodyApply"){
		sUrl = "/CreditManage/CreditApply/UGBodyApplyFrame.jsp";
	}
	OpenPage(sUrl+"?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","_self","");
</script>
<%@ include file="/IncludeEnd.jsp"%>
