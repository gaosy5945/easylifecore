package com.amarsoft.app.lending.bizlets;


import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * 对合同增加变更交易
 * @author qzhang2 2014/12/22
 *
 */

public class InsertTransInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{	
		String contractSerialNo=(String)this.getAttribute("serialNo");
		String userID=(String)this.getAttribute("userID");
		String orgID=(String)this.getAttribute("orgID");
		String sReturn="";
		JBOTransaction tx = null;
		try{
			tx = JBOFactory.createJBOTransaction();
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager bcm = f.getManager("jbo.acct.ACCT_TRANSACTION");
			tx.join(bcm);					
			BizObject at = bcm.newObject();
			
			//插入变更信息
			at.setAttributeValue("TRANSSTATUS", "0");
			at.setAttributeValue("RELATIVEOBJECTTYPE", "jbo.app.BUSINESS_CONTRACT");				
			at.setAttributeValue("INPUTORGID", orgID);
			at.setAttributeValue("INPUTUSERID", userID);
			at.setAttributeValue("INPUTTIME", DateHelper.getBusinessDate());
			at.setAttributeValue("RELATIVEOBJECTNO", contractSerialNo);
			at.setAttributeValue("TRANSACTIONCODE", "0000");
			at.setAttributeValue("TRANSACTIONNAME", "贷后变更");
			
			bcm.saveObject(at);
			sReturn = at.getAttribute("SerialNo").getString();
			tx.commit();		
		}catch(Exception ex){
			if(tx != null) tx.rollback();
			throw ex;
		}
		return sReturn;
	}


}
