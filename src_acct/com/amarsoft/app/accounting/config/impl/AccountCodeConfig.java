package com.amarsoft.app.accounting.config.impl;

import java.util.List;

import com.amarsoft.app.accounting.cashflow.CashFlowHelper;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.config.impl.XMLConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.Arith;
import com.amarsoft.are.util.xml.Document;

/**
 * 信贷账务科目配置
 * 
 * @author Amarsoft核算团队
 * 
 */
public final class AccountCodeConfig extends XMLConfig {
	public static final String accountcode_type_customer = "C"; //系统内置客户分类账
	
	public static final String JBO_NAME_ACCOUNT_BOOK_TYPE = "BookType"; //科目定义
	public static final String JBO_NAME_ACCOUNT_CODE = "AccountCode"; //科目定义
	public static final String JBO_NAME_JOURNAL_GROUP = "JournalGroup"; //分录组别定义
	public static final String JBO_NAME_JOURNAL = "Journal"; //分录定义
	
	//余额方向
	public static final String BALANCE_DIRECTION_DEBIT = "D";//借方
	public static final String BALANCE_DIRECTION_CREDIT = "C";//贷方
	public static final String BALANCE_DIRECTION_BOTH = "B";//借贷双向
	
	//表外账务处理方向
	public static final String BALANCE_DIRECTION_RECIEVE = "R"; //收
	public static final String BALANCE_DIRECTION_PAY = "P"; //付
	
	//红蓝字标识
	public final static String TRANS_FLAG_RED = "R";
	public final static String TRANS_FLAG_BLUE = "B";
	
	public static final String Balance_DateFlag_LastYear = "4";//上年余额=当前余额-当前发生额
	public static final String Balance_DateFlag_LastMonth = "3";//上月余额=当前余额-当月发生额
	public static final String Balance_DateFlag_LastDay = "2"; //昨日余额=当前余额-当日发生额
	public static final String Balance_DateFlag_CurrentDay = "1"; //当前余额

	

	private static BusinessObjectCache accountCodeConfigCache=new BusinessObjectCache(1000);
	private static BusinessObjectCache journalGroupConfigCache=new BusinessObjectCache(1000);

	
	//单例模式
	private static AccountCodeConfig acc = null;
	
	private AccountCodeConfig(){
		
	}
	
	public static AccountCodeConfig getInstance(){
		if(acc == null)
			acc = new AccountCodeConfig();
		return acc;
	}
	
	
	/**
	 * 更新账户余额信息
	 * 
	 * @param subsidiaryledger
	 * @param balance
	 * @throws Exception
	 */
	public static void setSubledgerBalance(BusinessObject subsidiaryledger, double balance) throws Exception {
		String direction = subsidiaryledger.getString("Direction");
		if (direction.equals(BALANCE_DIRECTION_DEBIT))
			subsidiaryledger.setAttributeValue("DebitBalance", balance);
		else if (direction.equals(BALANCE_DIRECTION_CREDIT))
			subsidiaryledger.setAttributeValue("CreditBalance", balance);
		else if (direction.equals(BALANCE_DIRECTION_BOTH))
			throw new ALSException("ED1003");
		else
			throw new ALSException("ED1004",direction);
	}

	/**
	 * 获取账户余额信息
	 * 
	 * @param subledger
	 * @param balanceDirection
	 * @param dateFlag :1当前、2上日、3上月末、4上年末
	 * @return
	 * @throws Exception
	 */
	public static double getSubledgerBalance(BusinessObject subledger, String balanceDirection, String dateFlag) throws Exception {
		double debitAmt = 0d, creditAmt = 0d;
		if (dateFlag.equals(AccountCodeConfig.Balance_DateFlag_CurrentDay)) {
		} else if (dateFlag.equals(AccountCodeConfig.Balance_DateFlag_LastDay)) {
			debitAmt = subledger.getDouble("DebitAmtDay");
			creditAmt = subledger.getDouble("CreditAmtDay");
		} else if (dateFlag.equals(AccountCodeConfig.Balance_DateFlag_LastMonth)) {
			debitAmt = subledger.getDouble("DebitAmtMonth");
			creditAmt = subledger.getDouble("CreditAmtMonth");
		} else if (dateFlag.equals(AccountCodeConfig.Balance_DateFlag_LastYear)) {
			debitAmt = subledger.getDouble("DebitAmtYear");
			creditAmt = subledger.getDouble("CreditAmtYear");
		} else {
			throw new ALSException("ED1005",dateFlag);
		}

		if (balanceDirection.equals(BALANCE_DIRECTION_DEBIT)) {
			return Arith.round(subledger.getDouble("DebitBalance") - subledger.getDouble("CreditBalance") - (debitAmt - creditAmt) , CashFlowHelper.getMoneyPrecision(subledger));
		} else if (balanceDirection.equals(BALANCE_DIRECTION_CREDIT)) {
			return Arith.round(subledger.getDouble("CreditBalance") - subledger.getDouble("DebitBalance") + (debitAmt - creditAmt) , CashFlowHelper.getMoneyPrecision(subledger));
		} else if (balanceDirection.equals(BALANCE_DIRECTION_BOTH)) {
			double b = subledger.getDouble("DebitBalance") - debitAmt - subledger.getDouble("CreditBalance")
					+ creditAmt;
			b = Arith.round(b, CashFlowHelper.getMoneyPrecision(subledger));
			return Math.abs(b);
		} else {
			throw new ALSException("ED1004",balanceDirection);
		}
	}

