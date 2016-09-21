package com.amarsoft.app.oci.server;

import org.apache.axiom.soap.SOAPEnvelope;

import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;

public class PLBSUIAS {
	/**
	 * 对外统一认证平台变更通知服务
	 * @author T-qijx
	 * @param source
	 * @return
	 */ 
	public SOAPEnvelope DataChgSubscribe(SOAPEnvelope source){
		Connection conn = null;
		OCITransaction transactionReq = null;
		try{
			conn = ARE.getDBConnection(OCIConfig.getProperty("DataSource", "als"));
			transactionReq=OCIConfig.getTransactionByServerID("uias_DataChgSubscribe",conn);
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
