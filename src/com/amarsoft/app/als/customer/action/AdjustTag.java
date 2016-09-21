package com.amarsoft.app.als.customer.action;

/**
 * author：柳显涛
 * 说明：分组调整类
 */

import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.json.JSONObject;

public class AdjustTag{
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
	public String AdjustTag(JBOTransaction tx) throws Exception{
		this.tx = tx;
		String newTagSerialNo = (String)inputParameter.getValue("newTagSerialNo");
		String serialNo = (String)inputParameter.getValue("serialNo");
		String customerID = (String)inputParameter.getValue("CustomerID");
		String inputUserID = (String)inputParameter.getValue("InputUserID");
		String inputDate = (String)inputParameter.getValue("InputDate");
		String inputOrgID = (String)inputParameter.getValue("InputOrgID");
		String[] serialNoArray = newTagSerialNo.split("~");
		String[] customerIDArray = customerID.split("@");
		String[] lastSerialNoArray = serialNo.split("@");
		
		for(int j = 0; j < serialNoArray.length; j++){
			for(int i = 0; i < customerIDArray.length; i++){
			UpdateToTag(serialNoArray[j].split("@")[0],serialNoArray[j].split("@")[1],customerIDArray[i],lastSerialNoArray[i],inputUserID,inputDate,inputOrgID);
		}
	}
		return "SUCCEED";
	}
	
	public String UpdateToTag(String newTagSerialNo,String tagID,String customerID,String lastSerialNo,String inputUserID,String inputDate,String inputOrgID) throws Exception{

			BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.OBJECT_TAG_LIBRARY");
			tx.join(bm);
			
			bm.createQuery("update O set tagSerialNo=:newTagSerialNo Where SerialNo=:SerialNo")
			.setParameter("newTagSerialNo", newTagSerialNo).setParameter("SerialNo", lastSerialNo)
			.executeUpdate();
			
			return "SUCCEED";
	}
}
