package com.amarsoft.app.base.config.impl;

import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.accounting.config.impl.AccountCodeConfig;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.BUSINESSOBJECT_CONSTANTS;
import com.amarsoft.app.base.util.DateHelper;

/**
 * 机构、即其他信息缓存，可根据需要添加
 * 
 * @author ygwang 2015/11/14
 */
public final class SystemDBConfig{
	private static Map<String,BusinessObjectCache> dbcache = new HashMap<String,BusinessObjectCache>();
	
	public static String[] getOrgs() throws Exception{
		BusinessObjectCache cache = dbcache.get("System_Org");
		if (cache == null){
			return new String[0];
		}
		else return cache.getCacheObjects().keySet().toArray(new String[0]);
	}
	
	public static BusinessObject getOrg(String orgID) throws Exception{
		BusinessObjectCache cache = dbcache.get("System_Org");
		if (cache == null){
			cache=new BusinessObjectCache(1024);
			dbcache.put("System_Org", cache);
		}
		
		BusinessObject o = (BusinessObject) cache.getCacheObject(orgID);
		if(o==null){
			BusinessObjectManager bomanager =BusinessObjectManager.createBusinessObjectManager();
			o = bomanager.keyLoadBusinessObject("jbo.sys.ORG_INFO",orgID);
			if(o==null){
				throw new ALSException("ED1016",orgID);
			}
			else{
				cache.setCache(orgID,o);
			}
		}
		return o;
	}

	/**
	 * 取对应机构、账户类型、币种的内部账号信息，如果账号不存在则找该机构的上级机构信息
	 * 
	 * @param orgID
	 * @param accountType
	 * @param currency
	 * @return
	 * @throws Exception
	 */
	public static BusinessObject getSystemAccount(String orgID, String accountType, String currency) throws Exception {
		BusinessObjectCache sysAccountCache = dbcache.get("System_Account");
		if (sysAccountCache == null){
			sysAccountCache=new BusinessObjectCache(1024);
			dbcache.put("System_Account", sysAccountCache);
		}
		int i=0;
		BusinessObject systemAccount =null;
		while (i<10) {	
			systemAccount = (BusinessObject) sysAccountCache.getCacheObject(orgID+"-"+accountType+"-"+currency);
			if(systemAccount!=null) return systemAccount;
			
			BusinessObjectManager bomanager =BusinessObjectManager.createBusinessObjectManager();
			systemAccount = bomanager.loadBusinessObject(BUSINESSOBJECT_CONSTANTS.system_account, "ACCOUNTORGID",orgID,"AccountType",accountType,"Currency",currency);
			if(systemAccount==null){
				BusinessObject org=SystemDBConfig.getOrg(orgID);
				if(org==null) throw new ALSException("ED1016",orgID);
				String relativeOrgID = org.getString("RelativeOrgID");
				if (relativeOrgID == null || relativeOrgID.equals(orgID)) {
					break;
				} else
					orgID = relativeOrgID;
			}
			else{
				sysAccountCache.setCache(orgID+"-"+accountType+"-"+currency,systemAccount);
				break;
			}
			i++;
		}

		if (systemAccount == null)
			throw new ALSException("ED1017",orgID ,accountType ,currency);
		return systemAccount;
	}
	
	
	/**
	 * 根据日期类型和日期判断是否工作日
	 * @param date
	 * @param calendarType
	 * @return
	 * @throws Exception
	 */
	public static boolean isWork(String date, String calendarType) throws Exception {
		BusinessObjectCache calendarCache = dbcache.get("System_Calendar");
		if (calendarCache == null){
			calendarCache=new BusinessObjectCache(1024);
			dbcache.put("System_Calendar", calendarCache);
		}
		
		BusinessObject calendar =  (BusinessObject)calendarCache.getCacheObject(calendarType+"-"+date);
		if(calendar == null)
		{	BusinessObjectManager bomanager =BusinessObjectManager.createBusinessObjectManager();
			calendar = bomanager.loadBusinessObject("jbo.sys.SYS_CALENDAR","CurDate=:CurDate and CalendarType=:CalendarType","CurDate",date,"CalendarType",calendarType);
		}
		
		if(calendar == null)
			throw new ALSException("EC0001",date,calendarType);
		else
		{
			if("1".equals(calendar.getString("WorkFlag"))) return true;
			else return false;
		}
		
	}
	
	/**
	 * 得到距离当前日期最近的未来工作日
	 * 
	 * @param date
	 * @return 得到工作日
	 * @throws Exception
	 */
	public static String getNextWorkDate(String date, String calendarTypeScript) throws Exception {
		String nextworkdate = date.trim();
		while (true) {
			nextworkdate = DateHelper.getRelativeDate(nextworkdate, DateHelper.TERM_UNIT_DAY, 1);
			if (SystemDBConfig.isWork(nextworkdate, calendarTypeScript))
				break;
		}
		return nextworkdate;
	}
	
	
	/**
	 * 得到距离当前日期最近的过去工作日
	 * 
	 * @param date
	 * @return 得到工作日
	 * @throws Exception
	 */
	public static String getLastWorkDate(String date, String calendarTypeScript) throws Exception {
		String lastworkdate = date.trim();
		while (true) {
			lastworkdate = DateHelper.getRelativeDate(lastworkdate, DateHelper.TERM_UNIT_DAY, -1);
			if (SystemDBConfig.isWork(lastworkdate, calendarTypeScript))
				break;
		}
		return lastworkdate;
	}
	
	/**
	 * 获取分户余额  用于会计分录配置
	 * @param subledger
	 * @param accountCodeNo
	 * @return
	 * @throws Exception
	 */
	public static double getSubledgerBalance(BusinessObject transaction,String accountCodeNo) throws Exception{
		
		BusinessObject loan= transaction.getBusinessObject("jbo.acct.ACCT_LOAN");
		
		BusinessObject subledger =loan.getBusinessObjectBySql("jbo.acct.ACCT_SUBSIDIARY_LEDGER","AccountCodeNo=:AccountCodeNo and ACCOUNTINGORGID=:ACCOUNTINGORGID","AccountCodeNo",accountCodeNo,"ACCOUNTINGORGID",loan.getString("ACCOUNTINGORGID"));
 		if(subledger == null)  return 0.0d;
		else{
			return AccountCodeConfig.getSubledgerBalance(subledger, AccountCodeConfig.Balance_DateFlag_CurrentDay);
		}
	}
}
