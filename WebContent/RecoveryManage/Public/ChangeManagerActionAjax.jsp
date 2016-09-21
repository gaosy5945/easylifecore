
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//定义变量
	String sSql = "";    
	ASResultSet rs = null;
	double sBalance = 0;
	String sReturnValue="";
	
	//合同流水号、保全机构、移交类型、移交方向
	String sDATSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("DATSerialNo")); 	
	if(sDATSerialNo == null) sDATSerialNo = "";//将空值转化为空字符串
	String sDAOSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("DAOSerialNo")); 	
	if(sDAOSerialNo == null) sDAOSerialNo = "";//将空值转化为空字符串
	//关联类型：LIChangeManager、DAChangeManager、PDAChangeManager
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType")); 	
	if(sObjectType == null) sObjectType = "";//将空值转化为空字符串
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")); 	
	if(sObjectNo == null) sObjectNo = "";//将空值转化为空字符串
   	String sTableName = "";

	if("LIChangeManager".equals(sObjectType) || "LIChangeManager"==sObjectType){
		//sTableName = "LAWCASE_INFO";
		sSql = "update lawcase_info li set(li.manageuserid,li.manageorgid,li.updatedate)=("+
			"select dat.inputuserid,dat.inputorgid,dat.occurdate from npa_debtasset_transaction dat "+
			" where dat.serialno=:DATSerialNo ) where li.serialno in(:ObjectNo) ";
	}
	if("DAChangeManager".equals(sObjectType) || "DAChangeManager"==sObjectType){
		sSql = "update  NPA_DEBTASSET DA set(DA.manageuserid,DA.manageorgid,DA.updatedate)=("+
				"select dat.inputuserid,dat.inputorgid,dat.occurdate from npa_debtasset_transaction dat "+
				" where dat.serialno=:DATSerialNo ) where DA.serialno in(:ObjectNo) ";
	}
	if("PDAChangeManager".equals(sObjectType) || "PDAChangeManager"==sObjectType){
		sSql = "update  business_contract bc set(bc.operateuserid,bc.operateorgid,bc.updatedate)=("+
				"select dat.inputuserid,dat.inputorgid,dat.occurdate from npa_debtasset_transaction dat "+
				" where dat.serialno=:DATSerialNo ) where bc.serialno in(:ObjectNo) ";
	}
	
    SqlObject so = new SqlObject(sSql);
    so.setParameter("DATSerialNo",sDATSerialNo);
    so.setParameter("ObjectNo",sObjectNo.replace("~", "','"));
    Sqlca.executeSQL(so);	 
    sReturnValue="true";
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