	/**
	 * 获取账户余额信息
	 * 
	 * @param subledger
	 * @param dateFlag :1当前、2上日、3上月末、4上年末
	 * @return
	 * @throws Exception
	 */
	public static double getSubledgerBalance(BusinessObject subledger, String dateFlag) throws Exception {
		String direction = subledger.getString("Direction");
		return AccountCodeConfig.getSubledgerBalance(subledger, direction, dateFlag);
	}

	/**
	 * 获取指定会计分录ID的定义信息
	 * 
	 * @param bookType
	 * @param accountCodeNo
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getJournalGroupConfig(String journalGroupID) throws Exception {
		BusinessObject journalGroupConfig = (BusinessObject)journalGroupConfigCache.getCacheObject(journalGroupID);
		if (journalGroupConfig == null) {
			throw new ALSException("EC2002",journalGroupID);
		}
		return journalGroupConfig;
	}
	
	/**
	 * 获取指定账套的定义信息
	 * 
	 * @param bookType
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getBookTypeConfig(String bookType) throws Exception {
		BusinessObject bookTypeConfig = (BusinessObject)accountCodeConfigCache.getCacheObject(bookType);
		if (bookTypeConfig == null) {
			throw new ALSException("EC2003",bookType);
		}
		return bookTypeConfig;
	}
	
	/**
	 * 获取指定账套、账务代码的定义信息
	 * 
	 * @param bookType
	 * @param accountCodeNo
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getAccountCodeConfig(String bookType, String accountCodeNo) throws Exception {
		BusinessObject bookTypeConfig = (BusinessObject)accountCodeConfigCache.getCacheObject(bookType);
		if (bookTypeConfig == null) {
			throw new ALSException("EC2004",bookType,accountCodeNo);
		}

		BusinessObject accountCodeConfig = bookTypeConfig.getBusinessObjectByAttributes(AccountCodeConfig.JBO_NAME_ACCOUNT_CODE,"ID", accountCodeNo);
		if (accountCodeConfig == null) {
			throw new ALSException("EC2004",bookType,accountCodeNo);
		}
		return accountCodeConfig;
	}
	

	/**
	 * 加载缓存内容
	 */
	public synchronized void init(String file,int size)  throws Exception {
		Document document = getDocument(ARE.replaceARETags(file));
		
		BusinessObjectCache accountCodeConfigCache = new BusinessObjectCache(size);
		BusinessObjectCache journalGroupConfigCache = new BusinessObjectCache(size);
		
		List<BusinessObject> bookTypeList = this.convertToBusinessObjectList(document.getRootElement().getChild("BookTypes").getChildren("BookType"));
		if (bookTypeList!=null) {
			for (BusinessObject bookType : bookTypeList) {
				accountCodeConfigCache.setCache(bookType.getString("id"), bookType);
			}
		}
		
		
		List<BusinessObject> journalGroupList = this.convertToBusinessObjectList(document.getRootElement().getChild("JournalGroups").getChildren("JournalGroup"));
		if (journalGroupList!=null) {
			for (BusinessObject journalGroup : journalGroupList) {
				journalGroupConfigCache.setCache(journalGroup.getString("id"), journalGroup);
			}
		}
		
		
		//静态变量先申请新的对象，后赋值，避免多线程并行时出现取值和加载数据同时进行导致异常
		AccountCodeConfig.accountCodeConfigCache = accountCodeConfigCache;
		AccountCodeConfig.journalGroupConfigCache = journalGroupConfigCache;
	}
}
