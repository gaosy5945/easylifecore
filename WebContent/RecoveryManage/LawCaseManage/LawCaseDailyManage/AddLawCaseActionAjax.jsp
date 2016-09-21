
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//案件编号、案件类型、我行的诉讼地位
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String  sLawCaseType= DataConvert.toRealString(iPostChange,(String)request.getParameter("LawCaseType"));
	String sReturnValue="";
	//CaseStatus=001表示不属于任何诉讼进程、CasePhase=010表示诉前
	try{
		String sSql = " insert into LAWCASE_INFO(SerialNo,LawCaseType,CasePhase,CaseStatus,ManageUserID,ManageOrgID,OperateUserID,OperateOrgID,InputUserID,InputOrgID,UpdateDate,InputDate,Currency,PigeonholeDate ) "+
			          " values(:SerialNo,:LawCaseType,:CasePhase,'',:ManageUserID,:ManageOrgID,:OperateUserID,:OperateOrgID,:InputUserID,:InputOrgID,"+
			          " :UpdateDate,:InputDate,:Currency,:PigeonholeDate )";
		SqlObject so = null;
		so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo).setParameter("LawCaseType",sLawCaseType)
		.setParameter("CasePhase","010").setParameter("ManageUserID",CurUser.getUserID())
		.setParameter("ManageOrgID",CurOrg.getOrgID()).setParameter("OperateUserID",CurUser.getUserID())
		.setParameter("OperateOrgID",CurOrg.getOrgID()).setParameter("InputUserID",CurUser.getUserID())
		.setParameter("InputOrgID",CurOrg.getOrgID()).setParameter("UpdateDate",StringFunction.getToday())
		.setParameter("InputDate",StringFunction.getToday()).setParameter("Currency","CNY")
		.setParameter("PigeonholeDate",StringFunction.getToday());
		Sqlca.executeSQL(so);
		sReturnValue="true";
	}catch(Exception e){
		e.fillInStackTrace();
		sReturnValue="false";
	}
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part02;Describe=返回值处理;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Part03;Describe=返回值;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>