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
 * �Ŵ������Ŀ����
 * 
 * @author Amarsoft�����Ŷ�
 * 
 */
public final class AccountCodeConfig extends XMLConfig {
	public static final String accountcode_type_customer = "C"; //ϵͳ���ÿͻ�������
	
	public static final String JBO_NAME_ACCOUNT_BOOK_TYPE = "BookType"; //��Ŀ����
	public static final String JBO_NAME_ACCOUNT_CODE = "AccountCode"; //��Ŀ����
	public static final String JBO_NAME_JOURNAL_GROUP = "JournalGroup"; //��¼�����
	public static final String JBO_NAME_JOURNAL = "Journal"; //��¼����
	
	//����
	public static final String BALANCE_DIRECTION_DEBIT = "D";//�跽
	public static final String BALANCE_DIRECTION_CREDIT = "C";//����
	public static final String BALANCE_DIRECTION_BOTH = "B";//���˫��
	
	//������������
	public static final String BALANCE_DIRECTION_RECIEVE = "R"; //��
	public static final String BALANCE_DIRECTION_PAY = "P"; //��
	
	//�����ֱ�ʶ
	public final static String TRANS_FLAG_RED = "R";
	public final static String TRANS_FLAG_BLUE = "B";
	
	public static final String Balance_DateFlag_LastYear = "4";//�������=��ǰ���-��ǰ������
	public static final String Balance_DateFlag_LastMonth = "3";//�������=��ǰ���-���·�����
	public static final String Balance_DateFlag_LastDay = "2"; //�������=��ǰ���-���շ�����
	public static final String Balance_DateFlag_CurrentDay = "1"; //��ǰ���

	

	private static BusinessObjectCache accountCodeConfigCache=new BusinessObjectCache(1000);
	private static BusinessObjectCache journalGroupConfigCache=new BusinessObjectCache(1000);

	
	//����ģʽ
	private static AccountCodeConfig acc = null;
	
	private AccountCodeConfig(){
		
	}
	
	public static AccountCodeConfig getInstance(){
		if(acc == null)
			acc = new AccountCodeConfig();
		return acc;
	}
	
	
	/**
	 * �����˻������Ϣ
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
	 * ��ȡ�˻������Ϣ
	 * 
	 * @param subledger
	 * @param balanceDirection
	 * @param dateFlag :1��ǰ��2���ա�3����ĩ��4����ĩ
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
	 * ��ȡ�˻������Ϣ
	 * 
	 * @param subledger
	 * @param dateFlag :1��ǰ��2���ա�3����ĩ��4����ĩ
	 * @return
	 * @throws Exception
	 */
	public static double getSubledgerBalance(BusinessObject subledger, String dateFlag) throws Exception {
		String direction = subledger.getString("Direction");
		return AccountCodeConfig.getSubledgerBalance(subledger, direction, dateFlag);
	}

	/**
	 * ��ȡָ����Ʒ�¼ID�Ķ�����Ϣ
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
	 * ��ȡָ�����׵Ķ�����Ϣ
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
	 * ��ȡָ�����ס��������Ķ�����Ϣ
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
	 * ���ػ�������
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
		
		
		//��̬�����������µĶ��󣬺�ֵ��������̲߳���ʱ����ȡֵ�ͼ�������ͬʱ���е����쳣
		AccountCodeConfig.accountCodeConfigCache = accountCodeConfigCache;
		AccountCodeConfig.journalGroupConfigCache = journalGroupConfigCache;
	}
}
