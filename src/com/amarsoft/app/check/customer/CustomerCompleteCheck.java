package com.amarsoft.app.check.customer;

import java.util.List;

import com.amarsoft.app.alarm.AlarmBiz;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.prd.analysis.ProductAnalysisFunctions;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;


/**
 * �ͻ���Ϣ�����Լ��
 * @author xjzhao
 * @since 2014/12/10
 */
public class CustomerCompleteCheck extends AlarmBiz {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		/** ȡ���� **/
		List<BusinessObject> baList = (List<BusinessObject>)this.getAttribute("Main");	//��ȡ������Ϣ
		
		if(baList == null || baList.isEmpty())
			putMsg("���������Ϣδ�ҵ������飡");
		else
		{
			for(BusinessObject ba:baList)
			{
				BusinessObject customer = ba.getBusinessObjectByKey("jbo.customer.IND_INFO",ba.getString("CustomerID"));
				if(customer == null) putMsg("δ�ҵ������ˡ�"+ba.getString("CustomerName")+"���ͻ���Ϣ");
				else if(!"0".equals(customer.getString("TempSaveFlag"))){
					putMsg("�뱣�桾"+ba.getString("CustomerName")+"���Ŀͻ���Ϣ��");
				}
				String customerID = ba.getString("CustomerID");
				String productType3 = Sqlca.getString(new SqlObject("select productType3 from PRD_PRODUCT_LIBRARY where ProductID = :ProductID").setParameter("ProductID", ba.getString("ProductID")));
				String smEmonopolyFlag =  Sqlca.getString(new SqlObject("select smEmonopolyFlag from CUSTOMER_INFO where CustomerID = :CustomerID").setParameter("CustomerID", customerID));
				if(smEmonopolyFlag == null) smEmonopolyFlag = "";
				if("1".equals(smEmonopolyFlag)){
					String smClientType = customer.getString("smClientType");
					if(smClientType == null || "".equals(smClientType)){
						putMsg("��ѡ��ͻ���"+ba.getString("CustomerName")+"���Ŀͻ�������ͣ�");
					}else if("4".equals(smClientType) && "02".equals(productType3)){
						putMsg("��Ӫ�Դ���Ŀͻ�������Ͳ���Ϊ��������Ȼ�ˡ������޸ģ�");
					}
				}
				ASResultSet ii = Sqlca.getResultSet(new SqlObject("select II.Marriage from IND_INFO II where II.CustomerID = :CustomerID and II.Marriage in('20','21','22','23')")
				.setParameter("CUSTOMERID", customerID));
				//ֻ�е���������ҪУ��������Ϣ��������
				BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
				List<BusinessObject> relaBas = bom.loadBusinessObjects("jbo.app.BUSINESS_APPLY", "SerialNo in(select AR.ObjectNo from jbo.app.APPLY_RELATIVE AR where AR.ApplySerialNo=:ApplySerialNo and AR.ObjectType = 'jbo.app.BUSINESS_APPLY' and AR.RelativeType = '04')", "ApplySerialNo",ba.getString("SerialNo"));
				String approveModel = "";
				if(relaBas != null && relaBas.size() > 0)
				{
					approveModel = ProductAnalysisFunctions.getComponentOptionalValue(relaBas.get(0), "PRD04-04", "CreditApproveModel","0010", "02");
				}else{
					approveModel = ProductAnalysisFunctions.getComponentOptionalValue(ba, "PRD04-04", "CreditApproveModel","0010", "02");
				}
				if(approveModel != null && "01".equals(approveModel)){
					Boolean flag = false;
					String amount = Sqlca.getString(new SqlObject("select AMOUNT from CUSTOMER_FINANCE where CustomerID = :CustomerID and FinancialItem = '3050' ")
					.setParameter("CUSTOMERID", customerID));
					if(amount != null && !"".equals(amount)){
						flag = true;
					}
					if(!flag){
						putMsg("���롾"+ba.getString("CustomerName")+"����������Ϣδ¼�룡");
					}
				}
				if(ii.next()){
					boolean iiflag = false;
					ASResultSet iii = Sqlca.getResultSet(new SqlObject("select C.CUSTOMERNAME,II.TEMPSAVEFLAG from CUSTOMER_INFO C,CUSTOMER_RELATIVE CR,IND_INFO II where "
							+ "C.CUSTOMERID = CR.CUSTOMERID and CR.RELATIONSHIP = '2007' and CR.RELATIVECUSTOMERID = II.CUSTOMERID and"
							+ " C.CUSTOMERID = :CUSTOMERID").setParameter("CUSTOMERID", customerID));
					if(iii.next()){
						iiflag = true;
					}
					if(!iiflag){
						putMsg("���롾"+ba.getString("CustomerName")+"������״��Ϊ�ѻ� ������δ¼����ż��Ϣ��");
					}
					iii.close();
				}else{
					boolean iiflag = false;
					ASResultSet iii = Sqlca.getResultSet(new SqlObject("select C.CUSTOMERNAME,II.TEMPSAVEFLAG from CUSTOMER_INFO C,CUSTOMER_RELATIVE CR,IND_INFO II where "
							+ "C.CUSTOMERID = CR.CUSTOMERID and CR.RELATIONSHIP = '2007' and CR.RELATIVECUSTOMERID = II.CUSTOMERID and"
							+ " C.CUSTOMERID = :CUSTOMERID").setParameter("CUSTOMERID", customerID));
					if(iii.next()){
						iiflag = true;
					}
					if(iiflag){
						putMsg("���롾"+ba.getString("CustomerName")+"������״��Ϊδ�� �����ǹ�����������ż��");
					}
					iii.close();
				}
				ii.close();
				ASResultSet rr = Sqlca.getResultSet(new SqlObject("select * from CUSTOMER_TEL where CUSTOMERID = :CUSTOMERID").setParameter("CUSTOMERID", customerID));
				ASResultSet rr1 = Sqlca.getResultSet(new SqlObject("select * from PUB_ADDRESS_INFO where ObjectType = 'jbo.customer.CUSTOMER_INFO' and ObjectNo = :ObjectNo").setParameter("ObjectNo", customerID));
				
				boolean flag2 = false;
				boolean flag3 = false;
				if(rr.next()){
					flag2 = true;
				}
				if(rr1.next()){
					flag3 = true;
				}
				if(!flag2){
					putMsg("���롾"+ba.getString("CustomerName")+"����ϵ�绰��Ϣδ¼��!");
				}
				rr.close();
				if(!flag3){
					putMsg("���롾"+ba.getString("CustomerName")+"����ϵ��ַ��Ϣδ¼��!");
				}
				rr1.close();
			}
		}
		
		/** ���ؽ������ **/
		if(messageSize() > 0){
			setPass(false);
		}else{
			setPass(true);
		}
		
		return null;
	}
}
