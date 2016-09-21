package com.amarsoft.app.als.sys.bizlet;

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.json.JSONObject;

public class CodeCreditAction {
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
	
	public String checkCodeCatalog(JBOTransaction tx)throws Exception{
		String result = "true";
		this.tx = tx;
		String codeno = (String) inputParameter.getValue("CodeNo");
		
		businessObjectManager = this.getBusinessObjectManager();
		
		List<BusinessObject> codeList = businessObjectManager.loadBusinessObjects("jbo.sys.CODE_CATALOG", "CodeNo=:CodeNo", "CodeNo", codeno);
		if(codeList.size()>0)
			result = "false@新增的代码已经存在，代码编号重复！";
		
		return result;
	}

	
	public String checkCodeLibrary(JBOTransaction tx)throws Exception{
		String result = "true";
		this.tx = tx;
		String codeno = (String) inputParameter.getValue("CodeNo");
		String itemno = (String) inputParameter.getValue("ItemNo");
		
		businessObjectManager = this.getBusinessObjectManager();
		
		List<BusinessObject> codeList = businessObjectManager.loadBusinessObjects("jbo.sys.CODE_LIBRARY", "CodeNo=:CodeNo and ItemNo=:ItemNo", "CodeNo", codeno,"ItemNo", itemno);
		if(codeList.size()>0)
			result = "false@新增的代码已经存在，代码编号重复！";
		
		return result;
	}
}
