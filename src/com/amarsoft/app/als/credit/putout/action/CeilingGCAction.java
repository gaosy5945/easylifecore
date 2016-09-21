package com.amarsoft.app.als.credit.putout.action;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.guaranty.model.GuarantyContractAction;
import com.amarsoft.app.als.guaranty.model.GuarantyObjects;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.json.JSONObject;

/**
 * @author t-zhangq2
 *
 */
public class CeilingGCAction {
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

	//生效最高额担保合同(不支持批量生效)
	public String validateContract(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.validateContract(tx,serialNo);
	}
	
	public String validateContract(JBOTransaction tx,String serialNo) throws Exception{
		
		BizObjectManager arm = JBOFactory.getBizObjectManager("jbo.app.APPLY_RELATIVE");
		tx.join(arm);
		GuarantyObjects go = new GuarantyObjects();
		go.load(tx.getConnection(arm), "jbo.guaranty.GUARANTY_CONTRACT", serialNo);
		go.calcBalance();
		
		if(go.RiskMessage.size() > 0){
			String returnString = "";
			for(String message:go.RiskMessage)
			{
				returnString += message+"\r\n";
			}
			return returnString;
		}
		
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		//String serialNoArray[] = serialNos.split("@");
		String message = "";
		List<BusinessObject> gclist = new ArrayList<BusinessObject>();
		
		BusinessObject gc = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", serialNo);
		String maturityDate = gc.getString("MaturityDate");
		if(StringX.isEmpty(maturityDate)){
			message = "最高额担保合同"+gc.getString("ContractNo")+"未录入合同到期日，生效失败！";
			return message;
		}
		String status = gc.getString("ContractStatus");
		if("01".equals(status)){
			if(!compareDate(maturityDate,DateHelper.getBusinessDate())){//当前日期未超过合同到期日，则生效
				gc.setAttributeValue("ContractStatus", "02");
				gclist.add(gc);
			}
			else{
				message = "最高额担保合同"+gc.getString("ContractNo")+"已到期，不能生效！";
				return message;
			}
		}
		
		//调用担保方案及其关联信息保存接口
		GuarantyInfoSave gs = new GuarantyInfoSave();
		String result = gs.saveGuaranty(serialNo,"",tx);
		if(!"true".equals(result)){
			gc.setAttributeValue("ContractStatus", "01");
			gclist.add(gc);
		}
		
		bomanager.updateBusinessObjects(gclist);
		bomanager.updateDB();
		
		return result;
	}
	
	//date2是否超过date1
	public boolean compareDate(String date1,String date2){
		date1 = date1.substring(0, 4) + date1.substring(5,7) + date1.substring(8,10);
		date2 = date2.substring(0, 4) + date2.substring(5,7) + date2.substring(8,10);
		if(Integer.parseInt(date2) > Integer.parseInt(date1))
			return true;
		else
			return false;
	}
	
	//失效最高额担保合同
	public String inValidateContract(JBOTransaction tx) throws Exception{
		this.tx=tx;
		String serialNo = (String)inputParameter.getValue("SerialNo");
		return this.inValidateContract(serialNo);
	}
	
	public String inValidateContract(String serialNo) throws Exception{
		BusinessObjectManager bomanager = this.getBusinessObjectManager();
		BusinessObject gc = bomanager.keyLoadBusinessObject("jbo.guaranty.GUARANTY_CONTRACT", serialNo);
		
		String status = gc.getString("ContractStatus");
		if("02".equals(status)){
			gc.setAttributeValue("ContractStatus", "03");
			bomanager.updateBusinessObject(gc);
			bomanager.updateDB();
		}

		//调用删除担保方案及其关联信息接口
		/*
		try{
			OCITransaction oci = ClrInstance.GntPrpslAndInfoDel(serialNo,bomanager.getTx().getConnection(bomanager.getBizObjectManager(gc.getObjectType())));
		}catch(Exception ex)
		{
			ex.printStackTrace();
			ARE.getLog().error("GUARANTY_CONTRACT_"+gc.getObjectNo()+"_save_error.");
			throw ex;
		}*/
		bomanager.updateBusinessObject(gc);
		bomanager.updateDB();
				
		return "true";
	}
}