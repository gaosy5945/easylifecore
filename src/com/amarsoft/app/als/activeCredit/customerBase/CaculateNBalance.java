package com.amarsoft.app.als.activeCredit.customerBase;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class CaculateNBalance {
	public double getBalacne(String CertID,JBOTransaction tx) throws Exception{
		BizObjectManager table = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(table);

		BizObjectQuery q = table.createQuery("CertID=:CertID and CertType='1'").setParameter("CertID", CertID);
		BizObject pr = q.getSingleResult(false);
		String CustomerID = "";
		double Balance = 0.0;
		double BusinessSum = 0.0;
		if(pr!=null)
		{
			CustomerID = pr.getAttribute("CustomerID").getString();
			
			BizObjectManager tableBC = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
			tx.join(tableBC);
			//������ƷΪ���������ô����018���Ĵ������֮��
			BizObjectQuery qBCBalance = tableBC.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", CustomerID);
			List<BizObject> BCBalanceList = qBCBalance.getResultList(false);
			if(BCBalanceList != null && !BCBalanceList.isEmpty())
			{
				for(BizObject boBCBalance:BCBalanceList)
				{
					String SerialNo = boBCBalance.getAttribute("SerialNo").getString();
					
					BizObjectManager tableBDBalance = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
					tx.join(tableBDBalance);
					
					BizObjectQuery qBDBalance = tableBDBalance.createQuery("ContractSerialno=:ContractSerialno and BusinessType='018'").setParameter("Contractserialno", SerialNo);
					List<BizObject> BDListBalance = qBDBalance.getResultList(false);
					if(BDListBalance != null && !BDListBalance.isEmpty())
					{
						for(BizObject boBDBalance:BDListBalance){
							double BalanceTemp = boBDBalance.getAttribute("Balance").getDouble();
							Balance += BalanceTemp;
						}
					}
				}
			}
			
			//������ƷΪ �����������Ŷ�ȡ���666���ҵ�����ʽΪ������δ����� ��ͬ���֮��
			BizObjectQuery qBCBusinessSum = tableBC.createQuery("CustomerID=:CustomerID and VouchType = 'D' and BusinessType = '666'").setParameter("CustomerID", CustomerID);
			List<BizObject> BCBusinessSumList = qBCBusinessSum.getResultList(false);
			if(BCBusinessSumList != null && !BCBusinessSumList.isEmpty())
			{
				for(BizObject boBCBusinessSum:BCBusinessSumList)
				{
					String SerialNo = boBCBusinessSum.getAttribute("SerialNo").getString();
					
					BizObjectManager tableBDBusinessSum = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL");
					tx.join(tableBDBusinessSum);
					
					BizObjectQuery qBDBusinessSum = tableBDBusinessSum.createQuery("ContractSerialno=:ContractSerialno and BusinessStatus in ('L0', 'L11', 'L12', 'L13')").setParameter("Contractserialno", SerialNo);
					List<BizObject> BDListBusinessSum = qBDBusinessSum.getResultList(false);
					if(BDListBusinessSum != null && !BDListBusinessSum.isEmpty())
					{
						for(BizObject boBDBusinessSum:BDListBusinessSum){
							double BusinessSumTemp = boBDBusinessSum.getAttribute("BusinessSum").getDouble();
							BusinessSum += BusinessSumTemp;
						}
					}
				}
			}
		}
		
		//����N���ڷ��������������ô������
		double NBusinessBalance = Balance + BusinessSum;

		return NBusinessBalance;
	}
}
