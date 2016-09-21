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
		
		//获取参数：流水号，对象类型，对象编号，和共同申请人ID
		String sSerialNo = this.SerialNo;		//无用参数 by yzheng
		String sObjectType = this.ObjectType;
		String sObjectNo = this.ObjectNo;
		String sApplicantID = this.ApplicantID;						
		
		//将空值转化成空字符串
		if(sSerialNo == null) sSerialNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sApplicantID == null) sApplicantID = "";
		
 		//定义变量： 返回结果、业务申请人
 
		String sReturn = "";
		String sCustomerID = "";
		boolean sFlag = false;
	 
 		//判断是否存在共同申请人
		BizObjectQuery query =JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLICANT",tx)
		.createQuery(" select  SerialNo,ApplicantID  from O where where ObjectNo=:ObjectNo and ObjectType=:ObjectType")
		.setParameter("ObjectNo", sObjectNo).setParameter("ObjectType", sObjectType);
		
		@SuppressWarnings("unchecked")
		List<BizObject> bos = query.getResultList(false);
	     
		if(bos!=null)
		for(int i =0;i<bos.size();i++)
		{
			BizObject bo = bos.get(i);
			//取数据库中存在的共同申请人ID
			String sApplicantID1 = bo.getAttribute("ApplicantID").toString();
			if(sApplicantID1 ==null) sApplicantID1 = "";
			//如果该共同申请人已经存在则退出循环
			if(sApplicantID.equals(sApplicantID1))
			{
				sFlag = true;	
				break;		
			}			
		}
 			
		//判断共同申请人是否和申请人相同  
		if(!sFlag)
		{	
			String sTableName="";
			//不同阶段在不同表中查询CustomerID
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
			//如果取得表明则执行sql
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
		//判断返回信息
		if(sFlag)
			sReturn = "对不起，该申请人已经存在！";
		else if(sApplicantID.equals(sCustomerID))
			sReturn = "对不起，共同申请人和业务申请人不能相同！";
		else
			sReturn = "SUCCESS";
		//返回值
		return sReturn;
	}

}
