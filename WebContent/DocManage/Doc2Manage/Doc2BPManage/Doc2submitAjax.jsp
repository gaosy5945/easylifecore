<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: ҵ�����ϲ��� Ԥ�鵵���ύ������
 				1.����һ��������ϢDO��doc_operation��
 				2.����ǰ�׶ε�DOF��doc_operation_file�� ��ϵ ȫ�����Ƶ���һ�������׶�
 				3.����ǰ�׶�status ��Ϊ �Ѵ���
 				4.DO��״̬�ı仯������DFP��DOC_FILE_PACKAGE��״̬�ı仯
 				5.DFP״̬��DFI��DOC_FILE_INFO���ụ��Ӱ��
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
	//��������
	String sOperationType = CurPage.getParameter("OperationType");
	if(sOperationType == null) sOperationType = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//1,��ȣ�2.���3��������Ŀ
	if(sObjectType == null) sObjectType = "";
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	String sPosition = CurPage.getParameter("Position");
	if(sPosition == null) sPosition = "";
	
	String sUserId = CurUser.getUserID();
	String sOrgId = CurUser.getOrgID();
	String sDate = StringFunction.getToday();
	String sDFPSerialNo = "";
	String sTransactionCode = "";
	String sDFPNextStatus = "";
	String sDFINextStatus = "";

	String sInsertSql = "";
	String sSelSql = "";
	SqlObject so = null;
	String sSql = "";
	ASResultSet rs = null;
	//��Ӧ����һ�׶� DO��Ӧ�Ĳ����׶�
	if("0011".equals(sOperationType) || "0011" == sOperationType){//Ԥ�鵵
		sTransactionCode = "0010";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0010".equals(sOperationType) || "0010" == sOperationType){//��� ֻ���ĵ�ǰstatus
		//sTransactionCode = "0020";
		sDFPNextStatus = "03";
		sDFINextStatus = "03";
	}else	if("0020".equals(sOperationType) || "0020" == sOperationType){//��������--���⣨�����ֳ��⣩
		sTransactionCode = "0070";
		sDFPNextStatus = "03";
		sDFINextStatus = "03";
	}else	if("0030".equals(sOperationType) || "0030" == sOperationType){//��������--���裨���ã�
		sTransactionCode = "0070";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0040".equals(sOperationType) || "0040" == sOperationType){//�黹
		sTransactionCode = "0010";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0050".equals(sOperationType) || "0050" == sOperationType){//����
		//sTransactionCode = "0060";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0060".equals(sOperationType) || "0060" == sOperationType){//����
		//sTransactionCode = "0070";
		sDFPNextStatus = "02";
		sDFINextStatus = "02";
	}else	if("0070".equals(sOperationType) || "0070" == sOperationType){//��ȡ
		sTransactionCode = "0040";
		sDFPNextStatus = "04";
		sDFINextStatus = "07";
	}
	
	
	String sReturnValue = "false";
	try{
		
		if("0070".equals(sOperationType) || "0070" == sOperationType){//��ȡ
			sSql = "  update doc_operation do2 set do2.status='04' where serialno=( select do.serialno from doc_operation do where do.objecttype=:ObjectType and do.objectno=:ObjectNo and do.operatedate = (select max(do1.operatedate) from doc_operation do1 where do.objecttype=:ObjectType1 and do.objectno=:ObjectNo1 and do1.transactioncode in('0020','0030') and do1.status='03'))";
			so = new SqlObject(sSql);
			so.setParameter("ObjectType", sObjectType);
			so.setParameter("ObjectNo", sObjectNo);
			so.setParameter("ObjectType1", sObjectType);
			so.setParameter("ObjectNo1", sObjectNo);
			Sqlca.executeSQL(so);//���³��� ��״̬�������� Ϊ �ѳ���
		}
		String sDO1SerialNo =  "";
		if(!"0011".equals(sOperationType) && "0011" != sOperationType){//Ԥ�鵵
			sDO1SerialNo =  DBKeyHelp.getSerialNo("doc_operation","SerialNo",""); 
			sInsertSql = "insert into doc_operation do "+
					  " (do.serialno,do.taskserialno,do.objecttype,do.objectno,do.transactioncode,do.operatedate,do.operateuserid, do.inputuserid,do.status,do.operatedescription) "+
					  " (select :SerialNo,do1.taskserialno,do1.objecttype,do1.objectno, :TransactionCode, "+
							  " :OperateDate,:OperateUserId, :InputUserId,:Status,do1.operatedescription "+
						" from doc_operation do1 where do1.serialno = :DOSerialNo)";
			so = new SqlObject(sInsertSql);
			so.setParameter("SerialNo", sDO1SerialNo);
			so.setParameter("TransactionCode", sTransactionCode);
			so.setParameter("OperateDate", sDate);
			so.setParameter("OperateUserId", sUserId);
			so.setParameter("InputUserId", sUserId);
			so.setParameter("Status", "01");//������
			so.setParameter("DOSerialNo", sDOSerialNo);
			Sqlca.executeSQL(so);//���� ��һ�׶� һ��������Ϣ��doc_operation��
			//��ѯ��ǰ�׶εĹ�����ϵ
			sSelSql = "select serialno,operationserialno,fileserialno,operatememo from doc_operation_file dof where dof.operationserialno=:DOSerialNo ";
			so = new SqlObject(sSelSql);
			so.setParameter("DOSerialNo", sDOSerialNo);
			//Sqlca.executeSQL(so);
			rs = Sqlca.getASResultSet(so);
			while(rs.next()){
				try{
					///���ƹ�����ϵ doc_operation_File ����һ���׶�
					String sDOFSerialNo = DBKeyHelp.getSerialNo("doc_operation_file","SerialNo",""); 
					sInsertSql = "insert into doc_operation_file DOF (DOF.SERIALNO,DOF.OPERATIONSERIALNO,DOF.FILESERIALNO,DOF.OPERATEMEMO) "+
							" VALUES(:SerialNo,:OperationSerialNo,:FileSerialNo,:OperateMemo)";
					so = new SqlObject(sInsertSql);
					so.setParameter("SerialNo", sDOFSerialNo);
					so.setParameter("OperationSerialNo",sDO1SerialNo);//��һ�׶ε� ������ˮ��
					so.setParameter("FileSerialNo", rs.getString("fileserialno"));
					so.setParameter("OperateMemo", rs.getString("operatememo"));
					//����һ����������
					Sqlca.executeSQL(so);
				}catch(Exception e){
					rs.getStatement().close();
					e.fillInStackTrace();
					sReturnValue="false";
				}
			}
			rs.getStatement().close();
			
		}
		
		//���� ������dfiΪ���
		sSql = "update doc_file_info dfi set dfi.status=:Status where dfi.serialno in(select dof.fileserialno from doc_operation_file dof where dof.operationserialno=:DOSerialNo )";
		so = new SqlObject(sSql);
		so.setParameter("Status", sDFINextStatus);
		so.setParameter("DOSerialNo", sDOSerialNo);
		Sqlca.executeSQL(so);
		//����dfpΪ�ѳ��� �� ���ֳ���
		sSql = "update doc_file_package dfp set dfp.status=:Status ,dfp.updatedate=:UpdateDate where dfp.packagetype='02' and dfp.objecttype=:ObjectType and dfp.objectno=:ObjectNo ";
		so = new SqlObject(sSql);
		so.setParameter("Status", sDFPNextStatus);
		so.setParameter("UpdateDate", StringFunction.getToday());
		so.setParameter("ObjectType", "jbo.app.BUSINESS_CONTRACT");
		so.setParameter("ObjectNo", sObjectNo);
		Sqlca.executeSQL(so); 
		
		sReturnValue="true";
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