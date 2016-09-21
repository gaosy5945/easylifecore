package com.amarsoft.app.als.prd.demo;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.are.jbo.JBOTransaction;

public class BusinessApplyLoader implements IBusinessDataLoader {

	public BusinessObject load(JBOTransaction tx, String sceneType,String sceneNo,String objectType,String objectNo) throws Exception {
		BusinessObjectManager bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		//1.申请信息
		BusinessObject businessApply = bomanager.keyLoadBusinessObject(objectType, objectNo);
		//2.借款人信息
		String customerID = businessApply.getString("CustomerID");
		BusinessObject customer = null;
		if(customerID!=null&&customerID.length()>0){
			customer = bomanager.keyLoadBusinessObject("jbo.app.CUSTOMER_INFO",customerID);
			if(customer!=null){
				String customerType = customer.getString("CustomerType");
				if(customerType!=null && !"".equals(customerType))
					if(customerID.length() >= 3)
						customerType = customerType.substring(0, 3);
				if("030".equals(customerType) || "040".equals(customerType) || "035".equals(customerType)){//个人客户
					BusinessObject customer_ind = bomanager.keyLoadBusinessObject("jbo.app.IND_INFO",customerID);
					if(customer_ind!=null) customer.appendAttributes(customer_ind);
				}
				else {//企业客户
					BusinessObject customer_ent = bomanager.keyLoadBusinessObject("jbo.app.ENT_INFO",customerID);
					if(customer_ent!=null) customer.appendAttributes(customer_ent);
				}
				businessApply.setAttributesValue(customer);
			}
		}
		//3.担保信息....
		/*String sql = "select * from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where ObjectType='GuarantyContract' and SerialNo=:ObjectNo )";
		List<BusinessObject> guarantyContractList = bomanager.loadBusinessObjects_SQL(
				"jbo.app.GUARANTY_CONTRACT",sql, "ObjectNo="+objectNo, ",");
		businessApply.setRelativeObjects(guarantyContractList);
		//4.押品信息
		sql  = "select * from GUARANTY_INFO where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType=:ObjectType and ObjectNo=:ObjectNo )";
		List<BusinessObject> collateralList = bomanager.loadBusinessObjects_SQL(
				"jbo.app.GUARANTY_INFO", sql,"ObjectType="+objectType+",ObjectNo="+objectNo,",");
		businessApply.setRelativeObjects(collateralList);*/
		//5.其他信息......
		
		//jbo.app.CUSTOMER_CONTRIBUTION
		
		return businessApply;
	}
}
