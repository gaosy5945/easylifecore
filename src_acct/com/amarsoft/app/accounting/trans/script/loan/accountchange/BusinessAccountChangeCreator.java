package com.amarsoft.app.accounting.trans.script.loan.accountchange;

import java.util.List;

import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.config.impl.TransactionConfig;
import com.amarsoft.app.base.trans.TransactionProcedure;

/**
 * ����˻��������
 * @author Amarsoft�����Ŷ�
 */
public class BusinessAccountChangeCreator extends TransactionProcedure{

	public int run() throws Exception {
		String accountIndicator=TransactionConfig.getScriptConfig(transactionCode, scriptID, "AccountIndicator");
		List<BusinessObject> oldAccountList = bomanager.loadBusinessObjects(BUSINESSOBJECT_CONSTANTS.business_account, 
				"ObjectType=:ObjectType and ObjectNo=:ObjectNo and Status=:Status and AccountIndicator in(:AccountIndicator)",
				"ObjectType",relativeObject.getBizClassName(),"ObjectNo",relativeObject.getKeyString(),"Status","1","AccountIndicator",accountIndicator.split(","));
		for(BusinessObject account:oldAccountList)
		{
			//������ʷ�˻���Ϣ
			BusinessObject newAccount = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.business_account);
			newAccount.setAttributes(account);
			newAccount.generateKey(true);
			newAccount.setAttributeValue("ObjectType", documentObject.getBizClassName());
			newAccount.setAttributeValue("ObjectNo", documentObject.getKeyString());
			newAccount.setAttributeValue("Status", "2");
			bomanager.updateBusinessObject(newAccount);
			
			//�������˻���Ϣ����ǰ���޸�
			BusinessObject newAccountE = BusinessObject.createBusinessObject(BUSINESSOBJECT_CONSTANTS.business_account);
			newAccountE.setAttributes(account);
			newAccountE.generateKey(true);
			newAccountE.setAttributeValue("ObjectType", documentObject.getBizClassName());
			newAccountE.setAttributeValue("ObjectNo", documentObject.getKeyString());
			newAccountE.setAttributeValue("Status", "0");
			bomanager.updateBusinessObject(newAccountE);
		}
		
		documentObject.setAttributeValue("ObjectType", relativeObject.getBizClassName());
		documentObject.setAttributeValue("ObjectNo", relativeObject.getKeyString());
		bomanager.updateBusinessObject(documentObject);
		
		return 1;
	}

}