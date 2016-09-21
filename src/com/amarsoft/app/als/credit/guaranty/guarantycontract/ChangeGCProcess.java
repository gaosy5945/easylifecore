package com.amarsoft.app.als.credit.guaranty.guarantycontract;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.als.credit.apply.action.CustInfoQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.util.DBKeyHelp;

public class ChangeGCProcess extends ALSBusinessProcess
implements BusinessObjectOWDeleter,BusinessObjectOWUpdater{
	
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
		
		
		String guarantyContractSerialNo=guarantyContract.getKeyString();
		if(StringX.isEmpty(guarantyContractSerialNo)){
			guarantyContract.generateKey();
		}
		
		if(StringX.isEmpty(guarantyContract.getString("ContractNo"))){
			String contractNo = this.getGuarantyContractNo(guarantyContract);//自动生成担保编号
			guarantyContract.setAttributeValue("ContractNo", contractNo);
		}
		this.bomanager.updateBusinessObject(guarantyContract);

		String contractType = guarantyContract.getString("ContractType");
		if("020".equals(contractType)){
			BusinessObject cl = BusinessObject.createBusinessObject("jbo.cl.CL_INFO");
			cl.setAttributeValue("ObjectType", "jbo.guaranty.GUARANTY_CONTRACT");
			cl.setAttributeValue("ObjectNo", guarantyContract.getKeyString());
			cl.setAttributeValue("CLType", "1001");
			cl.setAttributeValue("Status", "10");
			cl.generateKey();
			this.bomanager.updateBusinessObject(cl);
		}
		
		String[] relativeTables=com.amarsoft.app.als.guaranty.model.GuarantyFunctions.getRelativeTable(this.asPage.getParameter("ObjectType"));
		BusinessObject applyRelative = null;
		if(!StringX.isEmpty(relativeTables[0])){
			applyRelative = guarantyContract.getBusinessObject(relativeTables[0]);
		}
		else
			applyRelative = guarantyContract.getBusinessObject("jbo.app.APPLY_RELATIVE");
		applyRelative.setAttributeValue("ObjectType",guarantyContract.getBizClassName());
		applyRelative.setAttributeValue("ObjectNo",guarantyContract.getKeyString());
		if("010".equals(contractType)){
			applyRelative.setAttributeValue("RelativePercent", 1.0);   //100%
		}
		String applyRelativeNo=applyRelative.getKeyString();
		if(StringX.isEmpty(applyRelativeNo)){
			applyRelative.generateKey();
			applyRelativeNo = applyRelative.getKeyString();
		}
		this.bomanager.updateBusinessObject(applyRelative);
		
		String guarantyType = guarantyContract.getString("GuarantyType");

		if(guarantyType.equals("01020")){//履约保险保证
			//删除该担保保证金信息
			List<BusinessObject> clrList = this.bomanager.loadBusinessObjects("jbo.guaranty.CLR_MARGIN_INFO", 
					"ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo", "ObjectNo",guarantyContract.getKeyString());
			if(clrList != null || clrList.size() != 0)
				this.bomanager.deleteBusinessObjects(clrList);
			//删除押品信息
			List<BusinessObject> grList = this.bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", 
					"GCSerialNo=:GCSerialNo", "GCSerialNo",guarantyContract.getKeyString());
			this.bomanager.deleteBusinessObjects(grList);
		}
		else if(guarantyType.equals("01010") || guarantyType.equals("01030") || guarantyType.equals("01080") || guarantyType.equals("01090")){//保证金
			//删除该担保保险信息
			List<BusinessObject> insuranceList = this.bomanager.loadBusinessObjects("jbo.app.INSURANCE_INFO", 
					"ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo", "ObjectNo",guarantyContract.getKeyString());
			if(insuranceList != null || insuranceList.size() != 0)
				this.bomanager.deleteBusinessObjects(insuranceList);
			//删除押品信息
			List<BusinessObject> grList = this.bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", 
					"GCSerialNo=:GCSerialNo", "GCSerialNo",guarantyContract.getKeyString());
			this.bomanager.deleteBusinessObjects(grList);
		}
		else{
			//删除该担保保证金信息
			List<BusinessObject> clrList = this.bomanager.loadBusinessObjects("jbo.guaranty.CLR_MARGIN_INFO", 
					"ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo", "ObjectNo",guarantyContract.getKeyString());
			if(clrList != null || clrList.size() != 0)
				this.bomanager.deleteBusinessObjects(clrList);
			//删除该担保保险信息
			List<BusinessObject> insuranceList = this.bomanager.loadBusinessObjects("jbo.app.INSURANCE_INFO", 
					"ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo", "ObjectNo",guarantyContract.getKeyString());
			if(insuranceList != null && insuranceList.size() != 0)
				this.bomanager.deleteBusinessObjects(insuranceList);
		}
		
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(guarantyContract);
		
		//this.bomanager.updateDB();
		return result;
	}

	//自动生成担保编号，一般担保为业务合同编号+4位，最高额担保为机构+年份+10位
	public String getGuarantyContractNo(BusinessObject bo) throws Exception{
		String contractType = bo.getString("ContractType");
		if("020".equals(contractType)){//最高额担保，机构+年份+10位
			return GetGCContractNo.getCeilingGCContractNo(bo);
		}
		
		String applySerialNo = "",applyTable = "",relativeTable = "",serialNoType = "";
		if("jbo.app.BUSINESS_APPLY".equals(this.asPage.getParameter("ObjectType"))){
			applySerialNo = bo.getString("ApplySerialNo");
			applyTable = "jbo.app.BUSINESS_APPLY";
			relativeTable = "jbo.app.APPLY_RELATIVE";
			serialNoType = "ApplySerialNo";
		}else if("jbo.app.BUSINESS_CONTRACT".equals(this.asPage.getParameter("ObjectType"))){
			applySerialNo = bo.getString("ContractSerialNo");
			applyTable = "jbo.app.BUSINESS_CONTRACT";
			relativeTable = "jbo.app.CONTRACT_RELATIVE";
			serialNoType = "ContractSerialNo";
		}
		
		BusinessObject ba = this.bomanager.keyLoadBusinessObject(applyTable, applySerialNo);
		String artificialNo = ba.getString("ContractArtificialNo");
		
		if("010".equals(contractType)){//一般担保，业务合同编号+4位
			
			String sno = GetGCContractNo.getGCContractNo(artificialNo);
			
			return sno;
		}
		
		return "";
	}
	
	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		return businessObjectList;
	}

	@Override
	public int delete(BusinessObject guarantyContract,
			ALSBusinessProcess businessProcess) throws Exception {
		BusinessObject applyRelative = guarantyContract.getBusinessObject("jbo.app.APPLY_RELATIVE");
		
		String contractStatus = guarantyContract.getString("ContractStatus");
		if("01".equals(contractStatus)){//待生效
			String guarantyType = guarantyContract.getString("GuarantyType");
			if(guarantyType.equals("01020")){//履约保险保证
				List<BusinessObject> insuranceList = this.bomanager.loadBusinessObjects("jbo.app.INSURANCE_INFO", 
						"ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo", "ObjectNo",guarantyContract.getKeyString());
				if(insuranceList != null && insuranceList.size() != 0)
					this.bomanager.deleteBusinessObjects(insuranceList);
			}
			else if(guarantyType.equals("01010") || guarantyType.equals("01030") || guarantyType.equals("01080") || guarantyType.equals("01090")){
				List<BusinessObject> clrList = this.bomanager.loadBusinessObjects("jbo.guaranty.CLR_MARGIN_INFO", 
						"ObjectType='jbo.guaranty.GUARANTY_CONTRACT' and ObjectNo=:ObjectNo", "ObjectNo",guarantyContract.getKeyString());
				if(clrList != null && clrList.size() != 0){
					for(BusinessObject clr:clrList){
						List<BusinessObject> accountList = this.bomanager.loadBusinessObjects("jbo.acct.ACCT_BUSINESS_ACCOUNT", 
								"ObjectType='jbo.guaranty.CLR_MARGIN_INFO' and ObjectNo=:ObjectNo", "ObjectNo",clr.getKeyString());
						this.bomanager.deleteBusinessObjects(accountList);
					}
					this.bomanager.deleteBusinessObjects(clrList);
				}
			}
			else if(guarantyType.startsWith("020") || guarantyType.startsWith("040")){
				//抵质押担保处理 
				List<BusinessObject> grList = this.bomanager.loadBusinessObjects("jbo.guaranty.GUARANTY_RELATIVE", "GCSerialNo=:GCSerialNo", "GCSerialNo",guarantyContract.getKeyString());
				if(grList != null && grList.size() != 0){
					this.bomanager.deleteBusinessObjects(grList);
				}
			}
			else{}
			
			this.bomanager.deleteBusinessObject(guarantyContract);
		}
		
		this.bomanager.deleteBusinessObject(applyRelative);
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(guarantyContract);
		return 1;
	}

	@Override
	public int delete(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		return 1;
	}

}
