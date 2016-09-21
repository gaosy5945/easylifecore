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
 * Class <code>CreditObject</code>是授信对象的基础类. 
 *
 * @author  xjzhao
 * @version 1.0, 20120406
 * @version 1.1, 20150401
 */

public abstract class CreditObject {
	/**
	 * 用于保存授信对象关键信息（BC、BA）
	 */
	public BusinessObject CreditObject = null;
	/**
	 * 用于保存强制控制信息
	 */
	public List<String> RiskMessage = new ArrayList<String>();
	/**
	 * 用于保存提示控制信息
	 */
	public List<String> AlarmMessage = new ArrayList<String>();

	/**
	 *@param Connection 数据库连接用于加载授信相关数据 
	 *@param ObjectType 加载对象类型
	 *@param ObjectNo 加载对象编号
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public abstract void load(Connection conn,String ObjectType,String ObjectNo) throws SQLException,Exception;
	
	/**
	 *@param ASValuePool 通过外部传入不通过数据库连接初始化
	 *@author xjzhao
	 *@throws SQLException,Exception
	 */
	public abstract void load(BusinessObject creditObject) throws SQLException,Exception;
	
	/**
	 *@context 该Method用于计算授信使用授信金额相关数据
	 *@author xjzhao
	 *@throws Exception 
	 */
	public abstract double calcBalance() throws Exception;
	
	/**
	 *@context context 保存计算结果 该方法必须必须依赖calcBalance()，不可单独使用
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
