package com.amarsoft.app.oci.ws.decision.prepare;

public class Classification {
	//业务种类
	public final static String IND_NEW_HOUSE_LOAN = "001";//个人一手房购房贷款
	public final static String IND_OLD_HOUSE_LOAN = "002";//个人二手房购房贷款
	public final static String IND_NEW_SUITABLE_HOUSE_LOAN = "032";//个人一手房购房贷款-经适房
	public final static String IND_NEW_HOUSE_FORCES_LOAN = "033";//个人一手房购房贷款-合力贷
	public final static String IND_OLD_HOUSE_RELAY_LOAN = "034";//个人二手房-接力贷
	public final static String IND_OLD_HOUSE_FORCES_LOAN = "035";//个人二手房-合力贷
	public final static String IND_BUSINESS_HOUSE_RELAY_LOAN = "036";//个人商业用房按揭贷款-接力贷
	public final static String ACC_FUND_SUITABLE_HOUSE_LOAN = "102";//公积金贷款-经适房
	public final static String IND_HOUSE_BOND_LOAN = "407";//个人住房证券化贷款
	//合同状态
	public final static String PUT_MONEY = "03";//已放款
	//财务类型
	public final static String MON_STABLE_INCOME = "3010";//月稳定收入
	public final static String MON_RENT_INCOME = "3020";//租金月收入
	public final static String MON_INVEST_INCOME = "3030";//投资月收入
	public final static String MON_REST_INCOME = "3040";//其他月收入
	//客户关系类型
	public final static String SPOUSE = "2007";//配偶
	//额度类型
	public final static String CONSUMEPOOL_AMT = "0105";//消费额度
	public final static String WORKINGPOOL_AMT = "0106";//经营额度
	//标的物类型
	public final static String LIVE_BUSINESS_HOUSE_PROPERTY = "20";//商用房地产和居住用房地产
	public final static String TRAFFIC_TRANSPORT_EQUIPMENT = "40500";//交通运输设备
	//客户等级
	public final static String PLATINUM_CUSTOMER = "10";//白金客户
	//申请人类型
	public final static String MAIN_APPLICANT = "01";//主申请人
	public final static String COMMON_BORROW_APPLICANT = "02";//共同借款人
	public final static String COMMON_REPAYMENT_APPLICANT = "03";//共同还款人
	//特殊业务标示
	public final static String COMMON_BUSINESS = "01";//普通业务
	public final static String EXCEPTION_APPROVE_BUSINESS = "02";//例外审批业务
	//申请关联类型
	public final static String ACCUMULATION_FUND_COMBINATION_APPLY = "07";//公积金组合打包申请
	//担保类型
//	public final static String CREDIT = "005";//信用
//	public final static String GUARANTEE = "010";//保证
//	public final static String PLEDGE = "020";//抵押
//	public final static String ZHIYA = "040";//质押
//	public final static String INSURE_GUARANTEE = "01020";//履约保险保证
	//主要担保方式
	public final static String CREDIT = "D";//信用
	public final static String GUARANTEE = "C";//保证
	public final static String PLEDGE = "B";//抵押
	public final static String ZHIYA = "A";//质押
	public final static String INSURE_GUARANTEE = "01020";//履约保险保证
	//贷款种类
	public final static String IND_HOUSE_LOAN = "11"; //个人住房贷款
	public final static String IND_COMMERCIAL_HOUSE_LOAN = "12";//个人商用房贷款
	public final static String IND_HOUSE_ACCUMULATIONFUND_LOAN = "13";//个人住房公积金贷款
	public final static String OTHER_LOAN = "99";//其他贷款
	//贷款状态
    public final static String NORMAL_LOAN = "1";//贷款状态为正常
    public final static String OVERDUE_LOAN = "2";//贷款状态为逾期
    public final static String SETTLE_LOAN = "3";//贷款状态为结清
    public final static String BADDEBT_LOAN = "4";//贷款状态为呆账
    public final static String ROLLOUT_LOAN = "5";//贷款状态为转出
    //卡状态
    public final static String NORMAL_LOANCARD = "1";//卡状态为正常
    public final static String FROZEN_LOANCARD = "2";//卡状态为冻结
    public final static String STOPPAYMENT_LOANCARD = "3";//卡状态为止付
    public final static String CANCELLATION_LOANCARD = "4";//卡状态为销户
    public final static String BADDEBT_LOANCARD = "5";//卡状态为呆账
    public final static String NOTACTIVATED_LOANCARD = "6";//卡状态为未激活
    //五级分类
    public final static String NORMAL_CLASS_5STATE = "1";//5级分类为正常
    public final static String NORMAL_CLASS_5STATE_ATTENSTION = "2";//5级分类为关注
    public final static String NORMAL_CLASS_5STATE_SEC = "3";//5级分类为次级
    public final static String NORMAL_CLASS_5STATE_SUS = "4";//5级分类为可疑
    public final static String NORMAL_CLASS_5STATE_LOS = "5";//5级分类为损失
    public final static String NORMAL_CLASS_5STATE_UNKNONE = "9";//5级分类为未知
    //还款频率
    public final static String MONTHPAYMENT_RATING = "03";//还款频率为月
    //户籍性质
    public final static String LOCAL_RESIDENT = "01";//本地常住户口
    //行业分类
    public final static String FARMING = "A";//农、林、牧、渔业
    public final static String MINING = "B";//采掘业
    public final static String MANUFACTURING = "C";//制造业
    public final static String ENERGY = "D";//电力、燃气及水的生产和供应业
    public final static String BUILDING = "E";//建筑业
    public final static String MARKETING = "F";//批发和零售行业
    public final static String TRANSPORTATION = "G";//交通运输、仓储和邮政业
    public final static String CATERING = "H";//住宿和餐饮业
    public final static String INFORMATION = "I";//信息传输、计算机服务和软件业
    public final static String FINANCE = "J";//金融业
    public final static String HOUSING = "K";//房地产
    public final static String LEASE = "L";//租赁和商务服务
    public final static String SCIENCE = "M";//科学研究和技术服务行业
    public final static String ENVIRONMENT = "N";//水利、环境、和公共设施管理业
    public final static String SERVE = "O";//居民服务和其他服务行业
    public final static String EDUCATION = "P";//教育
    public final static String HEALTH = "Q";//卫生、社会保障和社会福利
    public final static String CULTURE = "R";//文化、体育和娱乐业
    public final static String COMMUNITY = "S";//公共管理和社会组织
    public final static String INTERNATION = "T";//国际组织
    //客户标示
    public final static String PEOPLE_BANK_BLACKLIST = "1020";//人行黑名单
    public final static String LOCAL_BANK_BLACKLIST = "1030";//本行黑名单
    //返回固定值配置
    public final static String SYSTEMID = "PL";//请求方代码
    public final static String ALIAS = "PLAPPONL";//交易码
    public final static String SIGNATURE = "SPDB";//所调用策略流的签名
    public final static String INPUTDATAAREA = "SPDB";//输入的Physical Layout
    public final static String OUTPUTDATAAREA = "OPLAPPOT";//输出的Physical Layout
    public final static String TRACELEVEL = "16";//调用DA时的日志级别
    public final static String POSITION = "0";//调用位置
    //抵质押类型
    public final static String FINANCIAL_GUARANTY = "01";//金融类质押品
    public final static String TRADE_SHOULD_INCOME = "30100";//交易类应收账款
    public final static String ELSE_SHOULD_INCOME = "30300";//其他应收账款
    
    /** 征信查询原因  - 贷款审批 */
    public final static String QUERY_REASON_LOAN = "02";
    /** 征信查询原因   - 信用卡审批*/
    public final static String QUERY_REASON_CREDIT = "03";
    
    /**人行不存在征信报告*/
    public final static String QUERY_RESPONSE_NOTEXSISTS = "人行不存在该人的征信记录";
}
