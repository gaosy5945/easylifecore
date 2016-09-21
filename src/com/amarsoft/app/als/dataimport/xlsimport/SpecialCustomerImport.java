package com.amarsoft.app.als.dataimport.xlsimport;

import java.util.Date;
import java.util.Map;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.sys.tools.CodeGenerater;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.DateX;


/**
 * ����ͻ����빦��ʵ��
 * @author gfTang 
 * ALS743���� 20140416
 *
 */
public class SpecialCustomerImport extends AbstractExcelImport {
	private int icount=1;
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bm;
	
	public void start(JBOTransaction tx) {
		trans = tx;
		try {
			bm = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_SPECIAL);
			trans.join(bm);
		} catch (JBOException e) {
			e.printStackTrace();
		}
	}
	
	public boolean process(Map<String, DataElement> excelMap) {
		boolean flag = true;
		try {
			BizObject bo = bm.newObject();
			String customerName = excelMap.get("CUSTOMERNAME").getString();
			String certID = excelMap.get("CERTID").getString();
			String certTypeName = excelMap.get("CERTTYPE").getString();
			String certType = CodeGenerater.getItemNoByName(certTypeName, "CertType");
			String remark = excelMap.get("REMARK").getString();
			String customerID="";
			//У��
			int count = bm.createQuery("CUSTOMERNAME=:customerName and CertID=:certID and CertType=:certType and SpecialCustomerType = :specialCustomerType")
					.setParameter("customerName",customerName).setParameter("certID",certID).setParameter("certType",certType).setParameter("specialCustomerType",getParameter("SpecialCustomerType")).getTotalCount();
			if(count > 0){
				writeLog("��"+icount+"�пͻ�:��" + customerName + "���Ѵ��ڣ����飡");
				flag = false;
    			rollBack = true;
			}
			
			//У����и�֤�����ͺ�֤������Ŀͻ���customer_info���Ƿ����
			//�����ڣ���customerID��ֵ
			BizObject boCust  = JBOFactory.createBizObjectQuery(CustomerConst.CUSTOMER_INFO, "certType=:certType and certID=:certID")
					.setParameter("certType", certType).setParameter("certID", certID).getSingleResult(false);
			if(boCust!=null){
				customerID = boCust.getAttribute("CustomerID").getString();
			}
			
			if(flag){
				bo.setAttributeValue("CUSTOMERNAME", customerName);
				bo.setAttributeValue("CUSTOMERID", customerID);
				bo.setAttributeValue("CERTID", certID);
				bo.setAttributeValue("CERTTYPE", certType);
				bo.setAttributeValue("SPECIALCUSTOMERTYPE", getParameter("SpecialCustomerType"));
				bo.setAttributeValue("REMARK", remark);
				bo.setAttributeValue("INLISTSTATUS", "1");
				bo.setAttributeValue("INPUTUSERID", CurUser.getUserID());
				bo.setAttributeValue("INPUTORGID", CurUser.getOrgID());
				bo.setAttributeValue("INPUTDATE", DateX.format(new Date()));
				bo.setAttributeValue("UPDATEDATE", DateX.format(new Date()));
				bm.saveObject(bo);
			}
			icount++;
		} catch (JBOException e) {
			rollBack = true;
			e.printStackTrace();
		}
		return flag;
	}
	
	public void end() {
		if(rollBack){
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("����ع�����");
			}
		}else{
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("�����ύ����");
			}
		}
	}
	
}
