/**
 * Class <code>BusinessObjectKeyFactory</code> �Ƕ�����������ˮ��������
 *
 * @author  ygwang xjzhao
 * @version 1.0, 13/03/13
 * @see com.amarsoft.are.jbo.JBOException
 * @see com.amarsoft.are.jbo.JBOFactory
 * @see com.amarsoft.are.jbo.JBOTransaction
 * @see com.amarsoft.are.jbo.impl.ALSBizObjectManager
 * @see com.amarsoft.app.base.businessobject.BusinessObject
 * @since   JDK1.6
 */

package com.amarsoft.app.base.businessobject;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.HashMap;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.JBOClassNotFoundException;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.impl.ALSBizObjectManager;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.lang.StringX;

public class BusinessObjectKeyFactory{
	
	/**
	 * �������ݿ����ˮ����أ�
	 *  ���÷������ݿ������ˮ������
	 *  	key=����+�ֶ���+���ڸ�ʽ+��ֵ��ˮ��ʽ
	 *      value=[��ˮ��ʼֵ,��ˮ��ֵֹ]
	 * ��������壺
	 * 1��ÿ�ΰ����λ�ȡ��ˮ����ȡ��ˮ���κ���뻺������У�������ʹ��ʱֱ�Ӵӻ����ȡ���������ݿ���Ӧ��֮��Ľ����ӿ�Ч��
	 * 2��ͨ��java��ͬ�������ڻ�ȡ������ˮʱ�����߳�֮�䲻����ֻ�ȡ��ͬһ��ˮ�����
	 * 3��ͨ�����ݿ�������ݲ���ͬ�����ƣ��ڶ���������Ҳ������ڻ�ȡ��ͬһ��ˮ�����
	 */
	private static HashMap<String,String[]> serialNoPool = new HashMap<String,String[]>();
	
	public static BusinessObjectKeyFactory getFactory(BizObjectClass bizObjectClass) throws InstantiationException, IllegalAccessException, JBOException, ClassNotFoundException{
		try {
			JBOFactory.getBizObjectClass(bizObjectClass.getRoot().getAbsoluteName());
			String keyFactoryClassName=BusinessObjectHelper.getBizClassProperty(bizObjectClass, "KeyGenerator");
			if(StringX.isEmpty(keyFactoryClassName)){
				return BusinessObjectKeyFactory.class.newInstance();
			}
			else{
				Class<?> keyFactoryClass = Class.forName(keyFactoryClassName);
				return (BusinessObjectKeyFactory)keyFactoryClass.newInstance();
			}
		} catch (JBOClassNotFoundException e) {
			return BusinessObjectKeyFactory.class.newInstance();
		}
		
	}
	
	/**
	 * ���ɶ�����ˮ���ֶ�
	 * 	����JBO�����ļ��ж������ֶθ����������ֶθ�������1��������ˮ��Ϣ��������������ļ��Ͳ�����������ˮ������Ҳ���ԡ�
	 *  ��ˮ�Ĵ������÷���<tt>getSerialNo</tt>��������õ�����Ϊϵͳ�������ڣ�����SYSTEM_SETUP.BUSINESSDATEֵ�����ڲ���ϵͳ����
	 *  ��������ǰ������������ʱ��Ҫע�⣬���������ˮ��ͻ����
	 *  ͨ��JBO�����ļ��в���query.InitNumֵ��ָ��ÿ�λ�ȡ��ˮ�������뻺�浱�У���������ˮʹ������ٴ����ݿ��л�ȡ
	 * @param businessObject
	 * @throws Exception
	 */
	public static String getBizObjectKey(BizObjectClass bizObjectClass) throws JBOException{
		String jboClassName = bizObjectClass.getRoot().getAbsoluteName();
		if(jboClassName.equals(BusinessObject.OBJECT_TYPE_DEFAULT_NAME)){
			return java.util.UUID.randomUUID().toString().replaceAll("-","");
		}
		ALSBizObjectManager bizObjectManager = null;
		try{
			bizObjectManager  = (ALSBizObjectManager)JBOFactory.getBizObjectManager(jboClassName);
		}catch(Exception ex){
			return java.util.UUID.randomUUID().toString().replaceAll("-","");
		}
		String keyType=bizObjectManager.getQueryProperties().getProperty("KeyType");
		if(StringX.isEmpty(keyType)) keyType="DB";
		
		if("UUID".equals(keyType)){
			return java.util.UUID.randomUUID().toString().replaceAll("-","");
		}
		else if("DB".equals(keyType)){
			String[] keys = bizObjectClass.getKeyAttributes();
			if(keys==null||keys.length == 0) {
				throw new JBOException("����"+jboClassName+"������δ����!");
			}
			
			if(keys.length>1){
				throw new JBOException("����"+jboClassName+"Ϊ��������!");
			}
			
			if(bizObjectClass.getAttribute(keys[0]).getType() != 0){
				throw new JBOException("����"+jboClassName+"�����������ַ���!");
			}
			
			if(!bizObjectManager.isCreateKey()){//�ַ�����ʹ��
				return "";
			}

			Object o = bizObjectManager.getQueryProperties().get("InitNum");
			Object p = bizObjectManager.getQueryProperties().get("Pre");
			String pre = "";
			int initNum = 1;
			if(o != null) initNum = Integer.valueOf((String)o);
			if(p != null) pre = String.valueOf(p);
			String tableName=bizObjectManager.getTable();
			String colName=bizObjectClass.getAttribute(keys[0]).getName();
			String objectNo = BusinessObjectKeyFactory.getSerialNo(bizObjectManager.getDatabase(),tableName,colName,"yyyyMMdd","00000000",new DateX(),initNum);
			return pre+objectNo;
		}
		else{
			throw new JBOException("����"+jboClassName+"���������ɷ�ʽ{"+keyType+"}�ݲ�֧��!");
		}
	}

