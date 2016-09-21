package com.amarsoft.app.als.cl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.dict.als.cache.CodeCache;
import com.amarsoft.dict.als.manage.NameManager;

/**
 * Class <code>CreditLineCopartner</code>�Ǻ�����Ŀ������ȵĻ�����. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 */

public class CreditLineCopartner2 extends CreditLineObject {

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
		String[] paras = new String[]{objectNo};
		
		//����������
		String sql = "select SerialNo,ObjectType,ObjectNo,CLType,DivideType,Currency,BusinessAppAmt,BusinessAvaAmt,BusinessAvaBalance,RevolvingFlag,MaturityDate,Status,OrgID,BusinessType from CL_INFO where (ObjectType,ObjectNo) in(select ObjectType,ObjectNo from PRJ_RELATIVE PR where PR.ProjectSerialNo = ? and PR.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT') and (ParentSerialNo is null or ParentSerialNo='')";
		List<BusinessObject> coList = this.loadDB(conn, sql, paras);
		
		if(coList != null  && !coList.isEmpty())
		{
			this.CreditObject = coList.get(0);
			//���ض��ʹ�ö���
			paras = new String[]{CreditObject.getString("SerialNo")};
			sql = "select SerialNo,ObjectType,ObjectNo,CLType,Currency,BusinessAppAmt,BusinessAvaAmt,BusinessAvaBalance,RevolvingFlag,MaturityDate,Status,OrgID,BusinessType from CL_INFO where ParentSerialNo = ? ";
			this.splitObjects = this.loadDB(conn, sql, paras);
			
			//����������Ϣ
			paras = new String[]{objectNo};
			sql = "select sum(case when BA.ApproveStatus in('01','02') and BA.OccurType = '0010' then GC.GuarantyValue else 0 end) as BusinessSum,BA.AccountingOrgID,BA.BusinessType from BUSINESS_APPLY BA,APPLY_RELATIVE AR,GUARANTY_CONTRACT GC where BA.SerialNo = AR.ApplySerialNo and AR.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT' and AR.ObjectNo = GC.SerialNo and AR.RelativeType = '05' and GC.ProjectSerialNo= ?  and GC.ContractStatus in('01','02') group by BA.AccountingOrgID,BA.BusinessType ";
			this.applyObjects = loadDB(conn, sql, paras);
			
			//���غ�ͬ��Ϣ
			sql = " select AccountingOrgID,BusinessType,sum(GC.GuarantyValue) as BusinessSum from BUSINESS_PUTOUT BP,CONTRACT_RELATIVE CR,GUARANTY_CONTRACT GC where BP.ContractSerialNo = CR.ContractSerialNo and CR.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT' and CR.ObjectNo = GC.SerialNo and CR.RelativeType = '05' and GC.ProjectSerialNo= ?  and GC.ContractStatus in('01','02') and BP.PutOutStatus IN('01','02','03') group by BP.BusinessType,BP.AccountingOrgID";
			this.putObjects = loadDB(conn, sql, paras);
			
			//���ؽ��
			sql = " select MFOrgID as AccountingOrgID,BusinessType,sum(GC.GuarantyValue) as BusinessSum from BUSINESS_DUEBILL BD,CONTRACT_RELATIVE CR,GUARANTY_CONTRACT GC where BD.ContractSerialNo = CR.ContractSerialNo and CR.ObjectType = 'jbo.guaranty.GUARANTY_CONTRACT' and CR.ObjectNo = GC.SerialNo and CR.RelativeType = '05' and GC.ProjectSerialNo= ?  and GC.ContractStatus in('01','02') and BD.Balance > 0 group by BD.BusinessType,BD.MFOrgID";
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
		
		String DivideType = this.CreditObject.getString("DivideType");
		String RevolvingFlag = this.CreditObject.getString("RevolvingFlag");
		String maturityDate = this.CreditObject.getString("MaturityDate");
		String clStatus = this.CreditObject.getString("Status");
		
		if(!"00".equals(DivideType))
		{
			for(BusinessObject split:splitObjects)
			{
				double splitUseSum = 0.0d;
				double splitUseBalance = 0.0d;
				
				
				for(BusinessObject apply:applyObjects)
				{
					if("10".equals(DivideType) && split.getString("BusinessType").equals(apply.getString("BusinessType")))
					{
						splitUseSum += apply.getDouble("BusinessSum");
						splitUseBalance += apply.getDouble("BusinessSum");
					}
					else if("20".equals(DivideType) && split.getString("OrgID").equals(apply.getString("AccountingOrgID")))
					{
						splitUseSum += apply.getDouble("BusinessSum");
						splitUseBalance += apply.getDouble("BusinessSum");
					}
				}
				
				
				for(BusinessObject put:putObjects)
				{
					if("10".equals(DivideType) && split.getString("BusinessType").equals(put.getString("BusinessType")))
					{
						splitUseSum += put.getDouble("BusinessSum");
						splitUseBalance += put.getDouble("BusinessSum");
					}
					else if("20".equals(DivideType) && split.getString("OrgID").equals(put.getString("AccountingOrgID")))
					{
						splitUseSum += put.getDouble("BusinessSum");
						splitUseBalance += put.getDouble("BusinessSum");
					}
				}
				
				for(BusinessObject duebill:duebillObjects)
				{
					if("10".equals(DivideType) && split.getString("BusinessType").equals(duebill.getString("BusinessType")))
					{
						splitUseSum += duebill.getDouble("BusinessSum");
						splitUseBalance += duebill.getDouble("BusinessSum");
					}
					else if("20".equals(DivideType) && split.getString("OrgID").equals(duebill.getString("AccountingOrgID")))
					{
						splitUseSum += duebill.getDouble("BusinessSum");
						splitUseBalance += duebill.getDouble("BusinessSum");
					}
				}
				
				if("1".equals(RevolvingFlag))
				{
					double splitDoSum = split.getDouble("BUSINESSAPPAMT") - splitUseBalance;
					if(split.getDouble("BUSINESSAPPAMT") < splitUseBalance)
					{
						this.RiskMessage.add("������ȵġ�"+("10".equals(DivideType) ? NameManager.getBusinessName(split.getString("BusinessType")) : split.getString("OrgID"))+"�������������ʣ���"+DataConvert.toMoney(splitDoSum)+"���Ѳ���");
					}
					else
					{
						this.AlarmMessage.add("������ȵġ�"+("10".equals(DivideType) ? NameManager.getBusinessName(split.getString("BusinessType")) : split.getString("OrgID"))+"��������"+DataConvert.toMoney(splitDoSum));
					}
				}else{
					double splitDoSum = split.getDouble("BUSINESSAPPAMT") - splitUseSum;
					if(split.getDouble("BUSINESSAPPAMT") < splitUseSum)
					{
						this.RiskMessage.add("������ȵġ�"+("10".equals(DivideType) ? NameManager.getBusinessName(split.getString("BusinessType")) : split.getString("OrgID"))+"�������������ʣ���"+DataConvert.toMoney(splitDoSum)+"���Ѳ���");
					}
					else
					{
						this.AlarmMessage.add("������ȵġ�"+("10".equals(DivideType) ? NameManager.getBusinessName(split.getString("BusinessType")) : split.getString("OrgID"))+"��������"+DataConvert.toMoney(splitDoSum));
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
			this.RiskMessage.add("������ȵĿ����������ʣ���"+DataConvert.toMoney(doSum)+"���Ѳ���");
		}
		else
		{
			this.AlarmMessage.add("������ȿ�����"+DataConvert.toMoney(doSum));
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
