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

public class CAMHouseExcelImport extends AbstractExcelImport {
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
			String RealtyTotal = excelMap.get("REALTYTOTAL").getString();
			String ContractNo = excelMap.get("CONTRACTNO").getString();
			String PutoutDate = excelMap.get("PUTOUTDATE").getString();
			String FinishStatusTemp = excelMap.get("FINISHSTATUS").getString();
			String FinishStatus = CodeGenerater.getItemNoByName(FinishStatusTemp,"BusinessStatus");
			String RegisterStatusTemp = excelMap.get("REGISTERSTATUS").getString();
			String RegisterStatus = CodeGenerater.getItemNoByName(RegisterStatusTemp,"GuarantyStatus");
			String BusinessSum = excelMap.get("BUSINESSSUM").getString();
			String BusinessBalance = excelMap.get("BUSINESSBALANCE").getString();
			String BusinessRate = excelMap.get("BUSINESSRATE").getString();
			String TotalPeriod = excelMap.get("TOTALPERIOD").getString();
			String MonthService = excelMap.get("MONTHSERVICE").getString();
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
			boCAI.setAttributeValue("REALTYTOTAL", RealtyTotal);
			boCAI.setAttributeValue("CONTRACTNO", ContractNo);
			boCAI.setAttributeValue("PUTOUTDATE", PutoutDate);
			boCAI.setAttributeValue("FINISHSTATUS", FinishStatus);
			boCAI.setAttributeValue("REGISTERSTATUS", RegisterStatus);
			boCAI.setAttributeValue("BUSINESSSUM", BusinessSum);
			boCAI.setAttributeValue("BUSINESSBALANCE", BusinessBalance);
			boCAI.setAttributeValue("BUSINESSRATE", BusinessRate);
			boCAI.setAttributeValue("TOTALPERIOD", TotalPeriod);
			boCAI.setAttributeValue("MONTHSERVICE", MonthService);
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
			
			//白名单客户执行跑批
			if("1".equals(CustomerListFlag)){
				
				//计算N行内非网贷消费类信用贷款余额
				CaculateNBalance CNB = new CaculateNBalance();
				double NBusinessBalance = CNB.getBalacne(CertID, trans);
				
				//跑批规则
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
				ARE.getLog("事务回滚出错");
			}
		} else {
			try {
				trans.commit();
			} catch (JBOException e) {
				ARE.getLog("事务提交出错");
			}
		}
	}
}
