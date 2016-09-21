<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: XXGe 2004-11-22
 * Tester:
 * Content: �ڵ�ծ�ʲ���ծ��Ϣ���в����ʼ��Ϣ
 * Input Param:
 *		   
 *  
 * Output param:
 *		��	
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//������š��������͡����е����ϵ�λ
	String 	sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String 	sDASerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("DASerialNo"));
	String 	sRelativeContractNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("RelativeContractNo"));
	String  sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectType"));
	String sReturnValue="";

	String sSql = "";
	SqlObject so = null;
	ASResultSet rs = null;
	//sObjectType=��Business_Contract����ʾ���ڵ�ծ�ʲ���Ӧ��ͬ��Ϣ��CasePhase=��LawCase_Inof����ʾ��ծ�ʲ���Ӧ������Ϣ
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

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part02;Describe=����ֵ����;]~*/%>
<%	
	ArgTool args = new ArgTool();
	args.addArg(sReturnValue);
	sReturnValue = args.getArgString();
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Part03;Describe=����ֵ;]~*/%>
<%	
	out.println(sReturnValue);
%>
<%/*~END~*/%>
<%@ include file="/IncludeEndAJAX.jsp"%>