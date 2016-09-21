package com.amarsoft.app.accounting.config.impl;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.config.impl.XMLConfig;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.xml.Document;
import com.amarsoft.are.util.xml.Element;

/**
 * 现金流计算配置信息
 */
public final class CashFlowConfig extends XMLConfig {
	
	public final static String SEGRPTAMOUNT_LOAN_BALANCE = "1"; //贷款余额
	public final static String SEGRPTAMOUNT_SEG_AMT = "2";      //指定金额
	public final static String SEGRPTAMOUNT_SEG_INSTALMENTAMT = "3";//指定每期还款额
	public final static String SEGRPTAMOUNT_FINAL_PAYMENT = "4";//尾款金额
	
	public final static String JBO_NAME_INTEREST_TYPE_CONFIG = "InterestTypeConfig";
	public final static String JBO_NAME_RATE_TYPE_CONFIG = "RateTypeConfig";
	public final static String JBO_NAME_RATE_INTEREST_CONFIG = "RateInterestConfig";
	public final static String JBO_NAME_PAY_RULE_GROUP = "PayRuleGroup";
	public final static String JBO_NAME_PAY_RULE = "PayRule";
	public final static String JBO_NAME_PS_TYPE_CONFIG = "PSTypeConfig";

	/**
	 * 利息类型定义
	 */
	private static BusinessObjectCache interestTypeConfigs=new BusinessObjectCache(1000);
	
	/**
	 * 现金流金额类型定义
	 */
	private static BusinessObjectCache amountCodeConfigs=new BusinessObjectCache(1000);
	
	/**
	 * 收付计划类型定义
	 */
	private static BusinessObjectCache paymentScheduleConfigs=new BusinessObjectCache(1000);
	
	/**
	 * 还款顺序规则定义
	 */
	private static BusinessObjectCache payRuleConfigs=new BusinessObjectCache(1000);
	
	/**
	 * 还款频率定义
	 */
	private static BusinessObjectCache payFrequencyConfigs=new BusinessObjectCache(50);
	
	/**
	 * 提前还款定义
	 */
	private static BusinessObjectCache prepayScriptConfigs=new BusinessObjectCache(50);
	
	/**
	 * 利率调整方式
	 */
	private static BusinessObjectCache repriceTypeConfigs=new BusinessObjectCache(50);
	
	/**
	 * 年基准天数定义
	 */
	private static BusinessObjectCache yearBaseDayConfigs=new BusinessObjectCache(10);
	/**
	 * 金额小数位数
	 */
	private static BusinessObjectCache numberPrecisionConfigs = new BusinessObjectCache(10);
	
	
	//单例模式
	private static CashFlowConfig cfc = null;
	
	private CashFlowConfig(){
		
	}
	
