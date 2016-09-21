package com.amarsoft.app.oci.comm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.app.oci.parser.IParser;
import com.amarsoft.are.ARE;

/**
 * <p>
 * 这个类封装了本系统作为客户端或是服务端的不同处理，目的是Transaction的统一报文处理、日志记录等
 * </p>
 * 
 * @author xjzhao 
 * 
 */
public abstract class Communicator {

	protected IParser dataParser;
	protected OCITransaction transaction;

	public Communicator(OCITransaction transaction) throws OCIException {
		this.transaction = transaction;
		try{
			dataParser= (IParser)Class.forName(transaction.getProperty("Parser")).newInstance();
		}catch(Exception e){
			ExceptionFactory.parse(e, "实例化ServerBean");
		}
	}

	/**
	 * 逻辑处理
	 * @param 
	 * @return
	 */
	public abstract void execute() throws Exception;

	/**
	 * 组包
	 * @return Object
	 * @throws OCIException 
	 */
	protected void compositeTransData() throws Exception{
		dataParser.compositeTransData(this.transaction);
	}
	
	/**
	 * 拆包
	 * @return
	 * @throws OCIException 
	 */
	protected void decomposeTransData() throws Exception{
		dataParser.decomposeTransData(this.transaction);
	}
	
	/**
	 * <p>
	 * 将报文明文输出到日志文件
	 * </p>
	 */
	protected void writeString(Object s){
		if( s == null){
			s = "";
		}
		ARE.getLog().debug(s.toString());
	}
	
	/**
	 * <p>记录请求记录到数据库</p>
	 * @param data
	 * @throws OCIException
	 */
	protected void insertDBLog(String msgID,String sourceSysID,String consumerID,String serviceAdr,String serviceAction,String tranDate,String tranTime,String tranSeqNo,String globalSeqNo) throws Exception {
		String datasource = OCIConfig.getProperty("DataSource", "als");
		Connection connection = null;
		String sql = "";
		PreparedStatement ps = null;
		try {
			connection = ARE.getDBConnection(datasource);
			connection.setAutoCommit(false);
			
			sql = "INSERT INTO TRANSACTION_LOG(MSGID, SOURCESYSID, CONSUMERID, SERVICEADR, SERVICEACTION, TRANDATE, TRANTIME,TRANSEQNO,GLOBALSEQNO) "
					+ "VALUES(?,?,?,?,?,?,?,?,?)";
			ps = connection.prepareStatement(sql);
			ps.setString(1, msgID);
			ps.setString(2, sourceSysID);
			ps.setString(3, consumerID);
			ps.setString(4, serviceAdr);
			ps.setString(5, serviceAction);
			ps.setString(6, tranDate);
			ps.setString(7, tranTime);
			ps.setString(8, tranSeqNo);
			ps.setString(9, globalSeqNo);
			ps.executeUpdate();
			ps.close();
			connection.commit();
			connection.close();
		} catch (Exception e) {
			try {
				if (ps != null) {
					ps.close();
				}
				if(connection != null)
				{
					connection.close();
				}
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			ARE.getLog().error("插入日志出错",e);
		}
	}
}
