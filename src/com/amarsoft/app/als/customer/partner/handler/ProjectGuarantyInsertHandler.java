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
 * ����׶�����������Ϣҳ��
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
		
		
		//������Ϣ
		guarantyContract.setAttributeValue("ContractType", "010");//һ�㵣��Э��
		guarantyContract.setAttributeValue("GuarantyType", "01010");//���˱�֤
		guarantyContract.setAttributeValue("ContractStatus", "01");//����Ч
		guarantyContract.setAttributeValue("GUARANTEETYPE", "3");//���˵���
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
		
		
		
		//�����Ϣ
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
		
		//��Ȳ����Ϣ
		List<BusinessObject> pbiList = this.bomanager.loadBusinessObjects("jbo.prj.PRJ_BASIC_INFO", 
				"SerialNo=:SerialNo", "SerialNo",ProjectSerialNo);
		String ProductList = pbiList.get(0).getString("ProductList"); //��Ʒ
		String ParticipateOrg = pbiList.get(0).getString("ParticipateOrg"); //����
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
					//ɾ��ԭ���з�ά���µ����ж����Ϣ
				}
			}
		}else{
		//����Ʒ������²�Ϊ��
		if((!"".equals(ProductList))&&("".equals(ParticipateOrg)) || ("".equals(ProductList))&&(!"".equals(ParticipateOrg)) || (!"".equals(ProductList))&&(!"".equals(ParticipateOrg))){
			List<BusinessObject> CLList = this.bomanager.loadBusinessObjects("jbo.cl.CL_INFO", 
					"SerialNo=:SerialNo and ObjectNo=:ObjectNo and ObjectType='jbo.guaranty.GUARANTY_CONTRACT'", "SerialNo",CLSerialNo,"ObjectNo",SerialNo);
			if(CLList.isEmpty() || CLList == null){
				DivideTypeLast = "";
			}else{
				DivideTypeLast= CLList.get(0).getString("DIVIDETYPE");
			}
			if(!"".equals(DivideTypeLast) || !"00".equals(DivideTypeLast)){
				if(!DivideTypeLast.equals(DivideType)){//parent��CL�����з�ά���뱣��ʱ�Ĳ�ͬ����ɾ�����б���ǰ�з�ά�����зֵ�����son�����Ϣ
					String sReturn = aa.selectCutCL(CLSerialNo,DivideTypeLast);
					//��ѯ����ǰson������Ƿ����зֶ�ȵ�����
					if(!"EmptyProduct".equals(sReturn) || !"EmptyOrg".equals(sReturn)){
						DeleteCutCL deleteCL = new DeleteCutCL();
						deleteCL.deleteSonsCL(CLSerialNo, DivideTypeLast, SerialNo,this.bomanager.getTx());
						//ɾ��ԭ���з�ά���µ����ж����Ϣ����CL���������µĶ���з���Ϣ
						bb.importCutCLInfo(CL,ParticipateOrg,ProductList,DivideType,guarantyContractSerialNo,bomanager.getTx());
					}
				}else{
					List<BusinessObject> clList1 = this.bomanager.loadBusinessObjects("jbo.cl.CL_INFO", 
							"ParentSerialNo=:ParentSerialNo and DivideType=:DivideType", "ParentSerialNo", CLSerialNo,"DivideType", DivideTypeLast);
					if(clList1.isEmpty() || clList1 == null){
						bb.importCutCLInfo(CL,ParticipateOrg,ProductList,DivideType,guarantyContractSerialNo,bomanager.getTx());
					}
				}
			}else{//����ǰ��û���зֶ�ȵ����ݣ�����CL���в�����з�ά�ȵ��зֶ����Ϣ
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
