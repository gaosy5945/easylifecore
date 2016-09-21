package com.amarsoft.app.als.cl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.base.util.ERateHelper;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.cache.CodeCache;

/**
 * Class <code>CreditLineCustomer</code>是个人授信额度的基础类. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 */

public class CreditLineCustomer extends CreditLineObject {

	/**
	 * 保存子额度的信息
	 */
	protected List<BusinessObject> subObjects = null;
	/**
	 * 保存单笔授信业务对应的出账信息
	 */
	protected List<BusinessObject> putObjects=null;
	/**
	 * 保存单笔授信业务对应的借据信息
	 */
	protected List<BusinessObject> duebillObjects=null;
	/**
	 * 保存单笔授信业务对应的申请信息
	 */
	protected List<BusinessObject> applyObjects=null;

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
		String sql = "select SerialNo,RevolveFlag,BusinessCurrency,BusinessSum,ContractStatus,VouchType,MaturityDate from BUSINESS_CONTRACT where SerialNo = ? ";
		this.CreditObject = this.loadDB(conn, sql, paras).get(0);
		
		//加载额度对应拆分信息（子CL_INFO）
		String[] paras1 = new String[]{ObjectType,ObjectNo};
		sql = "select SerialNo,ClType,Currency,BusinessAppAmt,BusinessAvaAmt,BusinessAvaBalance,RevolvingFlag,MaturityDate,Status from CL_INFO where ObjectType = ? and ObjectNo = ? ";
		this.splitObjects = this.loadDB(conn, sql, paras1);
		
		//加载出账信息
		sql = "select SerialNo as PutOutNo,BusinessType,BusinessSum,BusinessCurrency,PutOutStatus from BUSINESS_PUTOUT where ContractSerialNo = ? ";
		this.putObjects = loadDB(conn, sql, paras);
		
		//加载贷款信息
		sql = "select PutOutSerialNo,BusinessType,BusinessSum,BusinessCurrency,Balance from BUSINESS_DUEBILL where ContractSerialNo = ? ";
		this.duebillObjects = loadDB(conn, sql, paras);
		
		//加载申请信息
		sql = " select BA.BusinessType,(case when BA.ApproveStatus in('01','02') and BA.OccurType = '0010' then ((select BusinessSum from BUSINESS_APPROVE where SerialNo in (select max(SerialNo) from BUSINESS_APPROVE where ApplySerialNo = BA.SerialNo))) else 0 end) as BusinessSum,BusinessCurrency from BUSINESS_APPLY BA,APPLY_RELATIVE AR where BA.SerialNo = AR.ApplySerialNo and AR.ObjectType = ? and AR.ObjectNo = ? and RelativeType = '06' ";
		this.applyObjects = loadDB(conn, sql, paras1);
		
		//子额度的信息
		sql = "select SerialNo,ObjectType,ObjectNo,ClType,Currency,BusinessAppAmt,BusinessAvaAmt,BusinessAvaBalance,RevolvingFlag,MaturityDate,Status from CL_INFO where parentSerialNo in(select serialno from CL_INFO where ObjectType = ? and ObjectNo = ?) and CLType in('0101','0102','0103','0104','0107','0108') ";
		this.subObjects = this.loadDB(conn, sql, paras1);
		
