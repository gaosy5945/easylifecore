package com.amarsoft.app.als.customer.common.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class IndCustomerBasicInfoHandler extends CommonHandler{

	protected  void afterUpdate(JBOTransaction tx, BizObject bo) throws Exception{
		
		BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO");
		tx.join(bm);
		String customerID = bo.getAttribute("customerID").getString();
		String customerName = bo.getAttribute("customerName").getString();
		String smemonoPolyFlag = bo.getAttribute("smemonoPolyFlag").getString();
		String englishName = bo.getAttribute("ENGLISHNAME").getString();
		String isConsumeCredit = bo.getAttribute("ISCONSUMECREDIT").getString();
		String consumeCreditDate = bo.getAttribute("CONSUMECREDITDATE").getString();
		String issueCountry = bo.getAttribute("ISSUECOUNTRY").getString();
		bm.createQuery("update O set SMEMONOPOLYFLAG=:smemonoPolyFlag,ENGLISHNAME=:englishName,ISCONSUMECREDIT=:isConsumeCredit,CONSUMECREDITDATE=:consumeCreditDate,ISSUECOUNTRY=:issueCountry Where customerID=:customerID")
		  .setParameter("smemonoPolyFlag", smemonoPolyFlag).setParameter("englishName", englishName).setParameter("isConsumeCredit", isConsumeCredit).setParameter("consumeCreditDate", consumeCreditDate)
		  .setParameter("issueCountry", issueCountry).setParameter("customerID", customerID)
		  .executeUpdate();
		
		
		BizObjectManager bm1 = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_IDENTITY");
		tx.join(bm1);
		
		String certType = bo.getAttribute("CERTTYPE").getString();
		String certID = bo.getAttribute("CERTID").getString();
		String cnidegCity = bo.getAttribute("CNIDREGCITY").getString();
		String idexpriry = bo.getAttribute("IDEXPIRY").getString();
		
		bm1.createQuery("update O set CERTTYPE=:CERTTYPE,CERTID=:CERTID,CNIDREGCITY=:CNIDREGCITY,IDEXPIRY=:IDEXPIRY Where customerID=:customerID")
		  .setParameter("CERTTYPE", certType).setParameter("CERTID", certID).setParameter("CNIDREGCITY", cnidegCity)
		  .setParameter("IDEXPIRY", idexpriry).setParameter("customerID", customerID)
		  .executeUpdate();
		
		
		BizObjectManager bm2 = JBOFactory.getBizObjectManager("jbo.customer.IND_SI");
		tx.join(bm2);
		
		String accountNo = bo.getAttribute("ACCOUNTNO").getString();
		
		bm2.createQuery("update O set ACCOUNTNO=:ACCOUNTNO Where customerID=:customerID")
		  .setParameter("ACCOUNTNO", accountNo).setParameter("customerID", customerID)
		  .executeUpdate();
		
		
		BizObjectManager bm3 = JBOFactory.getBizObjectManager("jbo.customer.IND_RESUME");
		tx.join(bm3);
		
		String employMent = bo.getAttribute("EMPLOYMENT").getString();
		String companyNature = bo.getAttribute("COMPANYNATURE").getString();
		//String companyTel = bo.getAttribute("COMPANYTEL").getString();
		//String companyAdd = bo.getAttribute("COMPANYADD").getString();
		//String companyZip = bo.getAttribute("COMPANYZIP").getString();
		String departMent = bo.getAttribute("DEPARTMENT").getString();
		String industryType = bo.getAttribute("INDUSTRYTYPE").getString();
		String employerScale = bo.getAttribute("EMPLOYERSCALE").getString();
		String beginDate = bo.getAttribute("BEGINDATE").getString();
		
		bm3.createQuery("update O set EMPLOYMENT=:EMPLOYMENT,COMPANYNATURE=:COMPANYNATURE"
				+ ",DEPARTMENT=:DEPARTMENT,INDUSTRYTYPE=:INDUSTRYTYPE,EMPLOYERSCALE=:EMPLOYERSCALE,BEGINDATE=:BEGINDATE"
				+ " Where customerID=:customerID")
		  .setParameter("EMPLOYMENT", employMent).setParameter("COMPANYNATURE", companyNature).setParameter("DEPARTMENT", departMent)
		  .setParameter("INDUSTRYTYPE", industryType).setParameter("EMPLOYERSCALE", employerScale).setParameter("BEGINDATE", beginDate)
		  .setParameter("customerID", customerID)
		  .executeUpdate();
		//修改客户信息时,调用修改接口
		//ECIFAlterInstance.queryAlterECIFCustomer(customerID, certType, certID, customerName, tx);
		
	}

}