	/**
	 * ������ȡָ�����ݱ��ֶε���ˮ��Ϊ�˱���߲����³���������������ڱ���ȡ��ˮ�ų����в���ָ��ֵ���µݹ���õķ�ʽ����ʹ�����������ʽ
	 * @param sDatabase ���ݿ�����
	 * @param sTable ����
	 * @param sColumn �ֶ���
	 * @param sDateFmt ���ڸ�ʽ һ��yyyyMMdd
	 * @param sNoFmt ��ˮ��ʽ
	 * @param today ��ǰ���� yyyy/MM/dd ���뽻������
	 * @param Num ÿ�λ�ȡ��ˮ���� ���Դ�jbo�����ļ�����query.InitNum�л�ȡֵ
	 * @return ���ؼ�1������ˮ��
	 * @throws Exception
	 * @author xjzhao
	 */
	public synchronized final static String getSerialNo(String database, String table, String column, String dateFormat, String noFormat, DateX date,int Num)
    	throws JBOException
	{
		table = table.toUpperCase();
	    column = column.toUpperCase();
		
		if(Num <= 0) Num = 1;
	    DecimalFormat decimalformat = new DecimalFormat(noFormat);
	    String sDate = date.getDateString(dateFormat);
	    int iDateLen = sDate.length();
		
	    //�ȴ��ڴ���ȡ�Ƿ����ѻ�ȡ��δʹ�õ���ˮ
		String[] serialNo = (String[])serialNoPool.get(table+column+dateFormat+noFormat);
		if(serialNo != null && !serialNo[0].equals(serialNo[1]) && serialNo[0].startsWith(sDate))//�����д��ڡ������е���ˮδʹ���ꡢ�����е���ˮ����ƥ�䴫������
		{
			int iMaxNo = Integer.valueOf(serialNo[0].substring(iDateLen)).intValue();
			serialNo[0] = sDate + decimalformat.format(iMaxNo + 1);
			return serialNo[0];
		}
		
	    Connection conn = null;
	    String sQuerySql = "select MaxSerialNo from object_maxsn where TableName=? and ColumnName=? and DateFmt=? and NoFmt=?";
	    String sUpdateSql = "update object_maxsn set MaxSerialNo = ? where TableName=? and ColumnName=? and DateFmt=? and NoFmt=? and MaxSerialNo = ?";
	    String sInsertSql = "insert into object_maxsn (TABLENAME,COLUMNNAME,MAXSERIALNO,DATEFMT,NOFMT) values (?,?,?,?,?)";
	    
	    String[] sNewSerialNo = new String[2];
	    int iMaxNo = 0;
	    try
	    {
	        conn = ARE.getDBConnection(database);
	        conn.setAutoCommit(false);
	    }
	    catch(SQLException ex)
	    {
	        throw new JBOException(1327, ex);
	    }
	    try
	    {
	        PreparedStatement pst = conn.prepareStatement(sQuerySql);
	        pst.setString(1, table);
	        pst.setString(2, column);
	        pst.setString(3, dateFormat);
	        pst.setString(4, noFormat);
	        ResultSet rs = pst.executeQuery();
	        if(rs.next())
	        {
	            String sMaxSerialNo = rs.getString(1);
	            rs.close();
	            pst.close();
	            iMaxNo = 0;
	            if(sMaxSerialNo != null && sMaxSerialNo.indexOf(sDate, 0) != -1)
	            {
	                iMaxNo = Integer.valueOf(sMaxSerialNo.substring(iDateLen)).intValue();
	                sNewSerialNo[0] = sDate + decimalformat.format(iMaxNo + 1);
	                sNewSerialNo[1] = sDate + decimalformat.format(iMaxNo + Num);
	            } else
	            {
	            	sNewSerialNo[0] = getInitSerialNo(table, column, dateFormat, noFormat, date, conn);
	            	iMaxNo = Integer.valueOf(sNewSerialNo[0].substring(iDateLen)).intValue();
	            	sNewSerialNo[1] = sDate + decimalformat.format(iMaxNo + Num-1);
	            }
	            PreparedStatement pst_update = conn.prepareStatement(sUpdateSql);
	            pst_update.setString(1, sNewSerialNo[1]);
	            pst_update.setString(2, table);
	            pst_update.setString(3, column);
	            pst_update.setString(4, dateFormat);
	            pst_update.setString(5, noFormat);
	            pst_update.setString(6, sMaxSerialNo);
	            int i = pst_update.executeUpdate();
	            pst_update.close();
	            conn.commit();
	            if(i<=0)//δ���µ�������ݹ���ø÷������»�ȡ
	            {
	            	return BusinessObjectKeyFactory.getSerialNo(database, table, column, dateFormat, noFormat, date, Num);
	            }
	        } else
	        {
	            rs.close();
	            pst.close();
	            sNewSerialNo[0] = getInitSerialNo(table, column, dateFormat, noFormat, date, conn);
	            iMaxNo = Integer.valueOf(sNewSerialNo[0].substring(iDateLen)).intValue();
	            sNewSerialNo[1] = sDate + decimalformat.format(iMaxNo + Num-1);
	            PreparedStatement pst_insert = conn.prepareStatement(sInsertSql);
	            pst_insert.setString(1, table);
	            pst_insert.setString(2, column);
	            pst_insert.setString(3, sNewSerialNo[1]);
	            pst_insert.setString(4, dateFormat);
	            pst_insert.setString(5, noFormat);
	            pst_insert.executeUpdate();
	            pst_insert.close();
	            conn.commit();
	        }
	    }
	    catch(Exception e)
	    {
	        try
	        {
	            conn.rollback();
	        }
	        catch(SQLException e1)
	        {
	            ARE.getLog().error(e1);
	        }
	        ARE.getLog().debug("getSerialNo...\u5931\u8D25[" + e.getMessage() + "]!", e);
	        throw new JBOException(1327, e);
	    }
	    finally
	    {
	        if(conn != null)
	        {
	            try
	            {
	                conn.close();
	            }
	            catch(SQLException e)
	            {
	                ARE.getLog().error(e);
	            }
	            conn = null;
	        }
	    }
	    serialNoPool.put(table+column+dateFormat+noFormat, sNewSerialNo);//���µ���ˮ������뻺����
	    return sNewSerialNo[0];
	}
	
