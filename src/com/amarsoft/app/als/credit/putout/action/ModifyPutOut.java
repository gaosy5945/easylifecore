package com.amarsoft.app.als.credit.putout.action;


import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 删除指定对象主信息和其关联信息，并将其关联流程信息也删除
 * @author 赵晓建
 */
public class ModifyPutOut{
	private String contractSerialNo;
	private String putOutSerialNo;

	public String getContractSerialNo() {
		return contractSerialNo;
	}

	public void setContractSerialNo(String contractSerialNo) {
		this.contractSerialNo = contractSerialNo;
	}

	
	public String getPutOutSerialNo() {
		return putOutSerialNo;
	}

	public void setPutOutSerialNo(String putOutSerialNo) {
		this.putOutSerialNo = putOutSerialNo;
	}

	public String modify(JBOTransaction tx) throws Exception {
		
		
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		BusinessObject bp = bomanager.keyLoadBusinessObject("jbo.app.BUSINESS_PUTOUT", this.putOutSerialNo);
		
		AddPutOutInfo add = new AddPutOutInfo();
		add.setUserID(bp.getString("InputUserID"));
		add.setOrgID(bp.getString("InputOrgID"));
		add.setContractSerialNo(contractSerialNo);
		add.setPutoutStatus("01");
		
		BusinessObject bo = BusinessObject.convertFromBizObject(add.createPutOut(bomanager.getTx()));
		bo.setAttributeValue("BatchSerialNo", bp.getString("BatchSerialNo"));
		bo.setAttributeValue("BusinessSum", bp.getDouble("BusinessSum"));
		bo.setAttributeValue("BusinessTerm", bp.getInt("BusinessTerm"));
		bo.setAttributeValue("Remark", bp.getString("Remark"));
		
		
		if(!bp.getKeyString().equals(bo.getKeyString()))
			bomanager.deleteBusinessObject(bp);
		bomanager.updateBusinessObject(bo);
		bomanager.updateDB();
		
		return "true";
	}
	
}
