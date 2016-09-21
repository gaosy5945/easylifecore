package com.amarsoft.app.als.customer.partner.handler;

import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.credit.guaranty.guarantycontract.GetGCContractNo;
import com.amarsoft.app.als.project.DeleteCutCL;
import com.amarsoft.app.als.project.ImportCutCLInfo;
import com.amarsoft.app.als.project.SelectCutCL;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.ASValuePool;

/**
 * @author
 * 申请阶段新增担保信息页面
 */
public class ProjectGuarantyInsertHandler extends ALSBusinessProcess
		implements BusinessObjectOWUpdater {
	private String DivideTypeLast = "";
	@Override
	public List<BusinessObject> update(BusinessObject guarantyContract,
			ALSBusinessProcess businessProcess) throws Exception {
		guarantyContract.generateKey();
		String guarantyContractSerialNo=guarantyContract.getKeyString();
		this.bomanager.updateBusinessObject(guarantyContract);
		BusinessObject PR = guarantyContract.getBusinessObject("jbo.prj.PRJ_RELATIVE");
		PR.generateKey();
		String PRKeySerialNo=PR.getKeyString();
		this.bomanager.updateBusinessObject(PR);
		BusinessObject CL = guarantyContract.getBusinessObject("jbo.cl.CL_INFO");
		CL.generateKey();
		String CLKeySerialNo=CL.getKeyString();
		this.bomanager.updateBusinessObject(CL);
		
		String SerialNo = guarantyContract.getString("SERIALNO");
		String CLSerialNo = CL.getString("SERIALNO");
		String DivideType = CL.getString("DIVIDETYPE");
		String ProjectSerialNo = PR.getString("PROJECTSERIALNO");
		
		
		//担保信息
		guarantyContract.setAttributeValue("ContractType", "010");//一般担保协议
		guarantyContract.setAttributeValue("GuarantyType", "01010");//法人保证
		guarantyContract.setAttributeValue("ContractStatus", "01");//待生效
		guarantyContract.setAttributeValue("GUARANTEETYPE", "3");//单人担保
		BusinessObject project = this.bomanager.keyLoadBusinessObject("jbo.prj.PRJ_BASIC_INFO", ProjectSerialNo);
		guarantyContract.setAttributeValue("GuarantorID", project.getString("CustomerID"));
		BusinessObject customer = this.bomanager.keyLoadBusinessObject("jbo.customer.CUSTOMER_INFO", project.getString("CustomerID"));
		if(customer!=null){
			String customerName = customer.getString("CustomerName");
			if(!StringX.isEmpty(customerName))
				guarantyContract.setAttributeValue("GuarantorName", customerName);
		}
		guarantyContract.setAttributeValue("ProjectSerialNo", ProjectSerialNo);
		if(StringX.isEmpty(guarantyContract.getString("ContractNo"))){
			guarantyContract.setAttributeValue("InputDate", DateHelper.getBusinessDate());
			guarantyContract.setAttributeValue("InputOrgID", this.curUser.getOrgID());
			guarantyContract.setAttributeValue("InputUserID", this.curUser.getUserID());
			String contractNo = GetGCContractNo.getCeilingGCContractNo(guarantyContract);
			guarantyContract.setAttributeValue("ContractNo", contractNo);
			
		}
		guarantyContract.setAttributeValue("UpdateDate", DateHelper.getBusinessDate());
		guarantyContract.setAttributeValue("UpdateOrgID", this.curUser.getOrgID());
		guarantyContract.setAttributeValue("UpdateUserID", this.curUser.getUserID());
		this.bomanager.updateBusinessObject(guarantyContract);
		
		
		
		//额度信息
		CL.setAttributeValue("BUSINESSAPPAMT", guarantyContract.getDouble("GUARANTYVALUE"));
		CL.setAttributeValue("BUSINESSAVAAMT", guarantyContract.getDouble("GUARANTYVALUE"));
		CL.setAttributeValue("CURRENCY", guarantyContract.getString("GUARANTYCURRENCY"));
		CL.setAttributeValue("STATUS", "10");
		CL.setAttributeValue("INPUTUSERID", guarantyContract.getString("INPUTUSERID"));
		CL.setAttributeValue("INPUTORGID", guarantyContract.getString("INPUTORGID"));
		CL.setAttributeValue("INPUTDATE", guarantyContract.getString("INPUTDATE"));
		CL.setAttributeValue("UPDATEUSERID", guarantyContract.getString("UPDATEUSERID"));
		CL.setAttributeValue("UPDATEORGID", guarantyContract.getString("UPDATEORGID"));
		CL.setAttributeValue("UPDATEDATE", guarantyContract.getString("UPDATEDATE"));
		this.bomanager.updateBusinessObject(CL);
		
		//额度拆分信息
		List<BusinessObject> pbiList = this.bomanager.loadBusinessObjects("jbo.prj.PRJ_BASIC_INFO", 
				"SerialNo=:SerialNo", "SerialNo",ProjectSerialNo);
		String ProductList = pbiList.get(0).getString("ProductList"); //产品
		String ParticipateOrg = pbiList.get(0).getString("ParticipateOrg"); //机构
		ProductList = ProductList.replace(",", "@");
		ParticipateOrg = ParticipateOrg.replace(",", "@");
		SelectCutCL aa = new SelectCutCL();
		ImportCutCLInfo bb = new ImportCutCLInfo();
		if("00".equals(DivideType)){
			List<BusinessObject> CLList = this.bomanager.loadBusinessObjects("jbo.cl.CL_INFO", 
					"SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'", "SerialNo",CLSerialNo,"ObjectNo",SerialNo);
			if(CLList.isEmpty() || CLList == null){
				DivideTypeLast = "";
			}else{
				DivideTypeLast= CLList.get(0).getString("DIVIDETYPE");
			}
			String sResult = aa.selectCutCL(CLSerialNo,DivideTypeLast);
			if(sResult != "Empty"){
				if(!"EmptyProduct".equals(sResult) || !"EmptyOrg".equals(sResult)){
					DeleteCutCL deleteCL = new DeleteCutCL();
					deleteCL.deleteSonsCL(CLSerialNo, DivideTypeLast, SerialNo,this.bomanager.getTx());
					//删除原有切分维度下的所有额度信息
				}
			}
		}else{
		//当产品或机构下不为空
		if((!"".equals(ProductList))&&("".equals(ParticipateOrg)) || ("".equals(ProductList))&&(!"".equals(ParticipateOrg)) || (!"".equals(ProductList))&&(!"".equals(ParticipateOrg))){
			List<BusinessObject> CLList = this.bomanager.loadBusinessObjects("jbo.cl.CL_INFO", 
					"SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'", "SerialNo",CLSerialNo,"ObjectNo",SerialNo);
			if(CLList.isEmpty() || CLList == null){
				DivideTypeLast = "";
			}else{
				DivideTypeLast= CLList.get(0).getString("DIVIDETYPE");
			}
			if(!"".equals(DivideTypeLast) || !"00".equals(DivideTypeLast)){
				if(!DivideTypeLast.equals(DivideType)){//parent的CL表中切分维度与保存时的不同，则删除表中保存前切分维度所切分的所有son额度信息
					String sReturn = aa.selectCutCL(CLSerialNo,DivideTypeLast);
					//查询保存前son额度中是否有切分额度的数据
					if(!"EmptyProduct".equals(sReturn) || !"EmptyOrg".equals(sReturn)){
						DeleteCutCL deleteCL = new DeleteCutCL();
						deleteCL.deleteSonsCL(CLSerialNo, DivideTypeLast, SerialNo,this.bomanager.getTx());
						//删除原有切分维度下的所有额度信息后，在CL表中新增新的额度切分信息
						bb.importCutCLInfo(CL,ParticipateOrg,ProductList,DivideType,guarantyContractSerialNo,bomanager.getTx());
					}
				}else{
					List<BusinessObject> clList1 = this.bomanager.loadBusinessObjects("jbo.cl.CL_INFO", 
							"ParentSerialNo=:ParentSerialNo and DivideType=:DivideType", "ParentSerialNo", CLSerialNo,"DivideType", DivideTypeLast);
					if(clList1.isEmpty() || clList1 == null){
						bb.importCutCLInfo(CL,ParticipateOrg,ProductList,DivideType,guarantyContractSerialNo,bomanager.getTx());
					}
				}
			}else{//保存前，没有切分额度的数据，则向CL表中插入该切分维度的切分额度信息
				bb.importCutCLInfo(CL,ParticipateOrg,ProductList,DivideType,guarantyContractSerialNo,bomanager.getTx());
			}
		}
		}
		
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
