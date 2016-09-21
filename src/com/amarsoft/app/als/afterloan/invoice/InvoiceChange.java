package com.amarsoft.app.als.afterloan.invoice;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.are.jbo.JBOTransaction;

public class InvoiceChange {
	
	private String serialNo;
	private String status;

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	public String InvoiceStatusChange(JBOTransaction tx) throws Exception{
		String sReturn = "failed";
		BusinessObjectManager bom = BusinessObjectManager.createBusinessObjectManager();
		BusinessObject bo = bom.keyLoadBusinessObject(BUSINESSOBJECT_CONSTANTS.invoice_register, serialNo);
		bo.setAttributeValue("status", status);
		bom.updateBusinessObject(bo);
		bom.updateDB();
		sReturn = "success";
		return sReturn;
	}
}
