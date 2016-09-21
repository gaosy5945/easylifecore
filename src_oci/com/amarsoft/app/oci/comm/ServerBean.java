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
 * <p>这个类完成服务端接收数据，处理并返回组装好的响应报文</p>
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
			ExceptionFactory.parse(e, "实例化ServerBean");
		}
	}

	/**
	 * <p>完成作为服务端实时通讯时的所有步骤</p>
	 * @throws Exception 
	 * @throws Exception 
	 */
	public void execute()throws Exception{
		
		Date beginDate = null,endDate = null;
		boolean flag = true;
		try
		{
			beginDate = new Date();
			//记录日志
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
			//拆包
			decomposeTransData();
			//业务处理
			dispose();
		}catch(Exception ex){
			ex.printStackTrace();
			Map<String, String> paraHashMap = new HashMap<String,String>();
			paraHashMap.put("ReturnCode", this.transaction.getProperty("ConsumerId")+"01011001");
			paraHashMap.put("ReturnMsg", "交易出现异常："+ex.getMessage());
			transaction.createResponseMessage(paraHashMap,null,transaction.getDbconnection());
			flag = false;
			throw ex;
		}
		finally{
			//组包
			compositeTransData();
			endDate = new Date();
			//记录日志
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
			
			double between = (endDate.getTime() - beginDate.getTime()) / 1000.00;// 除以1000是为了转换成秒
			if(flag)
				ARE.getLog().info("[BeginTime:"+DateX.format(beginDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][EndTime:"+DateX.format(endDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][ServerID:"+transaction.getServerID()+"][TotalTime:"+between+"s][Status:Y]");
			else
				ARE.getLog().error("[BeginTime:"+DateX.format(beginDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][EndTime:"+DateX.format(endDate, DateHelper.AMR_NOMAL_FULLDATETIME_FORMAT)+"][ServerID:"+transaction.getServerID()+"][TotalTime:"+between+"s][Status:N]");
			//记录日志
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
	 * 调用业务处理类的固定方法填充返回报文对象的值
	 * @param transData
	 * @return
	 * @throws Exception 
	 */
	private void dispose() throws Exception{
		responser.dispose(this.transaction);
	}
}
