package com.amarsoft.app.als.credit.contract.action;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;
import com.amarsoft.awe.util.Transaction;



/**
 * @author t-wur
 *
 */
public class DeleteInsuranceInfo {
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

	public String deleteInsurance(JBOTransaction tx) throws Exception{
		this.tx=tx;
		getBusinessObjectManager();
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.deleteInsurance(serialNo);
	}
	
	public String deleteInsurance(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject ii = bomanager.keyLoadBusinessObject("jbo.app.INSURANCE_INFO", serialNo);
	
		if(ii==null)return "true";
		
		String InsRcdNo = ii.getString("CMISSERIALNO");
		if(!StringX.isEmpty(InsRcdNo)){
			//保险信息删除
			try{
				Transaction Sqlca = Transaction.createTransaction(tx);
				//OCITransaction oci = ClrInstance.InsInfoDel(InsRcdNo,Sqlca.getConnection());
			}catch(Exception ex)
			{
				ex.addSuppressed(new Exception("INSURANCE_INFO_"+ii.getKeyString()+"_save_error."));
				throw ex;
			}
			
			//如果有相同保险的信息，将多余的保险删除
			BizObjectManager bom = JBOFactory.getBizObjectManager("jbo.app.INSURANCE_INFO");
			tx.join(bom);
			BizObjectQuery bii = bom.createQuery("CmisSerialNo=:CmisSerialNo and SerialNo <>:SerialNo").setParameter("CmisSerialNo", InsRcdNo).setParameter("SerialNo", serialNo);
			List<BizObject> DataList = bii.getResultList(false);
			if(DataList!=null){
				for(BizObject bo:DataList){
					String SerialNoOthers = bo.getAttribute("SerialNo").getString();
					bom.createQuery("Delete From O Where SerialNo=:SerialNoOthers").setParameter("SerialNoOthers", SerialNoOthers).executeUpdate();
				}
			}
		}
		
		bomanager.deleteBusinessObject(ii);
		bomanager.updateDB();
		
		return "true";
	}

}