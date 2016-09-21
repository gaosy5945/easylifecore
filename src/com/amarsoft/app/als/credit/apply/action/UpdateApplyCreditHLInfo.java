package com.amarsoft.app.als.credit.apply.action;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * 流程结束更新安居贷信息
 * @author wangl3
 *
 */
public class UpdateApplyCreditHLInfo{
	
	private String applySerialNo;
	private String flowStatus;	

	public String getApplySerialNo() {
		return applySerialNo;
	}

	public void setApplySerialNo(String applySerialNo) {
		this.applySerialNo = applySerialNo;
	}

	public String getFlowStatus() {
		return flowStatus;
	}

	public void setFlowStatus(String flowStatus) {
		this.flowStatus = flowStatus;
	}

	/**
	 * 更新安居贷信息
	 * @param tx
	 * @throws Exception
	 */
	public void update(JBOTransaction tx) throws Exception{
		//查询申请基本信息
		BizObjectManager bam = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLY");
		tx.join(bam);
		BizObjectQuery baq = bam.createQuery("SerialNo=:ApplySerialNo");
		baq.setParameter("ApplySerialNo", applySerialNo);
		BizObject ba = baq.getSingleResult(true);
		if(ba == null ) throw new Exception("未找到对应申请信息，请检查配置信息！");
		BizObjectManager bcm = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_CONTRACT");
		tx.join(bcm);
		if("3".equals(flowStatus))
		{									
			BizObjectQuery bcq = bcm.createQuery("ApplySerialNo=:ApplySerialNo");
			bcq.setParameter("ApplySerialNo", applySerialNo);
			BizObject bc = bcq.getSingleResult(true);//取申请对应合同信息			
			if(bc != null)
			{		
				//放贷后，对于办理安居贷的申请，同步更新CreditHL_Info
				BizObjectQuery bcq2 = bcm.createQuery("ApplySerialNo=:ApplySerialNo and CREDITHLFLAG ='1' ");
				bcq2.setParameter("ApplySerialNo", applySerialNo);
				BizObject bc2 = bcq2.getSingleResult(true);//取申请对应合同信息
				if(bc2 != null)
				{			
					BizObjectManager IRbom = JBOFactory.getBizObjectManager("jbo.intf.INTF_RDS_OUT_MESSAGE"); //决策信息
					tx.join(IRbom);
					BizObjectQuery IRbq = IRbom.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType and CallType='02' ");
					IRbq.setParameter("ObjectNo", applySerialNo);
					IRbq.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
					BizObject irbo = IRbq.getSingleResult(true);							
					BizObjectManager CIbom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_INFO"); //客户信息
					tx.join(CIbom);
					BizObjectQuery CIbq = CIbom.createQuery("CustomerID=:CustomerID and CustomerName=:CustomerName");
					CIbq.setParameter("CustomerID", bc2.getAttribute("CUSTOMERID").getString());
					CIbq.setParameter("CustomerName", bc2.getAttribute("CUSTOMERNAME").getString());
					BizObject cibo = CIbq.getSingleResult(true);
					
					BizObjectManager CFbom = JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_FINANCE"); //收入信息
					tx.join(CFbom);
					BizObjectQuery CFbq1 = CFbom.createQuery("CustomerID=:CustomerID and financialItem='3050'");
					CFbq1.setParameter("CustomerID", bc2.getAttribute("CUSTOMERID").getString());
					BizObject cfbo1 = CFbq1.getSingleResult(true);
					double dAmount1=0.0;
					if(cfbo1 != null) dAmount1=cfbo1.getAttribute("AMOUNT").getDouble(); 
					
					BizObjectQuery CFbq2 = CFbom.createQuery("CustomerID in (select CR.RelativeCustomerID from jbo.customer.CUSTOMER_RELATIVE CR where CR.CustomerID=:CustomerID and CR.relationship='2007') and financialItem='3050'");
					CFbq2.setParameter("CustomerID", bc2.getAttribute("CUSTOMERID").getString());
					BizObject cfbo2 = CFbq2.getSingleResult(true);
					double dAmount2=0.0;
					if(cfbo2 != null) dAmount2=cfbo2.getAttribute("AMOUNT").getDouble(); 
					double dFamilymonthIncome=dAmount1+dAmount2;
					
					BizObjectManager BTbom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_TRADE"); //房产信息
					tx.join(BTbom);
					BizObjectQuery BTbq = BTbom.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType");
					BTbq.setParameter("ObjectNo", applySerialNo);
					BTbq.setParameter("ObjectType", "jbo.app.BUSINESS_APPLY");
					BizObject btbo = BTbq.getSingleResult(true);
					
					BizObjectManager AIbom = JBOFactory.getBizObjectManager("jbo.app.ASSET_INFO"); //押品信息
					tx.join(AIbom); 
					BizObjectQuery AIbq = AIbom.createQuery("SerialNo=:SerialNo and AssetType=:AssetType");
					AIbq.setParameter("SerialNo", btbo.getAttribute("ASSETSERIALNO").getString());
					AIbq.setParameter("AssetType", btbo.getAttribute("ASSETTYPE").getString());
					BizObject aibo = AIbq.getSingleResult(true);
					
					BizObjectManager bdbom = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_DUEBILL"); //借据信息
					tx.join(bdbom);
					BizObjectQuery bdbq = bdbom.createQuery("SerialNo=:SerialNo");
					bdbq.setParameter("SerialNo", bc2.getAttribute("DUEBILLSERIALNO").getString());
					BizObject bdbo = bdbq.getSingleResult(true);					
					
					BizObjectManager bm = JBOFactory.getBizObjectManager("jbo.app.CREDITHL_INFO");
					tx.join(bm);
					BizObject bo = bm.newObject();
					bo.setAttributeValue("CERTID", cibo.getAttribute("CERTID").getString());
					bo.setAttributeValue("CUSTOMERID", bc2.getAttribute("CUSTOMERID").getString());	
					bo.setAttributeValue("CUSTOMERNAME", bc2.getAttribute("CUSTOMERNAME").getString());	
					bo.setAttributeValue("APPLYSERIALNO", bc2.getAttribute("APPLYSERIALNO").getString());
					bo.setAttributeValue("CONTRACTNO", bc2.getAttribute("SERIALNO").getString());	
					bo.setAttributeValue("DUEBILLNO", bc2.getAttribute("DUEBILLSERIALNO").getString());	
					bo.setAttributeValue("BUSINESSSUM", bc2.getAttribute("BUSINESSSUM").getDouble());
					bo.setAttributeValue("BUSINESSRATE", bdbo.getAttribute("ACTUALBUSINESSRATE").getDouble());
					bo.setAttributeValue("HLRATEFLOAT", ba.getAttribute("HLRATEFLOAT").getDouble());
					bo.setAttributeValue("PUTOUTDATE", bc2.getAttribute("CONTRACTDATE").getString());
					bo.setAttributeValue("MATURITYDATE", bc2.getAttribute("MATURITYDATE").getString());
					bo.setAttributeValue("BUSINESSTERM", bc2.getAttribute("BUSINESSTERM").getInt());
					bo.setAttributeValue("BUSINESSTERMDAY", bc2.getAttribute("BUSINESSTERMDAY").getInt());
					bo.setAttributeValue("APPLYRISKLEVEL", irbo.getAttribute("RISK").getString());
					bo.setAttributeValue("MONTHLYINCOME",dAmount1);
					bo.setAttributeValue("SPOUSEMONTHLYINCOME",dAmount2);
					bo.setAttributeValue("CONTRACTAMOUNT", btbo.getAttribute("CONTRACTAMOUNT").getDouble());
					bo.setAttributeValue("EVALUATEVALUE", aibo.getAttribute("EVALUATEVALUE").getDouble());
					bo.setAttributeValue("HLCREDIT",getCreditHomeLoan(btbo.getAttribute("CONTRACTAMOUNT").getDouble(),aibo.getAttribute("EVALUATEVALUE").getDouble(),dFamilymonthIncome,irbo.getAttribute("RISK").getString(),tx));
					bo.setAttributeValue("CLRSERIALNO",aibo.getAttribute("CLRSERIALNO").getString());
					bo.setAttributeValue("ASSETSTATUS",aibo.getAttribute("ASSETSTATUS").getString());
					bo.setAttributeValue("EXPORTSTATUS","0");
					bo.setAttributeValue("EXECUTIVEORGID",bc2.getAttribute("EXECUTIVEORGID").getString());
					bo.setAttributeValue("EXECUTIVEUSERID",bc2.getAttribute("EXECUTIVEUSERID").getString());
					bm.saveObject(bo);				
				}								
			}			
		}					
	}	
	//计算客户安居贷可贷最高金额
	public double getCreditHomeLoan(double ContractAmount,double EvaluateValue,double FamilyIncome,String ApplyRiskLevel,JBOTransaction tx) throws Exception
	{
		
		BizObjectManager clm = JBOFactory.getBizObjectManager("jbo.sys.CODE_LIBRARY");
		tx.join(clm);
		BizObjectQuery clq = clm.createQuery("CodeNo=:CodeNo");
		clq.setParameter("CodeNo", "AssetValueRatio");
		BizObject cl = clq.getSingleResult(true);
		double dAssetValueRatio=Double.parseDouble(cl.getAttribute("ITEMDESCRIBE").getString());
		
		BizObjectQuery clq2 = clm.createQuery("CodeNo=:CodeNo");
		clq2.setParameter("CodeNo", "IncomeMultiple");
		BizObject cl2 = clq2.getSingleResult(true);
		double dIncomeMultiple=Double.parseDouble(cl2.getAttribute("ITEMDESCRIBE").getString());
		
		BizObjectQuery clq3 = clm.createQuery("CodeNo=:CodeNo and ItemNo=:ItemNo");
		clq3.setParameter("CodeNo", "CreditHLMultiple");
		clq3.setParameter("ItemNo", ApplyRiskLevel);
		BizObject cl3 = clq3.getSingleResult(true);
		double dCreditHLMultiple=Double.parseDouble(cl3.getAttribute("ITEMDESCRIBE").getString());
		
		BizObjectQuery clq4 = clm.createQuery("CodeNo=:CodeNo");
		clq4.setParameter("CodeNo", "MaxCreditHL");
		BizObject cl4 = clq4.getSingleResult(true);	
		double dMaxCreditHL=Double.parseDouble(cl4.getAttribute("ITEMDESCRIBE").getString());
		
		double dCL,dCL2,dCL3;
		dCL=ContractAmount<EvaluateValue?ContractAmount:EvaluateValue;//客户房产购买价与评估价的房产价值取较低
		dCL2=dCL*dAssetValueRatio<FamilyIncome*dIncomeMultiple?dCL*dAssetValueRatio:FamilyIncome*dIncomeMultiple;//不超过家庭月收入的N倍
		dCL3=dCL2*dCreditHLMultiple<dMaxCreditHL*10000?dCL2*dCreditHLMultiple:dMaxCreditHL*10000;
		return dCL3;
	 }	
}
