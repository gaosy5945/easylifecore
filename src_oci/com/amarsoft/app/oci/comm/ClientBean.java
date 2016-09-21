package com.amarsoft.app.oci.comm;


import java.util.Date;

import org.apache.axis2.client.ServiceClient;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.comm.impl.client.IRequester;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;

/**
 * <p>�������ɱ��Ķ������������Ͳ����գ����Ϊ���Ķ���</p>
 * @author xjzhao
 *
 */
public class ClientBean extends Communicator{
	
	private IRequester requester;
	
	public ClientBean(OCITransaction transaction) throws OCIException {
		super(transaction);
		try{
			requester = (IRequester)Class.forName(transaction.getProperty("Requester")).newInstance();
		}catch(Exception e){
			ExceptionFactory.parse(e, "ʵ���� ClientBean");
		}
	}
	
	/**
	 * <p>�����Ϊ�ͻ���ʵʱͨѶʱ�����в���</p>
	 */
	public void execute() throws Exception {
		if (OCIConfig.getProperty("IsInUse", true)){
			Object o = null;
			Date beginDate = null,endDate = null;
			try
			{
				beginDate = new Date();
				//���
				compositeTransData();
				
				
				//��¼��־
				if(OCIConfig.getProperty("ClientFileLogFlag", true))
				{
					try
					{
						super.writeString("Request:-----------------------------Begin");
						super.writeString(transaction.getRequestData());
						super.writeString("Request:-----------------------------End");
					}catch(Exception ex)
					{
						ex.printStackTrace();
					}
				}
				//����
				o = send();
				
				//��¼��־
				if(OCIConfig.getProperty("ClientFileLogFlag", true))
				{
					try
					{
						super.writeString("Response:-----------------------------Begin");
						super.writeString(transaction.getResponseData());
						super.writeString("Response:-----------------------------End");
					}catch(Exception ex)
					{
						ex.printStackTrace();
					}
				}
				endDate = new Date();
				
				//���
				decomposeTransData();
				double between = (endDate.getTime() - beginDate.getTime()) / 1000.00;// ����1000��Ϊ��ת������
				ARE.getLog().info("[BeginTime:"+DateX.format(beginDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][EndTime:"+DateX.format(endDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][ClientID:"+transaction.getClientID()+"][TotalTime:"+between+"s][Status:Y]");
			}catch(Exception ex)
			{
				if(endDate == null)  endDate = new Date();
				double between = (endDate.getTime() - beginDate.getTime()) / 1000.00;// ����1000��Ϊ��ת������
				ARE.getLog().error("[BeginTime:"+DateX.format(beginDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][EndTime:"+DateX.format(endDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][ClientID:"+transaction.getClientID()+"][TotalTime:"+between+"s][Status:N]");
				ARE.getLog().error("Request:-----------------------------Begin");
				ARE.getLog().error(transaction.getRequestData());
				ARE.getLog().error("Request:-----------------------------End");
				ARE.getLog().error("Response:-----------------------------Begin");
				ARE.getLog().error(transaction.getResponseData());
				ARE.getLog().error("Response:-----------------------------End");
				throw ex;
			}
			finally{
				//�ر���Դ
				if(o != null && o instanceof ServiceClient)
				{
					ServiceClient sc = (ServiceClient)o;
					sc.cleanupTransport();
					sc.cleanup();
				}
				
				
				//��¼��־
				if(OCIConfig.getProperty("ClientDBLogFlag", true))
				{
					try
					{
						super.insertDBLog(transaction.getProperty("MsgId"), 
								transaction.getProperty("SourceSysId"), 
								transaction.getProperty("ConsumerId"),
								transaction.getProperty("ServiceAdr"),
								transaction.getProperty("ServiceAction"),
								transaction.getProperty("TranDate"),
								transaction.getProperty("TranTime"), 
								transaction.getProperty("TranSeqNo"), 
								transaction.getProperty("GlobalSeqNo"));
					}catch(Exception ex)
					{
						ex.printStackTrace();
					}
				}
			}
		}else{			//���õ���
			long begin= System.currentTimeMillis();
			long end =System.currentTimeMillis();
			ARE.getLog().trace("fillTranscation takes "+(end-begin)+" ms");
		}
		
	}
	

	/**
	 * ����
	 * @param requestData
	 * @return
	 * @throws Exception 
	 */
	private Object send() throws OCIException{
			return requester.execute(this.transaction);
	}
	

}
