package com.amarsoft.app.oci.server;

import org.apache.axiom.soap.SOAPEnvelope;

import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;

public class PLBSECIF {
	/**
	 * AdrInfoModSubscribe��ַ��Ϣ�޸Ķ���
	 * @param source
	 * @return
	 */ 
	public SOAPEnvelope AdrInfoModSubscribe(SOAPEnvelope source){
		Connection conn = null;
		OCITransaction transactionReq = null;
		try{
			conn = ARE.getDBConnection(OCIConfig.getProperty("DataSource", "als"));
			transactionReq=OCIConfig.getTransactionByServerID("ecif_AdrInfoModSubscribe",conn);
			transactionReq.setRequestData(source);
			transactionReq.getCommunicator().execute();
			conn.commit();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}catch(Exception e){
			try{
				conn.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			e.printStackTrace();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}finally{
			try
			{
				if(conn != null)
					conn.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
	}
	
	/**
	 * ��ϵ��Ϣ�޸Ķ���
	 * @param source
	 * @return
	 */ 
	public SOAPEnvelope CtcInfoModSubscribe(SOAPEnvelope source){
		Connection conn = null;
		OCITransaction transactionReq = null;
		try{
			conn = ARE.getDBConnection(OCIConfig.getProperty("DataSource", "als"));
			transactionReq=OCIConfig.getTransactionByServerID("ecif_CtcInfoModSubscribe",conn);
			transactionReq.setRequestData(source);
			transactionReq.getCommunicator().execute();
			conn.commit();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}catch(Exception e){
			try{
				conn.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			e.printStackTrace();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}finally{
			try
			{
				if(conn != null)
					conn.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
	}
	
	/**
	 * ֤����Ϣ�޸Ķ���
	 * @param source
	 * @return
	 */ 
	public SOAPEnvelope CtfInfoModSubscribe(SOAPEnvelope source){
		Connection conn = null;
		OCITransaction transactionReq = null;
		try{
			conn = ARE.getDBConnection(OCIConfig.getProperty("DataSource", "als"));
			transactionReq=OCIConfig.getTransactionByServerID("ecif_CtfInfoModSubscribe",conn);
			transactionReq.setRequestData(source);
			transactionReq.getCommunicator().execute();
			conn.commit();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}catch(Exception e){
			try{
				conn.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			e.printStackTrace();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}finally{
			try
			{
				if(conn != null)
					conn.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
	}
	
	/**
	 * ��˽�ͻ���Ϣ��ѯ����
	 * @param source
	 * @return
	 */ 
	public SOAPEnvelope RtlClntInfoModSubscribe(SOAPEnvelope source){
		Connection conn = null;
		OCITransaction transactionReq = null;
		try{
			conn = ARE.getDBConnection(OCIConfig.getProperty("DataSource", "als"));
			transactionReq=OCIConfig.getTransactionByServerID("ecif_RtlClntInfoModSubscribe",conn);
			transactionReq.setRequestData(source);
			transactionReq.getCommunicator().execute();
			conn.commit();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}catch(Exception e){
			try{
				conn.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			e.printStackTrace();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}finally{
			try
			{
				if(conn != null)
					conn.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
	}
	
	/**
	 * �Թ��ͻ���Ϣ�޸Ķ���
	 * @param source
	 * @return
	 */ 
	public SOAPEnvelope CorpClntInfoModSubscribe(SOAPEnvelope source){
		Connection conn = null;
		OCITransaction transactionReq = null;
		try{
			conn = ARE.getDBConnection(OCIConfig.getProperty("DataSource", "als"));
			transactionReq=OCIConfig.getTransactionByServerID("ecif_CorpClntInfoModSubscribe",conn);
			transactionReq.setRequestData(source);
			transactionReq.getCommunicator().execute();
			conn.commit();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}catch(Exception e){
			try{
				conn.rollback();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
			e.printStackTrace();
			return (SOAPEnvelope)transactionReq.getResponseData();
		}finally{
			try
			{
				if(conn != null)
					conn.close();
			}catch(Exception ex)
			{
				ex.printStackTrace();
			}
		}
	}
}