	public static CashFlowConfig getInstance(){
		if(cfc == null)
			cfc = new CashFlowConfig();
		return cfc;
	}
	
	
	/**
	 * Load XML配置文件
	 */
	public synchronized void init(String file,int size)  throws Exception {
		file = ARE.replaceARETags(file);
		//先定义新的变量，加载完成后再赋值给私有变量
		BusinessObjectCache interestTypeConfigs=new BusinessObjectCache(1000);
		BusinessObjectCache amountCodeConfigs=new BusinessObjectCache(1000);
		BusinessObjectCache paymentScheduleConfigs=new BusinessObjectCache(1000);
		BusinessObjectCache payRuleConfigs=new BusinessObjectCache(1000);
		BusinessObjectCache payFrequencyConfigs=new BusinessObjectCache(50);
		BusinessObjectCache prepayScriptConfigs=new BusinessObjectCache(50);
		BusinessObjectCache repriceTypeConfigs=new BusinessObjectCache(50);
		BusinessObjectCache yearBaseDayConfigs=new BusinessObjectCache(10);
		BusinessObjectCache numberPrecisionConfigs=new BusinessObjectCache(10);
		
		Document document = getDocument(file);
		Element root = document.getRootElement();
		
		List<BusinessObject> interestTypeList = this.convertToBusinessObjectList(root.getChild("InterestTypeConfigs").getChildren("InterestTypeConfig"));
		if (interestTypeList!=null) {
			for (BusinessObject interestType : interestTypeList) {
				interestTypeConfigs.setCache(interestType.getString("id"), interestType);
			}
		}
		
		List<BusinessObject> amountCodeList = this.convertToBusinessObjectList(root.getChild("AmountCodeConfigs").getChildren("AmountCodeConfig"));
		if (amountCodeList!=null) {
			for (BusinessObject amountCode : amountCodeList) {
				amountCodeConfigs.setCache(amountCode.getString("id"), amountCode);
			}
		}
		
		List<BusinessObject> psTypeList = this.convertToBusinessObjectList(root.getChild("PSTypeConfigs").getChildren("PSTypeConfig"));
		if (psTypeList!=null) {
			for (BusinessObject psType : psTypeList) {
				paymentScheduleConfigs.setCache(psType.getString("id"), psType);
			}
		}
		
		List<BusinessObject> payRuleList = this.convertToBusinessObjectList(root.getChild("PayRuleConfigs").getChildren("PayRuleConfig"));
		if (payRuleList!=null) {
			for (BusinessObject payRule : payRuleList) {
				payRuleConfigs.setCache(payRule.getString("id"), payRule);
			}
		}
		
		//还款周期
		List<BusinessObject> payFrequencyList = this.convertToBusinessObjectList(root.getChild("PayFrequencyConfigs").getChildren("PayFrequencyType"));
		if (payFrequencyList!=null) {
			for (BusinessObject payFrequency : payFrequencyList) {
				payFrequencyConfigs.setCache(payFrequency.getString("id"), payFrequency);
			}
		}
		
		List<BusinessObject> prepayScriptList = this.convertToBusinessObjectList(root.getChild("PrepayScriptConfigs").getChildren("PrepayScript"));
		if(prepayScriptList != null){
			for (BusinessObject prepayScript : prepayScriptList) {
				prepayScriptConfigs.setCache(prepayScript.getString("id"), prepayScript);
			}
		}
		
		
		//还款周期
		List<BusinessObject> repriceTypeList = this.convertToBusinessObjectList(root.getChild("RepriceTypeConfigs").getChildren("RepriceType"));
		if (repriceTypeList!=null) {
			for (BusinessObject repriceType : repriceTypeList) {
				repriceTypeConfigs.setCache(repriceType.getString("id"), repriceType);
			}
		}
		
		//年基准天数
		List<BusinessObject> yearBaseDayList = this.convertToBusinessObjectList(root.getChild("YearBaseDayConfigs").getChildren("YearBaseDay"));
		if (yearBaseDayList!=null) {
			for (BusinessObject yearBaseDay : yearBaseDayList) {
				
				yearBaseDayConfigs.setCache(yearBaseDay.getString("id"), yearBaseDay);
			}
		}
		
		//金额小数位数
		List<BusinessObject> numberPrecisionList = this.convertToBusinessObjectList(root.getChild("NumberPrecisionConfigs").getChildren("NumberPrecision"));
		if (numberPrecisionList!=null) {
			for (BusinessObject numberPrecision: numberPrecisionList) {
				numberPrecisionConfigs.setCache(numberPrecision.getString("id"), numberPrecision);
			}
		}
		
		CashFlowConfig.interestTypeConfigs = interestTypeConfigs;
		CashFlowConfig.amountCodeConfigs = amountCodeConfigs;
		CashFlowConfig.paymentScheduleConfigs = paymentScheduleConfigs;
		CashFlowConfig.payRuleConfigs = payRuleConfigs;
		CashFlowConfig.payFrequencyConfigs = payFrequencyConfigs;
		CashFlowConfig.prepayScriptConfigs = prepayScriptConfigs;
		CashFlowConfig.repriceTypeConfigs = repriceTypeConfigs;
		CashFlowConfig.yearBaseDayConfigs = yearBaseDayConfigs;
		CashFlowConfig.numberPrecisionConfigs = numberPrecisionConfigs;
	}

	public static String getInterestAttribute(String interestType,String attributeID) throws Exception {
		BusinessObject interestTypeConfig = getInterestTypeConfig(interestType);
		return interestTypeConfig.getString(attributeID);
	}
	
	public static BusinessObject getInterestRateConfigs(String interestType, String rateType) throws Exception {
		BusinessObject interestTypeConfig = getInterestTypeConfig(interestType);
		BusinessObject rateTypeConfig = interestTypeConfig.getBusinessObjectByAttributes(CashFlowConfig.JBO_NAME_RATE_TYPE_CONFIG,"id",rateType);
		return rateTypeConfig;
	}
	
