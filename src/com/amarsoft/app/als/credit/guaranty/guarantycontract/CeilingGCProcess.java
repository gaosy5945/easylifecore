package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.credit.apply.action.CustInfoQuery;
import com.amarsoft.are.lang.StringX;

/**
 * @author
 * 新增最高额担保信息页面
 */
public class CeilingGCProcess extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	
	@Override
	public List<BusinessObject> update(BusinessObject guarantyContract,
			ALSBusinessProcess businessProcess) throws Exception {
		//担保人处理************start*****************
		String guaType = guarantyContract.getString("GuarantyType");
		if(!"01030".equals(guaType)){//联贷联保不新建客户
			String guarantorID = guarantyContract.getString("GuarantorID");
			String guarantorName = guarantyContract.getString("GuarantorName");
			String certType = guarantyContract.getString("CertType");
			String certID = guarantyContract.getString("CertID");
			
			CustInfoQuery query = new CustInfoQuery();
			query.setBusinessObjectManager(this.bomanager);
			
			if("".equals(guarantorID) || guarantorID == null){
				String returnFlag = query.addCustomer(certType,certID,guarantorName,guarantyContract.getString("InputOrgID"),guarantyContract.getString("InputUserID"));
				if(!StringX.isEmpty(returnFlag)){
					if("true".equals(returnFlag.split("@")[0]))
						guarantyContract.setAttributeValue("GuarantorID", returnFlag.split("@")[1]);
					else
						throw new Exception("新增客户失败");
				}
				else{
					throw new Exception("新增客户失败");
				}
			}
			else{
				BusinessObject bo = this.bomanager.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO",guarantorID);
				if(bo != null){
					if(!certType.equals(bo.getString("CertType")) || !certID.equals(bo.getString("CertID")) 
							|| !guarantorName.equals(bo.getString("CustomerName"))){
						throw new Exception("客户"+guarantorID+"的证件信息与录入信息冲突");
					}
				}
			}
		}
		//担保人处理************end*******************
		guarantyContract.generateKey();
		
		if(StringX.isEmpty(guarantyContract.getString("ContractNo"))){
			guarantyContract.setAttributeValue("ContractNo", GetGCContractNo.getCeilingGCContractNo(guarantyContract));
		}
		this.bomanager.updateBusinessObject(guarantyContract);

		String contractType = guarantyContract.getString("ContractType");
		/*if("020".equals(contractType)){
			BusinessObject cl = BusinessObject.createBusinessObject("jbo.cl.CL_INFO");
			cl.setAttributeValue("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
			cl.setAttributeValue("ObjectNo", guarantyContract.getObjectNo());
			cl.setAttributeValue("CLType", "1001");
			cl.setAttributeValue("Status", "10");
			cl.generateKey();
			this.bomanager.updateBusinessObject(cl);
		}*/
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(guarantyContract);
		
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		return businessObjectList;
	}

}
