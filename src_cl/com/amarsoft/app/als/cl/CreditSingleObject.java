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
 * Class <code>CreditSingleObject</code>�ǵ������ţ������������ҵ�񣩵Ļ�����. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 */

public class CreditSingleObject extends CreditObject {
	/**
	 * ���浥������ҵ���Ӧ�ĳ�����Ϣ
	 */
	protected List<BusinessObject> putObjects=null;
	/**
	 * ���浥������ҵ���Ӧ�Ľ����Ϣ
	 */
	protected List<BusinessObject> duebillObjects=null;
	
	/**
	 * ���浥������ҵ���Ӧ�ĵ�����Ϣ
	 */
	protected List<BusinessObject> guarantyObjects=null;

	/**
	 * ���������Ŵ�����ý��
	 */
	protected double doSum = 0.0d;
	/**
	 * ���浥�����Ŵ������ռ���ϲ������
	 */
	protected double useBalance = 0.0d;
	/**
	 * ���浥�����Ŵ�����ռ���ϲ��Ƚ��
	 */
	protected double useSum = 0.0d;
	
	/**
	 *@param BusinessObject ͨ���ⲿ���벻ͨ�����ݿ����ӳ�ʼ��
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(BusinessObject creditObject) throws SQLException,Exception{
		this.CreditObject = creditObject;
	}
	

	/**
	 *@param Connection ���ݿ��������ڼ�������ҵ��������� 
	 *@param SerialNo ��ʾͨ�������ż�����������ҵ�����
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(Connection conn,String ObjectType,String ObjectNo) throws SQLException,Exception
	{
		String[] paras = new String[]{ObjectNo};
		//����������
		String sql = "select SerialNo,RevolveFlag,BusinessSum,BusinessCurrency,ContractStatus,NVL((select MaturityDate from CL_INFO where ObjectType = 'jbo.app.BUSINESS_CONTRACT' and ObjectNo = BUSINESS_CONTRACT.SerialNo and CLType in('0101','0102','0103','0104','0107','0108') and rownum = 1),MaturityDate) as MaturityDate from BUSINESS_CONTRACT where SerialNo = ? ";
		this.CreditObject = loadDB(conn, sql, paras).get(0);
		//���س�����Ϣ
		sql = "select SerialNo as PutOutNo,BusinessSum,BusinessCurrency,PutOutStatus from BUSINESS_PUTOUT where ContractSerialNo = ? ";
		this.putObjects = loadDB(conn, sql, paras);
		//���ش�����Ϣ
		sql = "select BusinessSum,Currency as BusinessCurrency,nvl((SELECT sum(nvl(DebitBalance,0.0)-nvl(CreditBalance,0.0)) from ACCT_SUBSIDIARY_LEDGER where relativeObjectNo = ACCT_LOAN.SerialNo and RelativeObjectType = 'jbo.acct.ACCT_LOAN' and AccountCodeNo in('Customer01','Customer02')),0.0) as Balance from ACCT_LOAN where ContractSerialNo = ? ";
		this.duebillObjects = loadDB(conn, sql, paras);
		
	}
	
	/**
	 *@param BusinessObject ͨ���ⲿ���벻ͨ�����ݿ����ӳ�ʼ��
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
	 *@context ��Method���ڼ�����������ʵ�ʷ��Ž�������ʵ�ʷ��Ž�������ֶ�
	 *@author xjzhao
	 *@throws Exception 
	 */
	public double calcBalance() throws Exception{
		
		String revolveFlag = this.CreditObject.getString("RevolveFlag");//��ͬ�Ƿ�ѭ��
		double businessSum = DataConvert.toDouble(this.CreditObject.getString("BusinessSum"));//��ͬ���
		String currency = this.CreditObject.getString("BusinessCurrency");//��ͬ����
		String contractStatus = this.CreditObject.getString("ContractStatus");
		String maturityDate = this.CreditObject.getString("MaturityDate");
		
		double balance = 0.0d;//�������㳨�ڽ��
		double putoutSum = 0.0d;//������Ž���㳨�ڽ��
		double allPutOutSum = 0.0d;//�ܷſ��������֤��
		//ɨ���ݱ���ҵ��
		for(BusinessObject duebill:duebillObjects)
		{
			balance += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*(DataConvert.toDouble(duebill.getString("Balance")));
			putoutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*DataConvert.toDouble(duebill.getString("BusinessSum"));
			allPutOutSum += ERateHelper.getERate(duebill.getString("BusinessCurrency"), currency)*DataConvert.toDouble(duebill.getString("BusinessSum"));
		}
		
		//ɨ�������Ϣ
		for(BusinessObject put:putObjects)
		{
			if("".equals(put.getString("PutOutStatus")) || "01".equals(put.getString("PutOutStatus")) || "02".equals(put.getString("PutOutStatus")) || "03".equals(put.getString("PutOutStatus"))) //������/�ලͨ��
			{
				balance += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*DataConvert.toDouble(put.getString("BusinessSum"));
				putoutSum += ERateHelper.getERate(put.getString("BusinessCurrency"), currency)*DataConvert.toDouble(put.getString("BusinessSum"));
			}
		}
		
		
		//ѭ����ȹ�ʽ ���ý��=��ͬ�ܽ��-������-�������ܽ��
		if("1".equals(revolveFlag))
		{
			this.doSum = businessSum - balance;
		}
		else//��ѭ����ȹ�ʽ  ���ý��=��ͬ�ܽ��-�ѷ��Ž�ݽ��-�������ܽ��
		{
			this.doSum = businessSum - putoutSum;
		}
		
		this.useBalance = Math.max(0,balance);
		this.useSum = Math.max(0,putoutSum);
		
		if("04".equals(contractStatus) || "05".equals(contractStatus))
		{
			this.RiskMessage.add("��ͬ״̬Ϊ��"+CodeCache.getItemName("BusinessContractStatus", contractStatus)+"�����ܷ���ҵ��");
			this.doSum = 0d;
		}
		
		if(maturityDate != null && !"".equals(maturityDate) && 	DateHelper.getBusinessDate().compareTo(maturityDate) > 0)
		{
			this.RiskMessage.add("��ͬ�ѵ��ڣ������ٷ���ҵ��");
			this.doSum = 0d;
		}
		
		//��ͬ���������У��
		if(this.doSum < 0)
		{
			this.RiskMessage.add("��ͬ�ɳ��˽�������ͬ�����ʼ������ڣ�Ϊ��"+DataConvert.toMoney(doSum));
		}
		else
		{
			this.AlarmMessage.add("��ͬ���ý������ʣ�Ϊ��"+DataConvert.toMoney(doSum));
		}
		
		return this.doSum;
	}
	
	/**
	 *@context ��������� �÷��������������calcBalance()�����ɵ���ʹ��
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
