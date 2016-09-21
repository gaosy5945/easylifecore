package com.amarsoft.app.als.activeCredit.customerBase;

import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.app.als.sys.tools.CodeGenerater;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;

public class CAMIncomeExcelImport extends AbstractExcelImport {
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmCAI;

	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmCAI = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_APPROVAL_INFO");
			trans.join(bmCAI);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	public boolean process(Map<String, DataElement> excelMap) {
		boolean result = false;
		try {
			String CertID = excelMap.get("CERTID").getString();
			String RateFloatRatishort = excelMap.get("RATEFLOATRATIOSHORT").getString();
			String RateFloatRatiomID = excelMap.get("RATEFLOATRATIOMID").getString();
			String RateFloatRatiolong = excelMap.get("RATEFLOATRATIOLONG").getString();
			String BusinessSendDate = excelMap.get("BUSINESSSENDDATE").getString();
			String Age = excelMap.get("AGE").getString();
			String PayRollDate = excelMap.get("PAYROLLDATE").getString();
			String PayRollentLevel = excelMap.get("PAYROLLENTLEVEL").getString();
			String Position = excelMap.get("POSITION").getString();
			String PayRollTotal = excelMap.get("PAYROLLTOTAL").getString();
			String MidDepositMoney = excelMap.get("MIDDEPOSITMONEY").getString();
			String MinDepositMoney = excelMap.get("MINDEPOSITMONEY").getString();
			String DepositMonths = excelMap.get("DEPOSITMONTHS").getString();
			String AccumulateDepositSum = excelMap.get("ACCUMULATEDEPOSITSUM").getString();
			String AccumulateDepositLife = excelMap.get("ACCUMULATEDEPOSITLIFE").getString();
			String AdjustMentA = excelMap.get("ADJUSTMENTA").getString();
			String AdjustMentB = excelMap.get("ADJUSTMENTB").getString();
			String AdjustMentC = excelMap.get("ADJUSTMENTC").getString();
			String AdjustMentF = excelMap.get("ADJUSTMENTF").getString();
			String Att01 = excelMap.get("ATT01").getString();
			String Att02 = excelMap.get("ATT02").getString();
			String Att03 = excelMap.get("ATT03").getString();
			String ActiveCreditTotal = excelMap.get("ACTIVECREDITTOTAL").getString();
			String CustomerListFlagTemp = excelMap.get("CUSTOMERLISTFLAG").getString();
			String CustomerListFlag = CodeGenerater.getItemNoByName(CustomerListFlagTemp,"YesNo");
			
			String BatchNo = this.getCurPage().getParameter("BATCHNO");
			String CustomerBaseID = this.getCurPage().getParameter("CUSTOMERBASEID");
			String CustomerBaseLevel = this.getCurPage().getParameter("CUSTOMERBASELEVEL");
			String ApproveOrgID = this.getCurPage().getParameter("APPROVEORGID");
			//double NBusinessBalance = Double.valueOf(this.getCurPage().getParameter("NBUSINESSBALANCE"));
			
			BizObject boCAI = bmCAI.newObject();
			boCAI.setAttributeValue("CERTID", CertID);
			boCAI.setAttributeValue("RATEFLOATRATIOSHORT", RateFloatRatishort);
			boCAI.setAttributeValue("RATEFLOATRATIOMID", RateFloatRatiomID);
			boCAI.setAttributeValue("RATEFLOATRATIOLONG", RateFloatRatiolong);
			boCAI.setAttributeValue("BUSINESSSENDDATE", BusinessSendDate);
			boCAI.setAttributeValue("AGE", Age);
			boCAI.setAttributeValue("PAYROLLDATE", PayRollDate);
			boCAI.setAttributeValue("PAYROLLENTLEVEL", PayRollentLevel);
			boCAI.setAttributeValue("POSITION", Position);
			boCAI.setAttributeValue("PAYROLLTOTAL", PayRollTotal);
			boCAI.setAttributeValue("MIDDEPOSITMONEY", MidDepositMoney);
			boCAI.setAttributeValue("MINDEPOSITMONEY", MinDepositMoney);
			boCAI.setAttributeValue("DEPOSITMONTHS", DepositMonths);
			boCAI.setAttributeValue("ACCUMULATEDEPOSITSUM", AccumulateDepositSum);
			boCAI.setAttributeValue("ACCUMULATEDEPOSITLIFE", AccumulateDepositLife);
			boCAI.setAttributeValue("ADJUSTMENTA", AdjustMentA);
			boCAI.setAttributeValue("ADJUSTMENTB", AdjustMentB);
			boCAI.setAttributeValue("ADJUSTMENTC", AdjustMentC);
			boCAI.setAttributeValue("ADJUSTMENTF", AdjustMentF);
			boCAI.setAttributeValue("ATT01", Att01);
			boCAI.setAttributeValue("ATT02", Att02);
			boCAI.setAttributeValue("ATT03", Att03);
			boCAI.setAttributeValue("ACTIVECREDITTOTAL", ActiveCreditTotal);
			boCAI.setAttributeValue("CUSTOMERLISTFLAG", CustomerListFlag);
			boCAI.setAttributeValue("BATCHNO", BatchNo);
			bmCAI.saveObject(boCAI);

			//�������ͻ�ִ������
			if("1".equals(CustomerListFlag)){
				
				//����N���ڷ��������������ô������
				CaculateNBalance CNB = new CaculateNBalance();
				double NBusinessBalance = CNB.getBalacne(CertID, trans);
				
				//��������
				BusinessObject para = BusinessObject.createBusinessObject();
				para.setAttributeValue("CertID", CertID);
				para.setAttributeValue("CAISerialNo", boCAI.getAttribute("SerialNo").getString());
				para.setAttributeValue("CustomerBaseID", CustomerBaseID);
				para.setAttributeValue("CustomerBaseLevel", CustomerBaseLevel);
				para.setAttributeValue("ApproveOrgID", ApproveOrgID);
				para.setAttributeValue("BusinessSendDate", BusinessSendDate);
				para.setAttributeValue("ActiveCreditTotal", ActiveCreditTotal);
				para.setAttributeValue("NBusinessBalance", NBusinessBalance);
				
				CAVolumeRule CAVR = new CAVolumeRule();
				CAVR.run(para, bmCAI.getTransaction().getConnection(bmCAI));
			}
			
			result = true;
		} catch (Exception e) {
			rollBack = true;
			e.printStackTrace();
		}

		return result;
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
