package com.amarsoft.app.util;

import com.amarsoft.are.ARE;
import com.amarsoft.are.AREException;
import com.amarsoft.are.AREServiceStub;

/**
 * 重新装载ARE的Java业务对象管理服务
 * @author xhgao
 * 
 */
public class ReloadServiceAction {
	
	private String serviceId = "JBO"; //ARE 服务编号

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		this.serviceId = serviceId;
	}

	public String reloadService() throws Exception{
		//定义变量
		String s=reloadSingleService(serviceId);
		if(s.equals("SUCCESS")) reloadSingleService("OW");
		return s;
	}
	
	public String reloadSingleService(String serviceId) throws Exception{
		//定义变量
		String sReturn = "SUCCESS";
		AREServiceStub s = ARE.getServiceStub(serviceId);
		ARE.getLog().trace("[服务编号]"+serviceId+" ,[stub]："+s);
		if(s!=null) {
			try {
				s.loadService();
				s.initService();
				ARE.getLog().trace("重载服务["+serviceId+"]成功！");
			} catch (AREException ex) {
				ARE.getLog().debug("重载服务["+serviceId+"]失败："+ex);
				sReturn = "FAILED";
			}
		}
		return sReturn;
	}
}
