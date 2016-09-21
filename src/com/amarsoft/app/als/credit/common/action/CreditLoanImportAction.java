package com.amarsoft.app.als.credit.common.action;

import java.util.HashMap;
import java.util.Map;

import com.amarsoft.amarscript.ASMethod;
import com.amarsoft.amarscript.Any;
import com.amarsoft.app.als.dataimport.xlsimport.AbstractExcelImport;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.ShareTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.app.als.sys.tools.CodeGenerater;
import com.amarsoft.app.lending.bizlets.InitApplyInfo;
import com.amarsoft.dict.als.manage.NameManager;
/**
 * 描述：业务受理批量导入
 * @author fengcr
 * @2015
 */
public class CreditLoanImportAction extends AbstractExcelImport {
	private JBOTransaction trans;
	private boolean rollBack = false;
	BizObjectManager bmPA;
	
	public void start(JBOTransaction tx) {
		try {
			trans = tx;
			bmPA = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_APPLICANT");
			trans.join(bmPA);
		} catch (JBOException e) {
			ARE.getLog().error("", e);
		}
	}

	public boolean process(Map<String, DataElement> excelMap){
		boolean result = false;
		boolean flag = false;
		try {
			InitApplyInfo info = new InitApplyInfo();
			
			Transaction Sqlca = Transaction.createTransaction(trans);
			
			String APPLYTYPE = getCurPage().getParameter("ApplyType");//申请类型
			String PRODUCTID = "";
			BizObject biz1 = null;
			try{
				PRODUCTID = excelMap.get("PRODUCTNAME").toString();//方案产品名称
				biz1 = JBOFactory.getFactory().getManager("jbo.prd.PRD_PRODUCT_LIBRARY").createQuery("O.PRODUCTID = :PRODUCTID").setParameter("PRODUCTID",PRODUCTID).getSingleResult(true);
			}catch(NullPointerException e){
				e.printStackTrace();
			}
			String BusinessType = excelMap.get("BUSINESSTYPENAME").toString();//基础产品名称
			BizObject biz2 = JBOFactory.getFactory().getManager("jbo.prd.PRD_PRODUCT_LIBRARY").createQuery("O.PRODUCTID = :BusinessType").setParameter("BusinessType",BusinessType).getSingleResult(true);
			String ProductType3 = "";
			try{
				ProductType3 = biz1.getAttribute("ProductType3").toString();
			}catch(NullPointerException e){
				e.printStackTrace();
			}
			String ProductType32 = biz2.getAttribute("ProductType3").toString();
			
			BizObject prbiz  = null;
			if(biz1 != null){
				prbiz = JBOFactory.getFactory().getManager("jbo.prd.PRD_PRODUCT_RELATIVE").createQuery("O.PRODUCTID = :PRODUCTID and O.ObjectType = 'jbo.prd.PRD_PRODUCT_LIBRARY' and O.ObjectNo = :ObjectNo and O.relativetype = '01'")
						.setParameter("PRODUCTID", PRODUCTID).setParameter("ObjectNo", BusinessType).getSingleResult(true);
			}
			
			
			String AccountingOrgId = excelMap.get("ACCOUNTINGORGID").toString();//入账机构编号
			BizObject oibiz = JBOFactory.getFactory().getManager("jbo.sys.ORG_INFO").createQuery("O.ORGID = :AccountingOrgId and O.ORGLEVEL in ('3','4','5')").setParameter("AccountingOrgId",AccountingOrgId).getSingleResult(true);
			//根据申请类型判断输入经营类产品或者消费类产品是否与其一致  //判断入账机构编号是否存在以及是否为三级及以下机构
			if("Apply01".equals(APPLYTYPE)&&(oibiz != null)){
				if("01".equals(ProductType3)){
					if("01".equals(ProductType32)&&(prbiz != null)){
						flag = true;
					}
				}else if("".equals(ProductType3)){
					if("01".equals(ProductType32)){
						flag = true;
					}
				}else{
					flag = false;
				}
			}else if("Apply04".equals(APPLYTYPE)&&(oibiz != null)){
				if("02".equals(ProductType3) ){
					if("02".equals(ProductType32) && (prbiz != null))
						flag = true;
				}else if("".equals(ProductType3)){
					if("02".equals(ProductType32))
						flag = true;
				}else{
					flag = false;
				}
			}
			
			if(flag == true){
				String CustomerID = "";//客户ID
				String CustomerName = excelMap.get("CUSTOMERNAME").toString();//客户名称
				String CustomerType = "";//客户类型
				String CertTypeName = excelMap.get("CERTTYPE").toString();//证件类型
				String CertType = CodeGenerater.getItemNoByName(CertTypeName, "CustomerCertType");
				String CertID = excelMap.get("CERTID").toString();//证件号
				String IssueCountryName = excelMap.get("ISSUECOUNTRY").toString();//证件签发国家
				String IssueCountry = CodeGenerater.getItemNoByName(IssueCountryName, "CountryCode");
				String BusinessCurrencyName = excelMap.get("BUSINESSCURRENCY").toString();//币种
				String BusinessCurrency = CodeGenerater.getItemNoByName(BusinessCurrencyName, "Currency");
				String BusinessSum = excelMap.get("BUSINESSSUM").toString();//贷款金额
				int BusinessTermYear = excelMap.get("BUSINESSTERMYEAR").getInt();//贷款期限(年)
				int BusinessTermMonth = excelMap.get("BUSINESSTERMMONTH").getInt();//贷款期限(月)
				int BusinessTermInt = BusinessTermYear * 12 + BusinessTermMonth;
				String BusinessTerm = Integer.toString(BusinessTermInt);
				String BusinessTermDay = excelMap.get("BUSINESSTERMDAY").toString();//贷款期限（天）
				String BusinessPriorityName = excelMap.get("BUSINESSPRIORITY").toString();//业务优先级
				String BusinessPriority = CodeGenerater.getItemNoByName(BusinessPriorityName, "BusinessPriority");
				String NonstdIndicator = "";
				String NonstdIndicatorName = excelMap.get("NONSTDINDICATOR").toString();//特殊业务标示
				
				if("普通业务".equals(NonstdIndicatorName)){
					NonstdIndicator = "01";
				}else if("例外审批业务".equals(NonstdIndicatorName)){
					NonstdIndicator = "02";
				}
				String UserID = getCurPage().getParameter("UserId");//用户号
				String OrgID = getCurPage().getParameter("OrgId");//机构号
				info.setAttribute("APPLYTYPE", APPLYTYPE);
				info.setAttribute("OCCURTYPE", "0010");
				info.setAttribute("BusinessType", BusinessType);
				info.setAttribute("ProductID", PRODUCTID);
				info.setAttribute("CertType", CertType);
				info.setAttribute("CertID", CertID);
				info.setAttribute("IssueCountry", IssueCountry);
				info.setAttribute("CustomerName", CustomerName);
				info.setAttribute("CustomerType", "03");
				info.setAttribute("BusinessCurrency", BusinessCurrency);
				info.setAttribute("BusinessSum", BusinessSum);
				info.setAttribute("BusinessTermUnit", "020");
				info.setAttribute("BusinessTerm", BusinessTerm);
				info.setAttribute("BusinessTermDay", BusinessTermDay);
				info.setAttribute("BusinessPriority", BusinessPriority);
				info.setAttribute("NonstdIndicator", NonstdIndicator);
				info.setAttribute("AccountingOrgId", AccountingOrgId);
				info.setAttribute("userID", UserID);
				info.setAttribute("ORGID", OrgID);
				
				info.run(Sqlca);
				result = true;
			}else{
				result = false;
			}
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
