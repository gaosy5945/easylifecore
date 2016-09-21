<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: 在抵债资产抵债信息表中插入初始信息
 * Input Param:
 *		   
 *  
 * Output param:
 *		无	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//案件编号、案件类型、我行的诉讼地位
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String 	sDASerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("DASerialNo"));
	String 	sRelativeContractNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("RelativeContractNo"));
	String  sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sReturnValue="";

	String sSql = "";
	SqlObject so = null;
	ASResultSet rs = null;
	//sObjectType=‘Business_Contract’表示属于抵债资产对应合同信息、CasePhase=‘LawCase_Inof’表示抵债资产对应案件信息
	try{
		sSql = " select count(1) as cnt from npa_debtasset_object where ObjectType=:ObjectType and ObjectNo=:ObjectNo and DEBTASSETSERIALNO=:DASerialNo";
		so = new SqlObject(sSql).setParameter("ObjectType",sObjectType)
				.setParameter("ObjectNo",sRelativeContractNo)
				.setParameter("DASerialNo",sDASerialNo);
		rs=Sqlca.getASResultSet(so);
		int iCount = 0;
		if(rs.next()){
			iCount = rs.getInt("cnt");
		}
		if(iCount<=0){

			sSql = " insert into npa_debtasset_object DA (DA.Serialno,DA.Objecttype,DA.Objectno,DA.DEBTASSETSERIALNO,DA.Inputuserid,DA.Inputorgid,DA.Inputdate,DA.Updatedate) "+
							" values(:SerialNo,:ObjectType,:ObjectNo,:DASerialNo,:InputUserId,:InputOrgId,:InputDate,:UpdateDate)";
			so = new SqlObject(sSql).setParameter("SerialNo",sSerialNo).setParameter("ObjectType",sObjectType)
			.setParameter("ObjectNo",sRelativeContractNo).setParameter("DASerialNo",sDASerialNo)
			.setParameter("InputUserId",CurUser.getUserID()).setParameter("InputOrgId",CurOrg.getOrgID())
			.setParameter("InputDate",StringFunction.getToday())
			.setParameter("UpdateDate",StringFunction.getToday());
			Sqlca.executeSQL(so);
			sReturnValue="true";	
		}else{
			sReturnValue="false";	
		}
		
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