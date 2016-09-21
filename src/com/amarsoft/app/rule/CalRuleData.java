package com.amarsoft.app.rule;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.awe.util.Transaction;
 
public class CalRuleData{
	Transaction Sqlca;
	JBOTransaction tx;
	 
	public void calRuleSimpleData(BusinessObjectManager bomanager,BusinessObject applyObject)throws Exception {
		 BusinessObject CI=bomanager.loadBusinessObject("jbo.customer.IND_INFO", "CustomerID",applyObject.getString("CustomerID"));
		 calRuleSimpleData_afterLoan(applyObject);
		 calRuleSimpleData_businessApply(applyObject);
		 calRuleSimpleData_customerInfo(applyObject);
		 calRuleSimpleData_businessIdentity(applyObject);
		 calRuleSimpleData_creditReport(applyObject);
		 calRuleSimpleData_mortgageInfo(applyObject);
		 calRuleSimpleData_odInfo(applyObject);
		 calRuleSimpleData_loanGradeInfo(applyObject);
		 String country=CI.getString("COUNTRY");
		 String birthday=CI.getString("BIRTHDAY");
		 int age=DateHelper.getYears(birthday, DateHelper.getBusinessDate());
		 applyObject.setAttributeValue("totaltenor", applyObject.getString("BusinessTerm"));//贷款期限
		 applyObject.setAttributeValue("age", age);
		  
	}
	//贷后检查信息
	private void calRuleSimpleData_afterLoan(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("projecttype", "01");//合作项目类型
		applyObject.setAttributeValue("customerrisklevel", "01");//客户风险等级
		applyObject.setAttributeValue("taskfrequency", "1");//任务生成频率
		applyObject.setAttributeValue("taskfrequencyunit", "05");//任务生成频率单位
		applyObject.setAttributeValue("taskstoppoint", "02");//任务停止生成时点
		applyObject.setAttributeValue("firsttaskmonth", "11");//首次任务生成间隔期（月）
		applyObject.setAttributeValue("firttaskbasetime", "02");//首次任务生成时基准时点
		applyObject.setAttributeValue("payway", "01");//首次任务生成时基准时点
	}	 

	//贷后检查信息
	private void calRuleSimpleData_businessApply(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("LTP", "50");//
		applyObject.setAttributeValue("LTV", "60");//
		applyObject.setAttributeValue("OD24month", "2");//本笔贷款最近24个月累计逾期次数（主动授信）
		applyObject.setAttributeValue("OD6month", "1");//本笔贷款最近6个月累计逾期次数（主动授信）
		applyObject.setAttributeValue("OtherMonthlyPayment", "2000");//除新申请贷款金额的月还款
		applyObject.setAttributeValue("currency", "RMB");
		applyObject.setAttributeValue("maxLTVLTP", "40");//贷款成数
		applyObject.setAttributeValue("expiryzl", "01");//贷款到期日是否晚于质押物到期日
		applyObject.setAttributeValue("amount", 10000);//贷款金额
		applyObject.setAttributeValue("extraamount", 500000);//贷款金额-贷款余额（主动授信）
		applyObject.setAttributeValue("totaltenor", 361);//贷款期限
		applyObject.setAttributeValue("tenorhouseage", 65);//贷款期限+房龄
		applyObject.setAttributeValue("tenorage", 71);//贷款期限+借款人年龄
		applyObject.setAttributeValue("loanpurpose", "101");//贷款用途
		applyObject.setAttributeValue("loanpurpose2", "03");//贷款用途
		applyObject.setAttributeValue("accountstatus", "01");//贷款账户状态（主动授信）
		applyObject.setAttributeValue("morgagerealestate", "01");//担保方式是否为房产抵押
		applyObject.setAttributeValue("NoofRes", "2");//第几套房（含此套）
		applyObject.setAttributeValue("CLmonth", "01");//额度有效期
		applyObject.setAttributeValue("citytype1", "01");//房产所在城市类型（所购资产）
		applyObject.setAttributeValue("drawdownmonth", "01");//放款日期距今月数（主动授信）
		applyObject.setAttributeValue("cartype", "01");//购车类型
		applyObject.setAttributeValue("relatedML", "01");//关联主贷款是否为房产按揭贷款
		applyObject.setAttributeValue("baseaccountrate", "01");//基础账户管理费率（无抵押信用消费贷款）
		applyObject.setAttributeValue("DSRTAV", "01");//客户还款能力判定标准
		applyObject.setAttributeValue("customergroup3", "01");//客户类别
		applyObject.setAttributeValue("customergroup1", "01");//客户类别1
		applyObject.setAttributeValue("customergroup2", "02");//客户组别2
		applyObject.setAttributeValue("actualaccountrate", 0.1);//实际账户管理费
		applyObject.setAttributeValue("paymyself", "01");//是否可以采用自主支付
		applyObject.setAttributeValue("guarantee", "");//是否有法人保证或自然人保证
		applyObject.setAttributeValue("DSR1", "50");//收入负债比1
		applyObject.setAttributeValue("DSR2", "");//收入负债比2
		applyObject.setAttributeValue("DSR3", "");//收入负债比3
		applyObject.setAttributeValue("formeramount", "");//同名转按原贷款余额
		applyObject.setAttributeValue("landagetenor", "30");//土地剩余年限-贷款期限
		applyObject.setAttributeValue("totalUPL2", 100000);//系统内外最高无抵押额度（不含本笔无抵押）
		applyObject.setAttributeValue("totalUPL1", 80000);//系统内外最高无抵押额度（含本笔无抵押）
		applyObject.setAttributeValue("YRLUPL2", 50000);//系统内最高无抵押额度（不含本笔无抵押贷款）
		applyObject.setAttributeValue("YRLUPL1", 30000);//系统内最高无抵押额度（含本笔无抵押贷款）
		applyObject.setAttributeValue("relatedML2", "01");//押品中是否有关联按揭房产
		applyObject.setAttributeValue("product02", "07");//业务品种（大类）
		applyObject.setAttributeValue("product01", "01");//业务品种（小类）
		applyObject.setAttributeValue("promotiontype", "04");//业务推荐渠道
		applyObject.setAttributeValue("Income", 10000);//月收入总金额
		applyObject.setAttributeValue("TAV1", "");//资产负债比1
		applyObject.setAttributeValue("TAV2", "");//资产负债比2
		applyObject.setAttributeValue("assetamount", 1000000);//资产总额
		
	}	 

