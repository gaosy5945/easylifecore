package com.amarsoft.app.als.credit.contract.action;

import java.sql.SQLException;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.Transaction;



/**
 * @author t-wur
 *
 */
public class DeletePersonInfo {
	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}

	public String deletePerson(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.deletePerson(serialNo);
	}
	
	public String deletePerson(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject ao = bomanager.keyLoadBusinessObject("jbo.app.ASSET_OWNER", serialNo);
	
		if(ao==null)return "true";
		
		String OwnerNo = ao.getString("CMISSERIALNO");
		if(!StringX.isEmpty(OwnerNo)){//判断是否押品系统中同样存在抵押人编号，若存在，则调用押品接口删除，否则不调用。
			//权属人信息删除
			try{
				Transaction Sqlca = Transaction.createTransaction(tx);
				//OCITransaction oci = ClrInstance.RtOwnerInfoDel(OwnerNo,Sqlca.getConnection());
			}catch(Exception ex)
			{
				ex.addSuppressed(new Exception("INSURANCE_INFO_"+ao.getKeyString()+"_save_error."));
				throw ex;
			}
		}
		
		bomanager.deleteBusinessObject(ao);
		bomanager.updateDB();
		
		return "true";
	}

}