	public static String[] getRateTypes(String interestType) throws Exception {
		BusinessObject interestTypeConfig = getInterestTypeConfig(interestType);
		List<BusinessObject> rateTypeConfigs=interestTypeConfig.getBusinessObjects(CashFlowConfig.JBO_NAME_RATE_TYPE_CONFIG);
		String[] s=new String[rateTypeConfigs.size()];
		int i=0;
		for(BusinessObject rateTypeConfig:rateTypeConfigs){
			String rateType = rateTypeConfig.getString("id");
			s[i]=rateType;
			i++;
		}
		return s;
	}
	
	public static BusinessObject getInterestTypeConfig(String interestType) throws Exception {
		BusinessObject interestTypeConfig = (BusinessObject)interestTypeConfigs.getCacheObject(interestType);
		return interestTypeConfig;
	}
	
	public static BusinessObject getPayFrequencyTypeConfig(String payFrequencyType) throws Exception {
		BusinessObject payFrequencyTypeConfig = (BusinessObject)payFrequencyConfigs.getCacheObject(payFrequencyType);
		return payFrequencyTypeConfig;
	}
	
	public static String getPayFrequencyTypeConfig(String payFrequencyType,String attributeID) throws Exception {
		BusinessObject payFrequencyTypeConfig = getPayFrequencyTypeConfig(payFrequencyType);
		return payFrequencyTypeConfig.getString(attributeID);
	}
	
	public static String[] getPayFrequencyTypeConfigKeys() throws Exception {
		return payFrequencyConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static String[] getRepriceTypeConfigKeys()  throws Exception {
		return repriceTypeConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static BusinessObject getRepriceTypeConfig(String repriceType) throws Exception {
		BusinessObject repriceTypeConfig = (BusinessObject)repriceTypeConfigs.getCacheObject(repriceType);
		return repriceTypeConfig;
	}
	
	public static String getRepriceTypeConfig(String repriceType,String attributeID) throws Exception {
		if(StringX.isEmpty(repriceType)) return "";
		BusinessObject repriceTypeConfig =getRepriceTypeConfig(repriceType);
		return repriceTypeConfig.getString(attributeID);
	}
	
	public static String getInterestAttribute(String interestType,String rateType,String attributeID) throws Exception {
		BusinessObject rateTypeConfig = getInterestRateConfigs(interestType,rateType);
		return rateTypeConfig.getString(attributeID);
	}
	
	public static String getAmountCodeAttibute(String amountCode,String attributeID) throws Exception {
		BusinessObject o = (BusinessObject)amountCodeConfigs.getCacheObject(amountCode);
		return o.getString(attributeID);
	}
	
	public static String getPaymentScheduleAttribute(String paymentScheduleType,String attributeID) throws Exception {
		BusinessObject o = (BusinessObject)paymentScheduleConfigs.getCacheObject(paymentScheduleType);
		return o.getString(attributeID);
	}
	
	public static String[] getPayRuleConfigKeys() {
		return payRuleConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static BusinessObject getPayRuleConfig(String payRuleCode) throws Exception {
		BusinessObject payRuleConfig = (BusinessObject)payRuleConfigs.getCacheObject(payRuleCode);
		return payRuleConfig;
	}

	public static String[] getInterestConfigKeys() {
		return interestTypeConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static String[] getPSTypeConfigKeys() {
		return paymentScheduleConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static String[] getAmountCodeConfigKeys() {
		return amountCodeConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static String[] getYearBaseDayConfigKeys(){
		return yearBaseDayConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static BusinessObject getYearBaseDayConfig(String cacheKey){
		return (BusinessObject)yearBaseDayConfigs.getCacheObject(cacheKey);
	}
	
	public static String[] getNumberPrecisionConfigKeys(){
		return numberPrecisionConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static BusinessObject getNumberPrecisionConfig(String cacheKey){
		return (BusinessObject)numberPrecisionConfigs.getCacheObject(cacheKey);
	}
	
	public static String[] getPrepayScriptConfigKeys(){
		return prepayScriptConfigs.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static BusinessObject getPrepayScriptConfig(String cacheKey){
		return (BusinessObject)prepayScriptConfigs.getCacheObject(cacheKey);
	}

}