	//客户信息
	private void calRuleSimpleData_customerInfo(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("debtmonthYRD", "3");//贷记卡及贷款平均开户距现在月数（YRD）
		applyObject.setAttributeValue("employment_country", "CHA");//单位所在国家
		applyObject.setAttributeValue("employmenttype", "02");//单位性质
		applyObject.setAttributeValue("yearofemployment", "01");//工作年限
		applyObject.setAttributeValue("EmploymentType", "10");//雇佣类型
		applyObject.setAttributeValue("marriage", "10");//婚姻状况
		applyObject.setAttributeValue("education", "10");//教育水平
		applyObject.setAttributeValue("nation", "CHA");//借款人国籍
		applyObject.setAttributeValue("domesticforeign", "01");//境内人士/境外人士
		applyObject.setAttributeValue("accountdate", "5");//开户时间（YRD）
		applyObject.setAttributeValue("custtype", "01");//客户类型
		applyObject.setAttributeValue("customertypeYRD", "01");//客户类型（YRD）
		applyObject.setAttributeValue("coapp1y_morgage", "01");//联合申请人是否为房产抵押人
		
		applyObject.setAttributeValue("age", "26");//年龄
		applyObject.setAttributeValue("incomeidentification", "01");//收入证明材料是否完整
		applyObject.setAttributeValue("industry", "01");//所属行业
		applyObject.setAttributeValue("debtcardusage", "75");//未销户贷记卡额度使用率（YRD）
		applyObject.setAttributeValue("living_status", "01");//现居住房屋状态
		applyObject.setAttributeValue("sex", "01");//性别
		applyObject.setAttributeValue("IDexpiry", "5");//证件有效期
		applyObject.setAttributeValue("position", "03");//职位(银监)
		applyObject.setAttributeValue("apply_morgage", "01");//主申请人是否为房产抵押人
		applyObject.setAttributeValue("assetdebt", "01");//资产负债余额
		
	}

