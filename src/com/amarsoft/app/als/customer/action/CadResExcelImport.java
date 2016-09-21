package com.amarsoft.app.als.customer.action;

import java.util.Map;

import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.app.als.sys.tools.CodeGenerater;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

public class CadResExcelImport extends AbstractExcelImport {
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmCL;
	
	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmCL = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_LIST");
			trans.join(bmCL);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	public boolean process(Map<String, DataElement> excelMap){
		boolean result = false;
		try {
			String customerID = excelMap.get("CUSTOMERID").getString();
			String customerName = excelMap.get("CUSTOMERNAME").getString();
			String CertTypeName = excelMap.get("CERTTYPE").toString();//证件类型
			String certType = CodeGenerater.getItemNoByName(CertTypeName, "CustomerCertType");
			String certID = excelMap.get("CERTID").getString();
			String description1 = excelMap.get("DESCRIPTION1").getString();
			String description2 = excelMap.get("DESCRIPTION2").getString();
			String description3 = excelMap.get("DESCRIPTION3").getString();
			String remark = excelMap.get("REMARK").getString();
			
			BizObject boCL = bmCL.newObject();
			boCL.setAttributeValue("CUSTOMERID", customerID);
			boCL.setAttributeValue("CUSTOMERNAME", customerName);
			boCL.setAttributeValue("CERTTYPE", certType);
			boCL.setAttributeValue("CERTID", certID);
			boCL.setAttributeValue("LISTTYPE", "90");
			boCL.setAttributeValue("DESCRIPTION1", description1);
			boCL.setAttributeValue("DESCRIPTION2", description2);
			boCL.setAttributeValue("DESCRIPTION3", description3);
			boCL.setAttributeValue("REMARK", remark);
			bmCL.saveObject(boCL);
					
			result = true;
		} catch (Exception e) {
			rollBack = true;
			e.printStackTrace();
		}
		
		return result;
	}

	public void end() {
		if(rollBack){
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("事务回滚出错");
			}
		}else{
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("事务提交出错");
			}
		}
	}
}
