package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class CheckSameApplicant{

	private String SerialNo=null;
	private String ObjectType =null;
	private String ObjectNo=null;
	private String ApplicantID=null;
	
	public String getSerialNo() {
		return SerialNo;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}

	public String getObjectType() {
		return ObjectType;
	}

	public void setObjectType(String objectType) {
		ObjectType = objectType;
	}

	public String getObjectNo() {
		return ObjectNo;
	}

	public void setObjectNo(String objectNo) {
		ObjectNo = objectNo;
	}

	public String getApplicantID() {
		return ApplicantID;
	}

	public void setApplicantID(String applicantID) {
		ApplicantID = applicantID;
	}

	public Object run(JBOTransaction tx) throws JBOException {
		
		//��ȡ��������ˮ�ţ��������ͣ������ţ��͹�ͬ������ID
		String sSerialNo = this.SerialNo;		//���ò��� by yzheng
		String sObjectType = this.ObjectType;
		String sObjectNo = this.ObjectNo;
		String sApplicantID = this.ApplicantID;						
		
		//����ֵת���ɿ��ַ���
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sApplicantID == null) sApplicantID = "";
		
 		//��������� ���ؽ����ҵ��������
 
		String sReturn = "";
		String sCustomerID = "";
		boolean sFlag = false;
	 
 		//�ж��Ƿ���ڹ�ͬ������
		BizObjectQuery query =JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLICANT",tx)
		.createQuery(" select  SerialNo,ApplicantID  from O where where ObjectNo=:ObjectNo and ObjectType=:ObjectType")
		.setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
		
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
	     
		if(bos!=null)
		for(int i =0;i<bos.size();i++)
		{
			BizObject bo = bos.get(i);
			//ȡ���ݿ��д��ڵĹ�ͬ������ID
			String sApplicantID1 = bo.getAttribute("ApplicantID").toString();
			if(sApplicantID1 ==null) sApplicantID1 = "";
			//����ù�ͬ�������Ѿ��������˳�ѭ��
			if(sApplicantID.equals(sApplicantID1))
			{
				sFlag = true;	
				break;		
			}			
		}
 			
		//�жϹ�ͬ�������Ƿ����������ͬ  
		if(!sFlag)
		{	
			String sTableName="";
			//��ͬ�׶��ڲ�ͬ���в�ѯCustomerID
			if(sObjectType.equalsIgnoreCase("BusinessContract"))
			{
				sTableName = "BUSINESS_CONTRACT";
			}else if(sObjectType.equalsIgnoreCase("ApproveApply"))
			{
				sTableName = "BUSINESS_APPROVE";
			}else if(sObjectType.equalsIgnoreCase("CreditApply"))
			{
				sTableName = "BUSINESS_APPLY";
			}
			//���ȡ�ñ�����ִ��sql
			if(!sTableName.equals(""))
			{
				BizObjectQuery query1 =JBOFactory.getBizObjectManager("jbo.app."+sTableName,tx)
						.createQuery(" select  CustomerID  from O where SerialNo=:SerialNo")
						.setParameter("SerialNo", sObjectNo);
				@SuppressWarnings( "unchecked" )
				List<BizObject> bos1 = query1.getResultList(false);
				if(bos1!=null && bos1.size()>0){
					sCustomerID = bos1.get(0).getAttribute("CustomerID").toString();
				}			 
 			}
			
			if(sCustomerID == null) sCustomerID="";
		}
		//�жϷ�����Ϣ
		if(sFlag)
			sReturn = "�Բ��𣬸��������Ѿ����ڣ�";
		else if(sApplicantID.equals(sCustomerID))
			sReturn = "�Բ��𣬹�ͬ�����˺�ҵ�������˲�����ͬ��";
		else
			sReturn = "SUCCESS";
		//����ֵ
		return sReturn;
	}

}