		for(BusinessObject sub : subObjects)
		{
			String clType = sub.getString("ClType");
			String subMaturityDate = sub.getString("MaturityDate");
			String status = sub.getString("Status");
			if(clType != null)
			{
				com.amarsoft.dict.als.object.Item item = com.amarsoft.dict.als.cache.CodeCache.getItem("CLType", clType);
				String className = item.getItemDescribe();
				if(className != null)
				{
					Class c = Class.forName(className);
					com.amarsoft.app.als.cl.CreditLineObject clc = (com.amarsoft.app.als.cl.CreditLineObject)c.newInstance();
					clc.load(conn, sub.getString("ObjectType"), sub.getString("ObjectNo"));
					clc.calcBalance();
					sub.setAttributeValue("useBalance", clc.useBalance);
					sub.setAttributeValue("useSum", clc.useSum);
					clc.saveData(conn);
				}
				else
				{
					if("50".equals(status) 
							|| "60".equals(status))//已失效、已结清 按照余额控制
					{
						com.amarsoft.app.als.cl.CreditSingleObject clc = new com.amarsoft.app.als.cl.CreditSingleObject();
						clc.load(conn, sub.getString("ObjectType"), sub.getString("ObjectNo"));
						clc.calcBalance();
						sub.setAttributeValue("useBalance", clc.useBalance);
						sub.setAttributeValue("useSum", clc.useSum);
						clc.saveData(conn);
					}
					else
					{
						sub.setAttributeValue("useBalance", sub.getDouble("BusinessAppAmt") - sub.getDouble("BusinessAvaBalance"));
						sub.setAttributeValue("useSum", sub.getDouble("BusinessAppAmt") - sub.getDouble("BusinessAvaBalance"));
					}
				}
			}
			else
			{
				if("50".equals(status) 
						|| "60".equals(status))//已失效、已结清 按照余额控制
				{
					com.amarsoft.app.als.cl.CreditSingleObject clc = new com.amarsoft.app.als.cl.CreditSingleObject();
					clc.load(conn, sub.getString("ObjectType"), sub.getString("ObjectNo"));
					clc.calcBalance();
					sub.setAttributeValue("useBalance", clc.useBalance);
					sub.setAttributeValue("useSum", clc.useSum);
					clc.saveData(conn);
				}
				else
				{
					sub.setAttributeValue("useBalance", sub.getDouble("BusinessAppAmt") - sub.getDouble("BusinessAvaBalance"));
					sub.setAttributeValue("useSum", sub.getDouble("BusinessAppAmt") - sub.getDouble("BusinessAvaBalance"));
				}
			}
		}
	}
	
	/**
	 *@context 该Method用于计算小微额度使用授信金额余额
	 *@author xjzhao
	 *@throws Exception 
	 */
	public double calcBalance() throws Exception
	{
		String revolveFlag = this.CreditObject.getString("RevolveFlag");
		String currency = this.CreditObject.getString("BusinessCurrency");
		String contractStatus = this.CreditObject.getString("ContractStatus");
		double businessSum = DataConvert.toDouble(this.CreditObject.getString("BusinessSum"));
		String maturityDate = this.CreditObject.getString("MaturityDate");
		
		String clStatus = "",clMaturityDate="";
		
		for(BusinessObject split:splitObjects)
		{
			if("0101".equals(split.getString("CLType")))
			{
				businessSum = split.getDouble("BusinessAppAmt");
				clStatus = split.getString("Status");
				clMaturityDate = split.getString("MaturityDate");
			}
			else if("0105".equals(split.getString("CLType")))//消费额度
			{
				double businessAppAmt = split.getDouble("BusinessAppAmt");
				double balance = 0.0d;//贷款按余额算敞口金额
				double putoutSum = 0.0d;//贷款按发放金额算敞口金额
				double allPutOutSum = 0.0d;//总放款金额不包含保证金
				//扫描借据表内业务
				for(BusinessObject duebill:duebillObjects)
				{
					String businessType = duebill.getString("BusinessType");
					BusinessObject prd = ProductConfig.getProduct(businessType);
					if("01".equals(prd.getString("ProductType3")))//消费类贷款
					{
						balance += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*(duebill.getDouble("Balance"));
						putoutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*duebill.getDouble("BusinessSum");
						allPutOutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*duebill.getDouble("BusinessSum");
					}
				}
				
				//扫描出账信息
				for(BusinessObject put:putObjects)
				{
					String businessType = put.getString("BusinessType");
					BusinessObject prd = ProductConfig.getProduct(businessType);
					if("01".equals(prd.getString("ProductType3")))//消费类贷款
					{
						if("".equals(put.getString("PutOutStatus")) || "01".equals(put.getString("PutOutStatus")) || "02".equals(put.getString("PutOutStatus")) || "03".equals(put.getString("PutOutStatus"))) //申请中/监督通过
						{
							balance += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*put.getDouble("BusinessSum");
							putoutSum += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*put.getDouble("BusinessSum");
						}
					}
				}
				
				//扫描申请信息
				for(BusinessObject apply:applyObjects)
				{
					String businessType = apply.getString("BusinessType");
					BusinessObject prd = ProductConfig.getProduct(businessType);
					if("01".equals(prd.getString("ProductType3")))//消费类贷款
					{
						balance += ERateHelper.getERate(apply.getString("BusinessCurrency"), currency)*apply.getDouble("BusinessSum");
						putoutSum += ERateHelper.getERate(apply.getString("BusinessCurrency"), currency)*apply.getDouble("BusinessSum");
					}
				}
				
				//扫描项下额度
				for(BusinessObject sub:subObjects)
				{
					String subRevolvingFlag = sub.getString("RevolvingFlag");
					String subMaturityDate = sub.getString("MaturityDate");
					String status = sub.getString("Status");
					String clType = sub.getString("CLType");
					if("0102".equals(clType))
					{
						if("50".equals(status) 
							|| "60".equals(status))//已失效、已结清 按照余额控制
						{
							balance += sub.getDouble("useBalance");
							putoutSum += sub.getDouble("useSum");
						}
						else
						{
							balance += sub.getDouble("BusinessAppAmt");
							putoutSum += sub.getDouble("BusinessAppAmt");
						}
					}
				}
				
				if("1".equals(revolveFlag))
				{
					split.setAttributeValue("doSum", businessAppAmt-Math.max(0,balance));
					if(businessAppAmt-Math.max(0,balance) < 0)
					{
						this.RiskMessage.add("授信额度项下的消费额度可用余额（含本笔）："+DataConvert.toMoney(businessAppAmt-Math.max(0,balance))+"，已不足额！");
					}
				}
				else
				{
					split.setAttributeValue("doSum", businessAppAmt-Math.max(0,putoutSum));
					if(businessAppAmt-Math.max(0,putoutSum) < 0)
					{
						this.RiskMessage.add("授信额度项下的消费额度可用余额（含本笔）："+DataConvert.toMoney(businessAppAmt-Math.max(0,putoutSum))+"，已不足额！");
					}
				}
			}
			else if("0106".equals(split.getString("CLType")))
			{

				double businessAppAmt = split.getDouble("BusinessAppAmt");
				double balance = 0.0d;//贷款按余额算敞口金额
				double putoutSum = 0.0d;//贷款按发放金额算敞口金额
				double allPutOutSum = 0.0d;//总放款金额不包含保证金
				//扫描借据表内业务
				for(BusinessObject duebill:duebillObjects)
				{
					String businessType = duebill.getString("BusinessType");
					BusinessObject prd = ProductConfig.getProduct(businessType);
					if("02".equals(prd.getString("ProductType3")))//经营类贷款
					{
						balance += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*(duebill.getDouble("Balance"));
						putoutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*duebill.getDouble("BusinessSum");
						allPutOutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*duebill.getDouble("BusinessSum");
					}
				}
				
				//扫描出账信息
				for(BusinessObject put:putObjects)
				{
					String businessType = put.getString("BusinessType");
					BusinessObject prd = ProductConfig.getProduct(businessType);
					if("02".equals(prd.getString("ProductType3")))//经营类贷款
					{
						if("".equals(put.getString("PutOutStatus")) || "01".equals(put.getString("PutOutStatus")) || "02".equals(put.getString("PutOutStatus"))  || "03".equals(put.getString("PutOutStatus"))) //申请中/监督通过
						{
							balance += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*put.getDouble("BusinessSum");
							putoutSum += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*put.getDouble("BusinessSum");
						}
					}
				}
				
				//扫描申请信息
				for(BusinessObject apply:applyObjects)
				{
					String businessType = apply.getString("BusinessType");
					BusinessObject prd = ProductConfig.getProduct(businessType);
					if("02".equals(prd.getString("ProductType3")))//经营类贷款
					{
						balance += ERateHelper.getERate(apply.getString("BusinessCurrency"), currency)*apply.getDouble("BusinessSum");
						putoutSum += ERateHelper.getERate(apply.getString("BusinessCurrency"), currency)*apply.getDouble("BusinessSum");
					}
				}
				
				//扫描项下额度
				for(BusinessObject sub:subObjects)
				{
					String subRevolvingFlag = sub.getString("RevolvingFlag");
					String subMaturityDate = sub.getString("MaturityDate");
					String status = sub.getString("Status");
					String clType = sub.getString("CLType");
					if("0103".equals(clType) || "0104".equals(clType))
					{
						if("50".equals(status) 
							|| "60".equals(status))//已失效、已结清 按照余额控制
						{
							balance += sub.getDouble("useBalance");
							putoutSum += sub.getDouble("useSum");
						}
						else
						{
							balance += sub.getDouble("BusinessAppAmt");
							putoutSum += sub.getDouble("BusinessAppAmt");
						}
					}
				}
				
				if("1".equals(revolveFlag))
				{
					split.setAttributeValue("doSum", businessAppAmt-Math.max(0,balance));
					if(businessAppAmt-Math.max(0,balance) < 0)
					{
						this.RiskMessage.add("授信额度项下的经营额度可用余额（含本笔）："+DataConvert.toMoney(businessAppAmt-Math.max(0,balance))+"，已不足额！");
					}
				}
				else
				{
					split.setAttributeValue("doSum", businessAppAmt-Math.max(0,putoutSum));
					if(businessAppAmt-Math.max(0,putoutSum) < 0)
					{
						this.RiskMessage.add("授信额度项下的经营额度可用余额（含本笔）："+DataConvert.toMoney(businessAppAmt-Math.max(0,putoutSum))+"，已不足额！");
					}
				}
			}
		}
		
		double balance = 0.0d;//贷款按余额算敞口金额
		double putoutSum = 0.0d;//贷款按发放金额算敞口金额
		double allPutOutSum = 0.0d;//总放款金额不包含保证金
		//扫描借据表内业务
		for(BusinessObject duebill:duebillObjects)
		{
			balance += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*(duebill.getDouble("Balance"));
			putoutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*duebill.getDouble("BusinessSum");
			allPutOutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*duebill.getDouble("BusinessSum");
		}
		
		//扫描出账信息
		for(BusinessObject put:putObjects)
		{
			if("".equals(put.getString("PutOutStatus")) || "01".equals(put.getString("PutOutStatus")) || "02".equals(put.getString("PutOutStatus"))  || "03".equals(put.getString("PutOutStatus"))) //申请中/监督通过
			{
				balance += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*put.getDouble("BusinessSum");
				putoutSum += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*put.getDouble("BusinessSum");
			}
		}
		
		//扫描申请信息
		for(BusinessObject apply:applyObjects)
		{
			balance += ERateHelper.getERate(apply.getString("BusinessCurrency"), currency)*apply.getDouble("BusinessSum");
			putoutSum += ERateHelper.getERate(apply.getString("BusinessCurrency"), currency)*apply.getDouble("BusinessSum");
		}
		
		//扫描项下额度
		for(BusinessObject sub:subObjects)
		{
			String subRevolvingFlag = sub.getString("RevolvingFlag");
			String subMaturityDate = sub.getString("MaturityDate");
			String status = sub.getString("Status");
			
			if("50".equals(status) 
				|| "60".equals(status))//已失效、已结清 按照余额控制
			{
				balance += sub.getDouble("useBalance");
				putoutSum += sub.getDouble("useSum");
			}
			else
			{
				balance += sub.getDouble("BusinessAppAmt");
				putoutSum += sub.getDouble("BusinessAppAmt");
			}
		}
		
		
		this.useBalance = Math.max(0,balance);
		this.useSum = Math.max(0,putoutSum);
		
		if("1".equals(revolveFlag))
		{
			this.doSum = businessSum-this.useBalance;
		}
		else
		{
			this.doSum = businessSum-this.useSum;
		}
		
		//授信额度合同状态校验
		if(!"03".equals(contractStatus))
		{
			this.RiskMessage.add("授信额度合同状态为【"+CodeCache.getItemName("BusinessContractStatus", contractStatus)+"】，不能使用！");
			this.doSum = 0d;
			for(BusinessObject split:splitObjects)
			{
				split.setAttributeValue("doSum", 0d);
			}
		}
		
		//授信额度状态校验
		if(!"20".equals(clStatus))
		{
			this.RiskMessage.add("授信额度状态为【"+CodeCache.getItemName("CLStatus", clStatus)+"】，不能使用！");
			this.doSum = 0d;
			for(BusinessObject split:splitObjects)
			{
				split.setAttributeValue("doSum", 0d);
			}
		}
		
		if(maturityDate != null && !"".equals(maturityDate) && DateHelper.getBusinessDate().compareTo(maturityDate) > 0
				|| clMaturityDate != null && !"".equals(clMaturityDate) && DateHelper.getBusinessDate().compareTo(clMaturityDate) > 0)
		{
			this.RiskMessage.add("额度已到期，不能再发起业务。");
			this.doSum = 0d;
			for(BusinessObject split:splitObjects)
			{
				split.setAttributeValue("doSum", 0d);
			}
		}
		
		//授信额度余额校验
		if(this.doSum < 0)
		{
			this.RiskMessage.add("授信额度的可用余额（含本笔）："+DataConvert.toMoney(doSum)+"，已不足额！");
		}
		else
		{
			this.AlarmMessage.add("授信额度额度可用余额（含本笔）："+DataConvert.toMoney(doSum));
		}
		
		
		return this.doSum;
	}
	
	
	/**
	 *@context 保存计算结果 该方法必须必须依赖calcBalance()，不可单独使用
	 *@author xjzhao
	 *@throws Exception 
	 */
	public void saveData(Connection conn) throws Exception{
		String sql = "update CL_INFO set BUSINESSAVABALANCE = ? where ObjectType = ? and ObjectNo = ? and CLType = ? ";
		PreparedStatement ps = null;
		try
		{
			ps = conn.prepareStatement(sql);
			ps.setDouble(1, Math.max(0, this.doSum));
			ps.setString(2, "jbo.app.BUSINESS_CONTRACT");
			ps.setString(3, this.CreditObject.getString("SerialNo"));
			ps.setString(4, "0101");
			ps.execute();
			
			for(BusinessObject split:splitObjects)
			{
				if("0105".equals(split.getString("CLType")) || "0106".equals(split.getString("CLType")))
				{
					ps.setDouble(1, Math.max(0, split.getDouble("doSum")));
					ps.setString(2, "jbo.app.BUSINESS_CONTRACT");
					ps.setString(3, this.CreditObject.getString("SerialNo"));
					ps.setString(4, split.getString("CLType"));
					ps.execute();
				}
			}
			
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
