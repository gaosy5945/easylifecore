<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: ҵ�����ϲ���  ����  
 				1.�޸�����״̬DO��doc_operation�� status
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
	String sOperationStatus = CurPage.getParameter("OperationStatus");//operationtype=0020����ʱ��01,���룻02��������03����ͨ����04:��ȡ��05���˻�
	if(sOperationStatus == null) sOperationStatus = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sObjectType = CurPage.getParameter("ObjectType");//1,��ȣ�2.���3��������Ŀ
	if(sObjectType == null) sObjectType = "";
	String sObjectNo = CurPage.getParameter("ObjectNo");
	if(sObjectNo == null) sObjectNo = "";
	String sStatus = CurPage.getParameter("Status");
	if(sStatus == null) sStatus = "";
	String sApproveSubmitStatus = CurPage.getParameter("ApproveSubmitStatus");//����--�ύ���˻�
	if(sApproveSubmitStatus == null) sApproveSubmitStatus = "";
	
	String sUserId = CurUser.getUserID();
	String sOrgId = CurUser.getOrgID();
	String sDate = StringFunction.getToday();
	String sDFPSerialNo = "";
	String sTransactionCode = "";
	
	String sInsertSql = "";
	String sUpdateSql = "";
	String sSelSql = "";
	SqlObject so = null;
	String sSql = "";
	ASResultSet rs = null;
	//��Ӧ����һ�׶� DO��Ӧ�Ĳ����׶�
	String sNextStatus = "";
	//����״̬�任
	if("01".equals(sStatus) || "01"==sStatus){//������ύ
		sNextStatus = "02";//�����ύ��������
	}
	if("02".equals(sStatus) || "02"==sStatus){//�����ύ��������
		sNextStatus = "03";//������������������ȡ����
	}
	if("03".equals(sStatus) || "03"==sStatus){//������������������ȡ���� sApproveSubmitStatus

		if("01".equals(sApproveSubmitStatus) || "01"==sApproveSubmitStatus){
			sNextStatus = "04";//�Ѵ���--���ã����⣬���ã� 
		}else if("02".equals(sApproveSubmitStatus) || "02"==sApproveSubmitStatus){
			sNextStatus = "05";//�Ѵ���--�˻�
		}
	}
	if("05".equals(sStatus) || "05"==sStatus){//�Ѵ���--�˻�
		sNextStatus = "02";//�˻� �����ύ
	}
	
	if(("0020".equals(sOperationType) || "0020" == sOperationType) && ("03".equals(sStatus) || "03"==sStatus)){//��������--���⣨�����ֳ��⣩
		sTransactionCode = "0070";
	}else	if(("0030".equals(sOperationType) || "0030" == sOperationType) && ("03".equals(sStatus) || "03"==sStatus)){//��������--���裨���ã�
		sTransactionCode = "0070";
	}
	String sReturnValue = "false";
	try{
		if(("03".equals(sStatus) || "03"==sStatus) && ("01".equals(sApproveSubmitStatus) || "01"==sApproveSubmitStatus)){
			//��������ͨ����ʱ��  �½�һ����������ȡ����Ϣ��
			//����һ����������
			String sDOSerialNo1 = DBKeyHelp.getSerialNo("DOC_operation","SerialNo",""); 
				
			sInsertSql = "insert into doc_operation do (do.serialno,do.objecttype,do.objectno,do.transactioncode," + 
								" do.operateuserid,do.operatedate,do.inputuserid,do.status,do.operatedescription) " + 
								" values(:SerialNo,:ObjectType,:ObjectNo,:TransactionCode ,:OperateUserId,:OperateDate,:InputUserId,:OperationStatus,:OperationDescription) "; 
			so = new SqlObject(sInsertSql);
			so.setParameter("SerialNo", sDOSerialNo1);
			so.setParameter("ObjectType", sObjectType);
			so.setParameter("ObjectNo", sObjectNo);
			so.setParameter("TransactionCode", "0070");
			so.setParameter("OperateUserId", CurUser.getUserID());
			so.setParameter("OperateDate", StringFunction.getToday());
			so.setParameter("InputUserId", CurUser.getUserID());
			so.setParameter("OperationStatus", "01");
			so.setParameter("OperationDescription", "");
			Sqlca.executeSQL(so);

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
					so.setParameter("OperationSerialNo",sDOSerialNo1);//��һ�׶ε� ������ˮ��
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
			//���� ������dfiΪ���
			sUpdateSql = "update doc_file_info dfi set dfi.status='04' where dfi.serialno in(select dof.fileserialno from doc_operation_file dof where dof.operationserialno=:DOSerialNo )";
			so = new SqlObject(sUpdateSql);
			so.setParameter("DOSerialNo", sDOSerialNo);
			Sqlca.executeSQL(so);
			//����dfpΪ�ѳ��� �� ���ֳ���
			sUpdateSql = "update doc_file_package dfp set dfp.status=:Status ,dfp.updatedate=:UpdateDate where  dfp.packagetype='02' and dfp.objecttype=:ObjectType and dfp.objectno=:ObjectNo ";
			so = new SqlObject(sUpdateSql);
			so.setParameter("Status", "04");//�ѳ���
			so.setParameter("UpdateDate", StringFunction.getToday());
			so.setParameter("ObjectType", sObjectType);
			so.setParameter("ObjectNo", sObjectNo);
			Sqlca.executeSQL(so);
			
		}
		
		sUpdateSql = "update doc_operation do set do.status=:Status where do.serialno=:SerialNo";
		so = new SqlObject(sUpdateSql);
		so.setParameter("Status", sNextStatus);
		so.setParameter("SerialNo", sDOSerialNo);
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