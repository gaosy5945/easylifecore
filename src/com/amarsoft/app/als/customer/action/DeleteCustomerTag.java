package com.amarsoft.app.als.customer.action;

/**
 * 删除客户分组逻辑类
 * @author 柳显涛
 *
 */

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.als.businesscomponent.config.BusinessComponentManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class DeleteCustomerTag {

	private JSONObject inputParameter;

	private BusinessObjectManager businessObjectManager;
	
	public void setInputParameter(JSONObject inputParameter) {
		this.inputParameter = inputParameter;
	}
	
	private JBOTransaction tx;

	public void setTx(JBOTransaction tx) {
		this.tx = tx;
	}
	
	private BusinessObjectManager getBusinessObjectManager() throws JBOException, SQLException{
		if(businessObjectManager==null)
			businessObjectManager = BusinessObjectManager.createBusinessObjectManager(tx);
		return businessObjectManager;
	}
	
	public void setBusinessObjectManager(BusinessObjectManager businessObjectManager) {
		this.businessObjectManager = businessObjectManager;
		this.tx = businessObjectManager.getTx();
	}
	
	
	public String deleteCustomerTag(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		deleteTagCatalog(serialNo);
		deleteTagLibrary(serialNo);
		return "SUCCEED";
	}
	
	public String deleteTagCatalog(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject bo = bomanager.keyLoadBusinessObject(CustomerConst.OBJECT_TAG_CATALOG, serialNo);
		bomanager.deleteBusinessObject(bo);

		bomanager.updateDB();
		return "SUCCEED";
	}
	
	public String deleteTagLibrary(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		List<BusinessObject> bo = bomanager.loadBusinessObjects(CustomerConst.OBJECT_TAG_LIBRARY, "tagSerialNo = :tagSerialNo", "tagSerialNo",serialNo);
		bomanager.deleteBusinessObjects(bo);

		bomanager.updateDB();
		return "SUCCEED";
	}
	
}
