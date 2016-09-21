package com.amarsoft.app.als.credit.common.action;

import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.credit.putout.action.AddPutOutInfo;
import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
/**
 * 描述：业务受理批量导入
 * @author fengcr
 */
public class CreditPutoutImportAction extends AbstractExcelImport {
	private BusinessObjectManager bomanager;
	private int cnt = 0;
	private double sum=0.0d;
	private boolean rollBack = false;
	
	public void start(JBOTransaction tx) {
		bomanager = BusinessObjectManager.createBusinessObjectManager(tx);
		
		try{
			BizObjectManager bbm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PUTOUT");
			if(tx!=null)tx.join(bbm);
			BizObjectQuery boq = bbm.createQuery("delete from O where BatchSerialNo=:BatchSerialNo");
			boq.setParameter("BatchSerialNo", getCurPage().getAttribute("BatchSerialNo"));
			boq.executeUpdate();
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}

	public boolean process(Map<String, DataElement> excelMap){
		try {
			
			String userID = getCurPage().getAttribute("UserID");
			String orgID = getCurPage().getAttribute("OrgID");
			String contractSerialNo = excelMap.get("CONTRACTSERIALNO").getString();
			String phone = excelMap.get("PHONE").getString();
			String certID = excelMap.get("CERTID").getString();
			String customerName = excelMap.get("CUSTOMERNAME").getString();
			
			BusinessObject bc = bomanager.loadBusinessObject("jbo.app.BUSINESS_CONTRACT", "SerialNo",contractSerialNo);
			if(bc == null)
			{
				List<BusinessObject> ls = bomanager.loadBusinessObjects("jbo.app.BUSINESS_CONTRACT", "CustomerID in(select CI.CustomerID from jbo.customer.CUSTOMER_INFO CI where CI.CertID = :CertID )", "CertID",certID);
				if(ls != null && !ls.isEmpty())
				{
					bc = ls.get(0);
				}
			}
			BusinessObject bo = null;
			if(bc != null)
			{
				contractSerialNo = bc.getKeyString();
				AddPutOutInfo add = new AddPutOutInfo();
				add.setUserID(userID);
				add.setOrgID(orgID);
				add.setContractSerialNo(contractSerialNo);
				add.setPutoutStatus("01");
				
				bo = BusinessObject.convertFromBizObject(add.createPutOut(bomanager.getTx()));
				bo.setAttributeValue("Remark", phone);
			}
			else
			{
				bo = BusinessObject.createBusinessObject("jbo.app.BUSINESS_PUTOUT");
				bo.setAttributeValue("ContractSerialNo", contractSerialNo);
				bo.setAttributeValue("CUSTOMERID", certID);
				bo.setAttributeValue("CUSTOMERNAME", customerName);
				bo.setAttributeValue("INPUTORGID", orgID);
				bo.setAttributeValue("INPUTUSERID", userID);
				bo.setAttributeValue("INPUTDATE", DateHelper.getBusinessDate());
				bo.setAttributeValue("UPDATEDATE", DateHelper.getBusinessDate());
				bo.setAttributeValue("OPERATEORGID", orgID);
				bo.setAttributeValue("OPERATEUSERID", userID);
				bo.setAttributeValue("OPERATEDATE", DateHelper.getBusinessDate());
				bo.setAttributeValue("Remark", phone);
				
				
				List<BusinessObject> ls = bomanager.loadBusinessObjects("jbo.app.BUSINESS_CONTRACT", "CustomerID in(select CI.CustomerID from jbo.customer.CUSTOMER_INFO CI where CI.CertID like :CertID )", "CertID","%"+certID.replaceAll(" ", "%")+"%");
				if(ls != null && !ls.isEmpty())
				{
					bo.setAttributeValue("PutOutStatus", "02");
				}
				else
				{
					bo.setAttributeValue("PutOutStatus", "03");
				}
			}
			bo.setAttributeValue("BatchSerialNo", getCurPage().getAttribute("BatchSerialNo"));
			bo.setAttributeValue("BusinessSum", excelMap.get("BusinessSum").getDouble());
			bo.setAttributeValue("BusinessTerm", excelMap.get("BusinessTerm").getInt());
			bomanager.updateBusinessObject(bo);
			bomanager.updateDB();
			sum += excelMap.get("BusinessSum").getDouble();
			cnt++;
		} catch (Exception e) {
			rollBack=true;
			e.printStackTrace();
		}
		
		return !rollBack;
	}

	public void end() {
		if(rollBack){
			try {
				bomanager.rollback();
			} catch (Exception e) {
				e.printStackTrace();
				ARE.getLog("事务回滚出错");
			}
		}else{
			try {
				BusinessObject batchBo = bomanager.keyLoadBusinessObject("jbo.app.BAT_BUSINESS", getCurPage().getAttribute("BatchSerialNo"));
				batchBo.setAttributeValue("TOTALSUM", sum);
				batchBo.setAttributeValue("TOTALCOUNT", cnt);
				bomanager.updateBusinessObject(batchBo);
				bomanager.updateDB();
				bomanager.commit();
			} catch (Exception e) {
				e.printStackTrace();
				ARE.getLog("事务提交出错");
			}
		}
	}
	

}
