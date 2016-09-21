package com.amarsoft.app.als.cl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * Class <code>CreditLineCopartner</code>�Ǻ�����Ŀ��ģ��ȵĻ�����. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 */

public class CreditLineCopartner extends CreditLineObject {

	/**
	 * ���浥������ҵ���Ӧ�ĺ�ͬ��Ϣ
	 */
	protected List<BusinessObject> putObjects=null;
	/**
	 * ���浥������ҵ���Ӧ�Ľ����Ϣ
	 */
	protected List<BusinessObject> duebillObjects=null;
	/**
	 * ���浥������ҵ���Ӧ��������Ϣ
	 */
	protected List<BusinessObject> applyObjects=null;
	/**
	 *@param Connection ���ݿ��������ڼ�������ҵ��������� 
	 *@param SerialNo ��ʾͨ�������ż�����������ҵ�����
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public void load(Connection conn,String objectType,String objectNo) throws SQLException,Exception
	{
		String[] paras = new String[]{objectType,objectNo};
		
		//����������
		String sql = "select SerialNo,ObjectType,ObjectNo,CLType,DivideType,Currency,BusinessAppAmt,BusinessAvaAmt,BusinessAvaBalance,RevolvingFlag,MaturityDate,Status,OrgID,BusinessType from CL_INFO where ObjectType = ? and ObjectNo = ? and (ParentSerialNo is null or ParentSerialNo='')";
		List<BusinessObject> coList = this.loadDB(conn, sql, paras);
		
		if(coList != null  && !coList.isEmpty())
		{
			this.CreditObject = coList.get(0);
			//���ض��ʹ�ö���
			paras = new String[]{CreditObject.getString("SerialNo")};
			sql = "select SerialNo,ObjectType,ObjectNo,CLType,Currency,BusinessAppAmt,BusinessAvaAmt,BusinessAvaBalance,RevolvingFlag,MaturityDate,Status,OrgID,BusinessType from CL_INFO where ParentSerialNo = ? ";
			this.splitObjects = this.loadDB(conn, sql, paras);
			
			//����������Ϣ
			paras = new String[]{"jbo.app.BUSINESS_APPLY",objectNo};
			sql = " select sum(case when BA.ApproveStatus in('01','02') and BA.OccurType = '0010' then nvl((select BusinessSum from BUSINESS_APPROVE where SerialNo in (select max(SerialNo) from BUSINESS_APPROVE where ApplySerialNo = BA.SerialNo)),nvl(BA.BusinessSum,0)) else 0 end) as BusinessSum,AccountingOrgID,BusinessType from BUSINESS_APPLY BA,PRJ_RELATIVE PR where BA.SerialNo = PR.ObjectNo and PR.ObjectType = ? and PR.ProjectSerialNo = ? and RelativeType = '01' group by AccountingOrgID,BusinessType ";
			this.applyObjects = loadDB(conn, sql, paras);
			
			//���غ�ͬ��Ϣ
			paras = new String[]{"jbo.app.BUSINESS_CONTRACT",objectNo};
			sql = " select AccountingOrgID,BusinessType,sum(BusinessSum) as BusinessSum from BUSINESS_PUTOUT BP,PRJ_RELATIVE PR where BP.ContractSerialNo = PR.ObjectNo and PR.ObjectType = ? and PR.ProjectSerialNo = ? and RelativeType = '02' and BP.PutOutStatus IN('01','02','03') group by BusinessType,AccountingOrgID";
			this.putObjects = loadDB(conn, sql, paras);
			
			//���ؽ��
			sql = " select MFOrgID as AccountingOrgID,BusinessType,sum(BusinessSum) as BusinessSum,sum(Balance) as Balance from BUSINESS_DUEBILL BP,PRJ_RELATIVE PR where BP.ContractSerialNo = PR.ObjectNo and PR.ObjectType = ? and PR.ProjectSerialNo = ? and RelativeType = '02' and Balance > 0 group by BusinessType,MFOrgID ";
			this.duebillObjects = loadDB(conn, sql, paras);
		}
	}
	
	/**
	 *@context �÷������ڼ�����������ʹ�����Ž���������
	 *@author xjzhao
	 *@throws Exception 
	 */
	public double calcBalance() throws Exception
	{
		if(this.CreditObject == null) return 0d;
		
		String divideType = this.CreditObject.getString("DivideType");
		String RevolvingFlag = this.CreditObject.getString("RevolvingFlag");
		String maturityDate = this.CreditObject.getString("MaturityDate");
		String clStatus = this.CreditObject.getString("Status");
		
		if(!"00".equals(divideType))
		{
			for(BusinessObject split:splitObjects)
			{
				double splitUseSum = 0.0d;
				double splitUseBalance = 0.0d;
				
				
				for(BusinessObject apply:applyObjects)
				{
					if("10".equals(divideType) && split.getString("BusinessType").equals(apply.getString("BusinessType")))
					{
						splitUseSum += apply.getDouble("BusinessSum");
						splitUseBalance += apply.getDouble("BusinessSum");
					}
					else if("20".equals(divideType) && split.getString("OrgID").equals(apply.getString("AccountingOrgID")))
					{
						splitUseSum += apply.getDouble("BusinessSum");
						splitUseBalance += apply.getDouble("BusinessSum");
					}
				}
				
				
				for(BusinessObject put:putObjects)
				{
					if("10".equals(divideType) && split.getString("BusinessType").equals(put.getString("BusinessType")))
					{
						splitUseSum += put.getDouble("BusinessSum");
						splitUseBalance += put.getDouble("BusinessSum");
					}
					else if("20".equals(divideType) && split.getString("OrgID").equals(put.getString("AccountingOrgID")))
					{
						splitUseSum += put.getDouble("BusinessSum");
						splitUseBalance += put.getDouble("BusinessSum");
					}
				}
				
				for(BusinessObject duebill:duebillObjects)
				{
					if("10".equals(divideType) && split.getString("BusinessType").equals(duebill.getString("BusinessType")))
					{
						splitUseSum += duebill.getDouble("BusinessSum");
						splitUseBalance += duebill.getDouble("Balance");
					}
					else if("20".equals(divideType) && split.getString("OrgID").equals(duebill.getString("AccountingOrgID")))
					{
						splitUseSum += duebill.getDouble("BusinessSum");
						splitUseBalance += duebill.getDouble("Balance");
					}
				}
				
				
				if("1".equals(RevolvingFlag))
				{
					double splitDoSum = split.getDouble("BUSINESSAPPAMT") - splitUseBalance;
					if(split.getDouble("BUSINESSAPPAMT") < splitUseBalance)
					{
						this.RiskMessage.add("��Ŀ��ģ��ȵġ�"+("10".equals(divideType) ? NameManager.getBusinessName(split.getString("BusinessType")) : split.getString("OrgID"))+"�������������ʣ���"+DataConvert.toMoney(splitDoSum)+"���Ѳ���");
					}
					else
					{
						this.AlarmMessage.add("��Ŀ��ģ��ȵġ�"+("10".equals(divideType) ? NameManager.getBusinessName(split.getString("BusinessType")) : split.getString("OrgID"))+"��������"+DataConvert.toMoney(splitDoSum));
					}
				}else{
					double splitDoSum = split.getDouble("BUSINESSAPPAMT") - splitUseSum;
					if(split.getDouble("BUSINESSAPPAMT") < splitUseSum)
					{
						this.RiskMessage.add("��Ŀ��ģ��ȵġ�"+("10".equals(divideType) ? NameManager.getBusinessName(split.getString("BusinessType")) : split.getString("OrgID"))+"�������������ʣ���"+DataConvert.toMoney(splitDoSum)+"���Ѳ���");
					}
					else
					{
						this.AlarmMessage.add("��Ŀ��ģ��ȵġ�"+("10".equals(divideType) ? NameManager.getBusinessName(split.getString("BusinessType")) : split.getString("OrgID"))+"��������"+DataConvert.toMoney(splitDoSum));
					}
				}
			}
		}
		
		for(BusinessObject apply:applyObjects)
		{
			this.useSum += apply.getDouble("BusinessSum");
			this.useBalance += apply.getDouble("BusinessSum");
		}
		
		
		for(BusinessObject put:putObjects)
		{
			this.useSum += put.getDouble("BusinessSum");
			this.useBalance += put.getDouble("BusinessSum");
		}
		
		for(BusinessObject duebill:duebillObjects)
		{
			this.useSum += duebill.getDouble("BusinessSum");
			this.useBalance += duebill.getDouble("Balance");
		}
		
		
		if("1".equals(RevolvingFlag))
		{
			this.doSum = this.CreditObject.getDouble("BUSINESSAPPAMT")-this.useBalance;
		}
		else
		{
			this.doSum = this.CreditObject.getDouble("BUSINESSAPPAMT")-this.useSum;
		}

		//���Ŷ��״̬У��
		if(!"20".equals(clStatus))
		{
			this.RiskMessage.add("���Ŷ��״̬Ϊ��"+CodeCache.getItemName("CLStatus", clStatus)+"��������ʹ�ã�");
			//this.doSum = 0d;
		}
		
		if(maturityDate != null && !"".equals(maturityDate) && DateHelper.getBusinessDate().compareTo(maturityDate) > 0)
		{
			this.RiskMessage.add("����ѵ��ڣ������ٷ���ҵ��");
			this.doSum = 0d;
		}
		
		//���Ŷ�����У��
		if(this.doSum < 0)
		{
			this.RiskMessage.add("��Ŀ��ģ��ȵĿ����������ʣ���"+DataConvert.toMoney(doSum)+"���Ѳ���");
		}
		else
		{
			this.AlarmMessage.add("��Ŀ��ģ��ȿ�����"+DataConvert.toMoney(doSum));
		}
		
		return this.doSum;
	}
	
	/**
	 *@context ��������� �÷��������������calcBalance()�����ɵ���ʹ��
	 *@author xjzhao
	 *@throws Exception 
	 */
	public void saveData(Connection conn) throws Exception{
		
		if(this.CreditObject == null) return ;
		String sql = "update CL_INFO set BUSINESSAVABALANCE = ? where SerialNo = ? ";
		PreparedStatement ps = null;
		try
		{
			ps = conn.prepareStatement(sql);
			ps.setDouble(1, this.doSum);
			ps.setString(2, this.CreditObject.getString("SerialNo"));
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
