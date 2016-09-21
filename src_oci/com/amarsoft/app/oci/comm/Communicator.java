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
 * ������װ�˱�ϵͳ��Ϊ�ͻ��˻��Ƿ���˵Ĳ�ͬ����Ŀ����Transaction��ͳһ���Ĵ�����־��¼��
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
			ExceptionFactory.parse(e, "ʵ����ServerBean");
		}
	}

	/**
	 * �߼�����
	 * @param 
	 * @return
	 */
	public abstract void execute() throws Exception;

	/**
	 * ���
	 * @return Object
	 * @throws OCIException 
	 */
	protected void compositeTransData() throws Exception{
		dataParser.compositeTransData(this.transaction);
	}
	
	/**
	 * ���
	 * @return
	 * @throws OCIException 
	 */
	protected void decomposeTransData() throws Exception{
		dataParser.decomposeTransData(this.transaction);
	}
	
	/**
	 * <p>
	 * �����������������־�ļ�
	 * </p>
	 */
	protected void writeString(Object s){
		if( s == null){
			s = "";
		}
		ARE.getLog().debug(s.toString());
	}
	
	/**
	 * <p>��¼�����¼�����ݿ�</p>
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
			ARE.getLog().error("������־����",e);
		}
	}
}