	/**
	 * �ڲ�������ˮ������£�ͨ��������ʵ�����ݳ�ʼ����ˮ��ʼֵ
	 * @param sTable
	 * @param sColumn
	 * @param sDateFmt
	 * @param sNoFmt
	 * @param today
	 * @param conn
	 * @return ��ʵ��������ˮ+1�ĳ�ʼֵ
	 * @throws Exception
	 */
	private final static String getInitSerialNo(String sTable, String sColumn, String sDateFmt, String sNoFmt, DateX date, Connection conn)
	    throws Exception
	{
	    DecimalFormat dfTemp = new DecimalFormat(sNoFmt);
	    ResultSet rsTemp = null;
	    String sPrefix = date.getDateString(sDateFmt);
	    int iDateLen = sPrefix.length();
	    String sSql = "select max(" + sColumn + ") from " + sTable.toLowerCase() + " where " + sColumn + " like '" + sPrefix + "%' ";
	    Statement st = conn.createStatement();
	    rsTemp = st.executeQuery(sSql);
	    int iMaxNo = 0;
	    if(rsTemp.next())
	    {
	        String sMaxSerialNo = rsTemp.getString(1);
	        if(sMaxSerialNo != null)
	            iMaxNo = Integer.valueOf(sMaxSerialNo.substring(iDateLen)).intValue();
	    }
	    st.close();
	    rsTemp.close();
	    String sNewSerialNo = sPrefix + dfTemp.format(iMaxNo + 1);
	    ARE.getLog().trace("newSerialNo[" + sTable + "][" + sColumn + "]=[" + sNewSerialNo + "]");
	    return sNewSerialNo;
	}
}