	private void calRuleSimpleData_businessIdentity(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("sharehold", "sharehold");//未知记录
	}
	//征信信息
	private void calRuleSimpleData_creditReport(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("CR026", "1");//贷款明细信息中“当前逾期总额”大于0的贷款数
		applyObject.setAttributeValue("CR002", "1");//当前逾期金额为1000元以上（含），或当前逾期期数2期以上（含）的贷款数
		applyObject.setAttributeValue("CR003", "2");//当前逾期金额为1000元以上（含），或当前逾期期数2期以上（含）的信用卡数
		applyObject.setAttributeValue("CR011", "1");//当前账户状态出现“止付、冻结、呆账”的贷款数
		applyObject.setAttributeValue("CR010", "1");//当前账户状态出现“止付、冻结、呆账”的信用卡数
		applyObject.setAttributeValue("CR001", "01");//该客户是否有有效征信记录
		applyObject.setAttributeValue("CR012", "0");//还款记录中出现“担保人代还”或“以资抵债”的贷款数
		applyObject.setAttributeValue("CR013", "0");//还款记录中出现“担保人代还”或“以资抵债”的信用卡数
		applyObject.setAttributeValue("CR018", "0");//近12个月还款记录中出现“1”累计次数大于2的贷款数
		applyObject.setAttributeValue("CR017", "1");//近12个月还款记录中出现“1”累计次数大于2的信用卡数
		applyObject.setAttributeValue("CR009", "0");//近12个月还款记录中出现“2”的累计次数大于等于2的贷款数
		applyObject.setAttributeValue("CR008", "0");//近12个月还款记录中出现“2”的累计次数大于等于2的信用卡数
		applyObject.setAttributeValue("CR020", "1");//近12个月还款记录中出现“2”累计次数大于等于1的贷款数
		applyObject.setAttributeValue("CR019", "0");//近12个月还款记录中出现“2”累计次数大于等于1的信用卡数
		applyObject.setAttributeValue("CR022", "0");//近24个月还款记录中出现“2”的累计次数大于“2”的贷款数
		applyObject.setAttributeValue("CR023", "1");//近24个月还款记录中出现“2”的累计次数大于“2”的信用卡数
		applyObject.setAttributeValue("CR005", "3");//近24个月还款记录中出现“3”的累计次数大于等于1的信用卡数
		applyObject.setAttributeValue("CR004", "2");//近24个月还款记录中出现“3”的累计次数大于等于1或贷款明细信息中“最高逾期期数”大于等于“3”的贷款数
		applyObject.setAttributeValue("CR029", "1");//近24个月还款记录中出现数字（1、2、3、4、5、6、7）的累计次数大于等于1的贷款数
		applyObject.setAttributeValue("CR030", "1");//近24个月还款记录中出现数字（1、2、3、4、5、6、7）的累计次数大于等于1的信用卡数
		applyObject.setAttributeValue("CR024", "1");//近6个月还款记录中出现“1”的累计次数大于等于1的贷款数
		applyObject.setAttributeValue("CR025", "1");//近6个月还款记录中出现“1”的累计次数大于等于1的信用卡数
		applyObject.setAttributeValue("CR006", "1");//近6个月还款记录中出现“1”的累计次数大于等于2的贷款数
		applyObject.setAttributeValue("CR007", "1");//近6个月还款记录中出现“1”的累计次数大于等于2的信用卡数
		applyObject.setAttributeValue("CR016", "0");//近6个月还款记录中出现“1”累计次数大于1的贷款数
		applyObject.setAttributeValue("CR015", "0");//近6个月还款记录中出现“1”累计次数大于1的信用卡数
		applyObject.setAttributeValue("CR028", "5");//近90天征信查询情况，征信查询原因为“贷款审批”的查询次数
		applyObject.setAttributeValue("CR014", "0");//近90天征信查询情况，征信查询原因为“贷款审批”或“信用卡审批”的查询次数
		applyObject.setAttributeValue("CR027", "0");//信用卡明细信息中“当前逾期总额”大于0的信用卡数
		applyObject.setAttributeValue("CR021", "2");//征信报告中累计逾期次数
		
	}
    //押品信息
	private void calRuleSimpleData_mortgageInfo(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("parkonly", "01");//抵押物中是否只有车位
		applyObject.setAttributeValue("purchaseprice", "2000000");//房产交易价
		applyObject.setAttributeValue("EMV", "1800000");//房产评估价
		applyObject.setAttributeValue("citytype2", "01");//房产所在城市类型
		applyObject.setAttributeValue("houseusage", "01");//房产用途
		applyObject.setAttributeValue("PropertyStatus", "");//房产状态
		applyObject.setAttributeValue("yearofhouse", "20");//房龄
		applyObject.setAttributeValue("FPcurrency", "01");//理财产品币种
		applyObject.setAttributeValue("currencysame", "01");//理财产品币种与贷款币种是否相同
		applyObject.setAttributeValue("FPexpiry", "12");//理财产品剩余期限
		applyObject.setAttributeValue("monthofEMV", "3");//评估时间
		applyObject.setAttributeValue("RMBDC", "300000");//人民币定期存单价值
		applyObject.setAttributeValue("yearofland", "");//土地剩余使用年限
		applyObject.setAttributeValue("FCDC", "200000");//外币定期存单价值
		applyObject.setAttributeValue("ztype", "01");//质押物类型
 	}
	//逾期信息
	private void calRuleSimpleData_odInfo(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("ODperiod", "2");//连续逾期期数
		applyObject.setAttributeValue("ODday", "2");//逾期天数
	}
	//资产分类信息
	private void calRuleSimpleData_loanGradeInfo(BusinessObject applyObject) throws JBOException {
		applyObject.setAttributeValue("BaselLoanCategory", "2");//Basel贷款种类
		applyObject.setAttributeValue("CEJMUpdate", "2");//CEJM更新日期
		applyObject.setAttributeValue("CEJMGrade", "2");//CEJM评级
		applyObject.setAttributeValue("SYSGENGRADEupdate", "2");//SYS GEN GRADE更新日期
		applyObject.setAttributeValue("LoanType", "2");//贷款状态
		applyObject.setAttributeValue("ACBorrowerGradeOverriding", "2");//覆盖后的借款人级别
		applyObject.setAttributeValue("ACBorrowerGrade", "2");//借款人级别
		applyObject.setAttributeValue("CustomerGrade", "2");//客户等级
		applyObject.setAttributeValue("CustomerGradeUpdate", "2");//客户等级更新日期
		applyObject.setAttributeValue("SpecializedLendingCode", "2");//特别贷款代码
		applyObject.setAttributeValue("SpecializedLendingLastUpdatedDate", "2");//特别贷款最后一次更新日期
	}
}
