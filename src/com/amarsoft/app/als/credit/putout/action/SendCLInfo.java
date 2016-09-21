package com.amarsoft.app.als.credit.putout.action;

import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.sql.Connection;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.object.Item;
/**
 * 
 * @author xjzhao
 * ���ܣ����ݺ�ͬ��Ϣ���ͺ��������׺�������
 * 
 * ���������״̬�⣬�������������ݸ��¡�
 */
public class SendCLInfo {
	private String contractNo;
	

	public String getContractNo() {
		return contractNo;
	}


	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}



	public String send(JBOTransaction tx) throws Exception{
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		
		BusinessObject bc = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_CONTRACT", this.contractNo);
		if(bc == null) throw new Exception("δ�ҵ���Ӧ������Ϣ��");
		
		String customerID = bc.getString("CustomerID");//�ͻ���ţ���ͻ����룩
		
		BusinessObject customer = bomanager.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", customerID);
		//���ʽ
		List<BusinessObject> rptList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RPT_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RPTTermID=:RPTTermID order by SegToStage", "ObjectType",bc.getBizClassName(),"ObjectNo",bc.getKeyString(),"RPTTermID",bc.getString("RPTTermID"));
		for(BusinessObject rpt:rptList)
		{
			
		}
		
		//������Ϣ
		List<BusinessObject> rateList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType and RateTermID=:RateTermID order by SegToStage", "ObjectType",bc.getBizClassName(),"ObjectNo",bc.getKeyString(),"RateType","01","RateTermID",bc.getString("LoanRateTermID"));
		for(BusinessObject rate:rateList)
		{
		}
		
		//��Ϣ����
		List<BusinessObject> fineList = bomanager.loadBusinessObjects("jbo.acct.ACCT_RATE_SEGMENT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo and RateType=:RateType", "ObjectType",bc.getBizClassName(),"ObjectNo",bc.getKeyString(),"RateType","02");
		for(BusinessObject fine:fineList)
		{
			
		}
		
		//��չ���˺�,��֤���˺�,�����˺�,�����˺�ƾ֤����
		
		List<BusinessObject> accountList = bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",bc.getBizClassName(),"ObjectNo",bc.getKeyString());
		for(BusinessObject account:accountList)
		{
		}
		
		//���������Ϣ
		List<BusinessObject> clList = bomanager.loadBusinessObjects("jbo.cl.CL_INFO", "ObjectType=:ObjectType and ObjectNo=:ObjectNo", "ObjectType",bc.getBizClassName(),"ObjectNo",bc.getKeyString());
		BusinessObject clbo = clList.get(0);
		
		
		bc.setAttributeValue("ContractStatus", "03");
		clbo.setAttributeValue("Status", "20");
		bomanager.updateBusinessObject(bc);
		bomanager.updateDB();
		
		
		return "true";
		
	}
}
