package com.amarsoft.app.als.cl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.ERateHelper;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.cache.CodeCache;

/**
 * Class <code>CreditSingleObject</code>是单笔授信（包括额度项下业务）的基础类. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 */

public class CreditSingleObject extends CreditObject {
	/**
	 * 保存单笔授信业务对应的出账信息
	 */
	protected List<BusinessObject> putObjects=null;
	/**
	 * 保存单笔授信业务对应的借据信息
	 */
	protected List<BusinessObject> duebillObjects=null;
	
	/**
	 * 保存单笔授信业务对应的担保信息
	 */
	protected List<BusinessObject> guarantyObjects=null;

	/**
	 * 报错单笔授信贷款可用金额
	 */
	protected double doSum = 0.0d;
	/**
	 * 保存单笔授信贷款余额占用上层额度余额
	 */
	protected double useBalance = 0.0d;
	/**
	 * 保存单笔授信贷款金额占用上层额度金额
	 */
	protected double useSum = 0.0d;
	
	/**
	 *@param BusinessObject 通过外部传入不通过数据库连接初始化
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(BusinessObject creditObject) throws SQLException,Exception{
		this.CreditObject = creditObject;
	}
	

	/**
	 *@param Connection 数据库连接用于加载授信业务相关数据 
	 *@param SerialNo 表示通过对象编号加载整个授信业务对象
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(Connection conn,String ObjectType,String ObjectNo) throws SQLException,Exception
	{
		String[] paras = new String[]{ObjectNo};
		//加载主对象
		String sql = "select SerialNo,RevolveFlag,BusinessSum,BusinessCurrency,ContractStatus,NVL((select MaturityDate from CL_INFO where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = BUSINESS_CONTRACT.SerialNo and CLType in('0101','0102','0103','0104','0107','0108') and rownum = 1),MaturityDate) as MaturityDate from BUSINESS_CONTRACT where SerialNo = ? ";
		this.CreditObject = loadDB(conn, sql, paras).get(0);
		//加载出账信息
		sql = "select SerialNo as PutOutNo,BusinessSum,BusinessCurrency,PutOutStatus from BUSINESS_PUTOUT where ContractSerialNo = ? ";
		this.putObjects = loadDB(conn, sql, paras);
		//加载贷款信息
		sql = "select BusinessSum,Currency as BusinessCurrency,nvl((SELECT sum(nvl(DebitBalance,0.0)-nvl(CreditBalance,0.0)) from ACCT_SUBSIDIARY_LEDGER where relativeObjectNo = ACCT_LOAN.SerialNo and RelativeObjectType = 'jbo.acct.ACCT_LOAN' and AccountCodeNo in('Customer01','Customer02')),0.0) as Balance from ACCT_LOAN where ContractSerialNo = ? ";
		this.duebillObjects = loadDB(conn, sql, paras);
		
	}
	
	/**
	 *@param BusinessObject 通过外部传入不通过数据库连接初始化
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(BusinessObject creditObject,ArrayList<BusinessObject> putObjects
			,ArrayList<BusinessObject> duebillObjects,ArrayList<BusinessObject> guarantyObjects) throws SQLException,Exception{
		if(creditObject!=null) load(creditObject);
		if(putObjects!=null) this.putObjects = putObjects;
		if(duebillObjects!=null) this.duebillObjects = duebillObjects;
		if(guarantyObjects!=null) this.guarantyObjects = guarantyObjects;
	}
	
	/**
	 *@context 该Method用于计算授信余额和实际发放金额，并更新实际发放金额和余额字段
	 *@author xjzhao
	 *@throws Exception 
	 */
	public double calcBalance() throws Exception{
		
		String revolveFlag = this.CreditObject.getString("RevolveFlag");//合同是否循环
		double businessSum = DataConvert.toDouble(this.CreditObject.getString("BusinessSum"));//合同金额
		String currency = this.CreditObject.getString("BusinessCurrency");//合同币种
		String contractStatus = this.CreditObject.getString("ContractStatus");
		String maturityDate = this.CreditObject.getString("MaturityDate");
		
		double balance = 0.0d;//贷款按余额算敞口金额
		double putoutSum = 0.0d;//贷款按发放金额算敞口金额
		double allPutOutSum = 0.0d;//总放款金额不包含保证金
		//扫描借据表内业务
		for(BusinessObject duebill:duebillObjects)
		{
			balance += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*(DataConvert.toDouble(duebill.getString("Balance")));
			putoutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*DataConvert.toDouble(duebill.getString("BusinessSum"));
			allPutOutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*DataConvert.toDouble(duebill.getString("BusinessSum"));
		}
		
		//扫描出账信息
		for(BusinessObject put:putObjects)
		{
			if("".equals(put.getString("PutOutStatus")) || "01".equals(put.getString("PutOutStatus")) || "02".equals(put.getString("PutOutStatus")) || "03".equals(put.getString("PutOutStatus"))) //申请中/监督通过
			{
				balance += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*DataConvert.toDouble(put.getString("BusinessSum"));
				putoutSum += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*DataConvert.toDouble(put.getString("BusinessSum"));
			}
		}
		
		
		//循环额度公式 可用金额=合同总金额-借据余额-出账中总金额
		if("1".equals(revolveFlag))
		{
			this.doSum = businessSum - balance;
		}
		else//非循环额度公式  可用金额=合同总金额-已发放借据金额-出账中总金额
		{
			this.doSum = businessSum - putoutSum;
		}
		
		this.useBalance = Math.max(0,balance);
		this.useSum = Math.max(0,putoutSum);
		
		if("04".equals(contractStatus) || "05".equals(contractStatus))
		{
			this.RiskMessage.add("合同状态为："+CodeCache.getItemName("BusinessContractStatus", contractStatus)+"，不能发起业务。");
			this.doSum = 0d;
		}
		
		if(maturityDate != null && !"".equals(maturityDate) && 	DateHelper.getBusinessDate().compareTo(maturityDate) > 0)
		{
			this.RiskMessage.add("合同已到期，不能再发起业务。");
			this.doSum = 0d;
		}
		
		//合同金额可用余额校验
		if(this.doSum < 0)
		{
			this.RiskMessage.add("合同可出账金额不够，合同余额（本笔计算在内）为："+DataConvert.toMoney(doSum));
		}
		else
		{
			this.AlarmMessage.add("合同可用金额（除本笔）为："+DataConvert.toMoney(doSum));
		}
		
		return this.doSum;
	}
	
	/**
	 *@context 保存计算结果 该方法必须必须依赖calcBalance()，不可单独使用
	 *@author xjzhao
	 *@throws Exception 
	 */
	public void saveData(Connection conn) throws Exception{
		String sql = "update CL_INFO set BUSINESSAVABALANCE = ? where ObjectType = ? and ObjectNo = ?";
		PreparedStatement ps = null;
		try
		{
			ps = conn.prepareStatement(sql);
			ps.setDouble(1, this.doSum);
			ps.setString(2, "jbo.app.BUSINESS_CONTRACT");
			ps.setString(3, this.CreditObject.getString("SerialNo"));
			ps.execute();
			ps.close();
			ps = null; 
		}
		catch(Exception ex)
		{
			throw ex;
		}
		finally
		{
			if(ps != null) ps.close();
		}
	}
	
}
