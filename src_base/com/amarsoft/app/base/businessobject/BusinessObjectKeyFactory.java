/**
 * Class <code>BusinessObjectKeyFactory</code> 是对象主键或流水的生成器
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
	 * 定义数据库表流水缓存池：
	 *  其用法与数据库最大流水表类似
	 *  	key=表名+字段名+日期格式+数值流水格式
	 *      value=[流水起始值,流水终止值]
	 * 其设计意义：
	 * 1、每次按批次获取流水，获取流水批次后放入缓存对象中，程序在使用时直接从缓存读取，减少数据库与应用之间的交互加快效率
	 * 2、通过java中同步机制在获取缓存流水时，多线程之间不会出现获取到同一流水的情况
	 * 3、通过数据库层面数据操作同步机制，在多进程情况下也不会存在获取到同一流水的情况
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
	 * 生成对象流水号字段
	 * 	根据JBO配置文件判断主键字段个数，主键字段个数大于1则不生成流水信息，如果本身配置文件就不创建主键流水，这里也忽略。
	 *  流水的创建调用方法<tt>getSerialNo</tt>，这里采用的日期为系统交易日期（即表SYSTEM_SETUP.BUSINESSDATE值）不在采用系统日期
	 *  所以在向前调整交易日期时需要注意，以免出现流水冲突错误
	 *  通过JBO配置文件中参数query.InitNum值来指定每次获取流水个数放入缓存当中，缓存中流水使用完后再从数据库中获取
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
				throw new JBOException("对象"+jboClassName+"的主键未定义!");
			}
			
			if(keys.length>1){
				throw new JBOException("对象"+jboClassName+"为复合主键!");
			}
			
			if(bizObjectClass.getAttribute(keys[0]).getType() != 0){
				throw new JBOException("对象"+jboClassName+"的主键不是字符型!");
			}
			
			if(!bizObjectManager.isCreateKey()){//字符串才使用
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
			throw new JBOException("对象"+jboClassName+"的主键生成方式{"+keyType+"}暂不支持!");
		}
	}

	/**
	 * 批量获取指定数据表及字段的流水，为了避免高并发下出现死锁的情况，在本获取流水号程序中采用指定值更新递归调用的方式，不使用锁表操作方式
	 * @param sDatabase 数据库连接
	 * @param sTable 表名
	 * @param sColumn 字段名
	 * @param sDateFmt 日期格式 一般yyyyMMdd
	 * @param sNoFmt 流水格式
	 * @param today 当前日期 yyyy/MM/dd 传入交易日期
	 * @param Num 每次获取流水总数 可以从jbo配置文件属性query.InitNum中获取值
	 * @return 返回加1的新流水号
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
		
	    //先从内存中取是否有已获取的未使用的流水
		String[] serialNo = (String[])serialNoPool.get(table+column+dateFormat+noFormat);
		if(serialNo != null && !serialNo[0].equals(serialNo[1]) && serialNo[0].startsWith(sDate))//缓存中存在、缓存中的流水未使用完、缓存中的流水必须匹配传入日期
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
	            if(i<=0)//未更新到数据则递归调用该方法重新获取
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
	    serialNoPool.put(table+column+dateFormat+noFormat, sNewSerialNo);//将新的流水区间放入缓存中
	    return sNewSerialNo[0];
	}
	
	/**
	 * 在不存在流水的情况下，通过搜索表实际数据初始化流水初始值
	 * @param sTable
	 * @param sColumn
	 * @param sDateFmt
	 * @param sNoFmt
	 * @param today
	 * @param conn
	 * @return 表实际数据流水+1的初始值
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
