package com.amarsoft.app.als.cl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObject;

/**
 * Class <code>CreditObject</code>�����Ŷ���Ļ�����. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 * @version 1.1, 20150401
 */

public abstract class CreditObject {
	/**
	 * ���ڱ������Ŷ���ؼ���Ϣ��BC��BA��
	 */
	public BusinessObject CreditObject = null;
	/**
	 * ���ڱ���ǿ�ƿ�����Ϣ
	 */
	public List<String> RiskMessage = new ArrayList<String>();
	/**
	 * ���ڱ�����ʾ������Ϣ
	 */
	public List<String> AlarmMessage = new ArrayList<String>();

	/**
	 *@param Connection ���ݿ��������ڼ�������������� 
	 *@param ObjectType ���ض�������
	 *@param ObjectNo ���ض�����
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public abstract void load(Connection conn,String ObjectType,String ObjectNo) throws SQLException,Exception;
	
	/**
	 *@param ASValuePool ͨ���ⲿ���벻ͨ�����ݿ����ӳ�ʼ��
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public abstract void load(BusinessObject creditObject) throws SQLException,Exception;
	
	/**
	 *@context ��Method���ڼ�������ʹ�����Ž���������
	 *@author xjzhao
	 *@throws Exception 
	 */
	public abstract double calcBalance() throws Exception;
	
	/**
	 *@context context ��������� �÷��������������calcBalance()�����ɵ���ʹ��
	 *@author xjzhao
	 *@throws Exception 
	 */
	public abstract void saveData(Connection conn) throws Exception;
	
	/**
	 * 
	 */
	
	protected List<BusinessObject> loadDB(Connection conn,String sql,String[] paras) throws Exception{
		
		List<BusinessObject> results = new ArrayList<BusinessObject>();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try
		{
			ps = conn.prepareStatement(sql);
			for(int i = 0 ; i < paras.length ; i ++)
			{
				ps.setString(i+1, paras[i]);
			}
			
			rs = ps.executeQuery();
			
			while(rs.next())
			{	
				Map<String,Object> mp = new HashMap<String, Object>();
				for(int i=1;i<rs.getMetaData().getColumnCount();i++){
					mp.put(rs.getMetaData().getColumnName(i),rs.getObject(i));
				}
				results.add(BusinessObject.createBusinessObject(mp));
			}
		}
		finally
		{
			try
			{
				if(rs != null) rs.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			
			try
			{
				if(ps != null) ps.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
		
		return results;
	}
	
}
