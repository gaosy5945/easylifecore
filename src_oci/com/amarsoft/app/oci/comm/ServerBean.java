package com.amarsoft.app.oci.comm;


import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.oci.OCIConfig;
import com.amarsoft.app.oci.bean.OCITransaction;
import com.amarsoft.app.oci.comm.impl.server.IResponser;
import com.amarsoft.app.oci.exception.ExceptionFactory;
import com.amarsoft.app.oci.exception.OCIException;
import com.amarsoft.are.ARE;
import com.amarsoft.are.lang.DateX;

/**
 * <p>�������ɷ���˽������ݣ�����������װ�õ���Ӧ����</p>
 * @author xjzhao
 *
 */
public class ServerBean extends Communicator {

	
	private IResponser responser;
	
	public ServerBean(OCITransaction transaction) throws OCIException {
		super(transaction);
		try{
			responser = (IResponser)Class.forName(transaction.getProperty("Responser")).newInstance();
		}catch(Exception e){
			ExceptionFactory.parse(e, "ʵ����ServerBean");
		}
	}

	/**
	 * <p>�����Ϊ�����ʵʱͨѶʱ�����в���</p>
	 * @throws Exception 
	 * @throws Exception 
	 */
	public void execute()throws Exception{
		
		Date beginDate = null,endDate = null;
		boolean flag = true;
		try
		{
			beginDate = new Date();
			//��¼��־
			if(OCIConfig.getProperty("ServiceFileLogFlag", true))
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
			//���
			decomposeTransData();
			//ҵ����
			dispose();
		}catch(Exception ex){
			ex.printStackTrace();
			Map<String, String> paraHashMap = new HashMap<String,String>();
			paraHashMap.put("ReturnCode", this.transaction.getProperty("ConsumerId")+"01011001");
			paraHashMap.put("ReturnMsg", "���׳����쳣��"+ex.getMessage());
			transaction.createResponseMessage(paraHashMap,null,transaction.getDbconnection());
			flag = false;
			throw ex;
		}
		finally{
			//���
			compositeTransData();
			endDate = new Date();
			//��¼��־
			if(OCIConfig.getProperty("ServiceFileLogFlag", true))
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
			
			double between = (endDate.getTime() - beginDate.getTime()) / 1000.00;// ����1000��Ϊ��ת������
			if(flag)
				ARE.getLog().info("[BeginTime:"+DateX.format(beginDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][EndTime:"+DateX.format(endDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][ServerID:"+transaction.getServerID()+"][TotalTime:"+between+"s][Status:Y]");
			else
				ARE.getLog().error("[BeginTime:"+DateX.format(beginDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][EndTime:"+DateX.format(endDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][ServerID:"+transaction.getServerID()+"][TotalTime:"+between+"s][Status:N]");
			//��¼��־
			if(OCIConfig.getProperty("ServiceDBLogFlag", true))
			{
				try
				{
					super.insertDBLog(UUID.randomUUID().toString(), 
							transaction.getProperty("ConsumerId"), 
							transaction.getProperty("TargetSysId"),
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
	}

	/**
	 * ����ҵ������Ĺ̶�������䷵�ر��Ķ����ֵ
	 * @param transData
	 * @return
	 * @throws Exception 
	 */
	private void dispose() throws Exception{
		responser.dispose(this.transaction);
	}
}
