package com.amarsoft.acct.accounting.web;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

/**
 * <p>
 * 获取Transaction对应的对象类型以及权限
 * </p>
 * @author  2015.11.18
 *
 */

public class GetTransactionRela extends Bizlet {
	
	public Object run(Transaction Sqlca) throws Exception {
		
		//自动获得传入的参数值
				String sSerialNo = (String)this.getAttribute("SerialNo");
				String sType = (String)this.getAttribute("Type");
				
				BusinessObjectManager bom = new BusinessObjectManager();
				BusinessObject bo =bom.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.transaction, "SerialNo",sSerialNo);
				String sRelativeObjectType = bo.getString("RelativeObjectType");
				String sRelativeObjectNo = bo.getString("RelativeObjectNo");
				
				 if(sRelativeObjectType.equals(BUSINESSOBJECT_CONSTANTS.loan))
					{
						if(BUSINESSOBJECT_CONSTANTS.loan.equals(sType))
							return sRelativeObjectNo;
						else if("jbo.app.BUSINESS_CONTRACT".equals(sType))
						{
							BusinessObject boLoan = bom.loadBusinessObject(sRelativeObjectType, "SerialNo",sRelativeObjectNo);
							return boLoan.getString("ContractSerialNo");
						}
						else if(BUSINESSOBJECT_CONSTANTS.transaction.equals(sType))
						{
							if(BUSINESSOBJECT_CONSTANTS.transaction.equals(bo.getString("DocumentType")) && !"4001".equals(bo.getString("TransCode")))
							{
								return bo.getString("DocumentNo");
							}
						}
						else return "";
					}
					else if(sRelativeObjectType.equals("jbo.app.BUSINESS_CONTRACT"))
					{
						if("jbo.app.BUSINESS_CONTRACT".equals(sType))
						{
							return sRelativeObjectNo;
						}
						else if(BUSINESSOBJECT_CONSTANTS.transaction.equals(sType))
						{
							if(BUSINESSOBJECT_CONSTANTS.transaction.equals(bo.getString("DocumentType")))
							{
								return bo.getString("DocumentNo");
							}
						}
						else
							return "";
					}
				
				
				return "";
	}
}
