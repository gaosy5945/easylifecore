package com.amarsoft.app.oci.server;

import org.apache.axiom.soap.SOAPEnvelope;

import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.are.ARE;
import com.amarsoft.are.sql.Connection;

public class PLBSZHIPP1 {
	/**
	 * 借据信息查询
	 * @author T-wur
	 * @param source
	 * @return
	 */ 
	public SOAPEnvelope DuebillInfoQry(SOAPEnvelope source){
		Connection conn = null;
		OCITransaction transactionReq = null;
		try{
			conn = ARE.getDBConnection(OCIConfig.getProperty("DataSource", "als"));
			transactionReq=OCIConfig.getTransactionByServerID("ZHIPP_DuebillInfoQry_Server",conn);
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
