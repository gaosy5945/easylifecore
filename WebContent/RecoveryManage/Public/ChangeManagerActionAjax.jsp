
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//�������
	String sSql = "";    
	ASResultSet rs = null;
	double sBalance = 0;
	String sReturnValue="";
	
	//��ͬ��ˮ�š���ȫ�������ƽ����͡��ƽ�����
	String sDATSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("DATSerialNo")); 	
	if(sDATSerialNo == null) sDATSerialNo = "";//����ֵת��Ϊ���ַ���
	String sDAOSerialNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("DAOSerialNo")); 	
	if(sDAOSerialNo == null) sDAOSerialNo = "";//����ֵת��Ϊ���ַ���
	//�������ͣ�LIChangeManager��DAChangeManager��PDAChangeManager
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType")); 	
	if(sObjectType == null) sObjectType = "";//����ֵת��Ϊ���ַ���
	String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo")); 	
	if(sObjectNo == null) sObjectNo = "";//����ֵת��Ϊ���ַ���
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
