<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: liuzq 20141215
 * Tester:
 * Content: һ��ҵ������  �ύ�����������׶ε���ز��� 
 * Input Param:
 *		   
 *  
 * Output param:
 *		��	
 * History Log: yjhou 2015.02.28 ����
 *
 */
%>
<%!
//���������ύ,1.����DFP״̬��2.����DFI״̬��3.����DO״̬
public boolean outOfWarehouseSubmit(Transaction Sqlca,String sDFIStatus,String sDFPStatus,String sDOSerialNo,String sDOStatus,String sUserID){
	try{
		updateDFI(Sqlca,sDFIStatus,sDOSerialNo);
		updateDFP(Sqlca,sDFPStatus,sDOSerialNo);
		//updateDO(Sqlca,sDOStatus,sDOSerialNo,sUserID);
		return true;
	}catch(Exception e){
		e.printStackTrace();
		return false;
	}
}
/**
 * ����DOSerialNo ���� DFP
 * @return
 */
public boolean updateDFP(Transaction Sqlca,String sDFPStatus,String sDOSerialNo){
	boolean sReturn = false;
	StringBuffer sbSql = new StringBuffer();
	SqlObject so ;
	try{
		sbSql.append(" update doc_file_package dfp set dfp.status=:Status,dfp.lastoperatedate=dfp.updatedate, dfp.updatedate=:UpdateDate where dfp.serialno in(select dfi.packageserialno from doc_file_info dfi,doc_operation_file dof where dof.fileserialno=dfi.serialno and dof.operationserialno=:SerialNo "); 
		so = new SqlObject(sbSql.toString());
		so.setParameter("SerialNo", sDOSerialNo)
		.setParameter("Status", sDFPStatus) //��״̬
		.setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		Sqlca.executeSQL(so);
		sReturn = true ;
	} catch(Exception e){
		e.printStackTrace();
	}
	return sReturn;
}

/**
 * ����DOSerialNo ���� DFI
 * @return
 */
public boolean updateDFI(Transaction Sqlca,String sDFIStatus,String sDOSerialNo){
	boolean sReturn = false;
	StringBuffer sbSql = new StringBuffer();
	SqlObject so ;
	try{
		sbSql.append(" update doc_file_info dfi set dfi.status=:Status where dfi.serialno in(select dof.fileserialno from doc_operation_file dof where dof.operationserialno=:SerialNo "); 
		so = new SqlObject(sbSql.toString());
		so.setParameter("SerialNo", sDOSerialNo)
		.setParameter("Status", sDFIStatus) ;//����״̬
		Sqlca.executeSQL(so);
		sReturn = true ;
	} catch(Exception e){
		e.printStackTrace();
	}
	return sReturn;
}
 
 /**
  * �ڳ�������׶��ύ����ʱ������doc_operation��SerialNo�����е�״̬����Ϊ "������"
  * �ڳ��������׶�����ͨ��ʱ������doc_operation��SerialNo�����е�״̬����Ϊ "�Ѵ���"
  * �ڳ��������׶������˻�ʱ������doc_operation��SerialNo�����е�״̬����Ϊ "������"����������Ϊ""
  * @return
  * @param Sqlca
  * @param sDOStatus  ����״̬
  * @param sDOSerialNo ������ˮ��
  * @param sUserID  ������
  * @param sDate ��������
  */ 
public boolean updateDO(Transaction Sqlca,String sDOStatus,String sDOSerialNo,String sUserID,String sDate,String sApplyType){
	boolean sReturn = false; 
	SqlObject so =null;
	try{   
	    	String sSql ="update doc_operation do set do.status=:Status,do.operateuserid=:OperateUserId,do.operatedate=:OperateDate"+ 
				     " where do.serialno =:SerialNo"; 
			so = new SqlObject(sSql);
			so.setParameter("Status", sDOStatus) //����״̬
			  .setParameter("OperateDate", sDate)//��������
			  .setParameter("OperateUserId", sUserID)//������
			  .setParameter("SerialNo", sDOSerialNo);//������ˮ�� 
		
		  //ִ�в���,��ִ�гɹ��򷵻�ֵΪ true 
		  if(Sqlca.executeSQL(so)>0){
			  sReturn = true ;
		  }
	} catch(Exception e){
		e.printStackTrace();
	}
	return sReturn;
}

%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//��ȡ��ز���
	String sAISerialNo = CurPage.getParameter("AISerialNo");
	if(sAISerialNo == null) sAISerialNo = "";
	String sDOSerialNo = CurPage.getParameter("DOSerialNo");//����������ˮ��
	if(sDOSerialNo == null) sDOSerialNo = "";
	String sApplyType = CurPage.getParameter("ApplyType");  //�׶�����
	if(sApplyType == null) sApplyType = "";
	
	String sDFPStatus = "";
	String sDFIStatus = "";
	String sDOStatus = ""; //����״̬
	
	String sUserId = CurUser.getUserID();
	String sOrgId = CurUser.getOrgID();
	String sDate =  StringFunction.getToday();
	boolean flag = false;
	String sReturnValue = "false";
	try{
		//����׶��ύ����ʱ
		if("01" == sApplyType || "01".equals(sApplyType)){
			
			sDOStatus = "02";
			flag = updateDO(Sqlca,sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
		}//�����׶�
		else  if("02" == sApplyType || "02".equals(sApplyType)){
			/* sDFPStatus = "04";
			sDFIStatus = "04";
			sDOStatus = "03";
			outOfWarehouseSubmit(Sqlca,sDFIStatus,sDFPStatus,sDOSerialNo,sDOStatus,sUserId); */
			sDOStatus = "03";
			flag = updateDO(Sqlca,sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
		}//���������˻�
		else if("03" == sApplyType || "03".equals(sApplyType)){
			sDOStatus = "01";
			flag = updateDO(Sqlca,sDOStatus,sDOSerialNo,sUserId,sDate,sApplyType);
		}
		if(flag==true){
			sReturnValue="true";
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