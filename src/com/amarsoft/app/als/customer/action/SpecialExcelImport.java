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

public class SpecialExcelImport extends AbstractExcelImport {
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

	public boolean process(Map<String, DataElement> excelMap) {
		boolean result = false;
		try {
			String customerID = excelMap.get("CUSTOMERID").getString();
			String customerName = excelMap.get("CUSTOMERNAME").getString();
			String CertTypeName = excelMap.get("CERTTYPE").toString();// ֤������
			String certType = CodeGenerater.getItemNoByName(CertTypeName,
					"CustomerCertType");
			String certID = excelMap.get("CERTID").getString();
			String remark = excelMap.get("REMARK").getString();
			String listType = this.getCurPage().getParameter("LISTTYPE");
			BizObject boCL = bmCL.newObject();
			boCL.setAttributeValue("CUSTOMERID", customerID);
			boCL.setAttributeValue("CUSTOMERNAME", customerName);
			boCL.setAttributeValue("STATUS", "1");
			boCL.setAttributeValue("CERTTYPE", certType);
			boCL.setAttributeValue("CERTID", certID);
			boCL.setAttributeValue("LISTTYPE", listType);
			boCL.setAttributeValue("REMARK", remark);
			bmCL.saveObject(boCL);

			// String serialNo = boCL.getAttribute("SerialNo").toString();
			// importTodoList(serialNo,phaseOpinion);

			result = true;
		} catch (Exception e) {
			rollBack = true;
			e.printStackTrace();
		}

		return result;
	}

	public void importTodoList(String SerialNo, String PhaseOpinion)
			throws Exception {
		BizObjectManager bm = JBOFactory
				.getBizObjectManager("jbo.app.PUB_TODO_LIST");

		BizObject bo = bm.newObject();
		bo.setAttributeValue("TRACEOBJECTTYPE", "jbo.customer.CUSTOMER_LIST");
		bo.setAttributeValue("TRACEOBJECTNO", SerialNo);
		bo.setAttributeValue("TODOTYPE", "03");
		bo.setAttributeValue("PHASEOPINION", PhaseOpinion);

		bm.saveObject(bo);

	}

	public void end() {
		if (rollBack) {
			try {
				trans.rollback();
			} catch (JBOException e) {
				ARE.getLog("����ع�����");
			}
		} else {
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("�����ύ����");
			}
		}
	}
}
